//
//  PaypalVC.swift
//  JobsDone
//
//  Created by musharraf on 17/04/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class PaypalVC: UIViewController {
var dic3 = [:] as Dictionary<String, AnyObject>
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var terms: UILabel!
    @IBOutlet weak var heading: UILabel!
    var parentViewType = ParentViewType.SIGNUP
    var emailTxt : String!
    var emailId: Int!
    var dic = Dictionary<String,AnyObject>()
    var method = ""
    var  withImg = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CURRENT PAYMENT METHOD"
        if emailId != nil{
            if emailTxt != nil{
               heading.text = "DEBIT"
                email.text = emailTxt!
            }
            email.isEnabled = false
            submitBtn.setTitle("DELETE PAYMENT METHOD", for: .normal)
            terms.isHidden  = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ClickSubmit(_ sender: UIButton)
    {
     if sender.titleLabel?.text == "DELETE PAYMENT METHOD"
     {
        method = "/members/settings/method"
        dic = Dictionary<String,AnyObject>()
        dic["paypal_email"] = email.text! as AnyObject
        self.DeletePayment()
     }else{
        if (email.text!.isEmpty) || email.text == nil {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Email is missing" , withNavigation: self)
            return
        }
        if !isValidEmail(testStr: email.text!){
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Email is not Valid" , withNavigation: self)
            return
        }
        if parentViewType == .PROFILE{
            method = "/members/settings/method"
            dic = Dictionary<String,AnyObject>()
            dic["paypal_email"] = email.text! as AnyObject
            self.AddPaypal()
        }else if parentViewType == .SIGNUP{
            dic3["paypal_email"] = email.text as AnyObject
            let con = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
            con.dic3 = self.dic3
            con.parentType = ParentType.SIGNUP
            con.withImg = self.withImg
            self.navigationController?.pushViewController(con, animated: true)
        }else{
            method = "/members/settings/method"
            dic = Dictionary<String,AnyObject>()
            dic["paypal_email"] = email.text! as AnyObject
            self.AddPaypal()
        }
        }
    }
    
    func AddPaypal()
    {
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 204{
                    Utilities.showToast(message: "Success", con: self)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    func DeletePayment()
    {
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doDeleteData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 204{
                    NotificationCenter.default.post(name: Notification.Name("PaymentMethodUpdated"), object: nil,userInfo: nil)
                    Utilities.showToast(message: "Success", con: self)
                   self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
