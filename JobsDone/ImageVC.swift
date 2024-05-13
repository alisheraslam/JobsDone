//
//  ImageVC.swift
//  JobsDone
//
//  Created by musharraf on 18/07/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import CropViewController
import Alamofire


class ImageVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate {
    @IBOutlet weak var profile_pic: UIImageView!
    @IBOutlet weak var disImg: UIImageView!
    @IBOutlet weak var profNewBtn: UIButton!
    @IBOutlet weak var profEditBtn: UIButton!
    @IBOutlet weak var disNewBtn: UIButton!
    @IBOutlet weak var disEditBtn: UIButton!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    var image: UIImage!
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var profNewPressed = true
    var editNewPressed = true
    var profileImg  = ""
    var dispImg  = ""
    var editPressed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        profNewBtn.tag = 1
        profEditBtn.tag = 1
        disNewBtn.tag = 2
        disEditBtn.tag = 2
        if self.dispImg == "https://servepk.plazauk.com/application/modules/User/externals/images/nophoto_user_thumb_profile.png"{
        self.profile_pic.image = #imageLiteral(resourceName: "default")
        }else{
            self.profile_pic.sd_setImage(with: URL(string: self.dispImg))
        }
        self.disImg.sd_setImage(with: URL(string: profileImg))
        if UserDefaults.standard.value(forKey: "level_id") as? Int == 7 || UserDefaults.standard.value(forKey: "level_id") as? Int == 8 {
            imgHeight.constant = 0
            self.profile_pic.isHidden = true
            self.disEditBtn.isHidden  = true
            self.disNewBtn.isHidden = true
        }
//        let btn = UIBarButtonItem(image: #imageLiteral(resourceName: "left_arrow"), style: .plain, target: self, action: #selector(self.CloseControll(_:)))
//        self.navigationItem.leftBarButtonItem = btn
        // Do any additional setup after loading the view.
    }
    func CloseControll(_ sender: UIBarButtonItem)
    {
        let imgArr: [UIImage] = [self.profile_pic.image!,self.disImg.image!]
        let img : [String: [UIImage]] = ["images": imgArr ]
        NotificationCenter.default.post(name: Notification.Name("ImagesSaved"), object: nil,userInfo: img)
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IMAGE VIEW DELEGATES
    @IBAction func ShowOptions(_ sender: UIButton)
    {
        if sender.tag == 1{
            self.profNewPressed = true
        }else{
            self.profNewPressed = false
        }
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
                //// MARK: UIImagePickerControllerDelegate
                func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                    // Dismiss the picker if the user canceled.
                    dismiss(animated: true, completion: nil)
                }
                func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
                    let selectedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
                    // Set photoImageView to display the selected image.
                    profile_pic.image = selectedImage
                    image = selectedImage
                    // Dismiss the picker.
                    dismiss(animated: true, completion: nil)
                }
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
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: selectedImage)
        if self.profNewPressed {
        let cgSize = CGSize(width: 300, height: 300)
            cropController.customAspectRatio = cgSize
        }else{
        let cgSize = CGSize(width: 720, height: 360)
            cropController.customAspectRatio = cgSize
        }
        cropController.aspectRatioLockEnabled = true
        cropController.delegate = self
        
//        picker.dismiss(animated: true, completion: {
//        self.present(cropController, animated: true, completion: nil)
            self.navigationController!.pushViewController(cropController, animated: true)
//        })
    }
    //MARK: - CROP VIEW CONTROLLER METHOD
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        if !editPressed{
        if self.profNewPressed {
            self.disImg.image = image
        }else{
           self.profile_pic.image = image
        }
        }else{
            if self.editNewPressed{
                self.disImg.image = image
            }else{
                self.profile_pic.image = image
            }
        }
        cropViewController.dismiss(animated: true, completion: nil)
        cropViewController.navigationController?.popViewController(animated: true)
        // 'image' is the newly cropped version of the original image
    }
    @IBAction func EditBtnPressed(_ sender: UIButton)
    {
        var img: UIImage!
        if sender.tag == 1{
            self.editNewPressed = true
            img = self.disImg.image
        }else{
            self.editNewPressed = false
            img = self.profile_pic.image
            
        }
        editPressed = true
        let cropController = CropViewController(croppingStyle: croppingStyle, image: img)
        if sender.tag == 1 {
            let cgSize = CGSize(width: 300, height: 300)
            cropController.customAspectRatio = cgSize
        }else{
            let cgSize = CGSize(width: 720, height: 360)
            cropController.customAspectRatio = cgSize
        }
        cropController.aspectRatioLockEnabled = true
        cropController.delegate = self
        self.navigationController!.pushViewController(cropController, animated: true)
    }
    //MARK: - Save Photo
    @IBAction func SavePhoto(_ sender: UIButton){
            var dic = Dictionary<String,AnyObject>()
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            let oauth_consumer_key = "k2h2kz0s4snfj7bh2l5242ctpw305nlg"
            let oauth_consumer_secret =  "b33c5kgu8m73wtspw3lvv5m9esn234ju"
        let manager = Alamofire.Session.default
            var headers: HTTPHeaders?
            headers =  ["oauth-consumer-key":oauth_consumer_key,"oauth-consumer-secret":oauth_consumer_secret,"Accept":"application/json"]
            if Utilities.isLoggedIn(){
                
                headers?["oauth-token"] = UserDefaults.standard.value(forKey: "oauth_token") as? String
                headers?["oauth-secret"] = UserDefaults.standard.value(forKey: "oauth_secret") as? String
                print(headers!)
            }
            DispatchQueue.main.async {
                manager.upload(
                    multipartFormData: { multipartFormData in
                        if UserDefaults.standard.value(forKey: "level_id") as? Int != 7 {
                            let imgData = (self.profile_pic.image?.jpeg(.lowest))!
                            multipartFormData.append(imgData, withName: "display_photo", fileName: "photo_.png", mimeType: "image/jpeg")
                        }
                        let imgData2 = (self.disImg.image?.jpeg(.lowest))!
                        multipartFormData.append(imgData2, withName: "photo", fileName: "photo_.png", mimeType: "image/jpeg")
                        print(multipartFormData)
                    },
                    to: "https://servepk.plazauk.com/sd/rest/members/edit/photo",
                    method: .post,
                    headers: headers)
                    .uploadProgress(queue: .main) { progress in
                        // Handle upload progress if needed
                    }
                    .responseJSON { response in
                        Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                        switch response.result {
                        case .success(let value):
                            print(value)
                            if let json = value as? [String: Any], let statusCode = json["status_code"] as? Int, statusCode == 200 {
                                NotificationCenter.default.post(name: Notification.Name("userImgChanged"), object: nil)
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .failure(let error):
                            print(error)
                            // Handle failure
                        }
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
