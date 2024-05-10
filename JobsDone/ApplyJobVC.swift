//
//  ApplyJobVC.swift
//  JobsDone
//
//  Created by musharraf on 08/03/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SDWebImage

class ApplyJobVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UITextViewDelegate {
    var count = 1
    var id: Int?
    @IBOutlet weak var durationBtn: UIButton!
    @IBOutlet weak var filesLbl: UILabel!
    @IBOutlet weak var priceLbl: UITextField!
    @IBOutlet weak var bodyLbl: UITextView!
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var agreeCheck: UIButton!
    var name = ""
    var img = ""
    var params = Dictionary<String,AnyObject>()
    var image = ""
    var imgArr = [UIImage]()
    var durationArr = [DropDown]()
    var currentItem: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "APPLY TO JOB"
        clView.delegate = self
        clView.dataSource = self
        LoadJob()
        let img = #imageLiteral(resourceName: "grayback")
        imgArr.append(img)
        self.hideKeyboardWhenTappedAround()
        clView.reloadData()
        bodyLbl.delegate = self
        agreeCheck.tintColor = UIColor(hexString: "#FF6B00")
        agreeCheck.setFAIcon(icon: .FASquareO, iconSize: 30, forState: .normal)
        agreeCheck.tag = 0
        // Do any additional setup after loading the view.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text!  == "Your Message here"{
            textView.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SelectDuration(_ sender: UIButton)
    {
        var catKeys = [String]()
        var catVAlues = [String]()
        let new = self.durationArr.sorted { (first, second) -> Bool in
            (first.value ) < (second.value )
        }
        print(new)
        for k in new  as [DropDown]{
            catKeys.append(k.key)
            catVAlues.append(k.value)
        }
        ActionSheetStringPicker.show(withTitle: "Select Type", rows:catVAlues , initialSelection: 0, doneBlock: {picker, values, indexes in
            let txt = catVAlues[values]
            self.params["duration"] = catKeys[values] as AnyObject
            self.durationBtn.setTitle(txt, for: .normal)
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 110.0, height: 110.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.clView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicCVC
        let img = #imageLiteral(resourceName: "grayback")
        if imgArr[indexPath.item].pngData() != img.pngData(){
            cell.addImg.image = #imageLiteral(resourceName: "rubbish-bin-orange")
            cell.whiteBack.backgroundColor = UIColor.white
            cell.backBtn.backgroundColor = UIColor(hexString: "#FF6B00")

        }else{
            cell.whiteBack.backgroundColor = UIColor.clear
            cell.backBtn.backgroundColor = UIColor.lightGray
            cell.addImg.image = #imageLiteral(resourceName: "plus")
        }
        cell.backImg.image = self.imgArr[indexPath.row]
        cell.backBtn.tag = indexPath.row
        cell.backBtn.addTarget(self, action: #selector(self.AddPicture(sender:cell:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func AddPicture(sender: UIButton ,cell: PicCVC)
    {
        let img = #imageLiteral(resourceName: "grayback")
        if imgArr[sender.tag].pngData() != img.pngData(){
            imgArr.remove(at: sender.tag)
            clView.reloadData()
        }else{
        currentItem = sender.tag
        selectProfilePicPressed()
        }
        
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
    
    func selectProfilePicPressed() {
        
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
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
        
        // Set photoImageView to display the selected image.
        imgArr.insert(selectedImage, at: imgArr.count - 1)
        //        image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        let indxPath = IndexPath(item: imgArr.count - 1, section: 0)
        self.clView.reloadData()
        self.clView.scrollToItem(at: indxPath, at: UICollectionView.ScrollPosition.left, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    @IBAction func ClickedApplyJob(_ sender: UIButton)
    {
        if agreeCheck.tag == 0{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please Agree with Terms & Privacy", withNavigation: self)
            return
        }
        if bodyLbl.text == ""{
            Utilities.showAlertWithTitle(title: "Misisng", withMessage: "Message is missing", withNavigation: self)
            return
        }
        if self.imgArr.count > 1{
         let last =    self.imgArr.index(before: self.imgArr.count)
            self.imgArr.remove(at: last)
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        params["id"] = self.id! as AnyObject
        params["body"] = bodyLbl.text as AnyObject
            var param = Dictionary<String,String>()
            param["id"] = String(describing: self.id!)
            param["body"] = bodyLbl.text
        ALFWebService.sharedInstance.doPostDataWithMultiImage(parameters: param, method: "/jobs/apply", image: self.imgArr, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 204{
                    let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .invitationSuccess) as! InvitationSuccess
                    vc.name = self.name
                    vc.image = self.img
                    vc.type = Type.Apply
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
        }else{
            params["id"] = self.id! as AnyObject
            params["body"] = bodyLbl.text as AnyObject
          Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: self.params, method: "/jobs/apply", success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                if let status_code = response["status_code"] as? Int{
                    if status_code == 204{
                        let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .invitationSuccess) as! InvitationSuccess
                        vc.name = self.name
                        vc.image = self.img
                        vc.type = Type.Apply
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }, fail: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
            })
        }
        
    }
    
    func LoadJob()
    {
        let method = "/jobs/apply"
        params["id"] = self.id! as AnyObject
        ALFWebService.sharedInstance.doGetData(parameters: params, method: "/jobs/apply", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    if let durationOptions = body!["durationOptions"] as? Dictionary<String,AnyObject>{
                        for dur in durationOptions{
                            
                            let model  = DropDown()
                            model.key = dur.key
                            model.value = dur.value as! String
                            self.durationArr.append(model)
                        }
                    }
                    
                }else if status_code == 400{
                    let mxg = response["message"] as? String
                    let alert = UIAlertController(title: "", message: "You already applied to this job.", preferredStyle: UIAlertController.Style.alert)
                    
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                        self.navigationController?.popViewController(animated: true)
                        }))
                    if let popoverPresentationController = alert.popoverPresentationController {
                    }
                    Utilities.doCustomAlertBorder(alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    
    

}

