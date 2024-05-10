//
//  MembershipVC.swift
//  JobsDone
//
//  Created by musharraf on 12/04/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import CoreLocation

public enum PaymentType{
    case SIGNUP
    case MEMBERSHIP
    case SIGNIN
}

class MembershipVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var clViewHeight: NSLayoutConstraint!
    @IBOutlet weak var page: CustomPager!
    var packageArr = [PackageModel]()
    var dic3 = [:] as Dictionary<String, AnyObject>
    var withImg = false
    var image: UIImage?
    var paymentType = PaymentType.SIGNUP
    var token = ""
    var secret = ""
    var userId: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page.updateDots()
        self.title = "MEMBERSHIP"
        clView.delegate = self
        clView.dataSource = self
        if packageArr.count != 0 && paymentType == .SIGNUP{
            loadMembershipPlan()
        }else if paymentType == .SIGNIN{
            loadGroupData()
        }
        else{
        loadGroupData()
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.page.updateDots()
    }
    override func viewWillDisappear(_ animated: Bool) {
//        if paymentType == .SIGNIN{
//            UserDefaults.standard.removeObject(forKey: "oauth_token")
//            UserDefaults.standard.removeObject(forKey: "oauth_secret")
//        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.packageArr.count
        page.numberOfPages = count
        page.currentPage = 0
        page.isHidden = !(count > 1)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.clView.dequeueReusableCell(withReuseIdentifier: "memberShipCell", for: indexPath) as! memberShipCell
         let model = self.packageArr[indexPath.item]
        cell.continueBtn.tag = indexPath.item
        cell.continueBtn.addTarget(self, action: #selector(ContinueWithPkg(_:)), for: .touchUpInside)
        cell.pkgType.text = Utilities.stringFromHtml(string: model.label)?.string
        cell.price.text = model.detail
        if indexPath.item == 0{
            cell.job.image = #imageLiteral(resourceName: "green_checked")
            cell.pkgType.text = model.label
            cell.price.text = model.detail
        }else
        if  indexPath.item == 1{
            cell.job.image = #imageLiteral(resourceName: "green_checked")
            cell.detail.image = #imageLiteral(resourceName: "green_checked")
            cell.hire.image = #imageLiteral(resourceName: "green_checked")
            cell.mxg.image = #imageLiteral(resourceName: "green_checked")
        }else
        {
            cell.pkgType.text = model.label
            cell.price.text = model.detail
            cell.job.image = #imageLiteral(resourceName: "green_checked")
            cell.detail.image = #imageLiteral(resourceName: "green_checked")
            cell.hire.image = #imageLiteral(resourceName: "green_checked")
            cell.mxg.image = #imageLiteral(resourceName: "green_checked")
            cell.invite.image = #imageLiteral(resourceName: "green_checked")
            cell.upload.image = #imageLiteral(resourceName: "green_checked")
        }
        if paymentType == .MEMBERSHIP{
            if model.active{
                cell.continueBtn.setTitle("CURRENT PLAN", for: .normal)
            }else{
            cell.continueBtn.setTitle("GET IT", for: .normal)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       let width =  UIScreen.main.bounds.width - 50
        
        return CGSize(width: width, height: self.clView.height)
    }
    @objc func ContinueWithPkg(_ sender: UIButton){
        let model = self.packageArr[sender.tag]
        dic3["package_id"] = model.package_id as AnyObject
        if paymentType == .SIGNUP{
            if model.price > 0 || model.package_id == 6{
            let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .cardVC) as! CardVC
            con.dic3 = self.dic3
            con.withImg = self.withImg
            con.parentViewType = .SIGNUP
            if withImg{
                con.img = self.image
            }
            self.navigationController?.pushViewController(con, animated: true)
            }else{
                let con = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
                con.dic3 = self.dic3
                con.withImg = self.withImg
                if withImg{
                    con.img = self.image
                }
                con.parentType = ParentType.SIGNUP
                if let typeId = self.dic3["profile_type"] as? String{
                    if typeId != "7" && typeId != "8"{
                
                self.navigationController?.pushViewController(con, animated: true)
                    }else{
                        SaveUser()
                    }
                }
            }
        }else if paymentType == .SIGNIN{
            if model.price > 0 || model.package_id == 6{
                let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .cardVC) as! CardVC
                con.parentViewType = .SIGNIN
                con.pkgId = model.package_id
                con.pkgModel = model
                con.dic3["package_id"] = model.package_id as AnyObject
                self.navigationController?.pushViewController(con, animated: true)
            }else{
            SetPackage(model: model)
            }
        }
        else{
           SetPackage(model: model)
        }
    }
    
    @IBAction func BackBtnClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadGroupData(){
        
        let method = "user/subscription/packages"
        var dic = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 200 {
                    if let body = response.object(forKey: "body") as? [Dictionary<String,AnyObject>]{
                        
                            let sub = body[0]
                            if let multi = sub["multiOptions"] as? [Dictionary<String, AnyObject>]{
                                for mult in multi{
                                    let model = PackageModel.init(mult)
                                    self.packageArr.append(model)
                                }
                            }
                        
                        self.clView.reloadData()
                    }
                }
            }
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
        
    }
    
    func loadMembershipPlan(){
        
        let method = "signup?subscriptionForm=1"
        
        var mydic = Dictionary<String,AnyObject>()
        mydic["profile_type"] = (self.dic3["profile_type"] as? String) as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: mydic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 200 {
                    if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject>{
                        if let subs = body["subscription"] as?[Dictionary<String,AnyObject>]{
                            self.packageArr.removeAll()
                            let sub = subs[0]
                            if let multi = sub["multiOptions"] as? [Dictionary<String, AnyObject>]{
                                for mult in multi{
                                    let model = PackageModel.init(mult)
                                    self.packageArr.append(model)
                                }
                            }
                        }
                        self.clView.reloadData()
                    }
                }
            }
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
        
    }
    
    func SetPckageWithoutLogin(model: PackageModel){
        var dic = Dictionary<String,AnyObject>()
        dic["package_id"] = model.package_id as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: "user/subscription/packages", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 200 {
                }else{
                    let mxg = response["message"] as? String
                    Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
                }
            }
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    
    func SetPackage(model: PackageModel)
    {
        var dic = Dictionary<String,AnyObject>()
        dic["package_id"] = model.package_id as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: "user/subscription/process", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 204 {
                    self.packageArr.removeAll()
                    self.loadGroupData()
                }else if status_code == 200 && self.paymentType == .SIGNIN{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    if let usr = body!["user"] as? Dictionary<String, AnyObject> {
                        let user = User.init(fromDictionary: usr)
                        if let loc = body!["location"]as? String{
                            let geoCoder = CLGeocoder()
                            geoCoder.geocodeAddressString(loc) { (placemarks, error) in
                                guard
                                    let placemarks = placemarks,
                                    let location = placemarks.first?.location
                                    else { return }
                                print(location)
                                var dic = Dictionary<String,AnyObject>()
                                dic["latitude"] = location.coordinate.latitude as AnyObject
                                dic["longitude"] = location.coordinate.longitude as AnyObject
                                
                                
                                let myLocation = LocationParam.init(fromDictionary: dic)
                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: myLocation)
                                UserDefaults.standard.set(encodedData, forKey: "locationParams")
                                // Use your location
                            }
                            
                        }else{
                            if let loc = body!["location"]as? Dictionary<String,AnyObject>{
                                let myLocation = LocationParam.init(fromDictionary: loc)
                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: myLocation)
                                UserDefaults.standard.set(encodedData, forKey: "locationParams")
                            }
                        }
                        if (user.phoneVerified != nil){
                            if user.phoneVerified! == 0{
                                UserDefaults.standard.set(false, forKey: "phone_verified")
                            }else{
                                UserDefaults.standard.set(true, forKey: "phone_verified")
                            }
                        }
                        
                        if let oauth_token = body!["oauth_token"] as? String{
                            if let oauth_secret = body!["oauth_secret"] as? String{
                                user.oauthToken = oauth_token
                                user.oauthSecret = oauth_secret
                            }
                        }
                        UserDefaults.standard.set(user.email, forKey: "email")
                        UserDefaults.standard.set(user.oauthToken, forKey: "oauth_token")
                        UserDefaults.standard.set(user.oauthSecret, forKey: "oauth_secret")
                        UserDefaults.standard.set(user.displayname, forKey: "name")
                        UserDefaults.standard.set(user.userId, forKey: "id")
                        UserDefaults.standard.set(user.image, forKey: "image")
                        UserDefaults.standard.set(user.timezone, forKey: "timezone")
                        UserDefaults.standard.set(user.locale, forKey: "locale")
                        if user.phone != nil{
                            if user.phone!.count > 0{}
                            UserDefaults.standard.set(user.phone!, forKey: "phone")
                        }
                        if user.levelId != nil{
                            UserDefaults.standard.set(user.levelId!, forKey: "level_id")
                        }
                        let app = UIApplication.shared.delegate as! AppDelegate
                        if user.verified == 1{
                            app.isCheckLogIn()
                        }else{
                            Utilities.logout()
                            app.isCheckLogIn()
                        }
                    }
                }else if self.paymentType == .MEMBERSHIP && status_code == 200{
                    self.packageArr.removeAll()
                    self.loadGroupData()
                }else if self.paymentType == .MEMBERSHIP && status_code == 401{
                    Utilities.showAlertWithTitle(title: "Please Add Payment Method", withMessage: "", withNavigation: self)
                }
                else{
                    let mxg = response["message"] as? String
                    Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
                }
            }
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    //MARK: - SAVE CLIENT WITHOUT SKILL
    func SaveUser()
    {
        let method = "signup?subscriptionForm=1"
        dic3["fields_validation"] = 0 as AnyObject
        dic3["ip"] = "127.0.0.1" as AnyObject
        if self.image == nil{
            
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: dic3, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 204 {

                }else if scode == 200{
//                    let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .wellcomeVC) as! WellcomeVC
//                    self.present(con, animated: true, completion: nil)
                    if scode == 200 {
                        if let body = response["body"] as? Dictionary<String, AnyObject> {
                            if let pkgId = body["package_id"] as? Int{
                                if pkgId == 0{
                                    let secret = body["secret"] as? String
                                    let token = body["token"] as? String
                                    let userId = body["user_id"] as? Int
                                    UserDefaults.standard.set(token, forKey: "oauth_token")
                                    UserDefaults.standard.set(secret, forKey: "oauth_secret")
                                    UserDefaults.standard.set(userId, forKey: "id")
                                    let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .membershipVC) as! MembershipVC
                                    con.withImg = false
                                    con.paymentType = .SIGNIN
                                    self.navigationController?.pushViewController(con, animated: true)
                                }
                            }
                            if let usr = body["user"] as? Dictionary<String, AnyObject> {
                                let  user = User.init(fromDictionary: usr)
                                if let loc = body["location"]as? String{
                                    let geoCoder = CLGeocoder()
                                    geoCoder.geocodeAddressString(loc) { (placemarks, error) in
                                        guard
                                            let placemarks = placemarks,
                                            let location = placemarks.first?.location
                                            else { return }
                                        print(location)
                                        var dic = Dictionary<String,AnyObject>()
                                        dic["latitude"] = location.coordinate.latitude as AnyObject
                                        dic["longitude"] = location.coordinate.longitude as AnyObject
                                        
                                        
                                        let myLocation = LocationParam.init(fromDictionary: dic)
                                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: myLocation)
                                        UserDefaults.standard.set(encodedData, forKey: "locationParams")
                                        // Use your location
                                    }
                                    
                                }else{
                                    if let loc = body["location"]as? Dictionary<String,AnyObject>{
                                        let myLocation = LocationParam.init(fromDictionary: loc)
                                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: myLocation)
                                        UserDefaults.standard.set(encodedData, forKey: "locationParams")
                                    }
                                }
                                if (user.phoneVerified != nil){
                                    if user.phoneVerified! == 0{
                                        UserDefaults.standard.set(false, forKey: "phone_verified")
                                    }else{
                                        UserDefaults.standard.set(true, forKey: "phone_verified")
                                    }
                                }
                                
                                if let oauth_token = body["oauth_token"] as? String{
                                    if let oauth_secret = body["oauth_secret"] as? String{
                                        user.oauthToken = oauth_token
                                        user.oauthSecret = oauth_secret
                                    }
                                }
                                UserDefaults.standard.set(user.email, forKey: "email")
                                UserDefaults.standard.set(user.oauthToken, forKey: "oauth_token")
                                UserDefaults.standard.set(user.oauthSecret, forKey: "oauth_secret")
                                UserDefaults.standard.set(user.displayname, forKey: "name")
                                UserDefaults.standard.set(user.userId, forKey: "id")
                                UserDefaults.standard.set(user.image, forKey: "image")
                                UserDefaults.standard.set(user.timezone, forKey: "timezone")
                                UserDefaults.standard.set(user.locale, forKey: "locale")
                                if user.phone != nil{
                                    if user.phone!.count > 0{}
                                    UserDefaults.standard.set(user.phone!, forKey: "phone")
                                }
                                if user.levelId != nil{
                                    UserDefaults.standard.set(user.levelId!, forKey: "level_id")
                                }
                                let app = UIApplication.shared.delegate as! AppDelegate
                                app.isCheckLogIn()
                            }
                        }
                    }
                }else{
                    let mxg = (response["message"] as? String) ?? ""
                    Utilities.showAlertWithTitle(title: mxg,withMessage:"", withNavigation: self)
                }
                
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.view)!)
                print(response)
            }
        }else{
            let convertedDict: [String: String] = dic3.mapPairs { (key, value) in
                (key, String(describing: value))
            }
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            
            ALFWebService.sharedInstance.doPostDataWithImage(parameters: convertedDict, method: method, image: self.image, success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                if let scode = response["status_code"] as? Int {
                    if scode == 204 {
                        
                        
                    }else if scode == 200{
//                        let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .wellcomeVC) as! WellcomeVC
//                        self.present(con, animated: true, completion: nil)
                        if scode == 200 {
                            if let body = response["body"] as? Dictionary<String, AnyObject> {
                                if let pkgId = body["package_id"] as? Int{
                                    if pkgId == 0{
                                        let secret = body["secret"] as? String
                                        let token = body["token"] as? String
                                        let userId = body["user_id"] as? Int
                                        UserDefaults.standard.set(token, forKey: "oauth_token")
                                        UserDefaults.standard.set(secret, forKey: "oauth_secret")
                                        UserDefaults.standard.set(userId, forKey: "id")
                                        let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .membershipVC) as! MembershipVC
                                        con.withImg = false
                                        con.paymentType = .SIGNIN
                                        self.navigationController?.pushViewController(con, animated: true)
                                    }
                                }
                                if let usr = body["user"] as? Dictionary<String, AnyObject> {
                                    let  user = User.init(fromDictionary: usr)
                                    if let loc = body["location"]as? String{
                                        let geoCoder = CLGeocoder()
                                        geoCoder.geocodeAddressString(loc) { (placemarks, error) in
                                            guard
                                                let placemarks = placemarks,
                                                let location = placemarks.first?.location
                                                else { return }
                                            print(location)
                                            var dic = Dictionary<String,AnyObject>()
                                            dic["latitude"] = location.coordinate.latitude as AnyObject
                                            dic["longitude"] = location.coordinate.longitude as AnyObject
                                            
                                            
                                            let myLocation = LocationParam.init(fromDictionary: dic)
                                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: myLocation)
                                            UserDefaults.standard.set(encodedData, forKey: "locationParams")
                                            // Use your location
                                        }
                                        
                                    }else{
                                        if let loc = body["location"]as? Dictionary<String,AnyObject>{
                                            let myLocation = LocationParam.init(fromDictionary: loc)
                                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: myLocation)
                                            UserDefaults.standard.set(encodedData, forKey: "locationParams")
                                        }
                                    }
                                    if (user.phoneVerified != nil){
                                        if user.phoneVerified! == 0{
                                            UserDefaults.standard.set(false, forKey: "phone_verified")
                                        }else{
                                            UserDefaults.standard.set(true, forKey: "phone_verified")
                                        }
                                    }
                                    
                                    if let oauth_token = body["oauth_token"] as? String{
                                        if let oauth_secret = body["oauth_secret"] as? String{
                                            user.oauthToken = oauth_token
                                            user.oauthSecret = oauth_secret
                                        }
                                    }
                                    UserDefaults.standard.set(user.email, forKey: "email")
                                    UserDefaults.standard.set(user.oauthToken, forKey: "oauth_token")
                                    UserDefaults.standard.set(user.oauthSecret, forKey: "oauth_secret")
                                    UserDefaults.standard.set(user.displayname, forKey: "name")
                                    UserDefaults.standard.set(user.userId, forKey: "id")
                                    UserDefaults.standard.set(user.image, forKey: "image")
                                    UserDefaults.standard.set(user.timezone, forKey: "timezone")
                                    UserDefaults.standard.set(user.locale, forKey: "locale")
                                    if user.phone != nil{
                                        if user.phone!.count > 0{}
                                        UserDefaults.standard.set(user.phone!, forKey: "phone")
                                    }
                                    if user.levelId != nil{
                                        UserDefaults.standard.set(user.levelId!, forKey: "level_id")
                                    }
                                    let app = UIApplication.shared.delegate as! AppDelegate
                                    app.isCheckLogIn()
                                }
                            }
                        }
                    }else{
                        let mxg = (response["message"] as? String) ?? ""
                        Utilities.showAlertWithTitle(title: mxg, withMessage: "", withNavigation: self)
                    }
                }
                
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
            }
        }
    }
    
   

}
extension MembershipVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Change the current page
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        page?.currentPage = Int(roundedIndex)
        //
    }
    
}
