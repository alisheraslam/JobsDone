//
//  SendInvitationVC.swift
//  JobsDone
//
//  Created by musharraf on 08/03/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SendInvitationVC: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var jobBtn: UIButton!
    @IBOutlet weak var jobBtnView: UIView!
    @IBOutlet weak var mxgField: UITextField!
    @IBOutlet weak var mxgFieldView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var starImg: UIImageView!
    @IBOutlet weak var agreeCheck: UIButton!
    @IBOutlet weak var termsLbl: UIButton!
    @IBOutlet weak var privacyLbl: UIButton!
    @IBOutlet weak var completeLbl: UILabel!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var dropImg: UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var ratingLbl = ""
    var reviewsLbl = ""
    var nameLbl = ""
    var image = ""
    var jobsArr  = [Dictionary<String , String>]()
    var jobs = Dictionary<String , AnyObject>()
    var dic = Dictionary<String , AnyObject>()
    var user_id : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "INVITE CONTRACTOR"
        self.hideKeyboardWhenTappedAround()
        starImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 30, height: 30))
        mxgField.delegate = self
        rating.text = ratingLbl
        reviews.text = reviewsLbl
        name.text = nameLbl
        userImg.setImageWith(URL(string: image)!)
        agreeCheck.tintColor = UIColor(hexString: "#FF6B00")
        agreeCheck.setFAIcon(icon: .FASquareO, iconSize: 30, forState: .normal)
        agreeCheck.tag = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        loadJobs()
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            bottomConstraint.constant =  keyboardSize.height
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            bottomConstraint.constant = 0
        }
        
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: - AGREE TERMS & CONDITION
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
    override func viewWillAppear(_ animated: Bool) {
        loadJobs()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadJobs()
    {
       
        let method = "members/profile/invite"
        var dic = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let jobs = body["jobs"] as? Dictionary<String,AnyObject> {
                            self.jobs = jobs
                            self.jobBtn.isHidden = false
                            self.mxgField.isHidden = false
                            self.mxgFieldView.isHidden = false
                            self.agreeCheck.isHidden = false
                            self.completeLbl.isHidden = false
                            self.termsLbl.isHidden = false
                            self.privacyLbl.isHidden = false
                            self.dropImg.isHidden = false
                            self.inviteBtn.setTitle("SEND INVITATION", for: .normal)
                        }
                    }

                }else{
                    self.jobBtn.isHidden = true
                    self.mxgField.isHidden = true
                    self.mxgFieldView.isHidden = true
                    self.agreeCheck.isHidden = true
                    self.completeLbl.isHidden = true
                    self.termsLbl.isHidden = true
                    self.privacyLbl.isHidden = true
                    self.dropImg.isHidden = true
                    self.inviteBtn.setTitle("CREATE JOB", for: .normal)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    
    @IBAction func didClickJobBtn(_ sender: Any) {
        self.view.endEditing(true)

        var vals = [String]()
        var keys = [String]()

        for (k,v) in jobs{
//            print(job[1])
            if k != "0"
            {
                keys.append(k)
                vals.append(v as! String)
            }
        }
//        if jobs.count == 0{
//            vals.append("Add New Job")
//        }
        
        ActionSheetStringPicker.show(withTitle: "Select", rows: vals , initialSelection: 0, doneBlock: {picker, values, indexes in
                self.dic.removeAll()
            if !keys.isEmpty {
                self.jobBtn.setTitle(vals[values], for: .normal)
                self.dic["job_id"] = keys[values] as AnyObject
            }else{
                if vals[values] == "Add New Job"{
                    self.CreateJobClick()
                }
            }
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
    }
    
    func CreateJobClick()
    {
        let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .createJobVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func textFieldPrimaryAction(_ sender: UITextField) {
        sender.resignFirstResponder()
        dismissKeyboard()
    }
    
    @IBAction func didClickApplyBtn(_ sender: UIButton)
    {
        if sender.titleLabel?.text == "CREATE JOB"{
            self.CreateJobClick()
        }else{
        if agreeCheck.tag == 0{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please Agree with Terms & Conditions", withNavigation: self)
            return
        }
        if dic["job_id"] == nil
        {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "kindly Select Job", withNavigation: self)
            return
        }
        self.dic["message"] = self.mxgField.text as AnyObject
        self.dic["user_id"] = self.user_id as AnyObject
        let method = "/members/profile/invite/"
        print(dic)
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in

            print(response)
            let status = response["status_code"] as? Int
            if status == 204
            {
                let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .invitationSuccess) as! InvitationSuccess
                vc.name = self.nameLbl
                vc.image = self.image
                self.navigationController?.pushViewController(vc, animated: true)
            }

            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
        }
    }
   
  
}
