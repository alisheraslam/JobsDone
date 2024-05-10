//
//  EditProfileVC.swift
//  JobsDone
//
//  Created by musharraf on 24/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import RichEditorView


enum FormType{
    case create
    case edit
}

class EditProfileVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,CreateFormCellDelegate {
    
    @IBOutlet weak var groupTbl: UITableView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var profile_pic: WAImageView!
    @IBOutlet weak var professional_pic: UIImageView!
    @IBOutlet weak var profImgHeight: NSLayoutConstraint!
    @IBOutlet weak var profBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var profBtn: UIButton!
    @IBOutlet weak var profImg: UIImageView!
    
    var forum_id : Int!
    var slug = ""
    var pluginEditUrl = ""
    var formTypeValue: FormType = .create
    var cancelBtn: UIBarButtonItem?
    var dataArray = [CreateFormModel]()
    var fullArr = [CreateFormModel]()
    var formValues = Dictionary<String, AnyObject>()
    var option_comp = [Dictionary<String, AnyObject>]()
    var option_inc = [Dictionary<String, AnyObject>]()
    var optArr = [String]()
    var fileName: String?
    var sTypw: pluginType = .groups
    var delegate: CreateFormCellDelegate?
    var delegate2: MediaPickVCDelegate?
    var detailAfterNotific: String = ""
    var empty = ""
    var file_data: URL?
    var file: AnyObject?
    var loaded = 0
    var img_url: URL?
    var image: UIImage?
    var imgVal = UIImageView()
    var multiCheckArr = [Bool]()
    var multicheckArrVals = [String]()
    var imagesArr = [UIImage]()
    var storedOffsets = [Int: CGFloat]()
    var cameFrmProfile = false
    var profileImg = ""
    var disImg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTbl.delegate = self
        groupTbl.dataSource = self
        // Do any additional setup after loading the view.
        cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClicked(sender:)))
        
        self.navigationItem.rightBarButtonItem = cancelBtn
        groupTbl.separatorStyle = .none
        loadGroupData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadImageAfterChange(_:)), name: NSNotification.Name(rawValue: "userImgChanged"), object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func ReloadImageAfterChange(_ notification: NotificationCenter)
    {
        self.dataArray.removeAll()
        self.fullArr.removeAll()
        loadGroupData()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            groupTbl.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            groupTbl.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    @objc func cancelBtnClicked(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.text? = (headerView.textLabel?.text?.capitalizedFirst())!
        headerView.backgroundView?.backgroundColor = UIColor.white
        headerView.textLabel?.textColor = UIColor.lightGray
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let objModel = dataArray[section]
        if objModel.type == "Text"{
            if objModel.hasValidator != nil{
                if objModel.hasValidator!{
                    let head = "\(objModel.label) *"
                    return head
                }else
                {
                    return objModel.label
                }
                
            }else{
                return objModel.label
            }
            
        }else if objModel.type == "Textarea"{
            if objModel.hasValidator != nil{
                if objModel.hasValidator!{
                    let head = "\(objModel.label) *"
                    return head
                }else
                {
                    return objModel.label
                }
            }
        }else if objModel.type == "MultiText" {
            
            if objModel.hasValidator!{
                let head = "\(objModel.label) *"
                return head
            }else
            {
                return objModel.label
            }
        }
            
        else if objModel.type == "File"{
            return objModel.label
            
        }else if objModel.type == "Select"{
            
            if objModel.hasValidator != nil{
                if objModel.hasValidator!{
                    let head = "\(objModel.label) *"
                    return head
                }else
                {
                    return objModel.label
                }
            }else{
                return objModel.label
            }
        }
        else if objModel.type == "Radio"{
            return objModel.label
        }else if objModel.type == "Submit" || objModel.type == "Button"{
            
            return nil
        }else if objModel.type == "Float" {
            if objModel.hasValidator != nil{
                if objModel.hasValidator!{
                    let head = "\(objModel.label) *"
                    return head
                }else
                {
                    return objModel.label
                }
            }else{
                return objModel.label
            }
        }else if objModel.type == "Date" {
            if objModel.hasValidator != nil{
                if objModel.hasValidator!{
                    let head = "\(objModel.label) *"
                    return head
                }else
                {
                    return objModel.label
                }
            }
        }else if objModel.type == "Checkbox" || objModel.type == "Heading" || objModel.type == "MultiCheckbox"{
            return nil
        }
        if objModel.hasValidator != nil{
            if objModel.hasValidator!{
                let head = "\(objModel.label) *"
                return head
            }
            return nil
        }else
        {
            return objModel.label
        }
    }
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//
//        let objModel = dataArray[section]
//
//        if objModel.type == "Select"{
//
//            return objModel.descrip
//        } else {
//            return nil
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let objModel = dataArray[section]
        if objModel.type == "Text"{
            return 1
        }else if objModel.type == "Textarea" || objModel.type == "Tinymce"{
            
            return 1
        }else if objModel.type == "MultiText" {
            print(option_inc.count)
            return option_inc.count
        }
            
        else if objModel.type == "File"{
            
            return 1
        }else if objModel.type == "Select"{
            
            return 1
        }else if objModel.type == "ProfileType"{
            
            return 1
        }
        else if objModel.type == "Radio"{
            for mult in objModel.multiOptions{
                if mult.key == ""{
                   let indx =  objModel.multiOptions.index(forKey: mult.key)
                    objModel.multiOptions.remove(at: indx!)
                }
            }
            
            return objModel.multiOptions.count
        }else if objModel.type == "Submit" || objModel.type == "Button"{
            
            return 1
        }else if objModel.type == "Float" {
            return 1
        }else if objModel.type == "Date" {
            return 1
        } else if objModel.type == "Checkbox" {
            return 1
        }else if objModel.type == "Heading" {
            return 1
        }else if objModel.type == "MultiCheckbox" {
            return objModel.multiOptions.count
        }else if objModel.type == "ProfImg"
        {
            return 1
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let objModel = dataArray[indexPath.section]
        if objModel.type == "Checkbox"
        {
            return 38
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let objModel = dataArray[indexPath.section]
        
        if objModel.type == "Textarea" || objModel.type == "Tinymce" {
            return 90
        } else if objModel.type == "MultiText" {
            
            return 51
        } else if objModel.type == "Submit" {
            
            return 70
        }else if objModel.type == "Button"{
            return 70
        }else if objModel.type == "Checkbox"
        {
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifier = "Text"
        let objModel = dataArray[indexPath.section]
        
        if objModel.type == "Text"{
            identifier = "textCell"
        }else if objModel.type == "Textarea"{
            if objModel.name == "body"
            {
                identifier = "textAreaViewCell"
            }else{
                identifier = "textAreaCell"
            }
        }else if objModel.type == "Tinymce"{
             identifier = "textAreaViewCell"
        }
        else if objModel.type == "MultiText"{
            print(indexPath.row)
            if indexPath.row == option_inc.count - 1 {
                if self.option_inc.count == objModel.fieldOptions.count - 1 {
                    identifier = "multiTextCell"
                }else {
                    identifier = "addOption"
                }
            } else {
                identifier = "multiTextCell"
            }
        }else if objModel.type == "ProfImg"{
            identifier  = "ProfCell"
        }
            
        else if objModel.type == "File"{
            if objModel.name == "photo" {
                identifier = "imageCell"
            } else {
                identifier = "fileCell"
            }
            
        }else if objModel.type == "Select"{
            
            identifier = "actionPickCell"
        }
        else if objModel.type == "Radio"{
            identifier = "radioCell"
        }else if objModel.type == "Submit" || objModel.type == "Button"{
            
            identifier = "submitCell"
        } else if objModel.type == "Float" {
            identifier = "textCell"
        }else if objModel.type == "Date" {
            identifier = "dateCell"
        } else if objModel.type == "Checkbox" {
            identifier = "selectCell"
        }else if objModel.type == "Heading" {
            identifier = "headingCell"
        }else if objModel.type == "MultiCheckbox" {
            identifier = "selectCell"
        }else if objModel.type == "ProfileType" {
            identifier = "actionPickCell"
        }else{
            identifier = "textCell"
        }
        
        //        ProfileType Button
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CreateFormCell
        //        cell.selectionStyle = .none
        cell.delegate = self
        cell.section = indexPath.section
        cell.txtView?.tag = indexPath.row
        cell.txtField?.tag = indexPath.row
        cell.multiTxtField?.tag = indexPath.row
        
        if objModel.type == "Text" {
            if let str = formValues[objModel.name] as? String{
                cell.txtField?.text = str
            }else{
                if formValues[objModel.name] != nil {
                if String(describing: formValues[objModel.name]) != ""
                {
                    cell.txtField?.text = String(describing: formValues[objModel.name]!)
                    }
                }else{
                    cell.txtField?.text = ""
                }
            }
            
        } else if objModel.type == "Float"{
            if let price = formValues[objModel.name] {
                print(price)
                cell.txtField?.text = String(describing: price)
            }
        } else if objModel.type == "Textarea"{
            if objModel.name == "body" {
                var txt = formValues[objModel.name] as? String
                if txt == nil {
                    txt = ""
                }
                let newTxt = try! NSAttributedString(
                    data: (txt?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                    options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil)
                
            } else {
                var txt = formValues[objModel.name] as? String
                if txt == nil {
                    txt = ""
                }
                let newTxt = try! NSAttributedString(
                    data: (txt?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                    options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil)
                cell.txtView?.text =  newTxt.string
            }
        }else if objModel.type == "Tinymce"{
            cell.htmlEditorView?.inputAccessoryView = cell.toolbar
            cell.toolbar.delegate = self
            cell.toolbar.editor = cell.htmlEditorView
            cell.htmlEditorView?.contentMode = .scaleAspectFit
            cell.indexForEditor = indexPath.row
            cell.htmlEditorView?.layer.borderColor = UIColor.clear.cgColor
            // We will create a custom action that clears all the input text when it is pressed
            let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
//                cell.toolbar.editor?.html = ""
            }
            
            var options = cell.toolbar.options
            options.append(item)
            cell.toolbar.options = options
            
            var txt = formValues[objModel.name] as? String
            if txt == nil {
                txt = ""
            }
            cell.htmlEditorView?.html = txt!
        }
        else if objModel.type == "File"{
            print(formValues)
            if objModel.name == "photo" {  
            } else {
                if formValues[objModel.name] == nil {
                    cell.img_lbl.text = "no file selected"
                } else {
                    print(fileName as Any)
                    cell.img_lbl.text = fileName
                }
            }
            
            
            if sTypw == .videos {
                if objModel.name == "filedata" {
                    if formValues["type"] != nil {
                        print(formValues)
                        if formValues["type"] as? String == "upload" {
                            
                            cell.enable(on: true)
                        } else {
                            cell.enable(on: false)
                        }
                    }
                    
                }
                
            }
            
            
        }else if objModel.type == "MultiText"{
            
        }
            
        else if objModel.type == "Select"{
            print(formValues)
            print(formValues[objModel.name] as Any)
            print(objModel.name)
            
            if let val = formValues[objModel.name] {
                let newVal2 = objModel.multiOptions[String(describing: val)]
                cell.multiOptBtn.setTitle(newVal2 as? String, for: .normal)
            }
            
        }else if objModel.type == "ProfileType"{
            print(formValues)
            print(formValues[objModel.name] as Any)
            print(objModel.name)
            if objModel.name != nil || objModel.name == "" {
                if formValues[objModel.name] != nil {
                    let val = formValues[objModel.name]
                    
                    let newVal2 = objModel.multiOptions[String(describing: val)]
                    cell.multiOptBtn.setTitle(newVal2 as? String, for: .normal)
                } else {
                    cell.multiOptBtn.setTitle("", for: .normal)
                }
                
            } else {
                cell.multiOptBtn.setTitle("", for: .normal)
            }
            
        }else if objModel.type == "Date"{
            print(formValues)
            print(formValues[objModel.name] as Any)
            
            if let val = formValues[objModel.name] {
                if val as? String == "" {
                    cell.dateBtn.setTitle("", for: .normal)
                } else {
                    cell.dateBtn.setTitle(formValues[objModel.name] as? String, for: .normal)
                }
            }
            
        }else if objModel.type == "Radio"{
            
            let values = Array(objModel.multiOptions.values)
            let keys = Array(objModel.multiOptions.keys)
            
            cell.radio_lbl.text = values[indexPath.row] as? String
            print(objModel.name)
            print(keys[indexPath.row])
            if let val = formValues[objModel.name] {
                print(val)
                let val2 = String(describing: val)
                if val2 == String(keys[indexPath.row]){
                    cell.radioBtn.setFAIcon(icon: FAType.FACircle, forState: .normal)
                }
                else {
                    cell.radioBtn.setFAIcon(icon: FAType.FACircleThin, forState: .normal)
                }
            } else {
                cell.radioBtn.setFAIcon(icon: FAType.FACircleThin, forState: .normal)
            }
            
            
        }else if objModel.type == "Checkbox" {
            
            cell.select_lbl.text = objModel.label
            if let val = formValues[objModel.name] {
                if val as? Bool  == false {
                    cell.selectBtn.setFAIcon(icon: .FASquareO, forState: .normal)
                } else {
                    cell.selectBtn.setFAIcon(icon: .FACheckSquare, forState: .normal)
                }
            }else{
               cell.selectBtn.setFAIcon(icon: .FASquareO, forState: .normal)
                self.formValues[objModel.name] = false as AnyObject
            }
        }else if objModel.type == "MultiCheckbox" {
            
            let vals = Array(objModel.multiOptions.values)
            print(indexPath.row)
            print(multiCheckArr)
            
            let isBool = multiCheckArr[indexPath.row]
            cell.select_lbl.text = vals[indexPath.row] as? String
            if isBool {
                cell.selectBtn.setFAIcon(icon: .FACheckSquare, forState: .normal)
            } else {
                cell.selectBtn.setFAIcon(icon: .FASquareO, forState: .normal)
            }
        }
        else if objModel.type == "Heading" {
            
            cell.heading_lbl.text = objModel.label
        }
        else if objModel.type == "Submit" || objModel.type == "Button"{
            if (app_links_color != "")
            {
                cell.submitBtn.titleLabel?.textColor = UIColor(hexString: app_header_color)
                cell.submitBtn.backgroundColor = UIColor(hexString: app_header_bg)
            }
        }else if objModel.type == "ProfImg"{
            if let level_id = UserDefaults.standard.value(forKey: "level_id") as? Int{
                if level_id == 7 || level_id == 8 {
                    cell.disImgHeight.constant = 0
                    if self.profileImg != nil && self.profileImg != ""{
                    cell.img_view.sd_setImage(with: URL(string: self.profileImg))
                    }
                }else{
                    cell.img_view.sd_setImage(with: URL(string: self.profileImg))
                    if self.disImg == "https://servepk.plazauk.com/application/modules/User/externals/images/nophoto_user_thumb_profile.png"{
                        cell.dispImg.image = #imageLiteral(resourceName: "default")
                    }else{
                    cell.dispImg.sd_setImage(with: URL(string: self.disImg))
                    }
                }
            }
            
            
            
            return cell
        }
        cell.validateEditor(createForm: objModel,formType: sTypw,detail: detailAfterNotific)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objModel = dataArray[indexPath.section]
        
        if objModel.type == "Select"{
            
        } else if objModel.type == "Checkbox" {
            
            if let val = formValues[objModel.name] {
                var indxPath: IndexPath!
                if val as! Bool  == false {
                    formValues[objModel.name] = true as AnyObject
                    if objModel.label == "Mailing is same as above"{
                        for model in self.dataArray{
                            if model.label == "Mailing Address"
                            {
                                let indx =   self.dataArray.index(of: model)
                                self.dataArray.remove(at: indx!)
                                indxPath = IndexPath(row: indx!, section: indexPath.section)
                                self.groupTbl.beginUpdates()
                                self.groupTbl.deleteSections(NSIndexSet(index: indx!) as IndexSet, with: .automatic)
                                self.groupTbl.endUpdates()
                                self.formValues[model.name] = "" as AnyObject
                            }
                        }
                    }
                } else {
                    formValues[objModel.name] = false as AnyObject
                    if objModel.label == "Mailing is same as above"{
                        for model in self.fullArr{
                            if model.label == "Mailing Address"
                            {
                                self.dataArray.insert(model, at: indexPath.section + 1)
                                self.groupTbl.beginUpdates()
                                self.groupTbl.insertSections(NSIndexSet(index: indexPath.section + 1) as IndexSet, with: .automatic)
                                self.groupTbl.endUpdates()
                            }
                            
                            
                        }
                    }
                }
            }
            let path = NSIndexPath(item: indexPath.row, section: indexPath.section)
              self.groupTbl.reloadRows(at: [path as IndexPath], with: .none)
            
        } else if objModel.type == "MultiCheckbox" {
            
            let isBool = multiCheckArr[indexPath.row]
            
            let keys = Array(objModel.multiOptions.keys)
            
            if isBool {
                multiCheckArr[indexPath.row] = false
                
                if multicheckArrVals.contains(keys[indexPath.row]) {
                    let index = self.multicheckArrVals.index(of: keys[indexPath.row])
                    if index != nil {
                        self.multicheckArrVals.remove(at: index!)
                    }    
                }
            } else {
                multiCheckArr[indexPath.row] = true
                self.multicheckArrVals.append(keys[indexPath.row])
                
            }
            print(multiCheckArr)
            
            let path = NSIndexPath(item: indexPath.row, section: indexPath.section)
                self.groupTbl.reloadRows(at: [path as IndexPath], with: .none)
        }
        else if objModel.type == "MultiText"{
            
            if indexPath.row == option_inc.count - 1 {
                print(option_inc.count)
                print(objModel.fieldOptions.count)
                if self.option_inc.count == objModel.fieldOptions.count - 1 {
                    self.option_inc.insert(self.option_comp[0], at: option_inc.count)
                    self.option_comp.remove(at: 0)
                    
                    self.option_inc.removeLast()
                    self.groupTbl.reloadData()
                } else {
                    self.option_inc.insert(self.option_comp[0], at: option_inc.count)
                    self.option_comp.remove(at: 0)
                    
                    self.groupTbl.reloadData()
                }
            }
            
        }
        else if objModel.type == "Radio"{
            
            let keys = Array(objModel.multiOptions.keys)
            if self.formValues[objModel.name] != nil {
                for (k,_) in self.formValues{
                    if objModel.name == k{
                        self.formValues[k] = keys[indexPath.row] as AnyObject
                        let indices: IndexSet = [indexPath.section]
                        self.groupTbl.reloadSections(indices, with: .none)
                    }
                }
            } else {
                self.formValues[objModel.name] = keys[indexPath.row] as AnyObject
                let indices: IndexSet = [indexPath.section]
                self.groupTbl.reloadSections(indices, with: .none)
                print(self.formValues)
            }
            
        }
    }
    /*
    // MARK: - Navigation
     func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return dataArray.count
     }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadGroupData(){
        var method = "groups/create"
        print(sTypw)
        var dic = Dictionary<String,AnyObject>()
        if formTypeValue == .edit {
            method = pluginEditUrl
            dic["user_id"] = UserDefaults.standard.value(forKey: "id")! as AnyObject
        } else if formTypeValue == .create {
            if sTypw == .jobs || sTypw == .myJobs {
                method = "jobs/create"
            }
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 200 {
                    if self.formTypeValue == .edit {
                        if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject>{
                            if UserDefaults.standard.value(forKey: "level_id") as? Int != nil{
                                let levelId = UserDefaults.standard.value(forKey: "level_id") as? Int
                                
                                    let model = CreateFormModel.init()
                                    model.type = "ProfImg"
                                    if self.dataArray.contains(model){}else{
                                       self.dataArray.append(model)
                                    }
                            }
                            if let form = body["form"] as? [Dictionary<String,AnyObject>]{
                                for obj in form{
                                    let objModel = CreateFormModel.init(obj)
                                    if objModel.name != "save" && objModel.label != "Mailing Address"{
                                    self.dataArray.append(objModel)
                                        
                                    }
                                    self.fullArr.append(objModel)
                                }
                            }
                            if let formValue = body["formValues"] as? Dictionary<String,AnyObject>{
                                for (k,v) in formValue {
                                    for formComp in self.fullArr {
                                        if formComp.name == k {
                                            print(k)
                                            self.formValues[k] = v
                                                if k == "1_1_34_alias_location"{
                                                    if v as? Bool == true
                                                    { self.dataArray.append(formComp)
                                                }
                                            }
                                        }
                                    }
                                }
                                if formValue["1_1_35_alias_"] == nil {
                                    for obj in self.fullArr{
                                        if obj.name == "1_1_34_alias_location"{
                                            self.dataArray.append(obj)
                                        }
                                    }
                                }

                                
                                if let profileImages = formValue["profileImages"] as? Dictionary<String,AnyObject>
                                {
                                    self.profileImg = profileImages["image"] as! String
                                }
                                if let dispImages = formValue["displayImages"] as? Dictionary<String,AnyObject>
                                {
                                    self.disImg = dispImages["image"] as! String
                                }
                            }
                        }
                        for formComp in self.fullArr{
                            if formComp.type == "Date" {

                                if formComp.name == "1_1_6_alias_birthdate" {
                                    if self.formValues[formComp.name] == nil {
                                        self.formValues[formComp.name] = "" as AnyObject
                                    }
                                    if String(describing: self.formValues[formComp.name]!) != "" {

                                        let dateStr = Utilities.dateFromStringConvertToString(self.formValues[formComp.name] as! String)
                                        self.formValues[formComp.name] = dateStr as AnyObject

                                    }
                                }

                            }
                        }
                        for formComp in self.fullArr{
                            if formComp.type == "MultiCheckbox" {
                                for _ in 0..<formComp.multiOptions.count {
                                    self.multiCheckArr.append(false)
                                }
                            }
                        }
                        for (k,_) in self.formValues {
                            if k == "submit" {
                                self.formValues[k] = nil
                            }
                            if k == "photo" {
                                print(self.imgVal.image as Any)
                                self.formValues[k] = self.imgVal.image
                            }
                            if k == "filedata" {
                                print(self.imgVal.image as Any)
                                self.formValues[k] = self.imgVal.image
                            }
                            if k == "songs" {
                                print(self.imgVal.image as Any)
                                self.formValues[k] = self.imgVal.image
                            }
                            if k == "filename" {
                                print(self.imgVal.image as Any)
                                self.formValues[k] = self.imgVal.image
                            }
                        }
                    } else if self.formTypeValue == .create {
                        if let body = response.object(forKey: "body") as? [Dictionary<String,AnyObject>]{
                            for obj in body{

                                let objModel = CreateFormModel.init(obj)
                                self.dataArray.append(objModel)
                                self.fullArr.append(objModel)
                            }

                            for formComp in self.fullArr{

                                if formComp.type == "Checkbox" {

                                    self.formValues[formComp.name] = formComp.value ?? false as AnyObject

                                }
                                else if formComp.type == "fullArr" {
                                    if let val = formComp.value as? Int {
                                        let newVal: String = String(val)
                                        self.formValues[formComp.name] = newVal as AnyObject
                                    } else {
                                        self.formValues[formComp.name] = formComp.value ?? "" as AnyObject
                                    }

                                } else if formComp.type == "MultiText" {

                                    for field in formComp.fieldOptions {
                                        self.option_comp.append(field)
                                        if let name = field["name"] as? String {
                                            self.formValues[name] = field["value"] ?? "" as AnyObject
                                        }
                                    }
                                } else if formComp.type == "File" {
                                    self.formValues[formComp.name] = formComp.value ?? self.file as AnyObject
                                } else if formComp.type ==  "MultiCheckbox" {
                                    self.formValues[formComp.name] = self.multicheckArrVals as AnyObject
                                }else {
                                    self.formValues[formComp.name] = formComp.value ?? "" as AnyObject
                                }
                            }
                            for formComp in self.fullArr{
                                if formComp.type == "MultiCheckbox" {
                                    for _ in 0..<formComp.multiOptions.count {
                                        self.multiCheckArr.append(false)
                                    }
                                }

                            }
                            for (k,_) in self.formValues {
                                if k == "submit" {
                                    self.formValues[k] = nil
                                }
                                if k == "photo" {
                                    print(self.imgVal.image as Any)
                                    self.formValues[k] = self.imgVal.image
                                }
                                if k == "filedata" {
                                    print(self.imgVal.image as Any)
                                    self.formValues[k] = self.imgVal.image
                                }
                                if k == "songs" {
                                    print(self.imgVal.image as Any)
                                    self.formValues[k] = self.imgVal.image
                                }
                                if k == "filename" {
                                    print(self.imgVal.image as Any)
                                    self.formValues[k] = self.imgVal.image
                                }
                            }
                        }
                    }
                    self.groupTbl.reloadData()
                } else {}
            }

        }) { (response) in
            print(response)
        Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }

    }
    //MARK:- ONCLICK UPDATE BUTTOM PRESSED
    @IBAction func UpdateBtnPressed(_ sender: UIButton)
    {
        for formdic in self.dataArray{
            
            if formdic.hasValidator == true{
                
                if formdic.type == "Checkbox" && formdic.name == "search" {
                    if formValues[formdic.name] as? Bool == false{
                        Utilities.showAlertWithTitle(title: "Missing", withMessage: "\(formdic.label) is missing" , withNavigation: self)
                        return
                    }
                } else if formdic.type == "Textarea"{
                    let title = formValues[formdic.name] as? String
                    if !((title?.count)! >= 1) {
                        Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(formdic.label) is missing" , withNavigation: self)
                        return
                    }
                } else {
                    print(formdic.name)
                    if formValues[(formdic.name as? String)!] == nil || String(describing: formValues[(formdic.name as? String)!]) == ""{
                        Utilities.showAlertWithTitle(title: "Missing", withMessage: "\(formdic.label) is missing" , withNavigation: self)
                        return
                    }
                }
                if formdic.name == "body" && formdic.type == "Textarea"{
                    let title = formValues[formdic.name] as? String
                    if !((title?.count)! >= 1) {
                        Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(formdic.label) is missing" , withNavigation: self)
                        return
                    }
                }else
                    
                    if formdic.name == "title" {
                        let title = formValues[formdic.name] as? String
                        if !((title?.count)! >= 3) {
                            Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(formdic.label) should be of at least 3 characters" , withNavigation: self)
                            return
                        }
                    } else if formdic.name == "category_id"  {
                        if formValues["category_id"] as? String == "" {
                            Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(formdic.label) is missing" , withNavigation: self)
                            return
                        }
                        
                }
                
            }
        }
        formValues["user_id"] = UserDefaults.standard.value(forKey: "id")! as AnyObject
        print(formValues)
        if (image != nil){
            let convertedDict: [String: String] = formValues.mapPairs { (key, value) in
                (key, String(describing: value))
            }
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostDataWithImage(parameters: convertedDict, method: "/members/edit/profile", image: image!, success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                if let scode = response["status_code"] as? Int {
                    if scode == 204 {
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let imageData = self.image!.jpegData(compressionQuality: 1)
                        UserDefaults.standard.set(imageData, forKey: "userImg")
                    } else {
                        Utilities.showAlertWithTitle(title: "Error", withMessage: response["message"] as! String, withNavigation: self)
                    }
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
            }
        }else{
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: formValues, method: "/members/edit/profile", success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                if let scode = response["status_code"] as? Int {
                    if scode == 204 {
                    } else {
                        Utilities.showAlertWithTitle(title: "Error", withMessage: response["message"] as! String, withNavigation: self)
                    }
                }
                
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
            }
        }
    }
    
    //MARK: - ON IMAGE BUTTON CLICK
    @IBAction func selectProfilePicPressed(_ sender: UIButton) {
            let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .imageVC) as! ImageVC
            vc.profileImg = self.profileImg
            vc.dispImg = self.disImg
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func ShowOptions()
    {
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
        profile_pic.image = selectedImage
        image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    //MARK: - CROP IMAGE
    
    //MARK: - CELL DELEGATES
    func didChangeTextField(index: Int, section: Int, text: String) {
        let objModel = dataArray[section]
        print(index)
        print(section)
        if objModel.type == "MultiText" {
            if let field = objModel.fieldOptions[index] as? Dictionary<String,AnyObject> {
                if let name = field["name"] as? String {
                    print(name)
                    self.formValues[name] = text as AnyObject
                }
            }
            
        } else {
            formValues[objModel.name] = text as AnyObject
            print(text)
        }
    }
    func didPressedFileButton(index: Int, section: Int, sender: Any) {
    }
    //MARK: - SUBMIT BUTTON
    func didPressedSubmitButton(index: Int, section: Int, sender: Any){}
    
    func didPressedDateButton(index: Int, section: Int, sender: WAButton) {
        
    }
    
    func didPressedmultiOptButton(index: Int, section: Int, sender: Any) {
        
    }
    
    func didChangeTextView(index: Int, section: Int, text: String) {
        let objModel = dataArray[section]
        formValues[objModel.name] = text as AnyObject
        print(text)
    }
    
    func didChangeEditorView(index: Int, section: Int, text: String) {
        let objModel = dataArray[section]
        formValues[objModel.name] = text as AnyObject
        print(text)
        
    }
    
    func didSelectImageBtn(index: Int, section: Int, sender: Any) {
        
    }
    
    func didPressedEditorBtn(index: Int, section: Int, sender: Any) {
        
    }

}
extension EditProfileVC: RichEditorToolbarDelegate {
    
    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
    
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
    
    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }
    
    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if toolbar.editor?.hasRangeSelection == true {
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
}

