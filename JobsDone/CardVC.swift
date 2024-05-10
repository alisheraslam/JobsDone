//
//  CardVC.swift
//  JobsDone
//
//  Created by musharraf on 17/04/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CoreLocation

public enum ParentViewType{
    case SIGNUP
    case PROFILE
    case SIGNIN
}

class CardVC: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var csv: UITextField!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var agreeCheck: UIButton!
    var parentViewType = ParentViewType.SIGNUP
    var dic3 = [:] as Dictionary<String, AnyObject>
    var withImg = false
    var img: UIImage!
    var dic = Dictionary<String,AnyObject>()
    var pkgId:Int!
    var pkgModel: PackageModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Credit Card"
        cardNumber.delegate = self
        cardNumber.tag = 1
        monthBtn.tag = 1
        yearBtn.tag = 2
        csv.delegate = self
        csv.tag = 5
        agreeCheck.tintColor = UIColor(hexString: "#FF6B00")
        agreeCheck.setFAIcon(icon: .FASquareO, iconSize: 30, forState: .normal)
        agreeCheck.tag = 0
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    //MARK: - SEG AGREE
    @IBAction func SetAgree(_ sender: UIButton)
    {
        if agreeCheck.tag == 0{
            agreeCheck.tag = 1
            agreeCheck.setFAIcon(icon: .FACheckSquare, iconSize: 25, forState: .normal)
        }else{
            agreeCheck.tag = 0
            agreeCheck.setFAIcon(icon: .FASquareO, iconSize: 25, forState: .normal)
        }
    }
    
    @IBAction func termsSelect(_ sender: Any) {
        
        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .privacyVC) as! PrivacyPolicyController
        con.pageTypes = .terms
        self.navigationController?.pushViewController(con, animated: true)
    }
    @IBAction func privacyPolicySelect(_ sender: UIButton) {
        
        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .privacyVC) as! PrivacyPolicyController
        con.pageTypes = .policy
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    
    @IBAction func ShowPicker(_ sender: UIButton)
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let currentDate = NSDate()
        let maxDatecomponents = NSDateComponents()
//        maxDatecomponents.year = -12
        let maxDate: NSDate = calendar!.date(byAdding: maxDatecomponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePicker.Mode.date, selectedDate: maxDate as Date?, doneBlock: {
            picker, value, index in
            
            print("value = \(String(describing: value!))")
            
            let dateString = Utilities.stringFromDate(value as! Date)
            print(dateString)
            
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
        datePicker?.maximumDate = maxDate as Date?
        datePicker?.minimumDate = Date()
        datePicker?.show()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.utf16.count + string.utf16.count - range.length
        if textField.tag == 1{
            return newLength <= 16
        }else if textField.tag == 2{
            return newLength <= 5
        }else if textField.tag == 5{
            return newLength <= 3
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitClick(_ sender: UIButton)
    {
        
        if (firstName.text!.isEmpty) || firstName.text == nil {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "First name is missing" , withNavigation: self)
            return
        }
        if (lastName.text!.isEmpty) || lastName.text == nil {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Last name is missing" , withNavigation: self)
            return
        }
        if (cardNumber.text!.isEmpty) || cardNumber.text == nil {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Card number is missing" , withNavigation: self)
            return
        }
        if monthBtn.titleLabel!.text! == "Month"{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please enter Month", withNavigation: self)
            return
        }
        if yearBtn.titleLabel!.text! == "Year"{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please enter Year", withNavigation: self)
            return
        }
        
        if (csv.text!.isEmpty) || csv.text == nil {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "CSV is missing" , withNavigation: self)
            return
        }
        if agreeCheck.tag == 0{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please Agree with Terms & Privacy", withNavigation: self)
            return
        }
        let refreshAlert = UIAlertController(title: "Note", message: " You will be charged after expiration of your free period", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.ValidateCard()
            print("Handle Ok logic here")
        }))
