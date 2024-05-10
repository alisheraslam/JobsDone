//
//  CreateJobVC.swift
//  JobsDone
//
//  Created by musharraf on 15/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import GooglePlaces
import ActionSheetPicker_3_0

public enum ControllerType{
    case CREATE
    case EDIT
}

class CreateJobVC: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate{
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var kmFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var kmField: UITextField!
    @IBOutlet weak var kmLbl: UILabel!
    @IBOutlet weak var kmView: UIView!
    @IBOutlet weak var radiusLbl: UILabel!
    @IBOutlet weak var jobTypeBtn: UIButton!
    @IBOutlet weak var proTypeBtn: UIButton!
    @IBOutlet weak var durationBtn: UIButton!
    @IBOutlet weak var catViewHeight: NSLayoutConstraint!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var skillClv: UICollectionView!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var locatioBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var titleCount: UILabel!
    @IBOutlet weak var expiryBtn: UIButton!
    @IBOutlet weak var searchCheckBox: UIImageView!
    @IBOutlet weak var searchCheckBox2: UIImageView!
    @IBOutlet weak var searchCheckBox3: UIImageView!
    @IBOutlet weak var searchCheckBox4: UIImageView!
    @IBOutlet weak var searchCheckBtn: UIButton!
    @IBOutlet weak var searchCheckBtn2: UIButton!
    @IBOutlet weak var searchCheckBtn3: UIButton!
    @IBOutlet weak var searchCheckBtn4: UIButton!
    @IBOutlet weak var notifCount: UILabel!
    @IBOutlet weak var notifViewHeight: NSLayoutConstraint!
    @IBOutlet weak var notifView: UIView!
    @IBOutlet weak var ViewAftnotifView: UIView!
    @IBOutlet weak var agreeCheck: UIButton!
    var checkArr = [UIImageView]()
    var btnArr = [UIButton]()
    var controllerType = ControllerType.CREATE
    var dic = Dictionary<String,AnyObject>()
    var durationArr = [DropDown]()
    var jobType = [DropDown]()
    var locationDic = Dictionary<String, AnyObject>()
    var imgArr = [UIImage]()
    var currentItem: Int!
    var skillArr = [Category]()
    var photosDic = [PhotosArr]()
    var deletedSkill = [Int]()
    //MARK:- VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        catViewHeight.constant = 0
        catView.isHidden = true
        notifViewHeight.constant = 0
        ViewAftnotifView.backgroundColor = UIColor.clear
        notifView.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        let img = #imageLiteral(resourceName: "grayback")
        imgArr.append(img)
        clView.delegate = self
        clView.dataSource = self
        skillClv.delegate = self
        skillClv.dataSource = self
        clView.reloadData()
        priceField.keyboardType = .numberPad
        agreeCheck.tintColor = UIColor(hexString: "#FF6B00")
        agreeCheck.setFAIcon(icon: .FASquareO, iconSize: 30, forState: .normal)
        agreeCheck.tag = 0
        if controllerType == .CREATE{
            let date = Calendar.current.date(byAdding: .month, value: 1, to: Date())
            let dateString = Utilities.stringFromDateWithFormat(date as! Date, format: "yyyy-MM-dd")
            self.dic["end_date"] = dateString as AnyObject
            self.expiryBtn.setTitle(dateString, for: .normal)
        self.title = "CREATE JOB"
        LoadJob()
        }else if controllerType == .EDIT{
            self.title = "UPDATE JOB"
            postBtn.setTitle("UPDATE JOB", for: .normal)
            LoadEditJob()
        }
         NotificationCenter.default.addObserver(self, selector: #selector(self.LoadSelectedSkills(_:)), name: NSNotification.Name(rawValue: "SelectedSkillForCreateJob"), object: nil)
        // Do any additional setup after loading the view.
        jobTypeBtn.tag = 0
        durationBtn.tag = 2
        titleField.delegate = self
        btnArr = [searchCheckBtn,searchCheckBtn2,searchCheckBtn3,searchCheckBtn4]
        checkArr = [searchCheckBox,searchCheckBox2,searchCheckBox3,searchCheckBox4]
        var i = 0
        kmFieldHeight.constant = 0
        kmView.isHidden = true
        radiusLbl.isHidden = true
        for check in checkArr{
        btnArr[i].tag = i
        check.tag = i
        i = i + 1
        check.setFAIconWithName(icon: .FASquareO, textColor: UIColor.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 30, height: 30))
        }
        
    }
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        titleCount.text = "-\(120 - newLength)"
        return newLength <= 120
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- AFTER CATEGORY SELECTION SHOW CATEGORIES
    @objc func LoadSelectedSkills(_ notifcation: NSNotification)
    {
        if let skills = notifcation.userInfo!["skills"] as? [Category] {
            skillArr = skills
            if skillArr.count > 0{
                catViewHeight.constant = 60
                catView.isHidden = false
                skillClv.reloadData()
                self.notifViewHeight.constant = 50
                self.notifView.isHidden = false
                self.ViewAftnotifView.backgroundColor = UIColor.lightGray
                self.GetEstimation()
            }
        }
    }
    //MARK:- ONCLICK CATEGORY BUTTON GO TO CONTROLLER
    @IBAction func OnclickCategory(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
        vc.parentType = .CREATEJOB
        vc.selectSkillData = self.skillArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- ONCLICK LOCATION PICKER BUTTON
    @IBAction func onClickLocationPicker(_ sender: UIButton)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment  //suitable filter type
        filter.country = "CA"  //appropriate country code
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:- COLLECTION VIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == skillClv
        {
            return skillArr.count
        }
        return imgArr.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == clView
        {
           return CGSize(width: 110.0, height: 110.0)
        }
        let str = skillArr[indexPath.row].categoryName
        var w = str?.width(withConstraintedHeight: 40, font: UIFont.systemFont(ofSize: 15.0))
        w = w! + 50
        return CGSize(width: w! , height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clView{
        let cell = self.clView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicCVC
        let img = #imageLiteral(resourceName: "grayback")
            if imgArr[indexPath.item].pngData() != img.pngData() {
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
    //MARK:- ONCLICK CATEGORY CROSS REMOVE CATEGORY
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
        self.GetEstimation()
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
    
    //MARK:- CHECK IF Already item contains image
    @objc func AddPicture(sender: UIButton ,cell: PicCVC)
    {
        let img = #imageLiteral(resourceName: "grayback")
        if imgArr[sender.tag].pngData() != img.pngData() {
            imgArr.remove(at: sender.tag)
            if controllerType == .EDIT {
                let photo = self.photosDic[sender.tag]
                deletedSkill.append(photo.photoId)
            }
            clView.reloadData()
        }else{
            currentItem = sender.tag
            selectProfilePicPressed()
        }
       
        
    }
    //MARK:- AFTER PICTURE SELECTION FROM GALLERY
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
    //MARK: - load job paramters
    func LoadJob()
    {
        var params = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: params, method: "/jobs/create", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
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
                if let typeOptions = body!["typeTypes"] as? Dictionary<String,AnyObject>
                {
                    for dur in typeOptions{
                        let model  = DropDown()
                        model.key = dur.key
                        model.value = dur.value as! String
                        self.jobType.append(model)
                    }
                }
            }
            }
            
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    
    //MARK:- LOAD EDIT JOB
    func LoadEditJob()
    {
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: "/jobs/edit", success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
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
                    if let typeOptions = body!["typeTypes"] as? Dictionary<String,AnyObject>
                    {
                        for dur in typeOptions{
                            let model  = DropDown()
                            model.key = dur.key
                            model.value = dur.value as! String
                            self.jobType.append(model)
                        }
                    }
                    var givenSkill  = [Category]()
                    if let categoryOptions = body!["categoryOptions"] as? [Dictionary<String,AnyObject>]
                    {
                        self.skillArr.removeAll()
                        for option in categoryOptions{
                            let model  = Category.init(fromDictionary: option)
                            givenSkill.append(model)
                        }
                    }
                    
                    if let form = body!["formValues"] as? Dictionary<String,AnyObject>{
                        self.titleField.text = form["title"] as? String
                        self.titleCount.text = "-\(120 - self.titleField.text!.count )"
                        let job_type = form["job_type"] as? Int
                        self.dic["job_type"] = String(describing: job_type!) as AnyObject
                        self.priceField.text = String(describing: (form["price"] as? Int)!)
                        let loc = form["location"] as? String
                        self.locatioBtn.setTitle(loc, for: .normal)
                        self.descriptionField.text = form["body"] as? String
                        for type in self.jobType{
                            if type.key == String(describing:job_type!){
                              self.jobTypeBtn.setTitle(type.value, for: .normal)
                            }
                        }
                        let duration = form["duration"] as? Int
                        self.dic["duration"] = String(describing: duration!) as AnyObject
                        for dur in self.durationArr{
                            if dur.key == String(describing: duration!){
                                self.durationBtn.setTitle(dur.value, for: .normal)
                            }
                        }
                        let expiry = form["end_date"] as? String
                        let expiryStr = expiry?.components(separatedBy: " ")
                        self.expiryBtn.setTitle(expiryStr?[0], for: .normal)
                        var selectedSkill = [Category]()
                        if let categories = form["categories"] as? [Int]
                        {
                            
                            for cat in categories{
                                for model in givenSkill{
                                    if cat == model.categoryId{
                                        selectedSkill.append(model)
                                    }
                                }
                            }
                            if selectedSkill.count > 0{
                                let skillDataDict:[String: [Category]] = ["skills": selectedSkill]
                                NotificationCenter.default.post(name: Notification.Name("SelectedSkillForCreateJob"), object: nil,userInfo: skillDataDict)
                            }
                        }
                        if let photos = form["photos"] as? [Dictionary<String,AnyObject>]
                        {
                            for photo in photos{
                                let phot = PhotosArr.init(fromDictionary: photo)
                                self.photosDic.append(phot)
                                let url = URL(string: photo["photo_url"] as! String)
                                if let data = try? Data(contentsOf: url!)
                                {
                                    let image: UIImage = UIImage(data: data)!
                                    self.imgArr.insert(image, at: self.imgArr.count - 1)
                                    
                                }
                            }
                            self.clView.reloadData()
                        }
                    }
                }
            }
            
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    //MARK:- ONCLIK JOB TYPE SELECT BUTTON
    @IBAction func JobTypeClick(_ sender: UIButton)
    {
        self.ShowDropdown(dataArr: self.jobType, sender: sender)
    }
    //MARK:- ONCLICK DURATION BUTTON
    @IBAction func DurationClick(_ sender: UIButton)
    {
        self.ShowDropdown(dataArr: self.durationArr, sender: sender)
    }
    @IBAction func ProTypeClick(_ sender: UIButton)
    {
        var proType = [DropDown]()
        let model = DropDown()
        model.key = "0"
        model.value = "Pro Type"
        proType.append(model)
        let model1 = DropDown()
        model1.key = "1"
        model1.value = "Individual"
        proType.append(model1)
        let model2 = DropDown()
        model2.key = "2"
        model2.value = "Company"
        proType.append(model2)
        self.ShowDropdown(dataArr: proType, sender: sender)
    }
    
    //MARK:- SHOW DROPDOWN function
    func ShowDropdown(dataArr: [DropDown],sender: UIButton)
    {
        var catKeys = [String]()
        var catVAlues = [String]()
        let new = dataArr.sorted { (first, second) -> Bool in
            (first.key ) < (second.key )
        }
        for k in new  as [DropDown]{
            catKeys.append(k.key)
            catVAlues.append(k.value)
        }
        ActionSheetStringPicker.show(withTitle: "Select", rows:catVAlues , initialSelection: 0, doneBlock: {picker, values, indexes in
            let txt = catVAlues[values]
            if sender.tag == 0{
                self.dic["job_type"] = catKeys[values] as AnyObject
            }else if sender.tag == 1{
                self.dic["pro"] = catKeys[values] as AnyObject
            }else if sender.tag == 2{
                self.dic["duration"] = catKeys[values] as AnyObject
            }
            sender.setTitle(txt, for: .normal)
            self.priceField.resignFirstResponder()
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
    }
    
    //MARK:- onclick post button
    @IBAction func PostBtnClick(_ sender:UIButton)
    {
        if titleField.text?.count == 0
        {
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please enter title", withNavigation: self)
            return
        }
        if skillArr.count == 0{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please at least one category", withNavigation: self)
            return
        }
        if jobTypeBtn.titleLabel?.text == "Job Type"
        {
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please select job type", withNavigation: self)
            return
        }
        if priceField.text?.count == 0
        {
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please enter price", withNavigation: self)
            return
        }
        if locatioBtn.titleLabel?.text == "Location"
        {
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please select job Location", withNavigation: self)
            return
        }
        
        if durationBtn.titleLabel?.text == "Duration"
        {
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please select duration", withNavigation: self)
            return
        }
        if descriptionField.text?.count == 0
        {
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please enter description", withNavigation: self)
            return
        }
        if agreeCheck.tag == 0{
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Please Agree with Terms & Privacy", withNavigation: self)
            return
        }
        
        var method = "/jobs/create"
        dic["title"] = titleField.text as AnyObject
        dic["price"] = priceField.text as AnyObject
        dic["body"] = descriptionField.text as AnyObject
        dic["location"]  =  locatioBtn.titleLabel?.text! as AnyObject
        
        if controllerType == .EDIT{
            var dlteStr = ""
            for delet in self.deletedSkill{
                dlteStr = "\(dlteStr),\(delet)"
            }
            dic["deleted_photos"] =  dlteStr as AnyObject
            method = "jobs/edit"
            for phot in photosDic{
                let url = URL(string: phot.photoUrl)
                if let data = try? Data(contentsOf: url!)
                {
                    let image: UIImage = UIImage(data: data)!
                    for img in self.imgArr{
                        let lhsData = img.pngData()
                        let rhsData = image.pngData()
                        if lhsData == rhsData
                        {
                            let indx = self.imgArr.index(of: img)
                            self.imgArr.remove(at: indx!)
                        }
                    }
                }

            }
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: locationDic, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        dic["locationParams"] = jsonString as AnyObject
        var i = 0
        var categeory_ids = ""
        for obModel in self.skillArr{
            categeory_ids = "\(categeory_ids),\(obModel.categoryId! )"
            i = i + 1
        }
        dic["categories"] = categeory_ids as AnyObject
        
        if self.imgArr.count > 1{
            let last =    self.imgArr.index(before: self.imgArr.count)
            self.imgArr.remove(at: last)
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            var param = Dictionary<String,String>()
            for (k,v) in self.dic{
                param[k] = String(describing: v)
            }
            if controllerType == .EDIT{
                param["deleted_photos"] =  String(describing: dic["deleted_photos"]!)
                param["id"] = String(describing: dic["id"]!)
            }
            param["location"]  = String(describing: locatioBtn.titleLabel!.text!)
            print(param)
            ALFWebService.sharedInstance.doPostDataWithMultiImage(parameters: param, method: method, image: self.imgArr, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                if let status_code = response["status_code"] as? Int{
                    if status_code == 200{
                         self.navigationController?.popViewController(animated: true)
                    }else if self.controllerType == .EDIT && status_code == 204{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        let mxg = response["message"] as? String
                        Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
                    }
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            }
        }else{
            dic["location"]  = String(describing: locatioBtn.titleLabel!.text!) as AnyObject
            print(dic)
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: self.dic, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                if let status_code = response["status_code"] as? Int{
                    if status_code == 200{
                        self.navigationController?.popViewController(animated: true)
                    }else if self.controllerType == .EDIT && status_code == 204{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        let mxg = response["message"] as? String
                        Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
                    }
                }
            }, fail: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
            })
        }

    }
    //MARK: - HANDLE CHECKBOX
    @IBAction func HandleCheckbox(_ sender: UIButton)
    {
        if sender.tag == 3 {
            self.notifViewHeight.constant = 0
            self.notifView.isHidden = true
            ViewAftnotifView.backgroundColor = UIColor.clear
            }else{
            self.notifViewHeight.constant = 50
            ViewAftnotifView.backgroundColor = UIColor.lightGray
            notifView.isHidden = false
            }
        for check in checkArr{
            if check.tag == sender.tag{
                
                check.setFAIconWithName(icon: .FACheckSquare, textColor: UIColor(hexString: app_header_bg), backgroundColor: .clear, size: CGSize(width: 30, height: 30))

        }else{
           check.setFAIconWithName(icon: .FASquareO, textColor: UIColor.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 30, height: 30))
               
        }
            
            if sender.tag == 0{
                kmLbl.isHidden = true
                kmFieldHeight.constant = 30
                kmView.isHidden = false
                radiusLbl.isHidden = false
                
            }else{
                kmLbl.isHidden = false
                kmFieldHeight.constant = 0
                kmView.isHidden = true
                radiusLbl.isHidden = true
            }
            if sender.tag == 0{
                self.dic["radius_search"] = 1 as AnyObject
                self.dic["radius"] = self.kmField.text! as AnyObject
                //
                self.dic["provincial_search"] = 0 as AnyObject
                self.dic["national_search"] = 0 as AnyObject
            }else if sender.tag == 1{
                self.dic["provincial_search"] = "1" as AnyObject
                //
                self.dic["radius_search"] = 0 as AnyObject
                self.dic["radius"] = nil
                self.dic["national_search"] = 0 as AnyObject
            }else if sender.tag == 2{
                self.dic["national_search"] = 1 as AnyObject
                //
                self.dic["radius_search"] = 0 as AnyObject
                self.dic["radius"] = nil
                self.dic["provincial_search"] = 0 as AnyObject
            }else if sender.tag == 3{
                self.dic["radius_search"] = 0 as AnyObject
                self.dic["radius"] = nil
                self.dic["provincial_search"] = 0 as AnyObject
                self.dic["national_search"] = 0 as AnyObject
            }
        }
        GetEstimation()
    }
    //MARK: - SEG AGREE
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
    //MARK: - PRESSED DATE BUTTON
    
    @IBAction func didPressedDateButton(_ sender: UIButton) {
        
        self.view.endEditing(true)
            let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let currentDate = NSDate()
            let maxDatecomponents = NSDateComponents()
            
            maxDatecomponents.month = +1
            let maxDate: NSDate = calendar!.date(byAdding: maxDatecomponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
            
            
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePicker.Mode.date, selectedDate: maxDate as Date?, doneBlock: {
                picker, value, index in
                
                print("value = \(String(describing: value!))")
                
                let dateString = Utilities.stringFromDateWithFormat(value as! Date, format: "yyyy-MM-dd")
                sender.setTitle(dateString, for: .normal)
                self.dic["end_date"] = dateString as AnyObject
            }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
            datePicker?.minimumDate = Date()
        datePicker?.maximumDate = maxDate as Date?
            datePicker?.show()
        }
    //MARK: - NOTIFICATION COUNT ESITMATE
    func GetEstimation()
    {
        var params = Dictionary<String,AnyObject>()
        var categeory_ids = ""
        for i in 0 ..< self.skillArr.count{
            let obj = self.skillArr[i]
            categeory_ids = "\(categeory_ids),\(obj.categoryId!)"
        }
        params["category_ids"] = categeory_ids as AnyObject
        let jsonData = try? JSONSerialization.data(withJSONObject: locationDic, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        params["locationParams"] = jsonString as AnyObject
        params["radius_search"]  = (self.dic["radius_search"] as? Int) as AnyObject
        params["radius"] = self.kmField.text! as AnyObject
        //
        params["provincial_search"] = (self.dic["provincial_search"] as? Int) as AnyObject
        params["national_search"] = (self.dic["national_search"] as? Int) as AnyObject
        ALFWebService.sharedInstance.doPostData(parameters: params, method: "/members/index/estimate", success: { (response) in
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let res = body["response"] as? Dictionary<String,AnyObject>{
                            let count = res["usersCount"] as? Int
                            self.notifCount.text = String(describing: count!)
                        }
                    }
                }
            }
        }) { (response) in
            
        }
    }
}
extension CreateJobVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        
         self.locationDic["location"] = "\(place.formattedAddress!)" as AnyObject
         self.locationDic["latitude"] = (String(describing: place.coordinate.latitude)) as AnyObject
        self.locationDic["longitude"] = (String(describing: place.coordinate.longitude)) as AnyObject
        self.locationDic["formatted_address"] = place.formattedAddress! as AnyObject
        self.locationDic["address"] = place.formattedAddress! as AnyObject
        for compo in place.addressComponents!{
            if compo.type == "country"{
                self.locationDic["country"] = compo.name as AnyObject
            }
            if compo.type == "city"{
                self.locationDic["city"] = compo.name as AnyObject
            }
            if compo.type == "city"{
                self.locationDic["state"] = compo.name as AnyObject
            }
        }
        
        self.notifViewHeight.constant = 50
        self.notifView.isHidden = false
        self.ViewAftnotifView.backgroundColor = UIColor.lightGray
        self.GetEstimation()
        self.locatioBtn.setTitle("\(place.formattedAddress!)", for: .normal)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}
