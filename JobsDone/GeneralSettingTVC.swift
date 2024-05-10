//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import ActionSheetPicker_3_0

class GeneralSettingTVC: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var time_zone_btn: WAButton!
    @IBOutlet weak var locale_btn: WAButton!
    
    @IBOutlet weak var sendBtn: WAButton!
    
    var locales = [String]()
    var locale_keys = [String]()
    var locale_key: String?
    var locale_value: String?
    
    var timeZone = [String]()
    var timeZone_keys = [String]()
    var timeZone_key: String?
    var timeZone_value: String?
    
    var user_name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackbutton(title: "Back")
        self.navigationItem.title = "General Settings"
        sendBtn.backgroundColor = UIColor(hexString: btnWithBGClr)
        if (UserDefaults.standard.value(forKey: "email") != nil){
            
            emailTxt.text = UserDefaults.standard.value(forKey: "email") as? String
            
        }
        if (UserDefaults.standard.value(forKey: "name") != nil){
            user_name = UserDefaults.standard.value(forKey: "name") as? String

        }
        emailTxt.delegate = self
        getSettingData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       emailTxt.resignFirstResponder()
    }
    func getSettingData(){
        let dic = [:] as Dictionary<String,AnyObject>
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: "members/settings/general", success: { (response) in
            
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            
            if let scode = response["status_code"] as? Int {
                if scode == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject> {
                        if let form = body["form"] as? [Dictionary<String,AnyObject>] {
                            for f in form {
                                if let val = f["name"] {
                                    if val as! String == "locale" {
                                        
                                        let dic = f["multiOptions"] as? Dictionary<String, AnyObject>
                                        let second = dic?.sorted { (first, second) -> Bool in
                                            (first.value as! String) < (second.value as! String)
                                        }
                                        for (k,v) in second!{
//                                            key.append(k)
//                                            val.append(v as! String)
                                            self.locales.append(v as! String)
                                            self.locale_keys.append(k)
                                            
                                            if (UserDefaults.standard.value(forKey: "locale") != nil){
                                                
                                                if UserDefaults.standard.value(forKey: "locale") as? String == k {
                                                    self.locale_btn.setTitle(v as? String, for: .normal)
                                                }
                                                
                                            }
                                        }
                                        
//                                        for (k,v) in (f["multiOptions"] as? Dictionary<String, AnyObject>)! {
//                                            self.locales.append(v as! String)
//                                            self.locale_keys.append(k)
//
//                                            if (UserDefaults.standard.value(forKey: "locale") != nil){
//
//                                                if UserDefaults.standard.value(forKey: "locale") as? String == k {
//                                                    self.locale_btn.setTitle(v as? String, for: .normal)
//                                                }
//
//                                            }
//                                        }
                                    } else if val as! String == "timezone" {
                                    
                                        for (k,v) in (f["multiOptions"] as? Dictionary<String, AnyObject>)! {
                                            
//                                            let second = objModel.multiOptions.sorted { (first, second) -> Bool in
//                                                (first.value as! String) < (second.value as! String)
//                                            }
//                                            for (k,v) in second{
//                                                key.append(k)
//                                                val.append(v as! String)
//                                            }
//
                                            self.timeZone.append(v as! String)
                                            self.timeZone_keys.append(k)
                                            
                                            if (UserDefaults.standard.value(forKey: "timezone") != nil){
                                                
                                                if UserDefaults.standard.value(forKey: "timezone") as? String == k {
                                                    self.time_zone_btn.setTitle(v as? String, for: .normal)
                                                    self.timeZone_key = UserDefaults.standard.value(forKey: "timezone") as? String
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
            

            print(self.locale_keys)
            print(self.locales)
            print(self.timeZone)
            print(self.timeZone_keys)
        }) { (response) in
            
        }
    }

    @IBAction func timeZoneBtnClicked(_ sender: Any) {
        
        emailTxt.resignFirstResponder()
        
        ActionSheetStringPicker.show(withTitle: "Select timeZone", rows: timeZone , initialSelection: 0, doneBlock: {picker, values, indexes in
            self.time_zone_btn.setTitle(self.timeZone[values], for: .normal)
            self.timeZone_key = self.timeZone_keys[values]
            self.timeZone_value = self.timeZone[values]
            
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
        
    }
    
    @IBAction func localeBtnClicked(_ sender: Any) {
        emailTxt.resignFirstResponder()
        ActionSheetStringPicker.show(withTitle: "Select Locale", rows: locales , initialSelection: 0, doneBlock: {picker, values, indexes in
            self.locale_btn.setTitle(self.locales[values], for: .normal)
            self.locale_key = self.locale_keys[values]
            self.locale_value = self.locales[values]

            
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)

    }
    
  
    @IBAction func saveChangesClicked(_ sender: Any) {
        
        var dic = [:] as Dictionary<String, AnyObject>
        
        if (UserDefaults.standard.value(forKey: "name") != nil) {
            dic["name"] = UserDefaults.standard.value(forKey: "name") as AnyObject
        }
        
        if (emailTxt?.text?.isEmpty)! {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Email is missing!", withNavigation: self)
            return
        }
        if time_zone_btn.currentTitle == nil {
            
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "TimeZone is missing!", withNavigation: self)
            return
        }
        if locale_btn.currentTitle == nil {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Locale is missing!", withNavigation: self)
            return
        }
        
        dic["email"] = emailTxt?.text as AnyObject
        dic["timezone"] = timeZone_key as AnyObject
        dic["locale"] = locale_key as AnyObject
        dic["username"] = "asd12" as AnyObject
        print(dic)
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: "members/settings/general", success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let scode = response["status_code"] as? Int {
                if scode == 204 {
                    UserDefaults.standard.set(self.emailTxt.text, forKey: "email")
                    UserDefaults.standard.set(self.timeZone_key, forKey: "timezone")
                    UserDefaults.standard.set(self.locale_key, forKey: "locale")
                    Utilities.showAlertWithTitle(title: "Success", withMessage: "Saved...!", withNavigation: self)
                    
                } else if scode == 401 {
                    Utilities.showAlertWithTitle(title: "Sorry", withMessage: "User does not have access to this resource!", withNavigation: self)
                }
            }
            
        }) { (response) in
            print(response)
        
        
        }
    }
    
}
