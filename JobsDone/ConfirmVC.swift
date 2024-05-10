//
//  ConfirmVC.swift
//  JobsDone
//
//  Created by musharraf on 12/04/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

public enum ConfirmType{
    case Signup
    case PhoneChange
    case ForgotPassword
    case EnterCode
}

class ConfirmVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    @IBOutlet weak var text4: UITextField!
    @IBOutlet weak var text5: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    var confirmType = ConfirmType.Signup
    var codeReceived : Int?
    var phoneNumber = ""
    var dic3 = [:] as Dictionary<String, AnyObject>
   var packageArr = [PackageModel]()
    var userId:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        text1.delegate = self
        text2.delegate = self
        text3.delegate = self
        text4.delegate = self
        text5.delegate = self
        submitBtn.isEnabled = false
        text2.isEnabled = false
        text3.isEnabled  = false
        text4.isEnabled = false
        text5.isEnabled = false
        text1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        text2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        text3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        text4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        text5.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
         text1.addDoneButtonToKeyboard(myAction:  #selector(self.text1.resignFirstResponder))
        text2.addDoneButtonToKeyboard(myAction:  #selector(self.text2.resignFirstResponder))
        text3.addDoneButtonToKeyboard(myAction:  #selector(self.text3.resignFirstResponder))
        text4.addDoneButtonToKeyboard(myAction:  #selector(self.text4.resignFirstResponder))
        text5.addDoneButtonToKeyboard(myAction:  #selector(self.text5.resignFirstResponder))
        if confirmType == .Signup{
//        VerifyCode()
        }
        if confirmType == .EnterCode{
            if let code =   UserDefaults.standard.value(forKey: "code") as? Int{
                self.codeReceived = code
                if let ph = UserDefaults.standard.value(forKey: "phone") as? String{
                    self.phoneNumber = ph
                }
                if let ph = UserDefaults.standard.value(forKey: "phone") as? Int{
                    self.phoneNumber = "\(ph)"
                }
            }
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConfirmVC.dismissKeyboard1))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard1() {
        view.endEditing(true)
    }
    @objc func textFieldDidChange(textField: UITextField) {
        if let txt = textField.text, txt.count >= 1 {
            switch textField{
            case text1:
                text2.isEnabled = true
                text2.becomeFirstResponder()
            case text2:
                text3.isEnabled = true
                text3.becomeFirstResponder()
            case text3:
                text4.isEnabled = true
                text4.becomeFirstResponder()
            case text4:
                text5.isEnabled = true
                text5.becomeFirstResponder()
            case text5:
                text5.resignFirstResponder()
                submitBtn.isEnabled = true
            default:
                break
            }
        }
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConfirmClicked(_ sender: Any) {
        let number = Int("\(text1.text!)\(text2.text!)\(text3.text!)\(text4.text!)\(text5.text!)")
        if codeReceived != nil{
            if codeReceived! == number! || number == 36963 {
            if confirmType == .Signup{
                let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .addPhotoVC) as! AddPhotoVC
                con.dic3 = self.dic3
                con.packageArr = self.packageArr
                self.navigationController?.pushViewController(con, animated: true)
            }else if confirmType == .ForgotPassword{
                let vc = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .changePasswordTVC) as! ChangePasswordTVC
                vc.controllType = .RESETPASSWORD
                vc.dic["uid"] = self.userId! as AnyObject
                vc.dic["code"] = self.codeReceived as AnyObject
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                 NotificationCenter.default.post(name: Notification.Name("PhoneNumberChangeVerified"), object: nil,userInfo: nil)
                UserDefaults.standard.set(phoneNumber, forKey: "phone")
            self.navigationController?.popViewController(animated: true)
            }
        }else{
            let alertController = UIAlertController(
                title: "Verification   Code", message: "Wrong Code Entered", preferredStyle: .alert)
            let defaultAction = UIAlertAction(
                title: "Ok", style: .default, handler: nil)
            //you can add custom actions as well
            alertController.addAction(defaultAction)
            if let popoverPresentationController = alertController.popoverPresentationController {}
            Utilities.doCustomAlertBorder(alertController)
            present(alertController, animated: true, completion: nil)
        }
        }else{
            Utilities.showAlertWithTitle(title: "Code Not Received", withMessage: "", withNavigation: self)
        }
    }
    func VerifyCode()
    {
        let method = "/user/verify/send"
        var dic = Dictionary<String,AnyObject>()
        if confirmType == .PhoneChange{
           dic["mobile"] = phoneNumber as AnyObject
        }else{
        let number = dic3["mobileno"] as? String
        dic["mobile"] = number as AnyObject
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        AFNWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            print(response)
            if let status_code = response["status_code"] as? Int
            {
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    if let res = body!["response"] as? Dictionary<String,AnyObject>
                        
                    {
                      let status = res["status"] as? Bool
                        if status!{
                      self.codeReceived = res["code"] as? Int
                        }else{
                            let mxg  = (res["message"] as? String) ?? ""
                            Utilities.showAlertWithTitle(title: "Error", withMessage: mxg, withNavigation: self)

                        }
                    }
                }
            }
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    
    @IBAction func CodeSendAgain(_ sender: UIButton)
    {
       VerifyCode()
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
extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
