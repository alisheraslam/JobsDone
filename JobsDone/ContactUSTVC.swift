//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class ContactUSTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
   
    
    //MARK: - IBOutlets
    @IBOutlet var contactTbl: UITableView!
    @IBOutlet weak var email_txt: UITextField? = nil
    @IBOutlet weak var name_txt: UITextField? = nil
    @IBOutlet weak var message_txt: WATextView? = nil
    
    @IBOutlet weak var sendBtn: WAButton!
    
    var pageTypes : pageType = pageType.contactus
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackbutton(title: "Back")
        self.navigationItem.title = "Contact Us"
        contactTbl.tableFooterView = UIView(frame: .zero)
        //Set Delegates
        email_txt?.delegate = self
        message_txt?.delegate = self
        
        if (UserDefaults.standard.value(forKey: "name") != nil) {
            name_txt?.text = UserDefaults.standard.value(forKey: "name") as? String
        }
        if (UserDefaults.standard.value(forKey: "email") != nil) {
            email_txt?.text = UserDefaults.standard.value(forKey: "email") as? String
        }
        
        email_txt?.text = "info@jobsdone.ca"
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if (app_links_color != "")
        {
            sendBtn.titleLabel?.textColor = UIColor(hexString: app_header_color)
            sendBtn.backgroundColors = UIColor(hexString: app_header_bg)
        }
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TextField Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //MARK:- IBActions
    
    @IBAction func sendMessageBtn(_ sender: Any) {
        
        email_txt?.resignFirstResponder()
        message_txt?.resignFirstResponder()
        name_txt?.resignFirstResponder()
        
        var dic = [:] as Dictionary<String, AnyObject>
        
        
        if (email_txt?.text?.isEmpty)! {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Email is missing!", withNavigation: self)
            return
        }
        if (message_txt?.text?.isEmpty)! {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Message is missing!", withNavigation: self)
            return
        }
        
        dic["email"] = email_txt?.text as AnyObject
        dic["body"] = message_txt?.text as AnyObject
        dic["name"] = name_txt?.text as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: "help/contact", success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let scode = response["status_code"] as? Int {
                if scode == 204 {
                    Utilities.showAlertWithTitle(title: "Success", withMessage: "Sent...!", withNavigation: self)
                    
                   
                }
            }
            
        }) { (response) in
            print(response)
        }
        
    }

}
