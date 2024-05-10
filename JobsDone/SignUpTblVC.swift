//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//



import UIKit
import ActionSheetPicker_3_0
import BSImagePicker
import Photos
import Alertift
import MediaPlayer
import GooglePlaces


enum SignUpFormType{
    case acc
    case info
}

class SignUpTblVC: UITableViewController,UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UIDocumentMenuDelegate, UINavigationControllerDelegate, MPMediaPickerControllerDelegate,SignUpCellDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var formTbl: UITableView!
    var signup_profile_type = "1"
    var item: MPMediaItem?
    var pluginEditUrl = ""
    var formTypeValue: SignUpFormType = .acc
    var locationPath : IndexPath!
    var signUpArr = [SignUpModel]()
    var fullArr = [SignUpModel]()
    var locationDic = Dictionary<String, AnyObject>()
    var accDic = Dictionary<String, AnyObject>()
    var infoDic = Dictionary<String, AnyObject>()
    var packageArr  = [PackageModel]()
    var formValues = Dictionary<String, AnyObject>()
    
    var fileName: String?
    
    var delegate: SignUpCellDelegate?
    var alreadyContains = false
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
    var cameFromLi = false
    var cameFromFb = false
    var cameFromTw = false
    var mobileVerification = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 70
        
        print(pluginEditUrl)
        print(formTypeValue)
        if formTypeValue == .acc {
            self.title = "Create Account"
            self.addBackbutton(title: "Back")
            
        } else {
            self.title = "Profile Information"
            self.addBackbutton(title: "Back")
        }
        
        loadGroupData()
        
        
        
//        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClicked(sender:)))
        
//        self.navigationItem.rightBarButtonItem = cancelBtn
        //        self.hideKeyboardWhenTappedAround()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
