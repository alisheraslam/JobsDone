//
//  AddSignUpPhotoTVC.swift
//  SchoolChain
//
//  Created by musharraf on 4/11/17.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit
import SDWebImage

class AddSignUpPhotoTblVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    // MARK: - IBOutlets
    @IBOutlet weak var profile_pic: WAImageView!
    
    
    var dic3 = [:] as Dictionary<String, AnyObject>
    
    var image: UIImage?
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dic3)
        dic3["ip"] = "127.0.0.1" as AnyObject
        if UserDefaults.standard.object(forKey: "image") != nil {
            let url = URL(string: UserDefaults.standard.object(forKey: "image") as! String)
            profile_pic.setImageWith(url!)
            image = profile_pic.image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
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
        
        let cancelActForIPhone = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        })
        let cancelActForIPad = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            
        })
        
        alert.addAction(action1)
        alert.addAction(action2)
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            alert.addAction(cancelActForIPad)
        } else {
            alert.addAction(cancelActForIPhone)
        }
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            if let popoverPresentationController = alert.popoverPresentationController {
                
                popoverPresentationController.sourceView = self.view
                
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
                //
                popoverPresentationController.permittedArrowDirections = []
                
                
                
            }
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func savePhotoPressed(_ sender: Any) {
        if image == nil {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Image is missing", withNavigation: self)
            return
        }
        
        print(image as Any)
        print(dic3 as Any)
        var dic4 = Dictionary<String,String>()
        for (k,v) in dic3{
            dic4[k] = String(describing: v)
        }
        dic4["device_type"] = "ios"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostDataWithImage(parameters: dic4, method: "signup", image: image!, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let scode = response["status_code"] as? Int {
                if scode == 200 {
                    
                    if let body = response["body"] as? Dictionary<String, AnyObject> {
                        
                        if let usr = body["user"] as? Dictionary<String, AnyObject> {
                            
                            self.user = User.init(usr)
                            
                            if let oauth_token = body["oauth_token"] as? String{
                                if let oauth_secret = body["oauth_secret"] as? String{
                                    
                                    self.user.oauth_token = oauth_token
                                    self.user.oauth_secret = oauth_secret
                                }
                            }
                            UserDefaults.standard.set((self.dic3["email"])!, forKey: "email")
                            UserDefaults.standard.set(self.user.oauth_token, forKey: "oauth_token")
                            UserDefaults.standard.set(self.user.oauth_secret, forKey: "oauth_secret")
                            UserDefaults.standard.set(self.user.displayname, forKey: "name")
                            UserDefaults.standard.set(self.user.userId!, forKey: "id")
                            UserDefaults.standard.set(self.user.image, forKey: "image")
                            
                            if UserDefaults.standard.object(forKey: "downloads") == nil {
                                
                                //            var downloads = [Dictionary<String, AnyObject>]()
                                
                                var downloads = [String: [Dictionary<String, AnyObject>]]()
                                downloads[String(self.user.userId!)] = [Dictionary<String, AnyObject>()]
                                UserDefaults.standard.set(downloads, forKey: "downloads")
                            } else {
                                var downloads = UserDefaults.standard.object(forKey: "downloads") as? [String: [Dictionary<String, AnyObject>]]
                                for (k,_) in downloads! {
                                    if k != String(self.user.userId!) {
//                                        downloads?[String(self.user.userId!)] = [Dictionary<String, AnyObject>()]
                                        downloads?[String(self.user.userId!)] = [[:]]
                                        UserDefaults.standard.set(downloads, forKey: "downloads")
                                    }
                                }
                            }
                        }
                    }
                    
                    let app = UIApplication.shared.delegate as! AppDelegate
                    app.isCheckLogIn()
                    
                } else {
                    
                    Utilities.showAlertWithTitle(title: "Error", withMessage: "Could not sign up. Please try again!", withNavigation: self)
                }
            }
            
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
        
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        dic3["device_type"] = "ios" as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic3, method: "signup", success: { (response) in
            print(response)
            
            if let scode = response["status_code"] as? Int {
                if scode == 200 {
                   
                    if let body = response["body"] as? Dictionary<String, AnyObject> {
                        
                        
                        if let usr = body["user"] as? Dictionary<String, AnyObject> {
                            
                            self.user = User.init(usr)
                            
                            if let oauth_token = body["oauth_token"] as? String{
                                if let oauth_secret = body["oauth_secret"] as? String{
                                    
                                    self.user.oauth_token = oauth_token
                                    self.user.oauth_secret = oauth_secret
                                }
                            }
                            UserDefaults.standard.set((self.dic3["email"])!, forKey: "email")
                            UserDefaults.standard.set(self.user.oauth_token, forKey: "oauth_token")
                            UserDefaults.standard.set(self.user.oauth_secret, forKey: "oauth_secret")
                            UserDefaults.standard.set(self.user.displayname, forKey: "name")
                            UserDefaults.standard.set(self.user.userId!, forKey: "id")
                            UserDefaults.standard.set(self.user.image, forKey: "image")
                            
                            if UserDefaults.standard.object(forKey: "downloads") == nil {
                                
                                //            var downloads = [Dictionary<String, AnyObject>]()
                                
                                var downloads = [String: [Dictionary<String, AnyObject>]]()
//                                downloads[String(self.user.userId!)] = [Dictionary<String, AnyObject>()]
                                downloads[String(self.user.userId!)] = [[:]]
                                UserDefaults.standard.set(downloads, forKey: "downloads")
                            }
                        }
                    }
                    
                    let app = UIApplication.shared.delegate as! AppDelegate
                    app.isCheckLogIn()
                    
                } else {
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                    Utilities.showAlertWithTitle(title: "Error", withMessage: "Could not sign up. Please try again!", withNavigation: self)
                }
            }

        }) { (response) in
            print(response)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        profile_pic.image = selectedImage
        image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
 
    
}
