//
//  CreatePortfolioVC.swift
//  JobsDone
//
//  Created by musharraf on 22/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

public enum PortfolioType{
    case Create
    case Edit
}

class CreatePortfolioVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var catViewHeight: NSLayoutConstraint!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var totalImg: UILabel!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var skillClv: UICollectionView!
    @IBOutlet weak var folioClv: UICollectionView!
    @IBOutlet weak var folioClvHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBtn: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var pager: CustomPager!
    var formValues = Dictionary<String,AnyObject>()
    var photos = [UIImage]()
    var img : UIImage!
    var skillArr = [Category]()
    var portfolioType = PortfolioType.Create
    var urlParams = Dictionary<String,AnyObject>()
    var url = ""
    var photosArr = [PortfolioImgModel]()
    var totalImgCount = 0
    var currentIndex:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
//        plusImg.setFAIconWithName(icon : .FAPlus, textColor: UIColor.darkGray)
        pager.type = "portfolio"
        folioClvHeight.constant = 190
        folioClv.isHidden = true
        catViewHeight.constant = 0
        catView.isHidden = true
        self.title = "UPLOAD PORTFOLIO"
        NotificationCenter.default.addObserver(self, selector: #selector(self.LoadSelectedSkills(_:)), name: NSNotification.Name(rawValue: "SelectedPortSkill"), object: nil)
        skillClv.delegate = self
        skillClv.dataSource = self
        folioClv.delegate = self
        folioClv.dataSource = self
        if portfolioType == .Edit{
            
            submitBtn.setTitle("UPDATE PORTFOLIO", for: .normal)
            LoadEditPortfolio()
        }
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        if photos.count > 0{
            folioClvHeight.constant = 365
          self.folioClv.reloadData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            bottomBtn.constant =  keyboardSize.height - 50
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            bottomBtn.constant = 0
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if skillArr.count > 0{
            catViewHeight.constant = 60
            catView.isHidden = false
            DispatchQueue.main.async {
                self.skillClv.reloadData()
            }
        }
    }
    
    
    //MARK: - TEXT LIMITS
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        guard let cell = textField.superview?.superview?.superview as? PortfolioCell else{
            return false
        }
        if textField.tag == 1{
            
            cell.titleCount.text = "-\( 50 - newLength)"
           return newLength <= 50
           
        }
        cell.detailCount.text = "-\(255 - newLength)"
        return newLength <= 255
    }
    
    @objc func LoadSelectedSkills(_ notifcation: NSNotification)
    {
        if let skills = notifcation.userInfo!["skills"] as? [Category] {
            skillArr = skills
            if skillArr.count > 0{
                catViewHeight.constant = 60
                catView.isHidden = false
                DispatchQueue.main.async {
                    self.skillClv.reloadData()
                }
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func OnclickCategory(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
        vc.parentType = .PORTFOLIO
        vc.selectSkillData = self.skillArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MAR: - COLLECTION VIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == folioClv{
            pager.numberOfPages = photosArr.count
            pager.currentPage = 0
            pager.isHidden = !(photosArr.count > 0)
            if portfolioType == .Edit{
                return self.photosArr.count
            }
            if photosArr.count > 0{
                return self.photosArr.count
            }
        }
        
        return self.skillArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == folioClv{
            let cell = folioClv.dequeueReusableCell(withReuseIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell
            cell.imgBtn.backgroundColor = UIColor.clear
            cell.plusImg.isHidden = true
            cell.titleField.tag = indexPath.row
            cell.titleField.delegate = self
            cell.titleField.tag = 1
            cell.detailField.tag = 2
            cell.detailField.delegate = self
            cell.detailField.tag = indexPath.row
            cell.imgBtn.tag = indexPath.row
            cell.imgBtn.addTarget(self, action: #selector(self.selectProfilePicPressed), for: .touchUpInside)
            cell.dlteBtn.addTarget(self, action: #selector(self.DeleteImg(_:)), for: .touchUpInside)
            cell.dlteBtn2.addTarget(self, action: #selector(self.DeleteImg(_:)), for: .touchUpInside)
            cell.titleField.addTarget(self, action: #selector(self.didChangeTitleField(_:)), for: .editingDidEnd)
            cell.detailField.addTarget(self, action: #selector(self.didChangeDetailField(_:)), for: .editingDidEnd)
//            if portfolioType == .Edit{
                let obj = self.photosArr[indexPath.row]
            if obj.image != nil{
                cell.img.sd_setImage(with: URL(string: obj.image!))
            }else{
               cell.img.image = self.photosArr[indexPath.row].img
            }
            cell.img.contentMode = .scaleAspectFill
            cell.img.clipsToBounds = true
                cell.titleField.text = obj.title ?? ""
                cell.detailField.text = obj.descriptionField ?? ""
                return cell
//            }
            
            
//            cell.titleField.text = self.formValues["title_\(indexPath.row)"] as? String ?? ""
//            cell.detailField.text = self.formValues["description_\(indexPath.row)"] as? String ?? ""
            
//            let img = #imageLiteral(resourceName: "rubbish-bin-orange")
//            let checkintintedImage = img.withRenderingMode(.alwaysTemplate)
//            cell.plusImg.image = checkintintedImage
//            cell.plusImg.tintColor = UIColor.darkGray
        }else{
        let cell = skillClv.dequeueReusableCell(withReuseIdentifier: "homeSkillCell", for: indexPath) as! SkillsCell
        
        let obj = skillArr[indexPath.row]
        cell.imgSkill.sd_setImage(with: URL(string: obj.thumbIcon))
        cell.imgSkill.image = cell.imgSkill.image?.withRenderingMode(.alwaysTemplate)
        cell.imgSkill.tintColor = UIColor.white
        cell.name.text = obj.categoryName
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(self.RemoveCategory(_:)), for: .touchUpInside)
        return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == skillClv{
        let str = skillArr[indexPath.row].categoryName
        var w = str?.width(withConstraintedHeight: 40, font: UIFont.systemFont(ofSize: 15.0))
        w = w! + 50
        return CGSize(width: w! , height: 50)
        }else{
        return CGSize(width: UIScreen.main.bounds.width , height: 364)
        }
    }
    @objc func RemoveCategory(_ sender: UIButton)
    {
        let obj = skillArr[sender.tag]
        skillArr.remove(at: sender.tag)
        let indexp = IndexPath(item: sender.tag, section: 0)
        self.skillClv.performBatchUpdates({
            self.skillClv.deleteItems(at: [indexp])
        }) { (finished) in
            self.skillClv.reloadItems(at: self.skillClv.indexPathsForVisibleItems)
        }
        if skillArr.count == 0{
            catViewHeight.constant = 0
            catView.isHidden = true
        }
    }
    
    //MARK:- AFTER PICTURE SELECTION FROM GALLERY
    
    @IBAction func CameraPressed(_ sender: UIButton)
    {
        selectProfilePicPressed()
    }
    @objc func selectProfilePicPressed() {
        
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
//        plusImg.isHidden = true
        let mydic = Dictionary<String,AnyObject>()
        let model = PortfolioImgModel.init(fromDictionary: mydic)
        model.img = selectedImage
        self.photosArr.append(model)
        photos.append(selectedImage)
        totalImg.text = "\(photos.count) IMAGE UPLOADED"
        if photosArr.count > 0{
            self.folioClv.isHidden = false
            self.folioClvHeight.constant = 365
            let indexPath = IndexPath(item: photosArr.count - 1, section: 0)
            self.folioClv.insertItems(at: [indexPath])
            self.folioClv.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
            
        }
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    @IBAction func PressedPostBtn(_ sender: UIButton)
    {
        if self.photosArr.count == 0{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Add Image for job", withNavigation: self)
            return
        }
        if self.skillArr.count == 0{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Select At least one category", withNavigation: self)
            return
        }
        for i in 0..<self.photosArr.count{
            let obj = self.photosArr[i]
//            let j = i + self.totalImgCount
            formValues["title_\(i)"] = (obj.title ?? "") as AnyObject
            formValues["description_\(i)"] = (obj.descriptionField ?? "") as AnyObject
//            if obj.img != nil{
//               self.photos.append(obj.img)
//            }else{
//              formValues["image_\(i)"] = obj.photoId as AnyObject
//            }
            
        }
        var param = Dictionary<String,String>()
        formValues["user_id"] = String(describing: UserDefaults.standard.value(forKey: "id") as! Int) as AnyObject
        var categeory_ids = ""
        for obModel in self.skillArr{
            categeory_ids = "\(categeory_ids),\(obModel.categoryId! )"
            
        }
        formValues["category_ids"] = categeory_ids as AnyObject
        let convertedDict: [String: String] = formValues.mapPairs { (key, value) in
            (key, String(describing: value))
        }
        var method = "/members/profile/createportfolio"
        if portfolioType == .Edit{
            let id = urlParams["portfolio_id"] as? Int
            method = url
            
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostDataWithMultiImage(parameters: convertedDict, method: method, image: self.photos, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code == 204{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    //MARK: - CELL BUTTON DELEGATE
    @objc func DeleteImg(_ sender: UIButton)
    {
        guard let cell = sender.superview?.superview?.superview as? PortfolioCell else{
            return
        }
        let indexPath  = self.folioClv.indexPath(for: cell)
        if indexPath != nil{
        self.photosArr.remove(at: (indexPath?.row)!)
            self.photos.remove(at: (indexPath?.row)!)
        self.folioClv.deleteItems(at: [indexPath!])
//        self.formValues["title_\(indexPath?.row)"] = nil
//        self.formValues["description_\(indexPath?.row)"] = nil
        }
        if photosArr.count == 0{
            folioClvHeight.constant = 190
            folioClv.isHidden = true
        }
    }
    @objc func didChangeTitleField(_ textField: UITextField)
    {
        guard let cell = textField.superview?.superview?.superview as? PortfolioCell else{
            return
        }
        let indexPath  = self.folioClv.indexPath(for: cell)
        if indexPath != nil{
        self.currentIndex = indexPath?.row
        let obj = self.photosArr[indexPath!.row]
        obj.title = textField.text!
        }
//        let index = textField.tag
//        formValues["title_\(index)"] = textField.text as AnyObject
        
    }
    @objc func didChangeDetailField(_ textField: UITextField)
    {
        guard let cell = textField.superview?.superview?.superview as? PortfolioCell else{
            return
        }
        let indexPath  = self.folioClv.indexPath(for: cell)
        if indexPath != nil{
        
        let obj = self.photosArr[indexPath!.row]
        obj.descriptionField = textField.text!
        }
//        let index = textField.tag
//        formValues["description_\(index)"] = textField.text as AnyObject
    }
    //MARK: - LOAD EDIT PORTFOLIO
    func LoadEditPortfolio()
    {
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: urlParams, method: url, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        let formvalues = body["formValues"] as? Dictionary<String,AnyObject>
                        if let skillArr = formvalues!["skills"] as? [Dictionary<String,AnyObject>]{
                            self.skillArr.removeAll()
                            for obj in skillArr{
                                let model = Category.init(fromDictionary: obj)
                                self.skillArr.append(model)
                            }
                            let skillDataDict:[String: [Category]] = ["skills": self.skillArr]
                            NotificationCenter.default.post(name: Notification.Name("SelectedPortSkill"), object: nil,userInfo: skillDataDict)
                        }
                        if let photosArr = formvalues!["photos"] as? [Dictionary<String,AnyObject>]{
                            self.photosArr.removeAll()
                            for obj in photosArr{
                                let model = PortfolioImgModel.init(fromDictionary: obj)
                                self.photosArr.append(model)
                            }
                            self.totalImg.text = "\(self.photosArr.count) IMAGE UPLOADED"
                            DispatchQueue.global(qos: .background).async {
                                for photo in self.photosArr{
                                do
                                {
                                    if let data = try? Data(contentsOf: URL(string: photo.image)!)
                                    {
                                        let image: UIImage = UIImage(data: data)!
                                        self.photos.append(image)
                                    }
                                }
                                catch { }
                                }
                            }
                            self.totalImgCount = self.photosArr.count
                            if photosArr.count > 0{
                                self.folioClvHeight.constant = 365
                                self.folioClv.isHidden = false
                                self.folioClv.reloadData()
                            }
                            self.pager.updateDots()
                        }
                    }
                }
            }
            print(response)
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
}
extension CreatePortfolioVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Change the current page
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        pager?.currentPage = Int(roundedIndex)
        //
    }
    
}