//
//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//            print("Handle Cancel Logic here")
//        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
        
    }
    
    func ValidateCard()
    {
        let method = "/signup/validatecard"
        
        dic["csv"] =  csv.text as AnyObject
        dic["firstname"] = firstName.text as AnyObject
        dic["lastname"] =  lastName.text as AnyObject
        dic["cardnumber"] = cardNumber.text as AnyObject
        dic["expiry_date"] =  "\(yearBtn.titleLabel!.text!)-\(monthBtn.titleLabel!.text!)-1" as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        AFNWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int
            {
                if status_code == 200{
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let resp = body["response"] as? Dictionary<String,AnyObject>{
                            let status = resp["status"] as? Bool
                            if status!{
                                self.dic3["csv"] =  self.csv.text as AnyObject
                                self.dic3["firstname"] = self.firstName.text as AnyObject
                                self.dic3["lastname"] =  self.lastName.text as AnyObject
                                self.dic3["expiry_date"] =  "\(self.yearBtn.titleLabel!.text!)-\(self.monthBtn.titleLabel!.text!)-1" as AnyObject
                                self.dic3["cardnumber"] = self.cardNumber.text as AnyObject
                                let con = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
                                con.dic3 = self.dic3
                                con.withImg = self.withImg
                                if self.withImg{
                                    con.img = self.img
                                }
                                con.parentType = ParentType.SIGNUP
                                if self.parentViewType == .PROFILE{
                                    self.AddPaypal()
                                }else if self.parentViewType == .SIGNIN{
                                    self.AddPaypal()
                                }
                                else{
                                    if let typeId = self.dic3["profile_type"] as? String{
                                        if typeId != "7" && typeId != "8"{
                                            
                                            self.navigationController?.pushViewController(con, animated: true)
                                        }else{
                                            self.SaveUser()
                                        }
                                    }
//                                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
//                            self.navigationController?.pushViewController(con, animated: true)
                                }
                            }else{
                                let mxg = resp["errors"] as? [String]
                                Utilities.showAlertWithTitle(title: "Error", withMessage:  mxg![0], withNavigation: self)
                            }
                        }
                    }
                   
                }
            }
            
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    func AddPaypal()
    {
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic3, method: "/members/settings/method", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 204{
                    if self.parentViewType == .SIGNIN{
                        let refreshAlert = UIAlertController(title: "Pay using Debit Card", message: "Are you sure you want to pay \(self.pkgModel.currency)\(self.pkgModel.price)", preferredStyle: UIAlertController.Style.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Pay", style: .default, handler: { (action: UIAlertAction!) in
                            self.SetPackage(pkgId: self.pkgId)
                        }))
                        
                        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                            print("Handle Cancel Logic here")
                        }))
                        Utilities.doCustomAlertBorder(refreshAlert)
                        self.present(refreshAlert, animated: true, completion: nil)
                    }else{
                    NotificationCenter.default.post(name: Notification.Name("PaymentMethodUpdated"), object: nil,userInfo: nil)
                    Utilities.showToast(message: "Success", con: self)
                self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                }
                else{
                    let mxg = response["message"] as? String
                    Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    //MARK: - SET PACKAGE
    func SetPackage(pkgId: Int)
    {
        var dic = Dictionary<String,AnyObject>()
        dic["package_id"] = self.pkgId as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: "user/subscription/process", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 200 && self.parentViewType == .SIGNIN{
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
    
    
    @IBAction func ShowPickerMonth(_ sender: UIButton)
    {
        var val = [String]()
        var mnth = ["Month","01","02","03","04","05","06","07","08","09","10","11","12"]
        var key = [Int]()
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        if sender.tag == 1{
        for i in 0 ..< 13{
                key.append(i)
                val.append(mnth[i])
            }
        }else{
            for i in 0 ..< 5{
                key.append(year + i)
                val.append(String(describing: year + i))
            }
        }
            ActionSheetStringPicker.show(withTitle: sender.titleLabel?.text!, rows: val , initialSelection: 0, doneBlock: {picker, values, indexes in
                let month = key[values] as AnyObject
                if sender.tag == 1{
                   self.dic[sender.titleLabel!.text!.lowercased()] = month as AnyObject
                    sender.setTitle(String(describing: val[values]), for: .normal)
                }else{
                self.dic[sender.titleLabel!.text!.lowercased()] = month as AnyObject
                sender.setTitle(String(describing: month), for: .normal)
                }
            }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
    }
    
    //MARK: - SAVE CLIENT WITHOUT SKILL
    func SaveUser()
    {
        let method = "signup?subscriptionForm=1"
        dic3["fields_validation"] = 0 as AnyObject
        dic3["ip"] = "127.0.0.1" as AnyObject
        if self.img == nil{
            
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: dic3, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 200 {
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
                }else if scode == 401{
                    let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .wellcomeVC) as! WellcomeVC
                    self.present(con, animated: true, completion: nil)
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
            
            ALFWebService.sharedInstance.doPostDataWithImage(parameters: convertedDict, method: method, image: self.img, success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                if let scode = response["status_code"] as? Int {
                    if scode == 200 {
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
                        
                    }else if scode == 401{
                        let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .wellcomeVC) as! WellcomeVC
                        self.present(con, animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
