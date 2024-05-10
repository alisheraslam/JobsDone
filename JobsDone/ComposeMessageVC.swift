//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import BSImagePicker
import Photos
import ActionSheetPicker_3_0
import DKImagePickerController
public enum SuggestType{
    case Chat
    case Recipient
}

class ComposeMessageVC: UIViewController, UITextFieldDelegate, UITextViewDelegate,SuggestionCollectionCellDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource ,UIImagePickerControllerDelegate, UINavigationControllerDelegate,AttachmentMenuProtocol  {
    

    @IBOutlet weak var sendToTxt: UITextField!
    @IBOutlet weak var subjectTxt: UITextField!
    @IBOutlet weak var messageTxt: UITextView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectView: UICollectionView!
  
    @IBOutlet weak var lineUnderCView: UIView!
    
    @IBOutlet var dropDownView: WAView!
    @IBOutlet weak var dropTblView: UITableView!
    
    @IBOutlet var attachVideoAlertView: WAView!
    @IBOutlet weak var videoTypeBtn: WAButton!
    @IBOutlet weak var videoUrl: WATextField!
    @IBOutlet weak var chooseVideoBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addBtnHeight: NSLayoutConstraint!
    var blurEffectView : UIVisualEffectView!
    let handler = AttachmentMenuHandler()
    var suggestionArr = [UsersModel]()
    var usersArr = [UsersModel]()
    var selectedUsers = [UsersModel]()
    var delegate: SuggestionCollectionCellDelegate?
    var attachBtn: UIBarButtonItem?
    var sendBtn: UIBarButtonItem?
    var video_id: String?
    var song_id: String?
    var image_file: UIImage?
    var url_file: String?
    var video_url: String?
    var userId : Int?
    var image_url: URL?
    var music_id: String?
    var searchString: String?
    var btnBarBadge : UIBarButtonItem?
    var attachmentAdded = false
    var suggestType = SuggestType.Chat
    var parms = Dictionary<String,AnyObject>()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtnHeight.constant = 0
        self.hideKeyboardWhenTappedAround()
        dropTblView.estimatedRowHeight = 50
        dropDownView.frame = CGRect(x: 15, y: 120, width: (self.view.frame.width) - 30, height: 128)
        attachVideoAlertView.frame = CGRect(x: 0, y: 200, width: self.view.frame.width - 40, height: 180)
        attachVideoAlertView.center.x = self.view.center.x
        videoUrl.setLeftPaddingPoints(10)
        if self.suggestType == .Chat{
        self.title = "New Message"
        }else{
          self.title = "Add Recipient"
        }
        messageTxt.text = "Compose Message"
        messageTxt.textColor = UIColor.lightGray
        if suggestType == .Recipient{
                self.sendToTxt.placeholder = "SEARCH PEOPLE"
            self.sendToTxt.isFirstResponder
            self.subjectTxt.placeholder = ""
            self.subjectTxt.isUserInteractionEnabled = false
            self.messageTxt.text = ""
            self.messageTxt.isUserInteractionEnabled = false
            addBtnHeight.constant = 40
            
        }
        
        collectionViewHeight.constant = 0
        lineUnderCView.isHidden = true
        