//    func cancelBtnClicked(sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            formTbl.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            formTbl.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    func loadGroupData(){
        
        let method = "signup?subscriptionForm=1"
        
        var dic = Dictionary<String,AnyObject>()
        if cameFromFb {
            if (UserDefaults.standard.value(forKey: "fb_id") != nil) {
                let id = UserDefaults.standard.value(forKey: "fb_id") as? String
                dic["facebook_uid"] = id as AnyObject
            }
        }else if cameFromTw{
            if (UserDefaults.standard.value(forKey: "twitter_id") != nil) {
                let id = UserDefaults.standard.value(forKey: "twitter_id") as? Int
                dic["twitter_uid"] = id as AnyObject
            }
        }else if cameFromLi{
            if (UserDefaults.standard.value(forKey: "linkedin_id") != nil) {
                let id = UserDefaults.standard.value(forKey: "linkedin_id") as? Int
                dic["linkedin_id"] = id as AnyObject
            }
        }
        if formTypeValue == .info{
            dic["signup_profile_type"] = (self.accDic["profile_type"] as? String ?? "1") as AnyObject
        }
        print(method)
        
        Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 200 {
                    if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject>{
                        if let verification = body["mobileVerification"] as? Bool{
                            self.mobileVerification = verification
                        }
                        if let subs = body["subscription"] as?[Dictionary<String,AnyObject>]{
                            let sub = subs[0]
                            if let multi = sub["multiOptions"] as? [Dictionary<String, AnyObject>]{
                                for mult in multi{
                                    let model = PackageModel.init(mult)
                                    self.packageArr.append(model)
                                }
                            }
                        }
                        if self.formTypeValue == .acc {
                            if let account = body["account"] as? [Dictionary<String,AnyObject>] {
                                for acc in account{
                                    let objModel = SignUpModel.init(acc)
                                    if !objModel.label.contains("Business")
                                    {
                                       self.signUpArr.append(objModel)
                                    }
                                    
                                    self.fullArr.append(objModel)
                                }
                            }
                            
                        }else {
                            if let fields = body["fields"] as? [Dictionary<String,AnyObject>] {
                                for field in fields{
                                    let objModel = SignUpModel.init(field)
                                    self.signUpArr.append(objModel)
                                }
                                
                            }
                        }
                        //FormValues for Account Array
                        
                        for formComp in self.signUpArr{
                            
                            if formComp.type == "Checkbox" {
                                
                                self.formValues[formComp.name] = formComp.value ?? false as AnyObject
                                
                            }
                            else if formComp.type == "Radio" {
                                if let val = formComp.value as? Int {
                                    let newVal: String = String(val)
                                    self.formValues[formComp.name] = newVal as AnyObject
                                } else {
                                    self.formValues[formComp.name] = formComp.value ?? "" as AnyObject
                                }
                                
                            } else if formComp.type == "File" {
                                self.formValues[formComp.name] = formComp.value ?? self.file as AnyObject
                            } else if formComp.type ==  "MultiCheckbox" {
                                self.formValues[formComp.name] = self.multicheckArrVals as AnyObject
                            }
//                            else if formComp.type ==  "Select" {
//                                if formComp.name ==  "timezone" {
//                                    self.formValues[formComp.name] = "US/Pacific" as AnyObject
//                                }
//                            }
                            else {
                                self.formValues[formComp.name] = formComp.value ?? "" as AnyObject
                            }
                            
                            
                        }
                        for formComp in self.signUpArr{
                            if formComp.type == "MultiCheckbox" {
                                for _ in 0..<formComp.multiOptions.count {
                                    self.multiCheckArr.append(false)
                                }
                            }
                            
                        }
                        print(self.multiCheckArr)
                        print(self.formValues)
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
                        
                        
                        
                        self.formTbl.reloadData()
                        
                    } else {
                        
                    }
                }
            }
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return signUpArr.count
        
    }
   override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let objModel = signUpArr[section]
    if objModel.name == "terms" || objModel.type == "Button" || objModel.type == "Heading"{
        return CGFloat.leastNormalMagnitude
    }
        return 35
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let objModel = signUpArr[section]
        if objModel.descrip == ""  {
            return CGFloat.leastNormalMagnitude
        }
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.text? = (headerView.textLabel?.text?.uppercased())!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let objModel = signUpArr[section]
        if objModel.type == "Submit" || objModel.type == "Button"{
            return nil
        }
        else if objModel.type == "Checkbox" {
            return nil
        }else if objModel.type == "Heading" {
            return nil
        }else if objModel.type == "MultiCheckbox" {
            return nil
        }else if objModel.type ==  "Select" {
            print(objModel.label)
            
            if objModel.hasValidator != nil {
                if objModel.hasValidator! {
                    let head = "\(objModel.label.uppercased()). *"
                    return head
                } else {
                    return objModel.label.uppercased()
                }
            } else {
                return objModel.label.uppercased()
            }
            
        } else {
            if objModel.hasValidator != nil {
                if objModel.hasValidator! {
                    let head = "\(objModel.label.uppercased()) *"
                    return head
                } else {
                    return objModel.label.uppercased()
                }
            } else {
                return objModel.label.uppercased()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        let objModel = signUpArr[section]
        if  objModel.type == "Checkbox" {
            return nil
        }else {
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let objModel = signUpArr[section]
        if objModel.type == "Radio" || objModel.type == "MultiCheckbox"{
            for mult in objModel.multiOptions{
                if mult.key == ""{
                    let indx =  objModel.multiOptions.index(forKey: mult.key)
                    objModel.multiOptions.remove(at: indx!)
                }
            }
            return objModel.multiOptions.count
        }
//        else if objModel.type ==  "Select" {
////            if objModel.name ==  "timezone" {
////                return 0
////            }
//            return 1
//        }
        else {
            return 1
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifier = "textCell"
        let objModel = signUpArr[indexPath.section]
        
        if objModel.type == "Text"{
            identifier = "textCell"
        }else if objModel.type == "Password"{
            
            identifier = "passCell"
        }else if objModel.type == "Textarea"{
            
            identifier = "textAreaCell"
        }else if objModel.type == "Location"{
            
            identifier = "locCell"
        }else if objModel.type == "Integer"{
            
            identifier = "countryCell"
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
            if objModel.name == "terms"{
                identifier = "TermsCell"
            }else{
            identifier = "selectCell"
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SignUpCell
        //        cell.selectionStyle = .none
        cell.delegate = self
        cell.section = indexPath.section
        cell.txtView?.tag = indexPath.row
        cell.txtField?.tag = indexPath.row
        cell.multiTxtField?.tag = indexPath.row
        
        if objModel.type == "Text"{
            if objModel.name == "mobileno"{
                cell.txtField?.keyboardType = .phonePad
                cell.txtField?.delegate = self
            }else{
               cell.txtField?.keyboardType = .default
            }
            if cameFromFb || cameFromTw || cameFromLi{
                
                if objModel.name  == "email" {
                    if cameFromFb{
                    if (UserDefaults.standard.value(forKey: "fb_email") != nil) {
                        cell.txtField?.text = UserDefaults.standard.value(forKey: "fb_email")! as? String
                        
                        formValues[objModel.name] = cell.txtField?.text as AnyObject
                    }else
                    {
                        
                        cell.txtField?.text = formValues[objModel.name] as? String
                        }
                        
                    }else if cameFromTw{
                        if(UserDefaults.standard.value(forKey: "twitter_email") != nil){
                            cell.txtField?.text = UserDefaults.standard.value(forKey: "twitter_email")! as? String
                            formValues[objModel.name] = cell.txtField?.text as AnyObject
                        }else
                        {
                            cell.txtField?.text = formValues[objModel.name] as? String
                        }
                    }else if cameFromLi{
                        if(UserDefaults.standard.value(forKey: "linkedin_email") != nil){
                            cell.txtField?.text = UserDefaults.standard.value(forKey: "linkedin_email")! as? String
                            formValues[objModel.name] = cell.txtField?.text as AnyObject
                        }else
                        {
                            cell.txtField?.text = formValues[objModel.name] as? String
                        }
                    }
                }else if objModel.name  == "1_1_3_alias_first_name" {
                    if (UserDefaults.standard.value(forKey: "first_name") != nil) {
                        cell.txtField?.text = UserDefaults.standard.value(forKey: "first_name")! as? String
                        formValues[objModel.name] = cell.txtField?.text as AnyObject
                    } else {
                        cell.txtField?.text = formValues[objModel.name] as? String
                    }
                } else if objModel.name  == "1_1_4_alias_last_name" {
                    
                    if (UserDefaults.standard.value(forKey: "last_name") != nil) {
                        cell.txtField?.text = UserDefaults.standard.value(forKey: "last_name")! as? String
                        formValues[objModel.name] = cell.txtField?.text as AnyObject
                    } else {
                        cell.txtField?.text = formValues[objModel.name] as? String
                    }
                }
                   
                else {
                    cell.txtField?.text = formValues[objModel.name] as? String
                }
                
            } else{
                cell.txtField?.text = formValues[objModel.name] as? String
            }
            
            
        }
        else if objModel.type == "Location"{
            if self.locationDic["location"] != nil {
                cell.locBtn.setTitle(self.locationDic["location"] as? String, for: .normal)
            } else {
                cell.locBtn.setTitle("", for: .normal)
            }
            
        }
        else if objModel.type == "Password"{
            cell.txtField?.text = formValues[objModel.name] as? String
        } else if objModel.type == "Textarea" {
            
            let txt = formValues[objModel.name] as? String
            let newTxt = try! NSAttributedString(
                data: (txt?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            cell.txtView?.text = newTxt.string
        }else if objModel.type == "File"{
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
            cell.radioBtn.tintColor = UIColor(hexString: app_header_bg)
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
            cell.selectBtn.tintColor = UIColor(hexString: app_header_bg)
            if objModel.name == "terms"{
                cell.termsBtn.addTarget(self, action: #selector(self.termsSelect(_:)), for: .touchUpInside)
                cell.policyBtn.addTarget(self, action: #selector(self.privacyPolicySelect(_:)), for: .touchUpInside)
            }else{
              cell.select_lbl.text = objModel.label
            }
            if let val = formValues[objModel.name] {
                print(val)
                print(cell.selectBtn)
                if val as? Bool  == false {
                    cell.selectBtn.setFAIcon(icon: .FASquareO, iconSize: 20, forState: .normal)
                } else {
                    cell.selectBtn.setFAIcon(icon: .FACheckSquare,iconSize: 20, forState: .normal)
                    
                }
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
            cell.submitBtn.setTitle("Continue", for: .normal)
            cell.submitBtn.backgroundColor = UIColor(hexString: app_header_bg)
        }
        
        return cell
    }
    @objc func termsSelect(_ sender: Any) {
        
        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .privacyVC) as! PrivacyPolicyController
        con.pageTypes = .terms
        self.navigationController?.pushViewController(con, animated: true)
    }
    @objc func privacyPolicySelect(_ sender: UIButton) {
        
        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .privacyVC) as! PrivacyPolicyController
        con.pageTypes = .policy
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objModel = signUpArr[indexPath.section]
        
        if objModel.type == "Select"{
            
        }
        else if objModel.type == "Checkbox" {
            
            if let val = formValues[objModel.name] {
                if val as! Bool  == false {
                    formValues[objModel.name] = true as AnyObject
                } else {
                    formValues[objModel.name] = false as AnyObject
                }
            }
            print(formValues)
            self.tableView.reloadData()
            //            let path = NSIndexPath(item: indexPath.row, section: indexPath.section)
            //            self.tableView.reloadRows(at: [path as IndexPath], with: .none)
            
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
            self.tableView.reloadRows(at: [path as IndexPath], with: .none)
        }
        else if objModel.type == "Radio"{
            
            let keys = Array(objModel.multiOptions.keys)
            if self.formValues[objModel.name] != nil {
                for (k,_) in self.formValues{
                    
                    if objModel.name == k{
                        self.formValues[k] = keys[indexPath.row] as AnyObject
                        
                        let indices: IndexSet = [indexPath.section]
                        self.tableView.reloadSections(indices, with: .none)
                        print(self.formValues)
                        
                    }
                    
                }
            } else {
                self.formValues[objModel.name] = keys[indexPath.row] as AnyObject
                
                let indices: IndexSet = [indexPath.section]
                self.tableView.reloadSections(indices, with: .none)
                print(self.formValues)
            }
            
        }
    }
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 40, height: 40), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    func didSelectICheckBtn(index: Int, section: Int, sender: Any) {
        let objModel = signUpArr[section]
        if let val = formValues[objModel.name] {
            if val as! Bool  == false {
                formValues[objModel.name] = true as AnyObject
            } else {
                formValues[objModel.name] = false as AnyObject
            }
        }
        print(formValues)
        self.tableView.reloadData()
        //        let path = NSIndexPath(item: index, section: section)
        //        self.tableView.reloadRows(at: [path as IndexPath], with: .none)
    }
    func didPressedFileButton(index: Int, section: Int, sender: Any) {
        self.view.endEditing(true)
        
    }
    
    // MPMediaPickerController Delegate methods
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true) {
            
        }
        
    }
    func export(_ assetURL: NSURL,titles: String, completionHandler: @escaping (NSURL?, Error?) -> ()) {
        let asset = AVURLAsset(url: assetURL as URL)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completionHandler(nil, ExportError.unableToCreateExporter as? Error)
            return
        }
        print(asset)
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(titles)?.appendingPathExtension("m4a")
        
        // remove any existing file at that location
        do {
            try FileManager.default.removeItem(at: fileURL!)
        }
        catch {
            // most likely, the file didn't exist.  Don't sweat it
        }
        
        
        exporter.outputURL = fileURL
        exporter.outputFileType = AVFileType(rawValue: "com.apple.m4a-audio")
        
        exporter.exportAsynchronously {
            print(exporter.status)
            if exporter.status == .completed {
                completionHandler(fileURL as NSURL?, nil)
            } else {
                
                completionHandler(nil, exporter.error)
            }
        }
    }
    
    func exampleUsage(with mediaItem: MPMediaItem) {
        
        if let assetURL = mediaItem.assetURL {
            export(assetURL as NSURL, titles: String(describing: mediaItem.title!)) { fileURL, error in
                guard let fileURL = fileURL, error == nil else {
                    print("export failed: \(String(describing: error))")
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                    return
                }
                
                // use fileURL of temporary file here
                print("\(fileURL)")
                self.file_data = fileURL as URL
                print(self.file_data as Any)
                if self.formValues["songs"] == nil {
                    self.formValues["songs"] = fileURL.lastPathComponent as AnyObject
                }
                self.fileName = "mediaItem.mp3"
                self.fileName = fileURL.lastPathComponent
                self.formTbl.reloadData()
                
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    enum ExportError: Error {
        case unableToCreateExporter
    }
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        print("you picked: \(mediaItemCollection)")//This is the picked media item.
        item = mediaItemCollection.items[0] as MPMediaItem
        print(item?.artist as Any)
        print(item?.albumArtist as Any)
        print(item?.title as Any)
        print(item?.lyrics as Any)
        
        self.exampleUsage(with: item!)
        
    }
    
    
    //MARK: - File Delegates
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        
        print("The Url is : \(cico)")
        print(controller.documentPickerMode)
        if controller.documentPickerMode == .import {
            
            self.file_data = cico
            self.fileName = cico.lastPathComponent
            if formValues["filename"] == nil {
                formValues["filename"] = cico.lastPathComponent as AnyObject
            }
            print(formValues)
            self.formTbl.reloadData()
            
        }
    }
    
    @available(iOS 8.0, *)
    
    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        
        present(documentPicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoUrl = info[UIImagePickerController.InfoKey.mediaURL.rawValue]as! URL
        print(videoUrl)
        self.file_data = videoUrl
        
        self.fileName = videoUrl.lastPathComponent
        if formValues["filedata"] == nil {
            formValues["filedata"] = videoUrl.lastPathComponent as AnyObject
        }
        print(formValues)
        self.formTbl.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print("we cancelled")
        //        dismiss(animated: true, completion: nil)
    }
    
    func mediaDidPicked(item: URL) {
        print(item)
        self.file_data = item
        print(file_data as Any)
        if formValues["songs"] == nil {
            formValues["songs"] = item.lastPathComponent as AnyObject
        }
        self.fileName = "mediaItem.mp3"
        fileName = item.lastPathComponent
        self.formTbl.reloadData()
    }
    
    func didPressedDateButton(index: Int, section: Int, sender: WAButton) {
        
        self.view.endEditing(true)
        
        let objModel = signUpArr[section]
        if objModel.name == "1_1_6_alias_birthdate" {
            let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let currentDate = NSDate()
            let maxDatecomponents = NSDateComponents()
            
            maxDatecomponents.year = -12
            let maxDate: NSDate = calendar!.date(byAdding: maxDatecomponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
            
            
            let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePicker.Mode.date, selectedDate: maxDate as Date?, doneBlock: {
                picker, value, index in
                
                print("value = \(String(describing: value!))")
                
                let dateString = Utilities.stringFromDate(value as! Date)
                print(dateString)
                
                self.formValues[objModel.name] = String(dateString) as AnyObject
                print(self.formValues[objModel.name]!)
                self.formTbl.reloadData()
                //                let path = IndexPath(item: index as! Int, section: section)
                //                self.formTbl.reloadRows(at: [path], with: .none)
                
            }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
            datePicker?.maximumDate = maxDate as Date?
            datePicker?.show()
        } else {
            
            let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePicker.Mode.dateAndTime, selectedDate: Date(), doneBlock: {
                picker, value, index in
                
                print("value = \(String(describing: value!))")
                
                let dateString = Utilities.stringFromDate(value as! Date)
                print(dateString)
                
                self.formValues[objModel.name] = String(dateString) as AnyObject
                print(self.formValues[objModel.name]!)
                self.formTbl.reloadData()
                //                let path = IndexPath(item: index as! Int, section: section)
                //                self.formTbl.reloadRows(at: [path], with: .none)
                
            }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
            datePicker?.show()
        }
        
        
        
    }
    
    
    func didPressedLocationButton(index: Int, section: Int, sender: Any) {
        self.view.endEditing(true)
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment  //suitable filter type
        filter.country = "CA"  //appropriate country code
        autocompleteController.autocompleteFilter = filter
        locationPath = IndexPath(item: index, section: section)
        present(autocompleteController, animated: true, completion: nil)
    }
    func didSelectImageBtn(index: Int, section: Int, sender: Any) {
    }
    func didPressedmultiOptButton(index: Int, section: Int, sender: Any) {
        
        self.view.endEditing(true)
        
        let objModel = signUpArr[section]
        print(objModel.multiOptions)
        var val = [String]()
        var key = [String]()
        
        if objModel.name == "1_1_39_alias_country" {
            let second = objModel.multiOptions.sorted { (first, second) -> Bool in
                (first.value as! String) < (second.value as! String)
            }
            for (k,v) in second{
                key.append(k)
                val.append(v as! String)
            }
            ActionSheetStringPicker.show(withTitle: objModel.label, rows: val , initialSelection: 0, doneBlock: {picker, values, indexes in
                
                self.formValues[objModel.name] = key[values] as AnyObject
                print(self.formValues)
                let index = IndexPath(row: index, section: section)
                
                self.formTbl.reloadRows(at: [index], with: .automatic)
            }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
        } else {
            
            let second = objModel.multiOptions
            
            for (k,v) in second{
                key.append(k)
                val.append(v as! String)
            }
            print(val)
            ActionSheetStringPicker.show(withTitle: objModel.label, rows: val , initialSelection: 0, doneBlock: {picker, values, indexes in
                if objModel.name ==  "profile_type"{
                    var i = 1
                    if key[values] == "1" {
                        if self.alreadyContains == false {
                        for obj in self.fullArr{
                            if obj.label == "Business Name" || obj.label == "Business Address"{
                                self.signUpArr.insert(obj, at: section + i)
                                self.formTbl.beginUpdates()
                                self.formTbl.insertSections(NSIndexSet(index: section + i) as IndexSet, with: .automatic)
                                self.formTbl.endUpdates()
                                i = i + 1
                            }
                        }
                            self.alreadyContains = true
                        }
                        
                    }else{
                        if self.alreadyContains == true{
                        for obj in self.signUpArr{
                            if obj.label == "Business Name" || obj.label == "Business Address" {
                                let indexx = self.signUpArr.index(of: obj)
                                self.signUpArr.remove(at: indexx!)
                                self.formTbl.beginUpdates()
                                self.formTbl.deleteSections(NSIndexSet(index: indexx!) as IndexSet, with: .automatic)
                                self.formTbl.endUpdates()
                            }
                        }
                        self.alreadyContains = false
                        }
                    }
                }
                self.formValues[objModel.name] = key[values] as AnyObject
                print(self.formValues)
                let index = IndexPath(row: index, section: section)
                
                self.formTbl.reloadRows(at: [index], with: .automatic)
            }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
        }
        
        
    }
    
    func didChangeTextView(index: Int, section: Int, text: String) {
        let objModel = signUpArr[section]
        formValues[objModel.name] = text as AnyObject
        print(text)
    }
    
    func didChangeTextField(index: Int, section: Int, text: String) {
        let objModel = signUpArr[section]
        
        print(index)
        print(section)
        
        if objModel.type == "MultiText" {
            if let field = objModel.fieldOptions[index] as? Dictionary<String,AnyObject> {
                if let name = field["name"] as? String {
                    print(name)
                    self.formValues[name] = text as AnyObject
                    print(formValues)
                }
                
            }
            
        } else {
            formValues[objModel.name] = text as AnyObject
            print(text)
            
        }
        
    }
    //MARK: - Number FORMATTING
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        //            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        let hasLeadingOne = true
        if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
            let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
            
            return (newLength > 10) ? false : true
        }
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        if hasLeadingOne {
            formattedString.append("+1.")
            index += 1
        }
        if (length - index) > 3 {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@.", areaCode)
            index += 3
        }
        if length - index > 3 {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@.", prefix)
            index += 3
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        textField.text = formattedString as String
        formValues["mobileno"] = formattedString as AnyObject
        return false
        
    }
    //MARK: - SUBMIT BUTTON CLICKED
    
    func didPressedSubmitButton(index: Int, section: Int, sender: Any) {
        self.view.endEditing(true)
        
        
        if let numb = formValues["mobileno"] as? String{
            let txt = numb
            let numb = txt.replacingOccurrences(of: ".", with: "")
            var realNum = ""
            if numb.count > 3{
                realNum = numb
                self.formValues["mobileno"] = realNum as AnyObject
            }
        }
        print(formValues)
        //PROFESSIONAL VALIDATION OF BUSINESS ADDRESS
        if let type = formValues["profile_type"] as? String{
            if type == "1" {
                if formValues["location"] == nil || formValues["location"] as? String == ""{
                    Utilities.showAlertWithTitle(title: "Missing", withMessage: "Business Address is missing" , withNavigation: self)
                    return
                }
            }
        }
        for formdic in self.signUpArr{
            
            if formdic.hasValidator == true{
                
                if formTypeValue == .acc {
                    if formdic.name == "email" {
                        let email = formValues[formdic.name] as? String
                        if (email?.isEmpty)! || email == nil {
                            Utilities.showAlertWithTitle(title: "Missing", withMessage: "\(formdic.label) is missing" , withNavigation: self)
                        }else if !(Utilities.isValidEmail(testStr: (email)!)) {
                            Utilities.showAlertWithTitle(title: "Alert", withMessage: "Email is not Valid!", withNavigation: self)
                            return
                        }
                        
                    }else if formdic.name == "password"
                    {
                        let password = formValues[formdic.name] as? String
                        if(password?.count == 0)
                        {
                            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Password is required", withNavigation: self)
                            return
                        }
//                        else if ((password?.count)! < 6)
//                        {
//                            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Password must be at least 6 characters", withNavigation: self)
//                            return
//                        }
                    }else if formdic.name == "passconf"
                    {
                        let password = formValues[formdic.name] as? String
                        let passwordconf = formValues["password"] as? String
                        if(password?.count == 0)
                        {
                            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Password again is required", withNavigation: self)
                            return
                        }else if (password != passwordconf)
                        {
                            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Password and Confirm Password does not match", withNavigation: self)
                            return
                        }else{
                            let password = formValues[formdic.name] as? String
                            if !isValidated(password!){
                                Utilities.showAlertWithTitle(title: "Password", withMessage: "Please enter at least 8 characters \n Password must include at least one number/digit, one lowercase letter and one uppercase letter." , withNavigation: self)
                                return
                            }
                        }
                        
                    }
                    if !(cameFromFb) || !(cameFromTw) || !(cameFromLi){
                        print(formdic.name)
                        print(formValues[String(formdic.name)] as Any)
                        let val = String(describing: formValues[String(formdic.name)]!)
                        print(val)
                        if val == ""{
                            Utilities.showAlertWithTitle(title: "Missing", withMessage: "\(formdic.label) is missing" , withNavigation: self)
                            return
                        }
                        
                        if formdic.name == "title" {
                            let title = formValues[formdic.name] as? String
                            if !((title?.count)! >= 3) {
                                Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(formdic.label) should be of at least 3 characters" , withNavigation: self)
                                return
                            }
                        }
                    }
                } else {
                    print(formdic.name)
                    
                    print(formValues[String(formdic.name)] as Any)
                    let val = String(describing: formValues[String(formdic.name)]!)
                    print(val)
                    if val == ""{
                        Utilities.showAlertWithTitle(title: "Missing", withMessage: "\(formdic.label) is missing" , withNavigation: self)
                        return
                    }
                    
                    if formdic.name == "title" {
                        let title = formValues[formdic.name] as? String
                        if !((title?.count)! >= 3) {
                            Utilities.showAlertWithTitle(title: "Alert", withMessage: "\(formdic.label) should be of at least 3 characters" , withNavigation: self)
                            return
                        }
                    }
                }
                
                if formdic.type == "Checkbox" || formdic.name == "search" {
                    if formValues[formdic.name] as? Bool == false {
                        Utilities.showAlertWithTitle(title: "Missing", withMessage: "\(formdic.label) is missing" , withNavigation: self)
                        return
                    }
                }
                if formdic.name == "password" && formdic.type == "password"{
                    if let pass = formValues[String(formdic.name)] as? String{
                    
                        
                    }
                }
                
            }
            
        }
        validateForm(dic: formValues)
        
        
    }
    func isValidated(_ password: String) -> Bool {
        var lowerCaseLetter: Bool = false
        var upperCaseLetter: Bool = false
        var digit: Bool = false
        var specialCharacter: Bool = false
        
        if password.count  >= 8 {
            for char in password.unicodeScalars {
                if !lowerCaseLetter {
                    lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
                }
                if !upperCaseLetter {
                    upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
                }
                if !digit {
                    digit = CharacterSet.decimalDigits.contains(char)
                }
                if !specialCharacter {
                    specialCharacter = CharacterSet.punctuationCharacters.contains(char)
                }
            }
            if specialCharacter || (digit && lowerCaseLetter && upperCaseLetter) {
                //do what u want
                return true
            }
            else {
                return false
            }
        }
        return false
    }
    func validateForm(dic: Dictionary<String, AnyObject>){
        
        var params = dic
        if formTypeValue == .acc {
            if cameFromFb {
                if (UserDefaults.standard.value(forKey: "fb_id") != nil) {
                    let id = UserDefaults.standard.value(forKey: "fb_id") as? String
                    params["facebook_uid"] = id as AnyObject
                    self.formValues["facebook_uid"] = id as AnyObject
                    //                    self.formValues
                }
                if (UserDefaults.standard.value(forKey: "fb_token") != nil) {
                    let access_token = UserDefaults.standard.value(forKey: "fb_token") as? String
                    params["access_token"] = access_token as AnyObject
                    self.formValues["access_token"] = access_token as AnyObject
                }
                params["code"] = "123456" as AnyObject
                self.formValues["code"] = 123456 as AnyObject
                
            }else if cameFromTw{
                    if (UserDefaults.standard.value(forKey: "twitter_id") != nil) {
                        let id = UserDefaults.standard.value(forKey: "twitter_id") as? Int
                        params["twitter_uid"] = id as AnyObject
                        self.formValues["twitter_uid"] = id as AnyObject
                        //                    self.formValues
                    }
                    if (UserDefaults.standard.value(forKey: "twitter_token") != nil) {
                        let access_token = UserDefaults.standard.value(forKey: "twitter_token") as? String
                        params["twitter_token"] = access_token as AnyObject
                        self.formValues["twitter_token"] = access_token as AnyObject
                }
                if (UserDefaults.standard.value(forKey: "twitter_secret") != nil) {
                    let access_token = UserDefaults.standard.value(forKey: "twitter_secret") as? String
                    params["twitter_secret"] = access_token as AnyObject
                    self.formValues["twitter_secret"] = access_token as AnyObject
                }
                    params["code"] = "123456" as AnyObject
                    self.formValues["code"] = 123456 as AnyObject
            }else if cameFromLi{
                if (UserDefaults.standard.value(forKey: "linkedin_id") != nil) {
                    let id = UserDefaults.standard.value(forKey: "linkedin_uid") as? Int
                    params["linkedin_uid"] = id as AnyObject
                    self.formValues["linkedin_uid"] = id as AnyObject
                    //                    self.formValues
                }
                if (UserDefaults.standard.value(forKey: "linkedin_token") != nil) {
                    let access_token = UserDefaults.standard.value(forKey: "linkedin_token") as? String
                    params["access_token"] = access_token as AnyObject
                    self.formValues["access_token"] = access_token as AnyObject
                }
                params["code"] = "123456" as AnyObject
                self.formValues["code"] = 123456 as AnyObject
            }
            
            params["account_validation"] = "1" as AnyObject
            params["fields_validation"] = "0" as AnyObject
        } else {
            params["account_validation"] = "0" as AnyObject
            params["fields_validation"] = "1" as AnyObject
            params.update(other: accDic)
        }
        
        params["timezone"] = "US/Pacific" as AnyObject
        print(params)
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: params, method: "signup/validations", success: { (response) in
            print(response)
            
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let err = response.object(forKey: "error") as? Bool {
                if err{
                    if let message = response.object(forKey: "message") as? Dictionary<String,AnyObject> {
                        for (_,v) in message {
                            let errr = v as? String
                            Utilities.showAlertWithTitle(title: "Warning", withMessage: errr!, withNavigation: self)
                            return
                        }
                    }
                }
            } else if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 204 {
                    
                    if self.formTypeValue == .acc {
                        if  self.mobileVerification{
                            self.VerifyCode()
                            
                        }else{
                        let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .addPhotoVC) as! AddPhotoVC
                        con.dic3 = self.formValues
                        con.packageArr = self.packageArr
                    self.navigationController?.pushViewController(con, animated: true)
                        }
                    } else {
                        if params["1_1_15_alias_"] == nil || params["1_1_15_alias_"] as? String == ""{
                            let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .wellcomeVC) as! WellcomeVC
                            con.dic3 = params
                            con.packageArr = self.packageArr
                            self.navigationController?.pushViewController(con, animated: true)
                        }else{
                        let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .confirmVC) as! ConfirmVC
                        con.dic3 = params
                        con.packageArr = self.packageArr
                        self.navigationController?.pushViewController(con, animated: true)
                        }

                    }
                }
            }
        }) { (response) in
            print(response)
        }
    }
    func VerifyCode()
    {
        let method = "/user/verify/send"
        var dic = Dictionary<String,AnyObject>()
            let number = self.formValues["mobileno"] as? String
            dic["mobile"] = number as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        AFNWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response.object(forKey: "status_code") as? Int
            {
                if status_code == 200{
                    let body = response.object(forKey: "body") as? Dictionary<String,AnyObject>
                    if let res = body!["response"] as? Dictionary<String,AnyObject>
                        
                    {
                        let status = res["status"] as? Bool
                        if status!{
                            let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .confirmVC) as! ConfirmVC
                            con.confirmType = .Signup
                            con.packageArr = self.packageArr
                            con.phoneNumber = self.formValues["mobileno"] as! String
                            con.dic3 = self.formValues
                            con.codeReceived = res["code"] as? Int
                        self.navigationController?.pushViewController(con, animated: true)
                           
                        }else{
                            let mxg  = (res["message"] as? String) ?? ""
                            Utilities.showAlertWithTitle(title: "Error", withMessage: mxg, withNavigation: self)
                            
                        }
                    }
                }
            }
            
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
}
extension String {
    func capitalizedFirst() -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased() + rest.lowercased()
    }
    
    func capitalizedFirst(with: Locale?) -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased(with: with) + rest.lowercased(with: with)
    }
}
extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}
extension SignUpTblVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.locationDic["Location"] = place.formattedAddress! as AnyObject
        self.locationDic["latitude"] = (String(describing: place.coordinate.latitude)) as AnyObject
        self.locationDic["longitude"] = (String(describing: place.coordinate.longitude)) as AnyObject
        self.locationDic["formatted_address"] = place.formattedAddress! as AnyObject
        self.locationDic["address"] = place.formattedAddress! as AnyObject
        self.formValues["location"] = "\(place.formattedAddress!)" as AnyObject
        self.locationDic["location"] = "\(place.formattedAddress!)" as AnyObject
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
        let jsonData = try? JSONSerialization.data(withJSONObject: locationDic, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        self.formValues["locationParams"] = jsonString as AnyObject
        dismiss(animated: true, completion: nil)
        self.formTbl.reloadRows(at: [locationPath], with: .none)
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

