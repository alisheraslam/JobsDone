//
//  AddPhotoVC.swift
//  JobsDone
//
//  Created by musharraf on 12/04/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

class AddPhotoVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var profile_pic: WAImageView!
    var dic3 = [:] as Dictionary<String, AnyObject>
    var packageArr = [PackageModel]()
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NextBtnClicked(_ sender: Any) {
        if image == nil {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Image is missing", withNavigation: self)
            return
        }
        if self.packageArr.count > 0 {
        let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .membershipVC) as! MembershipVC
        con.dic3 = self.dic3
        con.withImg = true
        con.image = image
        con.packageArr = self.packageArr
        self.navigationController?.pushViewController(con, animated: true)
        }else{
            let con = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
            con.dic3 = self.dic3
            con.withImg = true
            con.img = self.image
            con.parentType = ParentType.SIGNUP
            if let typeId = self.dic3["profile_type"] as? String{
                if typeId != "7" && typeId != "8"{
                    
                    self.navigationController?.pushViewController(con, animated: true)
                }else{
                    self.SaveUser()
                }
            }
            
        }
    }
    @IBAction func SkipBtnClicked(_ sender: Any) {
        if self.packageArr.count > 0{
        let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .membershipVC) as! MembershipVC
        con.dic3 = self.dic3
        con.withImg = false
        con.packageArr = self.packageArr
        self.navigationController?.pushViewController(con, animated: true)
        }else{
            let con = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
            con.dic3 = self.dic3
            con.withImg = true
            con.img = self.image
            con.parentType = ParentType.SIGNUP
            if let typeId = self.dic3["profile_type"] as? String{
                if typeId != "7" && typeId != "8"{
            
            
            self.navigationController?.pushViewController(con, animated: true)
                }else{
                   
                self.SaveUser()
                }
            }
        }
    }
    
    
    @IBAction func selectProfilePicPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Select Option", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Open Camera", style: .default) { (alert) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                
                // Only allow photos to be picked, not taken.
                imagePickerController.sourceType = .camera
                
                // Make sure ViewController is notified when the user picks an image.
                imagePickerController.delegate = self
                
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Source Type is not available", withNavigation: self)
            }
            
            
        }
        let action2 = UIAlertAction(title: "Open Gallery", style: .default) { (alert) in
            
            let imagePickerController = UIImagePickerController()
            
            // Only allow photos to be picked, not taken.
            imagePickerController.sourceType = .photoLibrary
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let action3 = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        if DeviceType.iPad{
            if let popoverPresentationController = alert.popoverPresentationController {
                
                popoverPresentationController.sourceView = self.view
                
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
                //
                popoverPresentationController.permittedArrowDirections = []
                
            }
        }
        present(alert, animated: true, completion: nil)
    }
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
        
        // Set photoImageView to display the selected image.
        profile_pic.contentMode = UIView.ContentMode.scaleAspectFill
        profile_pic.layer.cornerRadius = 90
        profile_pic.layer.masksToBounds = true
        profile_pic.image = selectedImage
        image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - SAVE CLIENT WITHOUT SKILL
    func SaveUser()
    {
        let method = "signup?subscriptionForm=1"
        dic3["fields_validation"] = 0 as AnyObject
        dic3["ip"] = "127.0.0.1" as AnyObject
        if self.image == nil{
            
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: dic3, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 200 {
                    if let response = response as? Dictionary<String,AnyObject>
                    {
                        self.SetUSer(response: response)
                    }
                }else if scode == 401{
                    let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .wellcomeVC) as! WellcomeVC
                    self.present(con, animated: true, completion: nil)
                }else{
                    let mxg = (response.object(forKey: "message") as? String) ?? ""
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
            
            ALFWebService.sharedInstance.doPostDataWithImage(parameters: convertedDict, method: method, image: self.image, success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                if let scode = response["status_code"] as? Int {
                    if scode == 200 {
                        if let response = response as? Dictionary<String,AnyObject>
                        {
                            self.SetUSer(response: response)
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
    func SetUSer(response: Dictionary<String,AnyObject>)
    {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