        chooseVideoBtn.isHidden = true
        if self.selectedUsers.count > 0{
            sendToTxt.isEnabled = false
            sendToTxt.isHidden = true
            self.collectionViewHeight.constant = 40
            self.lineUnderCView.isHidden = false
            collectView.delegate = self
            collectView.dataSource = self
            self.collectView.reloadData()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(ComposeMessageVC.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        sendToTxt.addTarget(self, action: #selector(self.SearchUser(_:)), for: .editingChanged)
//        getUsers()
    }
    @objc func dismissKeyboard1() {
        self.dropDownView.removeFromSuperview()
        self.view.endEditing(true)
    }

    @objc func SearchUser(_ textField: UITextField)
    {

        let strsss = textField.text!
        if strsss != ""{
        self.parms["search"] = strsss as AnyObject
        self.usersArr.removeAll()
            timer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getUsers), userInfo: nil, repeats: false)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
//    func cancel(){
//        self.naviga
//    }
    override func viewWillAppear(_ animated: Bool) {

        NotificationCenter.default.addObserver(self, selector: #selector(self.addBadge(notification:)), name: Notification.Name("addBadge"), object: nil)
//       sendBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "send"), style: .plain, target: self, action: #selector(sendTapped))
        sendBtn = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendTapped))
        btnBarBadge = UIBarButtonItem(image: #imageLiteral(resourceName: "attachment"),
                                      style: UIBarButtonItem.Style.done ,
                                      target: self, action: #selector(attachTapped))
        
     
//        let bageV = 10
     
//        btnBarBadge?.shouldHideBadgeAtZero = true
//        btnBarBadge?.shouldAnimateBadge = true
//        btnBarBadge?.badgeValue = String(describing: bageV)
//        btnBarBadge?.badgeOriginX = 25.0
//        btnBarBadge?.badgeOriginY = -6
//        btnBarBadge?.badgeTextColor = .white
//        btnBarBadge?.badgeBGColor = UIColor.red
//        
//        sendBtn?.shouldHideBadgeAtZero = true
//        sendBtn?.shouldAnimateBadge = true
//        sendBtn?.badgeValue = String(describing: bageV)
//        sendBtn?.badgeOriginX = 25.0
//        sendBtn?.badgeOriginY = -6
//        sendBtn?.badgeTextColor = .white
//        sendBtn?.badgeBGColor = UIColor.red
        
        
        if self.suggestType == .Chat{
        navigationItem.rightBarButtonItems = [sendBtn!, btnBarBadge!]
        }
//        btnBarBadge?.setBadge(text: "2")

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    // MARK: - Private Methods
    
    @objc func attachTapped(sender: UIBarButtonItem) {
        
        if attachmentAdded {
            if image_file != nil {
                Alertift.alert(title: "", message: "Already Attached Image")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        //                        self.btnBarBadge?.badgeValue = "0"
                        self.btnBarBadge?.setBadge(text: "")
                        self.image_file = nil
                        self.attachmentAdded = false
                    })
                    .show(on: self, completion: nil)
            } else if url_file != nil {
                Alertift.alert(title: "", message: "Already Attached Link")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        //                        self.btnBarBadge?.badgeValue = "0"
                        self.btnBarBadge?.setBadge(text: "")
                        self.url_file = nil
                        self.attachmentAdded = false
                    })
                    .show(on: self, completion: nil)
                
            } else if video_id != nil {
                Alertift.alert(title: "", message: "Already Attached Video")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        //                        self.btnBarBadge?.badgeValue = "0"
                        self.btnBarBadge?.setBadge(text: "")
                        self.video_id = nil
                        self.attachmentAdded = false
                    })
                    .show(on: self, completion: nil)
                
            } else if song_id != nil {
                Alertift.alert(title: "", message: "Already Attached Music")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        //                        self.btnBarBadge?.badgeValue = "0"
                        self.btnBarBadge?.setBadge(text: "")
                        self.song_id = nil
                        self.attachmentAdded = false
                    })
                    .show(on: self, completion: nil)
                
            }

        } else {
//            self.handler.setAttatchmentMenu(con: self, suplimentryView: nil)
            self.handler.setAttatchmentMenu(con: self, suplimentryView: nil, senderr: sender, view: self.view, btnTyp: "barBtn")
            self.handler.delegate = self
        }
        
        
    }
    
    //MARK:- Attachment handler Delegates
    @objc func addBadge(notification: Notification) {
        DispatchQueue.main.async { 
            self.btnBarBadge?.setBadge(text: "1")
        }
    }
    func didPickedImage(image: UIImage, url: URL) {
        //        self.btnBarBadge?.badgeValue = "1"
//        NotificationCenter.default.post(name: Notification.Name("addBadge"), object: self)
//        self.navigationItem.rightBarButtonItems?[1].setBadge(text: "1")
        self.btnBarBadge?.setBadge(text: "1")
        print(image)
        image_file = image
        
        image_url = url
        print(url)
        
        attachmentAdded = true
    }
    func didGotLink(url: String) {
//        NotificationCenter.default.post(name: Notification.Name("addBadge"), object: self)
        self.btnBarBadge?.setBadge(text: "1")
        if !Utilities.isValidUrl(userURL: url) {
            Utilities.showAlertWithTitle(title: "", withMessage: "Please enter a valid url with 'https://' or 'http://'..!", withNavigation: self)
            return
        }
//        self.btnBarBadge?.setBadge(text: "1")
        print(url)
        self.url_file = url
        self.attachmentAdded = true
    }
    
    func didPickedMusicId(id: String) {
//        NotificationCenter.default.post(name: Notification.Name("addBadge"), object: self)
        self.btnBarBadge?.setBadge(text: "1")
//        self.btnBarBadge?.setBadge(text: "1")
        
        music_id = id
        song_id = id
        self.attachmentAdded = true
    }
    func didPickedVideo(id: Int, url: String, imageStr: String) {
        self.btnBarBadge?.setBadge(text: "1")
        self.attachmentAdded = true
        self.video_id = String(describing: id)
        self.video_url = url
        
        print(id)
        print(url)
    }
    

    func mediaDidPicked(item: URL) {
        self.attachmentAdded = true
//        self.btnBarBadge?.badgeValue = "1"
        btnBarBadge?.setBadge(text: "1")
    }
    func didPickedVideoFromDevice(url: URL) {
        
    }
    func media_id(music_id: String) {
        self.attachmentAdded = true
//        self.btnBarBadge?.badgeValue = "1"
        btnBarBadge?.setBadge(text: "1")
    }
    
    
    @objc func sendTapped(sender: UIBarButtonItem) {
        
        var params = Dictionary<String,String>()
        var toValues: String?
        if selectedUsers.isEmpty {
            Utilities.showAlertWithTitle(title: "oOps..!", withMessage: "user is missing", withNavigation: self)
            return
        } else {
            var users = [String]()
            for usr in selectedUsers {
               users.append(usr.id!)
            }
            toValues = users.joined(separator: ",")
            
        }
        if (subjectTxt.text?.isEmpty)! {
            Utilities.showAlertWithTitle(title: "oOps..!", withMessage: "subject is missing", withNavigation: self)
            return
        }
        print(messageTxt.text)
        if messageTxt.text.isEmpty || messageTxt.text == "Compose Message" || messageTxt.text.count == 0 {
            Utilities.showAlertWithTitle(title: "oOps..!", withMessage: "body is missing", withNavigation: self)
            return
        }
        params["toValues"] = toValues!
        params["title"] = subjectTxt.text
        params["body"] = messageTxt.text
        
        if image_file != nil {
            
            params["post_attach"] = String(1)
            params["type"] = "photo"
            print(params)
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
   
            ALFWebService.sharedInstance.doPostDataWithImage(parameters: params , method: "messages/compose", image: image_file, success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                self.attachmentAdded = false
                self.navigationController?.popViewController(animated: true)
            }, fail: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                self.attachmentAdded = false
                self.navigationController?.popViewController(animated: true)
            })
        } else {

            if url_file != nil {
                params["uri"] = url_file
                params["post_attach"] = String(1)
                params["type"] = "link"
                print(params)
            } else if video_id != nil {
                
                params["video_id"] = String(describing: video_id!)
                params["post_attach"] = String(1)
                params["type"] = "video"
                print(params)
            } else if  song_id != nil {
                
                params["song_id"] = String(describing: song_id!)
                params["post_attach"] = String(1)
                params["type"] = "music"
                print(params) //video_url
            }
        print(params)
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: params as Dictionary<String, AnyObject>, method: "messages/compose", success: { (response) in
                print(response)
                self.attachmentAdded = false
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMessagePosted"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }) { (response) in
                print(response)
                self.attachmentAdded = false
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                self.navigationController?.popViewController(animated: true)
            }

        }
   
    }
    func didPressedCrossButton(sender: UIButton, tag: Int) {
        
        
        
        selectedUsers.remove(at:tag)
        if selectedUsers.isEmpty{
            self.collectView.reloadData()
            self.collectionViewHeight.constant = 0
            self.lineUnderCView.isHidden = true
        }else{
            self.collectView.reloadData()
        }
        

    }
    @objc func getUsers(){
        
        if suggestType == .Recipient{
            parms["message"] = 1 as AnyObject
        }
        parms["page"] = 1 as AnyObject
        parms["limit"] = 100 as AnyObject
//        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: parms, method: "user/suggest", success: { (response) in
//            print(response)
//           Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int {
                if status_code == 200 {
                    self.usersArr.removeAll()
                    if let body = response["body"] as? Dictionary<String,AnyObject> {
                        if let resp = body["response"] as? [Dictionary<String,AnyObject>] {
                            for res in resp {
                                let usr = UsersModel.init(res)
                                if self.userId != nil{
                                    if usr.id == String(describing: self.userId!){
//                                        self.selectedUsers.append(usr)
                                    }
                                }
                                self.usersArr.append(usr)
                            }
                            if self.usersArr.isEmpty{
                                self.dropDownView.removeFromSuperview()
                            }else{
                                self.suggestionArr = self.usersArr
                                self.view.addSubview(self.dropDownView)
                                self.dropTblView.reloadData()
                                
                            }
                        }else{
                            self.suggestionArr = self.usersArr
                            self.view.addSubview(self.dropDownView)
                            self.dropTblView.reloadData()
                        }
                        if self.userId != nil{
                            self.collectView.reloadData()
                            self.collectionViewHeight.constant = 40
                            self.lineUnderCView.isHidden = false
                        }

                    }
                   
                } else {
                    
                }
            }
           
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        attachVideoAlertView.removeFromSuperview()
        print(info)
        let videoUrl = info[UIImagePickerController.InfoKey.mediaURL.rawValue]as! URL
        print(videoUrl)
      
