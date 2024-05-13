//
//  SkillsVC.swift
//  JobsDone
//
//  Created by musharraf on 28/02/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import CoreLocation

public enum ParentType{
    case SIGNUP
    case PROFILE
    case CATEGORY
    case CREATEJOB
    case PORTFOLIO
    case PROFESSIONAL
    case IDEA
}

class SkillsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,skillDelegate ,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{
    var dic3 = [:] as Dictionary<String, AnyObject>
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchImg: UIButton!
    @IBOutlet weak var totalSkillLbl: UILabel!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    var skillsCount = 0
    var skillData = [Category]()
    var selectSkillData = [Category]()
    var filterSearch = [Category]()
    var formValues = [Int]()
    var selectedSkill = 0
    var parentType = ParentType.PROFILE
    var withImg = false
    var img: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let checkinImage = #imageLiteral(resourceName: "search")
        let checkintintedImage = checkinImage.withRenderingMode(.alwaysTemplate)
        searchImg.setImage(checkintintedImage, for: .normal)
        searchImg.tintColor = UIColor.darkGray
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        if parentType != .PROFILE{
            topConst.constant = 0
            submitBtn.setTitle("CONTINUE", for: .normal)
        }
        if parentType == .CATEGORY || parentType == .PORTFOLIO{
            self.title = "SELECT CATEGORIES"
            self.totalSkillLbl.text = "0 CATEGORIES SELECTED"
            searchTxt.attributedPlaceholder = NSAttributedString(string: "Search Categories", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }else{
            self.title = "SELECT SKILLS"
            self.totalSkillLbl.text = "0 SKILLS SELECTED"
            searchTxt.attributedPlaceholder = NSAttributedString(string: "Search Skills", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        
        self.hideKeyboardWhenTappedAround()
        loadSkills()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
       updateSearchResults(searchText:searchTxt.text!)
    }
    
    
    func updateSearchResults(searchText:String) {
        if searchText != ""{
        skillData = filterSearch.filter { obj  in
            return obj.categoryName.lowercased().contains(searchText.lowercased())
            }
        }else{
          skillData = filterSearch
        }
        self.collectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skillData.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width / 3
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return CGSize(width: width, height: width)
        
        // your code here
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let objModel = skillData[indexPath.item]
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsCell", for: indexPath as IndexPath) as! SkillsCell
        cell.delegate = self
        cell.name.text = objModel.categoryName
        if objModel.status!
        {
            
            cell.name.textColor = UIColor.white
            cell.contentView.backgroundColor = UIColor(hexString: "#FF6B02")
            var checkinImage = #imageLiteral(resourceName: "setting")
            if objModel.thumbIcon != ""
            {
                cell.imgSkill.sd_setImage(with: URL(string: objModel.thumbIcon), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                    // Perform your operations here.
                    cell.imgSkill.image = cell.imgSkill.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgSkill.tintColor = UIColor.white
                }
            }
        }else
        {

            cell.imgSkill.sd_setImage(with: URL(string: objModel.thumbIcon), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                // Perform your operations here.
                cell.imgSkill.image = cell.imgSkill.image?.withRenderingMode(.alwaysTemplate)
                cell.imgSkill.tintColor = UIColor(hexString: "#FF6B02")
            }
            cell.name.textColor = UIColor(hexString: "#FF6B02")
            cell.contentView.backgroundColor = UIColor.white
        }
        if parentType == .CATEGORY || parentType == .CREATEJOB || parentType == .PORTFOLIO || parentType == .PROFESSIONAL || parentType == .IDEA {
            for model in selectSkillData{
                if objModel.categoryName == model.categoryName
                {
                    cell.name.textColor = UIColor.white
                    cell.contentView.backgroundColor = UIColor(hexString: "#FF6B02")
                    if objModel.thumbIcon != ""
                    {
                        cell.imgSkill.sd_setImage(with: URL(string: objModel.thumbIcon))
                    }else{
                         cell.imgSkill.image = #imageLiteral(resourceName: "setting")
                    }
                    let checkinImage = cell.imgSkill.image
                    let checkintintedImage = checkinImage?.withRenderingMode(.alwaysTemplate)
                    cell.imgSkill.image = checkintintedImage
                    cell.imgSkill.tintColor = UIColor.white
                }
            }
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objModel = skillData[indexPath.item]
        if formValues.contains(objModel.categoryId!)
        {
            if selectedSkill > 0{
                selectedSkill = selectedSkill - 1
            }
            let ind = selectSkillData.index(of: objModel)
            selectSkillData.remove(at: ind!)
            let objIndex = formValues.index(of: objModel.categoryId!)
            formValues.remove(at: objIndex!)
            objModel.status = false
            let cell = collectionView.cellForItem(at: indexPath) as! SkillsCell
            
            cell.imgSkill.tintColor = UIColor(hexString: "#FF6B02")
            cell.contentView.backgroundColor = UIColor.white
            cell.name.textColor = UIColor(hexString: "#FF6B02")
        }else
        {
            if parentType == .PORTFOLIO || parentType == .CREATEJOB || parentType == .SIGNUP || parentType == .PROFILE{
                if  selectSkillData.count > 2{
                showToast(message: "Only 3 skills can be selected!")
                    return
                }else{
                 self.SelectSkill(objModel: objModel, indexPath: indexPath)
                }
            }
            else{
                self.SelectSkill(objModel: objModel, indexPath: indexPath)
            }
        }
        var totalStr = String(describing: self.selectedSkill)
        if parentType == .CATEGORY || parentType == .PORTFOLIO{
           self.totalSkillLbl.text = "\(totalStr) CATEGORIES SELECTED"
        }else{
        self.totalSkillLbl.text = "\(totalStr) SKILLS SELECTED"
        }
    }
    
    func SelectSkill(objModel: Category,indexPath: IndexPath)
    {
        selectSkillData.append(objModel)
        selectedSkill = selectedSkill + 1
        self.formValues.append(objModel.categoryId!)
        let indexPath = IndexPath(row: indexPath.item, section: 0)
        objModel.status = true
        let cell = collectionView.cellForItem(at: indexPath) as! SkillsCell
        cell.contentView.backgroundColor = UIColor(hexString: "#FF6B02")
        cell.name.textColor = UIColor.white
        cell.imgSkill.tintColor = UIColor.white
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadSkills()
    {
        var method = "/members/settings/skills"
        if parentType == .PROFILE{
            
        }else{
            method = "/signup/skills"
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        let params = Dictionary<String,AnyObject>()
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    self.skillsCount = body!["totalItemCount"] as! Int
                     if let skillArr   = body!["response"] as? [Dictionary<String,AnyObject>]
                     {
                        for skill in skillArr
                        {
                             let objModel = Category.init(fromDictionary: skill)
                             self.skillData.append(objModel)
                            self.filterSearch.append(objModel)
                            if objModel.status!
                            {
                                self.selectedSkill = self.selectedSkill + 1
                                self.formValues.append(objModel.categoryId!)
                                self.selectSkillData.append(objModel)
                            }
                        }
                    }
                    var totalStr = String(describing: self.selectedSkill)
                    if self.parentType == .CATEGORY || self.parentType == .PORTFOLIO{
                     self.totalSkillLbl.text = "\(totalStr) CATEGORIES SELECTED"
                    }else{
                    self.totalSkillLbl.text = "\(totalStr) SKILLS SELECTED"
                    }
                    self.collectionView.reloadData()
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    
    func didPressedSkillBtn(tag: Int) {
        let objModel = skillData[tag]
        if formValues.contains(objModel.categoryId!)
        {
            let ind = selectSkillData.index(of: objModel)
            selectSkillData.remove(at: ind!)
            let objIndex = formValues.index(of: objModel.categoryId!)
            formValues.remove(at: objIndex!)
            objModel.status = false
            let indexPath = IndexPath(item: tag, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! SkillsCell
            
            cell.imgSkill.tintColor = UIColor(hexString: "#FF6B02")
            cell.contentView.backgroundColor = UIColor.white
            cell.name.textColor = UIColor(hexString: "#FF6B02")
        }else
        {
            
            self.formValues.append(objModel.categoryId!)
            let indexPath = IndexPath(row: tag, section: 0)
            objModel.status = true
            let cell = collectionView.cellForItem(at: indexPath) as! SkillsCell
            cell.contentView.backgroundColor = UIColor(hexString: "#FF6B02")
            cell.name.textColor = UIColor.white
            cell.imgSkill.tintColor = UIColor.white
        }
    }
    
    @IBAction func updateSkills(_ sender: UIButton) {
         let skillDataDict:[String: [Category]] = ["skills": selectSkillData]
        if parentType == .PROFILE
        {
        updateSkill()
        }else if parentType == .PROFESSIONAL{
            NotificationCenter.default.post(name: Notification.Name("SelectedProfessionalSkill"), object: nil,userInfo: skillDataDict)
            self.navigationController?.popViewController(animated: true)
        }
        else if parentType == .CATEGORY {
           
            NotificationCenter.default.post(name: Notification.Name("SelectedSkill"), object: nil,userInfo: skillDataDict)
            self.navigationController?.popViewController(animated: true)
        }else if parentType == .PORTFOLIO{
            NotificationCenter.default.post(name: Notification.Name("SelectedPortSkill"), object: nil,userInfo: skillDataDict)
            self.navigationController?.popViewController(animated: true)
        }
        else if parentType == .CREATEJOB{
            NotificationCenter.default.post(name: Notification.Name("SelectedSkillForCreateJob"), object: nil,userInfo: skillDataDict)
            self.navigationController?.popViewController(animated: true)
        }else if parentType == .IDEA{
            NotificationCenter.default.post(name: Notification.Name("SelectedSkillForIdea"), object: nil,userInfo: skillDataDict)
            self.navigationController?.popViewController(animated: true)
        }
        else{
         SaveUser()
        }
    }
    
    func updateSkill()
    {
        let method = "/members/settings/skills"
        
        var dic = Dictionary<String,AnyObject>()
        for var i in (0..<formValues.count).reversed(){
            dic["category_id[\(i)]"] = formValues[i] as AnyObject
        }
        dic["hours"] = "48" as AnyObject
        print(dic)
        Utilities.sharedInstance.showActivityIndicatory(uiView: (self.view)!)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.view)!)
            print(response)
            let scode = response["status_code"] as! Int
            if scode == 204 {
                self.showToast(message: "Skill updated successfully")
            }else{
                let mxg = response["message"] as? String
                Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
            }
            
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.view)!)
            print(response)
        }
    }
    
    func SaveUser()
    {
        let method = "signup?subscriptionForm=1"
        for var i in (0..<formValues.count).reversed(){
            dic3["category_id[\(i)]"] = formValues[i] as AnyObject
        }
        dic3["fields_validation"] = 0 as AnyObject
        dic3["ip"] = "127.0.0.1" as AnyObject
        if self.img == nil{
       
        Utilities.sharedInstance.showActivityIndicatory(uiView: (self.view)!)
        ALFWebService.sharedInstance.doPostData(parameters: dic3, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.view)!)
            print(response)
            let scode = response["status_code"] as! Int
            if scode == 204 {
                self.showToast(message: "User Saved")
                self.skillData.removeAll()
                self.loadSkills()
                
            }else if scode == 200{
//                let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .wellcomeVC) as! WellcomeVC
//                self.present(con, animated: true, completion: nil)
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
                            
                            if let oauth_token = body["oauth-token"] as? String{
                                if let oauth_secret = body["oauth-secret"] as? String{
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
                let mxg = response["message"] as? Dictionary<String,AnyObject>
                Utilities.showAlertWithTitle(title: "Validation" as! String,withMessage:"\(String(describing: (mxg != nil)))", withNavigation: self)
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
            
            ALFWebService.sharedInstance.doPostDataWithImage(parameters: convertedDict, method: method, image: self.img, success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                if let scode = response["status_code"] as? Int {
                    if scode == 204 {
                        self.showToast(message: "User Saved")
                        self.skillData.removeAll()
                        self.loadSkills()
                        
                    }else if scode == 401{
                        let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .wellcomeVC) as! WellcomeVC
                        self.present(con, animated: true, completion: nil)
                    }else if scode == 200{
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
                                    
                                    if let oauth_token = body["oauth-token"] as? String{
                                        if let oauth_secret = body["oauth-secret"] as? String{
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
                    }
                    else{
                        Utilities.showAlertWithTitle(title: response["error_code"] as! String, withMessage: response["message"] as! String, withNavigation: self)
                    }
                }
                
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
            }
        }
    }
    
    
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0 , y: 0, width: 230, height: 35))
        toastLabel.center = self.view.center
        toastLabel.backgroundColor = UIColor(hexString: "#FF6B02")
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
    

