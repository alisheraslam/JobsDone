//
//  FeedbackVC.swift
//  JobsDone
//
//  Created by musharraf on 04/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import Cosmos

class AddFeedbackVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var skillView: CosmosView!
    @IBOutlet weak var availView: CosmosView!
    @IBOutlet weak var coopView: CosmosView!
    @IBOutlet weak var finishView: CosmosView!
    @IBOutlet weak var deadView: CosmosView!
    @IBOutlet weak var avgLbl: UILabel!
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var skillLbl: UILabel!
    @IBOutlet weak var availLbl: UILabel!
    @IBOutlet weak var coopLbl: UILabel!
    @IBOutlet weak var finLbl: UILabel!
    @IBOutlet weak var deadLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    var skillArr = [Category]()
    var image = ""
    var nametxt = ""
    var userId: Int!
    var sk = 0.0
    var avail = 0.0
    var coop = 0.0
    var fin  = 0.0
    var time = 0.0
    var dic = Dictionary<String,AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GIVE FEEDBACK TO"
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
        if image != ""{
        img.sd_setImage(with: URL(string: image))
        }
        name.text = nametxt
        LoadDetail()
        skillView.didFinishTouchingCosmos = { rating in
            self.dic["skills"] = rating as AnyObject
            self.sk = rating
            self.skillLbl.text = "\(rating)"
            self.CalAvg()
        }
        availView.didFinishTouchingCosmos = { rating in
            self.dic["availability"] = rating as AnyObject
            self.avail = rating
            self.availLbl.text = "\(rating)"
            self.CalAvg()
        }
        coopView.didFinishTouchingCosmos = { rating in
            self.dic["cooperative"] = rating as AnyObject
            self.coop = rating
            self.coopLbl.text = "\(rating)"
            self.CalAvg()
        }
        finishView.didFinishTouchingCosmos = { rating in
            self.dic["finishing"] = rating as AnyObject
            self.fin = rating
            self.finLbl.text = "\(rating)"
            self.CalAvg()
        }
        deadView.didFinishTouchingCosmos = { rating in
            self.dic["deadline"] = rating as AnyObject
            self.time = rating
            self.deadLbl.text = "\(rating)"
            self.CalAvg()
        }
        // Do any additional setup after loading the view.
    }
    func CalAvg()
    {
        let avg = ( self.sk + self.avail + self.coop + self.fin + self.time) /  5
        self.avgLbl.text = "\(avg)"
    }
    
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            UIView.animate(withDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            UIView.animate(withDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FeedBack(_ sender: UIButton)
    {
        if self.dic["skills"] as? Double == nil{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Provide Skill rating", withNavigation: self)
            return
        }
        if self.dic["availability"] as? Double == nil{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Provide Availability rating", withNavigation: self)
            return
        }
        if self.dic["cooperative"] as? Double == nil{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Provide Professionalism rating", withNavigation: self)
            return
        }
        if self.dic["finishing"] as? Double == nil{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Provide Finished rating", withNavigation: self)
            return
        }
        if self.dic["deadline"] as? Double == nil{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Provide Timeline rating", withNavigation: self)
            return
        }
        if txt.text == ""{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Provide Comment", withNavigation: self)
            return
        }
        let sk = self.dic["skills"] as! Double
        let avail = self.dic["availability"] as! Double
        let coo = self.dic["cooperative"] as! Double
        let fin = self.dic["finishing"] as! Double
        let dead = self.dic["deadline"] as! Double
        let avg =  (sk + avail + coo + fin  + dead ) / 5
        dic["avg_rating"] = avg as AnyObject
        dic["comments"] = txt.text! as AnyObject
        let method = "jobs/feedback"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code == 204{
                     NotificationCenter.default.post(name: Notification.Name("feedbackUploaded"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let mxg = response["message"] as? String
                    Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    
    //MARK: - LOAD USER DETAIL
    func LoadDetail()
    {
        let method = "user/profile/\(userId!)"
        var param = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: param, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    
                    if let responseObj   = body!["response"] as? Dictionary<String,AnyObject>
                    {
                        if let nam = responseObj["displayname"] as? String{
                            self.name.text = nam
                        }
                        if let location = responseObj["locationParams"] as? Dictionary<String,AnyObject>
                        {
                            let stat = location["state"] as? String
                            let code = location["state_code"] as? String
                            self.statusLbl.text = "\(stat!) \(code!)"
                        }
                        if let skills = responseObj["skills"] as? [Dictionary<String,AnyObject>]{
                            for skill in skills
                            {

                                let objModel  = Category.init(fromDictionary: skill)

                       self.skillArr.append(objModel)
                            }
                        }
                       
                        
                    }
                }
            }
        }){ (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
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
