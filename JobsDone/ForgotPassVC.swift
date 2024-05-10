//
//  ForgotPasswordVC.swift
//  JobsDone
//
//  Created by musharraf on 14/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import GLNotificationBar

class ForgotPassVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var number: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        number.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.title = "FORGOT ACCOUNT"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func forgetPassBtnClicked(_ sender: Any) {
        if emailTxt.text == "" && number.text == ""{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please Enter Valid Email Or Number", withNavigation: self)
            return
        }
        var dic = Dictionary<String,AnyObject>()
        if emailTxt.text != ""{
        dic["email"] = emailTxt.text as AnyObject
        }
        if number.text != ""{
        let txt = number.text!
        let numb = txt.components(separatedBy: ".")
        var realNum = ""
        if numb.count > 3{
        realNum = "\(numb[1])\(numb[2])\(numb[3])"
        dic["phone"] = realNum as AnyObject
        }
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: dic, method: "forgot-password", success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                        print(response)
                        let status_code = response["status_code"] as? Int
                        if status_code == 200{
                            if self.number.text != ""{
                                if let body = response["body"] as? Dictionary<String,AnyObject>
                                {
                                    if  let res = body["response"] as? Dictionary<String,AnyObject>
                                    {
                                        let status = res["status"] as? Bool
                                        if status!{
                                            let code = res["code"] as? Int
                                            let vc = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .confirmVC) as! ConfirmVC
                                            vc.codeReceived = code
                                            vc.confirmType = .ForgotPassword
                                            vc.userId = res["user_id"] as? Int
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }else{
                                        Utilities.showAlertWithTitle(title: "Error", withMessage: res["message"] as! String, withNavigation: self)
                                        }
                                    }
                                }

                            }else{
                                let info = response as? Dictionary<String,AnyObject>
                                let success = info?["success"] as? Bool
                                let notificationBar = GLNotificationBar(title: "Email Sent", message: "Please Check your email and change your password", preferredStyle: .simpleBanner , handler: { (notify) in
                                    print("selected")
                                })
                                notificationBar.showTime(3)
                            }
                        }else{
                            let mxg = response["message"] as? String
                            Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
                }
                    }, fail: { (response) in
                        print(response)
                        Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                    })
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
//            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
             let hasLeadingOne = true
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("+1.")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@.", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@.", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        
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
