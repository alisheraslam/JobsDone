// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan

import UIKit

class EmailAttachmentView: UIView,UITextFieldDelegate,UITextViewDelegate {

    
    @IBOutlet weak var toTextField: UITextField!
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var emailButton: UIButton!
    var menu = GutterMenuModel()
    var con = UIViewController()
    var blurrView = UIView()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        let view = instanceFromNib()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
        messageTextView.delegate = self
        toTextField.delegate = self
        subjectTextField.delegate = self
        emailButton.isEnabled = false
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == toTextField{
            print(string)
            let str : NSString = textField.text! as NSString
            let str2  = str.replacingCharacters(in: range, with: string)
            if Utilities.isValidEmail(testStr: str2) == true{
                textField.textColor = UIColor.black
            }else{
                textField.textColor = UIColor.red
            }
            checkEmailActivation(emailTextField:str2 as NSString , subjectTextField: subjectTextField.text! as NSString)
        }
        if textField == subjectTextField{
            print(string)
            let str : NSString = textField.text! as NSString
            let str2  = str.replacingCharacters(in: range, with: string)
            checkEmailActivation(emailTextField:toTextField.text! as NSString , subjectTextField: str2 as NSString)
        }
        
        return true
        
    }
    
    func checkEmailActivation(emailTextField:NSString,subjectTextField:NSString){
        
        if Utilities.isValidEmail(testStr: emailTextField as String) == true && subjectTextField.length > 0{
            emailButton.isEnabled = true
        }else{
            emailButton.isEnabled = false
        }
        
    }
    private func instanceFromNib() -> UIView {
        //        return UINib(nibName: "VideoAttachAlertView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func cancelButtonSelects(_ sender: Any) {
        self.removeFromSuperview()
        blurrView.removeFromSuperview()
    }
    @IBAction func emailButtonSelects(_ sender: Any) {
        
        
        self.removeFromSuperview()
        blurrView.removeFromSuperview()
        
        let url = menu.url
        var urlParams = Dictionary<String,AnyObject>()
        urlParams["to"] = toTextField.text as AnyObject
        urlParams["subject"] = subjectTextField.text as AnyObject
        urlParams["message"] = messageTextView.text as AnyObject
        
        //        urlParams = menu.urlParams
        self.removeFromSuperview()
        print("url is \(url) \n and parms are \(urlParams)" )
        Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
        ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.con.navigationController?.view)!)
            print(response)
            let scode = response["status_code"] as! Int
            if scode == 200 {
                
            } else {
                
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.con.navigationController?.view)!)
            print(response)
            
        }
        
        print(menu.urlParams)

    }
    

}