//        videoUrl.lastPathComponent as AnyObject
        var params = Dictionary<String, AnyObject>()
        
        params["post_attach"] = 1 as AnyObject
        params["type"] = 3 as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        
        AFNWebService.sharedInstance.doPostDataWithMedia(parameters: params, method: "videos/create", media: videoUrl, name: "filedata", success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int {
                if status_code == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject> {
                        if let response = body["response"] as? Dictionary<String,AnyObject> {
                            print(response["video_id"]!)
                            self.video_id = String(describing: response["video_id"]!)
                            self.attachmentAdded = true
                            self.btnBarBadge?.setBadge(text: "1")
                            Utilities.showAlertWithTitle(title: "Success", withMessage: "", withNavigation: self)
                        }
                    }
                } else {
                    Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Error Occured, Try Again", withNavigation: self)
                }
            }
            
        }, fail: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            
        })
 
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- IBActions
    
    @IBAction func videoAlertOkBtnClicked(_ sender: Any) {
        video_url = videoUrl.text
        attachVideoAlertView.removeFromSuperview()
        _ = URL(string: video_url!)
        
        var params = Dictionary<String, AnyObject>()
        
        params["post_attach"] = 1 as AnyObject
        params["url"] = video_url as AnyObject
        if videoTypeBtn.currentTitle == "youtube" {
            params["type"] = 1 as AnyObject
        } else if videoTypeBtn.currentTitle == "vimeo" {
            params["type"] = 2 as AnyObject
        }
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        print(params)
        
        ALFWebService.sharedInstance.doPostData(parameters: params, method: "videos/create", success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int {
                if status_code == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject> {
                        if let response = body["response"] as? Dictionary<String,AnyObject> {
                            print(response["video_id"]!)
                            self.video_id = String(describing: response["video_id"]!)
                            self.attachmentAdded = true
                            self.btnBarBadge?.setBadge(text: "1")
                            Utilities.showAlertWithTitle(title: "Success", withMessage: "", withNavigation: self)
                        }
                    }
                } else {
                    Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Error Occured, Try Again", withNavigation: self)
                }
            }
            
        }, fail: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            
        })

    }
    
    @IBAction func videoAlertCancelBtnClicked(_ sender: Any) {
        
        attachVideoAlertView.removeFromSuperview()
    }
    
    @IBAction func videoTypeBtnClicked(_ sender: Any) {
        
        let videoTypes = ["youtube", "viemo", "My Device"]
        
        ActionSheetStringPicker.show(withTitle: "--- Select Video Type ---", rows: videoTypes , initialSelection: 0, doneBlock: {picker, values, indexes in
            self.videoTypeBtn.setTitle(videoTypes[values], for: .normal)
            if self.videoTypeBtn.currentTitle == "My Device" {
                self.chooseVideoBtn.isHidden = false
                self.videoUrl.isHidden = true
            } else {
                self.chooseVideoBtn.isHidden = true
                self.videoUrl.isHidden = false
            }
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
        
    }
    
    @IBAction func chooseVideoBtnClicked(_ sender: Any) {
        
        
        Alertift.actionSheet(title: "", message: "Select Source")
            .action(.default("Open Gallery")) {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    print("captureVideoPressed and camera available.")
                    
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    //                        imagePicker.mediaTypes = kutype
                    imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                    
                    
                    self.present(imagePicker, animated: true, completion: nil)
                } else {
                    print("Camera not available.")
                }
            }
            .action(.cancel("Cancel")) {
                
            }
            .show(on: self, completion: nil)
        
    }
    // MARK:- textView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Compose Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - textView Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dropDownView.removeFromSuperview()
        if textField == videoUrl {
            video_url = textField.text
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == sendToTxt {
//            var str = textField.text
//            if self.suggestType == .Recipient{
                let strsss = textField.text!
//                self.parms["search"] = strsss as AnyObject
//                getUsers()
//                suggestionArr.removeAll()
//                suggestionArr = self.usersArr
////            }
//            let str : NSString = textField.text! as NSString
//            let str2  = str.replacingCharacters(in: range, with: string)
////            filterContentForSearchText(searchText: str2)
//            if !suggestionArr.isEmpty {
//                self.view.addSubview(dropDownView)
//                dropTblView.reloadData()
//            }else {
//                suggestionArr.removeAll()
//                self.dropDownView.removeFromSuperview()
//            }
        }
        
        return true
    }
    
    func filterContentForSearchText(searchText: String) {
        print(searchText)

        if searchText.count == 0 {
             suggestionArr.removeAll()
        } else {
            suggestionArr = usersArr.filter { term in
                return (term.label?.lowercased().contains(searchText.lowercased()))!
            }
        }
        
    }
    
    // MARK: - CollectionView data source
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUsers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let suggestion = selectedUsers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SuggestionCollectionCell
        cell.user_name.text = selectedUsers[indexPath.row].label
        if suggestType != .Recipient{
           cell.crosBtn.isHidden = true
        }
        
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let str = selectedUsers[indexPath.row].label
        var w = str?.width(withConstraintedHeight: 20, font: UIFont.systemFont(ofSize: 14.0))
        w = w! + 32
        return CGSize(width: w! , height: 35)
    }
    
    // MARK: - TableView data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let suggestion = suggestionArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DropDownCell
        
        cell.confiCell(image: suggestion.image_profile!, name: suggestion.label!)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let id = suggestionArr[indexPath.row].id!

        if selectedUsers.isEmpty{
            
            selectedUsers.append(suggestionArr[indexPath.row])
            
        }else{
            
            var idFind = true
            
            for users in  selectedUsers{
                if users.id! == id{
                    
                    idFind = false
                }
            }
            if idFind == true{
                
                selectedUsers.append(suggestionArr[indexPath.row])
                
            }
            self.selectedUsers = Array(Set(self.selectedUsers))
        }
        
        print(selectedUsers)
        dropDownView.removeFromSuperview()
//        self.collectView.reloadData()
        self.collectionViewHeight.constant = 40
        self.lineUnderCView.isHidden = false
        self.collectView.reloadData()
        self.sendToTxt.text = ""
        

    }
    //MARK: - ADD RECIPIENT
    @IBAction func AddRecipient(_ sender: UIButton)
    {
        
        let method = "/messages/addpeople/id/\(userId!)"
        var userids = ""
        for user in self.selectedUsers{
            userids = "\(userids),\(user.id!)"
        }
        var params = Dictionary<String,AnyObject>()
        params["userids"] = userids as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: params, method: method, success: { (response) in
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code ==  204{
                    NotificationCenter.default.post(name: Notification.Name("NewRecipientAdded"), object: nil)
                   self.navigationController?.popViewController(animated: true)
                }else{
                    Utilities.showAlertWithTitle(title: "", withMessage: response["message"] as! String, withNavigation: self)
                }
            }
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }) { (response) in
            
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
        
    }
    
    
}
