//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import FontAwesome_swift
import GLNotificationBar

public enum CONTROLLTYPE{
   case EMAILCHANGE
    case PASSWORDCHANGE
    case PHONECHANGE
    case RESETPASSWORD
}

class ChangePasswordTVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var oldLbl: UILabel?
    @IBOutlet weak var oldPassTxt: UITextField? = nil
    @IBOutlet weak var newLbl: UILabel?
    @IBOutlet weak var newPassTxt: UITextField? = nil
    @IBOutlet weak var newAgainLbl: UILabel?
    @IBOutlet weak var newAgainTxt: UITextField? = nil
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var lastView: UIView!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var firstImg: UIImageView!
    @IBOutlet weak var secondImg: UIImageView!
    @IBOutlet weak var thirdImg: UIImageView!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var EnterCodeBtn: UIButton!
    var controllType : CONTROLLTYPE = CONTROLLTYPE.EMAILCHANGE
    var dic = [:] as Dictionary<String, AnyObject>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackbutton(title: "Back")
        let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.lightGray, size: CGSize(width: 35, height: 35))
        firstImg.image = cheKImg
        secondImg.image = cheKImg
        thirdImg.image = cheKImg
        firstImg.isHidden = true
        EnterCodeBtn.isHidden = true
        orLbl.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.PhoneNumberChangeVerified), name: NSNotification.Name(rawValue: "PhoneNumberChangeVerified"), object: nil)
        if controllType == .EMAILCHANGE{
            self.navigationItem.title = "CHANGE EMAIL"
            topLbl.text = "CHANGE EMAIL"
            oldLbl?.text = "CURRENT EMAIL"
            newLbl?.text = "NEW EMAIL"
            oldPassTxt?.keyboardType = UIKeyboardType.emailAddress
            newPassTxt?.keyboardType = UIKeyboardType.emailAddress
            newAgainTxt?.keyboardType = UIKeyboardType.emailAddress
            newAgainLbl?.text = "CONFIRM NEW EMAIL"
            sendBtn.setTitle("CHANGE EMAIL", for: .normal)
            let email = UserDefaults.standard.value(forKey: "email") as! String
            oldPassTxt?.text = email
            let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.green, size: CGSize(width: 35, height: 35))
            firstImg.image = cheKImg
            oldPassTxt?.isUserInteractionEnabled = false
        }else if controllType == .PASSWORDCHANGE{
        self.navigationItem.title = "CHANGE PASSWORD"
            topLbl.text = "CHANGE PASSWORD"
            oldPassTxt?.keyboardType = UIKeyboardType.default
            newPassTxt?.keyboardType = UIKeyboardType.default
            oldPassTxt?.isSecureTextEntry = true
            newPassTxt?.isSecureTextEntry = true
            newAgainTxt?.isSecureTextEntry = true
            sendBtn.setTitle("CHANGE PASSWORD", for: .normal)
        }else if controllType == .PHONECHANGE{
            if let number  = UserDefaults.standard.value(forKey: "phone") as? String{
                if number.count > 0 {
                self.oldPassTxt?.text = "\(number)"
                }
            }
            if let numb  = UserDefaults.standard.value(forKey: "phone") as? Int{
                self.oldPassTxt?.text = "\(numb)"
            }
            let s  = self.formattedNumber(number: oldPassTxt!.text!)
            self.oldPassTxt?.text = s
            EnterCodeBtn.isHidden = false
            orLbl.isHidden = false
            self.navigationItem.title = "CHANGE MOBILE NUMBER"
            topLbl.text = "CHANGE MOBILE NUMBER"
            oldLbl?.text = "PLEASE ENTER VALID MOBILE NUMBER. A VERIFICATION CODE WILL BE SENT."
            newLbl?.text = ""
            oldPassTxt?.keyboardType = UIKeyboardType.numberPad
            oldPassTxt?.delegate = self
            newPassTxt?.isHidden = false
            oldPassTxt?.placeholder = ""
            newPassTxt?.placeholder = ""
            newAgainLbl?.isHidden = true
            newAgainTxt?.isHidden = true
            firstImg.isHidden = true
            thirdImg.isHidden = true
            secondImg.isHidden = true
            firstView.isHidden = false
            secondView.isHidden = true
            lastView.isHidden = true
            sendBtn.setTitle("SAVE MOBILE NUMBER", for: .normal)
            if UserDefaults.standard.value(forKey: "phone_verified") != nil{
                if let verify = UserDefaults.standard.value(forKey: "phone_verified") as? Bool{
                    if verify {
                        self.firstImg.isHidden = false
                    }else{
                        self.firstImg.isHidden = true
                    }
                }
            }
        }else if controllType == .RESETPASSWORD{
            self.navigationItem.title = "RESET PASSWORD"
            topLbl.text = "RESET PASSWORD"
            oldPassTxt?.isHidden = true
            firstView.isHidden = true
            firstImg.isHidden = true
            orLbl.isHidden = true
            EnterCodeBtn.isHidden = true
            oldLbl?.isHidden = true
            newPassTxt?.isSecureTextEntry = true
            newAgainTxt?.isSecureTextEntry = true
            newPassTxt?.placeholder = "******"
            newAgainTxt?.placeholder = "******"
            sendBtn.setTitle("UPDATE PASSWORD", for: .normal)
        }
        oldPassTxt?.addTarget(self, action: #selector(textFieldDidChangeOne(textField:)), for: .editingChanged)
        newPassTxt?.addTarget(self, action: #selector(textFieldDidChangeTwo(textField:)), for: .editingChanged)
        newAgainTxt?.addTarget(self, action: #selector(textFieldDidChangeThree(textField:)), for: .editingChanged)

    }
    override func viewWillAppear(_ animated: Bool) {
    }
    //MARK: - Number FORMATTING
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
    @objc func PhoneNumberChangeVerified()
    {
        dic["verified"] = 1 as AnyObject
        self.changePassBtnClicked(sendBtn)
    }
    
    @objc func textFieldDidChangeOne(textField: UITextField) {
        if controllType == .EMAILCHANGE{
        if isValidEmail(testStr: (oldPassTxt?.text)!)
        {
            let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.green, size: CGSize(width: 35, height: 35))
             firstImg.image = cheKImg
            
            
        }else{
            let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.lightGray, size: CGSize(width: 35, height: 35))
            firstImg.image = cheKImg
        }
        }else if controllType == .PASSWORDCHANGE{
            if oldPassTxt!.text!.count >= 6{
                let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.green, size: CGSize(width: 35, height: 35))
                firstImg.image = cheKImg
            }else{
                let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.lightGray, size: CGSize(width: 35, height: 35))
                secondImg.image = cheKImg
            }
        }else if controllType == .PHONECHANGE{
            
        }
    }
    @objc func textFieldDidChangeTwo(textField: UITextField) {
        if controllType == .EMAILCHANGE{
            if isValidEmail(testStr: (newPassTxt?.text)!)
            {
                let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor(hexString: "#17A916"), size: CGSize(width: 35, height: 35))
                secondImg.image = cheKImg
            }else{
                let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.lightGray, size: CGSize(width: 35, height: 35))
                secondImg.image = cheKImg
            }
        }else if controllType == .PASSWORDCHANGE || controllType == .RESETPASSWORD{
            if newPassTxt!.text!.count >= 6{
                let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor(hexString: "#17A916"), size: CGSize(width: 35, height: 35))
                secondImg.image = cheKImg
            }else{
                let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.lightGray, size: CGSize(width: 35, height: 35))
                secondImg.image = cheKImg
            }
        }
    }
    @objc func textFieldDidChangeThree(textField: UITextField) {
        if controllType == .EMAILCHANGE{
        if isValidEmail(testStr: (newAgainTxt?.text)!)
        {
            if newAgainTxt?.text! == newPassTxt?.text! {
            let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor(hexString: "#17A916"), size: CGSize(width: 35, height: 35))
            thirdImg.image = cheKImg
            }else{
                let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.lightGray, size: CGSize(width: 35, height: 35))
                thirdImg.image = cheKImg
            }
        }else{
            let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.lightGray, size: CGSize(width: 35, height: 35))
            thirdImg.image = cheKImg
        }
        }else if controllType == .PASSWORDCHANGE || controllType == .RESETPASSWORD {
            if newAgainTxt!.text!.count >= 6{
                if newAgainTxt?.text! == newPassTxt?.text! {
                let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor(hexString: "#17A916"), size: CGSize(width: 35, height: 35))
                thirdImg.image = cheKImg
                }
            }else{
                let cheKImg = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.lightGray, size: CGSize(width: 35, height: 35))
                thirdImg.image = cheKImg
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- TextField Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField
        print(nextField as Any)
        if textField.tag == 2 {
            textField.resignFirstResponder()
        }
        else if nextField != nil {
            nextField?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func isValidated(_ password: String) -> Bool {
        var lowerCaseLetter: Bool = false
        var upperCaseLetter: Bool = false
        var digit: Bool = false
        var specialCharacter: Bool = false
        
        if password.count  >= 8 {
            for char in password.unicodeScalars {
                if !lowerCaseLetter {
                    lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
                }
                if !upperCaseLetter {
                    upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
                }
                if !digit {
                    digit = CharacterSet.decimalDigits.contains(char)
                }
                if !specialCharacter {
                    specialCharacter = CharacterSet.punctuationCharacters.contains(char)
                }
            }
            if specialCharacter || (digit && lowerCaseLetter && upperCaseLetter) {
                //do what u want
                return true
            }
            else {
                return false
            }
        }
        return false
    }

    @IBAction func changePassBtnClicked(_ sender: Any) {
         var method = "/members/settings/email"
        if controllType == .PHONECHANGE{
            if oldPassTxt!.text!.isEmpty{
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "Phone Number is missing!", withNavigation: self)
                return
            }
            method = "/user/verify/change-mobile"
            let numb = oldPassTxt!.text!.replacingOccurrences(of: ".", with: "")
            if numb.count > 0{
            dic["mobileno"] = numb as AnyObject
            }
        }else if controllType == .RESETPASSWORD{
            if !isValidated(oldPassTxt!.text!){
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "Please enter at least 8 characters \n Password must include at least one number/digit, one lowercase letter and one uppercase letter.", withNavigation: self)
                return
            }
                if (newAgainTxt?.text?.isEmpty)! {
                    Utilities.showAlertWithTitle(title: "Alert", withMessage: "New Password (again) is missing!", withNavigation: self)
                    return
                }
                if !((newPassTxt?.text?.count)! >= 6) {
                    Utilities.showAlertWithTitle(title: "Alert", withMessage: "Password Length should be of at least 6 characters!", withNavigation: self)
                    return
                }
           
                if !(newPassTxt?.text == newAgainTxt?.text) {
                    Utilities.showAlertWithTitle(title: "Alert", withMessage: "Password does not match!", withNavigation: self)
                    return
                }
            
                method = "reset-password"
                dic["password"] = newPassTxt?.text as AnyObject
                dic["password_confirm"] = newAgainTxt?.text as AnyObject
        }else if controllType == .EMAILCHANGE{
            if (oldPassTxt?.text?.isEmpty)! {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(oldLbl!.text!) is missing!", withNavigation: self)
                return
            }else if !isValidEmail(testStr: oldPassTxt!.text!){
                if controllType != .PASSWORDCHANGE{
                    Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(oldLbl!.text!) is not valid!", withNavigation: self)
                    return
                }
            }
            if (newPassTxt?.text?.isEmpty)! {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(newLbl!.text!) is missing!", withNavigation: self)
                return
            }else if !isValidEmail(testStr: newPassTxt!.text!){
                if controllType != .PASSWORDCHANGE{
                    Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(newLbl!.text!) is not valid!", withNavigation: self)
                    return
                }
            }
            if (newAgainTxt?.text?.isEmpty)! {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "Confirm Email is missing!", withNavigation: self)
                return
            }else if !isValidEmail(testStr: newAgainTxt!.text!){
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(newLbl!.text!) is not valid!", withNavigation: self)
                return
            }
            if newPassTxt?.text! != newAgainTxt?.text!{
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(newLbl!.text!) and  \(newAgainLbl!.text!)  is not same!", withNavigation: self)
                return
            }
            method = "/members/settings/email"
            dic["email"] = newPassTxt?.text as AnyObject
        }else if controllType == .PASSWORDCHANGE{
            if (oldPassTxt?.text?.isEmpty)! {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(oldLbl!.text!) is missing!", withNavigation: self)
                return
            }
            if !((oldPassTxt?.text?.count)! >= 6) {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(oldLbl!.text!) Length should be of at least 6 characters!", withNavigation: self)
                return
            }
            if (newPassTxt?.text?.isEmpty)! {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(newLbl!.text!) is missing!", withNavigation: self)
                return
            }
            if !((newPassTxt?.text?.count)! >= 6) {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "Password Length should be of at least 6 characters!", withNavigation: self)
                return
            }
            if (newAgainTxt?.text?.isEmpty)! {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "New Password (again) is missing!", withNavigation: self)
                return
            }
            
            if !(newPassTxt?.text == newAgainTxt?.text) {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "Password does not match!", withNavigation: self)
                return
            }
            method = "members/settings/password"
            dic["oldPassword"] = oldPassTxt?.text as AnyObject
            dic["password"] = newPassTxt?.text as AnyObject
            dic["passwordConfirm"] = newAgainTxt?.text as AnyObject
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let scode = response["status_code"] as? Int {
                if scode == 204 {
                    if self.controllType == .RESETPASSWORD{
                        Utilities.showAlertWithTitle(title: "Success", withMessage: "New Password Saved", withNavigation: self)
                        let notificationBar = GLNotificationBar(title: "Reset Password", message: "Password is reset successfully.", preferredStyle: .simpleBanner , handler: { (notify) in
                              })
                        notificationBar.showTime(3)
                        let app = UIApplication.shared.delegate as! AppDelegate
                        app.isCheckLogIn()
                    }else{
                    Utilities.showAlertWithTitle(title: "Success", withMessage: "Changed...!", withNavigation: self)
                    if self.controllType == .EMAILCHANGE{
                    UserDefaults.standard.set(self.newPassTxt?.text, forKey: "email")
                    self.oldPassTxt?.text = self.newPassTxt?.text!
                    }
                    }
                } else if self.controllType == .PHONECHANGE && scode == 200{
                    let vc = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .confirmVC) as! ConfirmVC
                    vc.confirmType = ConfirmType.PhoneChange
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    let res = body!["response"] as? Dictionary<String,AnyObject>
                    let status = res!["status"] as! Bool
                    if status{
                       let code =  res!["code"] as? Int
                       let number = self.dic["mobileno"] as! String
                        UserDefaults.standard.set(code, forKey: "code")
                        UserDefaults.standard.set(number, forKey: "phone")
                    vc.codeReceived = code
                        vc.phoneNumber = number
//                    self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        Utilities.showAlertWithTitle(title: "Error", withMessage: (res!["message"] as? String)!, withNavigation: self)
                    }
                }else {
                    Utilities.showAlertWithTitle(title: "Sorry", withMessage: "User does not have access to this resource!", withNavigation: self)
                }
            }
            
        }) { (response) in
            print(response)
        }

        
    }
    
    private func formattedNumber(number: String) -> String {
        var cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var mask = ""
        if number.count == 10{
            mask = "+1.XXX.XXX.XXXX"
        }else{
            mask = "+X.XXX.XXX.XXXX"
        }
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    @IBAction func EnterCodePressed(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .confirmVC) as! ConfirmVC
        vc.confirmType = ConfirmType.EnterCode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

