//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import NextGrowingTextView
import ActionSheetPicker_3_0
import FSImageViewer
import Cupcake


class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,AttachmentMenuProtocol,ChatCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    let handler = AttachmentMenuHandler()
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var recipientView: WAView!
    @IBOutlet weak var recipientTbl: UITableView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var growingTextView: NextGrowingTextView!
    @IBOutlet weak var attachBottomBtn: MIBadgeButton!
    @IBOutlet weak var profileView: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var groupBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var emoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var tagBtn: MIBadgeButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var hireBtn: UIButton!
    
    @IBOutlet weak var hireView: UIView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var bodyTxt: UITextView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var hireModelBtn: UIButton!
    @IBOutlet weak var topStackView: UIStackView!
    var lastMxgId: Int!
    var img = ""
    var attachmentAdded = false
    let selfUserId = UserDefaults.standard.value(forKey: "id") as! Int
    let selfImage = UserDefaults.standard.value(forKey: "image") as? String
    var messagesArray = [ChatDataModel]()
    
    var conversation_id: Int!
    var senderName = ""
    var attachBtn: UIBarButtonItem?
    var image_file: UIImage?
    var image_url: URL?
    var url_file: String?
    var video_id: String?
    var videoKey: Int?
    var music_id: String?
    var video_url: String?
    var text = ""
    var pickedThumnail: UIImage?
    var btnBarBadge : UIBarButtonItem?
    var imageStr = ""
    var videoFrmDeviceURL : URL?
    var shouldLoad = true
    var emoArr = [EmoModel]()
    var selectedImagesArr = [UIImage]()
    var recipientArr = [User]()
    var chatRepeater : Timer!
    var timeInterval : TimeInterval = 5
    let height = Int(UIScreen.main.bounds.height) - 150
    var jobSkillArr = [Category]()
    var sending = false
    var phone = ""
    var selfText = ""
    var jobId: Int!
    var hireType = ""
    var hireCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imag = #imageLiteral(resourceName: "attachment")
        let imgClr = imag.withRenderingMode(.alwaysTemplate)
        self.tagBtn.setImage(imgClr, for: .normal)
        self.tagBtn.tintColor = UIColor(hexString: "#FF6B00")
        emoViewHeight.constant = 0
        self.hireBtn.isHidden = true
        self.clView.delegate = self
        self.clView.dataSource = self
        self.title = senderName
        recipientTbl.delegate = self
        recipientTbl.dataSource = self
        recipientTbl.estimatedRowHeight = 78
        recipientTbl.rowHeight = UITableView.automaticDimension
        recipientTbl.separatorColor = UIColor.clear
        let img = #imageLiteral(resourceName: "send")
        let im = img.withRenderingMode(.alwaysTemplate)
        sendBtn.setImage(im, for: .normal)
        sendBtn.tintColor = UIColor(hexString: "#FF6B00")
        tbl.tableFooterView = UIView()
        tbl.estimatedRowHeight = 68
        tbl.rowHeight = UITableView.automaticDimension
        recipientView.layer.borderWidth = 4
        recipientView.layer.borderColor = UIColor(hexString: "#FF6B00").cgColor
        recipientView.layer.cornerRadius = 5
        self.hideKeyboardWhenTappedAround()
        self.btn1.addTarget(self, action: #selector(self.SetRadioBtn(_:)), for: .touchUpInside)
        self.btn2.addTarget(self, action: #selector(self.SetRadioBtn(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.LoadRecipient), name: NSNotification.Name(rawValue: "NewRecipientAdded"), object: nil)
        
        handleGrowingTextView()
        let customButton = UIButton(type: UIButton.ButtonType.custom)
        customButton.frame = CGRect(x: 0, y: 0, width: 25.0, height: 25.0)
        customButton.addTarget(self, action: #selector(attachTapped), for: .touchUpInside)
        customButton.setImage(#imageLiteral(resourceName: "attachment"), for: .normal)
        
//        btnBarBadge = UIBarButtonItem(image: #imageLiteral(resourceName: "attachment"),
//                                      style: UIBarButtonItemStyle.plain ,
//                                      target: self, action: #selector(attachTapped))
//        btnBarBadge = UIBarButtonItem(customView: self.tagBtn)
//        attachBottomBtn.badgeValue = "2"
        self.btnBarBadge = UIBarButtonItem(customView: self.tagBtn)
//        self.btnBarBadge?.tintColor = UIColor(hexString: "#FF6B00")
//        self.navigationItem.rightBarButtonItem = self.btnBarBadge
//        let plusImg = #imageLiteral(resourceName: "plus-1")
//        let clrImg = plusImg.withRenderingMode(.alwaysTemplate)
//        self.addBtn.setImage(clrImg, for: .normal)
//        self.addBtn.tintColor = UIColor(hexString: "#FF6B00")
//        let groupImg = #imageLiteral(resourceName: "ic_groups")
//        let gClrImg = groupImg.withRenderingMode(.alwaysTemplate)
//        self.groupBtn.setImage(gClrImg, for: .normal)
//        self.groupBtn.tintColor = UIColor(hexString: "#FF6B00")
      topStackView.arrangedSubviews[2].isHidden = true
     topStackView.arrangedSubviews[3].isHidden = true
        loadMessages()
        self.LoadRecipient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if chatRepeater != nil{
        chatRepeater.invalidate()
        }
        
    }
    //MARK: - SET RADIO
    @objc func SetRadioBtn(_ sender: UIButton)
    {
        if sender == btn1{
            btn1.tag = 1
            btn2.tag = 0
            self.img1.setFAIconWithName(icon: FAType.FACircle, textColor: UIColor(hexString: "#FF6B00"))
            self.img2.setFAIconWithName(icon: FAType.FACircleThin, textColor: UIColor.lightGray)
        }else{
            btn1.tag = 0
            btn2.tag = 1
            self.img2.setFAIconWithName(icon: FAType.FACircle, textColor: UIColor(hexString: "#FF6B00"))
            self.img1.setFAIconWithName(icon: FAType.FACircleThin, textColor: UIColor.lightGray)
        }
    }
    
    @IBAction func AudioCallPressed(_ sender: UIButton)
    {
        if self.phone != "" && self.phone != "<null>"{
            self.phone.makeAColl()
        }else{
            self.showToast(message: "User does not have Number")
        }
    }
    //MARK: - Hire Btn Pressed
    @IBAction func HireBtnPressed(_ sender: UIButton)
    {
        if self.hireType == "multiple" || self.hireCount > 0{
            self.ShowRecipient(sender)
        }else{
            
            self.ShowHireModel(sender)
//            self.HireBtn(sender)
        }
    }
    //MARK: - SHOW HIRE MODAL
    @objc func ShowHireModel(_ sender: UIButton)
    {
        self.hireView.frame = CGRect(x: 10, y: 100, width: self.view.width - 20, height: 350)
        self.hireView.layer.cornerRadius = 10
        self.hireView.layer.borderColor = UIColor(hexString: "#FF6B00").cgColor
        self.hireView.layer.borderWidth = 5
        self.hireBtn.tag = sender.tag
        btn1.tag = 1
        self.img1.setFAIconWithName(icon: FAType.FACircle, textColor: UIColor(hexString: "#FF6B00"))
        self.img2.setFAIconWithName(icon: FAType.FACircleThin, textColor: UIColor.lightGray)
        self.view.addSubview(self.hireView)
    }
    @IBAction func CancelHire(_ sender: UIButton)
    {
        self.hireView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - SHOW USER SKILLS
    @objc func ShowUserSkill(_ sender: UIButton)
    {
        let user = self.recipientArr[sender.tag]
        vc.skillArr = user.skills
        if vc.skillArr.count > 0{
            let statVal: Double = 80
            let height = CGFloat((statVal * ceil((Double(vc.skillArr.count) / 2))))
            let skillMid = (height + 40) * 0.5
            vc.view.frame = CGRect(x: 0, y: self.view.frame.midY - (skillMid), width: (self.view.frame.width ), height: height + 40)
            vc.skillCl.reloadData()
            vc.removeBtn.addTarget(self, action: #selector(self.Remove(_:)), for: .touchUpInside)
            self.view.addSubview(vc.view)
            vc.view.center = self.view.center
        }
    }
    //MARK: - CLOSE USER SKILLS
    @objc func Remove(_ sender: UIButton)
    {
        vc.view.removeFromSuperview()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func DeleteConversation(){
        
        let alertController = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your Conversation?", preferredStyle: .alert)
        
        let sendButton = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.deleteConversation()
        })
        
        let  deleteButton = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            print("Delete button Cancel")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func handleGrowingTextView(){
        self.growingTextView.layer.cornerRadius = 15
        self.growingTextView.layer.borderWidth = 0.5
        self.growingTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.growingTextView.textView.textContainer.maximumNumberOfLines = 6
        self.growingTextView.textView.textContainerInset = UIEdgeInsets(top: 7, left: 0, bottom: 5, right: 0)
        self.growingTextView.placeholderLabel.attributedText = NSAttributedString(string: "Write here...",attributes: [NSAttributedString.Key.font: self.growingTextView.textView.font!, NSAttributedString.Key.foregroundColor: UIColor.gray
            ])
    }
    
    func deleteConversation(){
        let method = "messages/delete"
        var params = Dictionary<String,AnyObject>()
        params["conversation_ids"] = conversation_id as AnyObject
        if self.navigationController?.view != nil {
            Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
        } else {
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        }
        ALFWebService.sharedInstance.doPostData(parameters: params, method: method, success: { (response) in
            print(response)
            if self.navigationController?.view != nil {
                Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
            } else {
                Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            }
            let status = response["status_code"] as! Int
            if status == 204{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMessageDeleted"), object: nil)
//                if let con = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? ActivityFeedVC {
//
//                }
                self.navigationController?.popViewController(animated: true, completion: {
                    
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleted"), object: nil)
                })
            }
        }) { (response) in
            if self.navigationController?.view != nil {
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
            } else {
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            }
            
            
            print(response)
        }
    }
    //MARK: - CHECK NEW MESSAGES
    @objc func CheckNewMessage(){
        let methods = "messages/view/id/\(conversation_id!)"
        var params = Dictionary<String,AnyObject>()
        params["emoicons"] = 0 as AnyObject
        params["limit"] = 5 as AnyObject
        params["page"] = 1 as AnyObject
        if lastMxgId != nil{
        params["message_id"] = lastMxgId! as AnyObject
        }
        ALFWebService.sharedInstance.doGetData(parameters: params, method: methods, success: { (response) in
            print(response)
            if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject>{
                if let messages = body["messages"] as? [Dictionary<String,AnyObject>]{
                    var lastIndex : Int = 0
                    if self.messagesArray.count > 0{
                        lastIndex = self.messagesArray.count - 1
                    }
                    
                    for i in 0 ..< messages.count{
                        let mod = ChatDataModel.init(messages[i])
                        self.messagesArray.append(mod)
                        if i == messages.count - 1{
                            self.lastMxgId = mod.message["message_id"] as? Int
                        }
                    }
                    if messages.count < 2 {
                        do{
                        
                                self.tbl.beginUpdates()
                                let indexPath = IndexPath(row: self.messagesArray.count - 1, section: 0)
                                self.tbl.insertRows(at: [indexPath], with: .bottom)
                                self.tbl.endUpdates()
                                self.scrollToBottom()
                        
                        }catch{
                            
                        }
                    }else{
                        do{
                            
                                var indexPathsArray = [NSIndexPath]()
                                for index in lastIndex..<self.messagesArray.count - 1{
                                    let indexPath = NSIndexPath(row: index, section: 0)
                                    indexPathsArray.append(indexPath)
                                }
                                self.tbl.beginUpdates()
                                self.tbl.insertRows(at: indexPathsArray as [IndexPath], with: .bottom)
                                self.tbl.endUpdates()
                            
                        }catch{
                            
                        }
                    }
                    
                }
            }
        }) { (respnse) in
            
        }
    }

    
    func loadMessages(){
        
        let method = "messages/view/id/\(conversation_id!)"
        var params = Dictionary<String,AnyObject>()
        params["emoicons"] = 0 as AnyObject
        params["page"] = 1 as AnyObject
         Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            print(response)
            if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject>{
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                if let messages = body["messages"] as? [Dictionary<String,AnyObject>]{
                    self.messagesArray.removeAll()
                    for i in 0 ..< messages.count{
                        let mod = ChatDataModel.init(messages[i])
                        self.messagesArray.append(mod)
                        if i == messages.count - 1{
                            self.lastMxgId = mod.message["message_id"] as? Int
                        }
                        
                    }
                    if let conversation = body["conversation"] as? Dictionary<String,AnyObject>{
                        
                        if let canHire = conversation["canHire"] as? Bool{
                            if canHire{
                                self.hireBtn.isHidden = false
                            }else{
                                self.hireBtn.isHidden = true
                            }
                        }
                        if let id = conversation["job_id"] as? Int{
                            self.jobId = id
                        }
                        if let type = conversation["hire_type"] as? String{
                            self.hireType = type
                            if type == ""{
                                self.hireBtn.isHidden = true
                            }
                        }
                        if let receiver = conversation["receiver"] as? Dictionary<String,AnyObject>{
                            if let ph = receiver["phone"] as? Int{
                            self.phone = String(describing: receiver["phone"] as? Int)
                            }else{
                                let ph = receiver["phone"] as? String
                                if ph != nil{
                                self.phone = (ph?.replacingOccurrences(of: ".", with: ""))!
                                }
                            }
                        }
                    }
                    if let emoicons = body["emoicons"] as? [Dictionary<String,AnyObject>]{
                        for emo in emoicons{
                            let model = EmoModel.init(fromDictionary: emo)
                            self.emoArr.append(model)
                            
                        }
                        self.clView.reloadData()
                    }
                    self.tbl.reloadData()
                    let indexPath = IndexPath(row: self.messagesArray.count - 1, section: 0)
                    self.tbl.scrollToRow(at:indexPath , at: .top, animated: true)
                    DispatchQueue.main.async {
                        self.chatRepeater = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.CheckNewMessage), userInfo: nil, repeats: true)
                    }
                }
            }
            
        }) { (response) in
          Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
        
    }
    //MARK: - LOAD RECIPIENT
    @objc func LoadRecipient()
    {
        let method = "/messages/recipients/id/\(conversation_id!)"
        var dic = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    if let body =  response["body"] as? Dictionary<String,AnyObject>{
                        if let userList = body["response"] as? [Dictionary<String,AnyObject>]{
                            self.recipientArr.removeAll()
                            for user in userList{
                                let model =  User.init(fromDictionary: user)
                                self.recipientArr.append(model)
                            }
                        }
                    }
                    let count = (self.recipientArr.count * 67) + 28
                    if count > self.height{
                        self.recipientView.frame = CGRect(x: 10, y: 80, width: Int((self.view.frame.width) - 20), height: self.height)
                    }else{
                        self.recipientView.frame = CGRect(x: 10, y: 80, width: Int((self.view.frame.width) - 20), height: count)
                    }
                    self.recipientTbl.reloadData()
                }
            }
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    
    //MARK: - ONCLICK HIRE BUTTON
    @IBAction func HireBtn(_ sender: UIButton)
    {
        let refreshAlert = UIAlertController(title: "Hire", message: "Do you want to hire this Technician for this Job?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            let obj = self.recipientArr[sender.tag]
            var dic = Dictionary<String,AnyObject>()
            dic["user_id"]  = obj.userId as AnyObject
            dic["id"] = self.jobId as AnyObject
            dic["body"] = self.bodyTxt.text as AnyObject
            if self.btn1.tag == 1{
                dic["job_status"] = "hired" as AnyObject
            }else{
                dic["job_status"] = "" as AnyObject
            }
            let method = "/jobs/hire"
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                let status = response["status_code"] as? Int
                if status == 204
                {
                    self.hireBtn.isHidden = true
                    self.recipientArr.removeAll()
                    self.hireView.removeFromSuperview()
                    self.LoadRecipient()
                    
                }else{
                    let mxg = response["message"] as? String
                    Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        Utilities.doCustomAlertBorder(refreshAlert)
        present(refreshAlert, animated: true, completion: nil)
       
    }
    
    //MARK: - SET EMO VIEW HEIGHT
    @IBAction func SetEmoHeight(_ sender: UIButton)
    {
        
//        if emoViewHeight.constant == 0{
//            UIView.animate(withDuration: 0.25, animations: {
//                self.emoViewHeight.constant = 150
//
//            })
//        }else{
//            UIView.animate(withDuration: 0.25, animations: {
//                self.emoViewHeight.constant = 0
//
//            })
//        }
        self.attachTapped(sender: btnBarBadge!)
    }
    @objc func attachTapped(sender: UIBarButtonItem) {
        
        if attachmentAdded {
            if image_file != nil {
                Alertift.alert(title: "", message: "Already Attached Image")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        //                        self.btnBarBadge?.badgeValue = "0"
                        //                        self.tagBtn.setBadge(text: "")
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
                
            } else if music_id != nil {
                Alertift.alert(title: "", message: "Already Attached Music")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        //                        self.btnBarBadge?.badgeValue = "0"
                        self.btnBarBadge?.setBadge(text: "")
                        self.music_id = nil
                        self.attachmentAdded = false
                    })
                .show(on: self, completion: nil)
                
            }
            
            
        } else {
            self.handler.setAttatchmentMenu(con: self, suplimentryView: nil, senderr: sender, view: self.view, btnTyp: "barBtn")
            handler.delegate = self
        }
        
    }
    
    //MARK:- IBActions
    
    @IBAction func attachBtnClicked(_ sender: MIBadgeButton) {
        if attachmentAdded {
            if image_file != nil {
                Alertift.alert(title: "", message: "Already Attached Image")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        self.tagBtn.badgeValue = ""
                        sender.badgeValue = ""
                        self.btnBarBadge?.setBadge(text: "")
                        self.image_file = nil
                        self.attachmentAdded = false
                    })
                    .show(on: self, completion: nil)
            } else if url_file != nil {
                Alertift.alert(title: "", message: "Already Attached Link")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        sender.badgeValue = ""
                        self.btnBarBadge?.setBadge(text: "")
                        self.url_file = nil
                        self.attachmentAdded = false
                    })
                    .show(on: self, completion: nil)
                
            } else if video_id != nil {
                Alertift.alert(title: "", message: "Already Attached Video")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        sender.badgeValue = ""
                        self.btnBarBadge?.setBadge(text: "")
                        self.video_id = nil
                        self.attachmentAdded = false
                    })
                    .show(on: self, completion: nil)
                
            } else if music_id != nil {
                Alertift.alert(title: "", message: "Already Attached Music")
                    .action(.default("OK"))
                    .action(.cancel("Remove"), handler: {
                        sender.badgeValue = ""
                        self.btnBarBadge?.setBadge(text: "")
                        self.music_id = nil
                        self.attachmentAdded = false
                    })
                    .show(on: self, completion: nil)
            }
            
            
        } else {
            self.handler.setAttatchmentMenu(con: self, suplimentryView: nil, senderr: sender as AnyObject, view: self.view, btnTyp: "btn")
            handler.delegate = self
        }

    }
    @IBAction func handleSendButton(_ sender: UIButton) {
        sendBtn.tintColor = UIColor.lightGray
        sendBtn.isUserInteractionEnabled = false
        if self.chatRepeater != nil{
            self.chatRepeater.invalidate()
        }
        if sending == false{
            sending = true
        }else{
            sending = false
            self.showToast(message: "Request Already In Progress")
            return
        }
//        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        self.view.endEditing(true)
        print(growingTextView.textView.text)
        text = growingTextView.textView.text!
        let method = "messages/view/id/\(conversation_id!)"
        var params = Dictionary<String,AnyObject>()
        params["message_id"] = self.lastMxgId! as AnyObject
        print(attachmentAdded)
        if attachmentAdded == false{
            if growingTextView.textView.text == "" || growingTextView.textView.text == nil {
                Utilities.showAlertWithTitle(title: "", withMessage: "message is missing", withNavigation: self)
                return
            }

            let msg = ChatDataModel()
            msg.body = self.growingTextView.textView.text!
            msg.user_id = selfUserId
            msg.attachment_type = ""
            msg.image_icon = selfImage!
            let time = Utilities.timeAgoSinceDate(date: Date() as NSDate, numericDates: true)
            self.growingTextView.textView.text = ""
            msg.date = time
            
//            self.messagesArray.append(msg)
            
            
            
            
            params["body"] = text as AnyObject?
            
            DispatchQueue.global().async {
                ALFWebService.sharedInstance.doPostData(parameters: params, method: method, success: { (response) in
                    print(response)
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                    self.btnBarBadge?.setBadge(text: "")
                    self.sending = false
                    if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject>{
                        if let messages = body["messages"] as? [Dictionary<String,AnyObject>]{
                            for i in 0 ..< messages.count{
                                let mod = ChatDataModel.init(messages[i])
                                self.messagesArray.append(mod)
                                if i == messages.count - 1{
                                    self.lastMxgId = mod.message["message_id"] as? Int
                                }
                                UIView.setAnimationsEnabled(false)
                                self.tbl.beginUpdates()
                                self.tbl.insertRows(at: [IndexPath(row: self.messagesArray.count - 1, section: 0)], with: .fade)
                                self.tbl.endUpdates()
                                UIView.setAnimationsEnabled(true)
                                self.scrollToBottom()
                                self.sendBtn.tintColor = UIColor(hexString: "#FF6B00")
                                self.sendBtn.isUserInteractionEnabled = true
                                DispatchQueue.main.async {
                                    self.chatRepeater = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.CheckNewMessage), userInfo: nil, repeats: true)
                                }
                                
                            }
                        }
                    }
                    
                }) { (response) in
                    print(response)
                    self.sendBtn.tintColor = UIColor(hexString: "#FF6B00")
                    self.sendBtn.isUserInteractionEnabled = true
                    DispatchQueue.main.async {
                        
                        self.chatRepeater = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.CheckNewMessage), userInfo: nil, repeats: true)
                    }
                }
            }
        } else if attachmentAdded == true {
            attachmentAdded = false
            if image_file != nil {
                let msg = ChatDataModel()
                msg.body = self.growingTextView.textView.text!
                msg.user_id = selfUserId
                msg.attachment_type = "album_photo"
                var url: String?
                print(image_url!)
                
                url = image_url?.absoluteString
                msg.image = url!
                msg.image_icon = selfImage!
                msg.messageImg = self.image_file
                let time = Utilities.timeAgoSinceDate(date: Date() as NSDate, numericDates: true)
                
                msg.date = time
//                msg.i
//                self.messagesArray.append(msg)
                self.growingTextView.textView.text = ""
               
                params["post_attach"] = "1" as AnyObject
                params["type"] = "photo" as AnyObject
                params["body"] = text as AnyObject?
                
                print(params)
                let convertedDict: [String: String] = params.mapPairs { (key, value) in
                    (key, String(describing: value))
                }
                print(params)
                print(convertedDict)
                print(image_file!)
                DispatchQueue.global().async {
                    ALFWebService.sharedInstance.doPostDataWithImage(parameters: convertedDict as! [String : String], method: method, image: self.image_file, success: { (response) in
                        Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                        print(response)
                        self.image_file = nil
                        self.btnBarBadge?.setBadge(text: "")
                        self.sending = false
                        if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject>{
                            if let messages = body["messages"] as? [Dictionary<String,AnyObject>]{
                                for i in 0 ..< messages.count{
                                    let mod = ChatDataModel.init(messages[i])
                                    self.messagesArray.append(mod)
                                    if i == messages.count - 1{
                                        self.lastMxgId = mod.message["message_id"] as? Int
                                    }
                                    UIView.setAnimationsEnabled(false)
                                    self.tbl.beginUpdates()
                                    self.tbl.insertRows(at: [IndexPath(row: self.messagesArray.count - 1, section: 0)], with: .fade)
                                    self.tbl.endUpdates()
                                    UIView.setAnimationsEnabled(true)
                                    self.scrollToBottom()
                                    self.sendBtn.tintColor = UIColor(hexString: "#FF6B00")
                                    self.sendBtn.isUserInteractionEnabled = true
                                    DispatchQueue.main.async {
                                        self.chatRepeater = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.CheckNewMessage), userInfo: nil, repeats: true)
                                    }
                                    
                                }
                            }
                        }
                    }, fail: { (response) in
                        
                        self.image_file = nil
                        print(response)
                        self.sendBtn.tintColor = UIColor(hexString: "#FF6B00")
                        self.sendBtn.isUserInteractionEnabled = true
                        DispatchQueue.main.async {
                            self.chatRepeater = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.CheckNewMessage), userInfo: nil, repeats: true)
                        }
                    })
                }
                
            } else {
                
                if url_file != nil {
                    
                    let msg = ChatDataModel()
                    msg.body = self.growingTextView.textView.text!

                    msg.user_id = selfUserId
                    msg.attachment_type = "core_link"
                    msg.uri = url_file!
                    msg.image_icon = selfImage!
//                    let str = Utilities.stringFromDate(Date())
//                    
//                    let date = Utilities.dateFromString(str)
                    let time = Utilities.timeAgoSinceDate(date: Date() as NSDate, numericDates: true)
                    
                    msg.date = time
                    //                msg.i
//                    self.messagesArray.append(msg)
                    self.growingTextView.textView.text = ""
                    
                    
                    params["uri"] = url_file as AnyObject
                    params["post_attach"] = "1" as AnyObject
                    params["type"] = "link" as AnyObject
                    
                    params["body"] = text as AnyObject?
                    self.shouldLoad = false
                    url_file = nil
                }
                else if video_id != nil {
                    
                    let msg = ChatDataModel()
                    msg.body = growingTextView.textView.text!
                    
                    
                    msg.user_id = selfUserId
                    msg.attachment_type = "video"
                    
                    msg.uri = self.video_url!
                    msg.image_icon = selfImage!
                    msg.image = self.imageStr
//                    let str = Utilities.stringFromDate(Date())
//                    
//                    let date = Utilities.dateFromString(str)
                    let time = Utilities.timeAgoSinceDate(date: Date() as NSDate, numericDates: true)
                    
                    msg.date = time
                    msg.messageImg = pickedThumnail
                    
//                    self.messagesArray.append(msg)
                    self.growingTextView.textView.text = ""
                    
                    
                    params["video_id"] = video_id as AnyObject
                    params["post_attach"] = "1" as AnyObject
                    params["type"] = "video" as AnyObject
                    print(params)
                    
                   
                    params["body"] = text as AnyObject?
                    
                    video_id = nil
                    self.shouldLoad = true
                    Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
                    
                }
                else if  music_id != nil {
                    
                    let msg = ChatDataModel()
                    msg.body = growingTextView.textView.text!
                    
                    
                    msg.user_id = selfUserId
                    msg.attachment_type = "music_playlist_song"
                    
                    msg.image_icon = selfImage!
//                    let str = Utilities.stringFromDate(Date())
//                    
//                    let date = Utilities.dateFromString(str)
                    let time = Utilities.timeAgoSinceDate(date: Date() as NSDate, numericDates: true)
                    
                    msg.date = time
            
//                    self.messagesArray.append(msg)
                    self.growingTextView.textView.text = ""
                    
                    
                    params["song_id"] = music_id! as AnyObject
                    params["post_attach"] = "1" as AnyObject
                    params["type"] = "music" as AnyObject
                    
                    params["body"] = text as AnyObject?
                    
                    music_id = nil
                    self.shouldLoad = true
                    
                Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
                    
                }
           
                self.btnBarBadge?.setBadge(text: "")
//                self.attachBottomBtn.badgeValue = ""
                let _: [String: String] = params.mapPairs { (key, value) in
                    (key, String(describing: value))
                }
                print(params)
                print(method)
                DispatchQueue.global().async {
                
                    ALFWebService.sharedInstance.doPostData(parameters: params, method: method, success: { (response) in
                        print(response)
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.sending = false
                        if let status_code = response["status_code"] as? Int {
                            
                            if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject>{
                                if let messages = body["messages"] as? [Dictionary<String,AnyObject>]{
                                    for i in 0 ..< messages.count{
                                        let mod = ChatDataModel.init(messages[i])
                                        self.messagesArray.append(mod)
                                        if i == messages.count - 1{
                                            self.lastMxgId = mod.message["message_id"] as? Int
                                        }
                                        UIView.setAnimationsEnabled(false)
                                        self.tbl.beginUpdates()
                                        self.tbl.insertRows(at: [IndexPath(row: self.messagesArray.count - 1, section: 0)], with: .fade)
                                        self.tbl.endUpdates()
                                        UIView.setAnimationsEnabled(true)
                                        self.scrollToBottom()
                                        self.sendBtn.tintColor = UIColor(hexString: "#FF6B00")
                                        self.sendBtn.isUserInteractionEnabled = true
                                        DispatchQueue.main.async {
                                            self.chatRepeater = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.CheckNewMessage), userInfo: nil, repeats: true)
                                        }
                                        
                                    }
                                }
                            }
                            if status_code == 200 {
                                if self.shouldLoad {
//                                   self.loadMessages()
                                }
                            } else {
                            }
                        }
                    }) { (response) in
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.sendBtn.tintColor = UIColor(hexString: "#FF6B00")
                        self.sendBtn.isUserInteractionEnabled = true
                        DispatchQueue.main.async {
                            self.chatRepeater = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.CheckNewMessage), userInfo: nil, repeats: true)
                        }
                        print(response)
                    }
                }
                
                
            }
        }

    }
    
    
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                self.inputContainerViewBottom.constant =  0
                //textViewBottomConstraint.constant = keyboardHeight
                if self.profileView.constant == 0{
                    self.profileView.constant = 77
                }else{
                    self.profileView.constant = 0
                }
                UIView.animate(withDuration: 0.5, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    

    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.inputContainerViewBottom.constant = keyboardHeight - 45
                if self.profileView.constant == 0{
                    self.profileView.constant = 77
                }else{
                self.profileView.constant = 0
                }
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    self.scrollToBottom()
                })
            }
        }
    }
    
    func scrollToBottom(){
        if self.messagesArray.count > 0{
         
            self.tbl.scrollToRow(at: IndexPath.init(row: self.messagesArray.count - 1, section: 0), at: .top, animated: true)
        }
    }

    //MARK: - TABLE VIEW DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recipientTbl{
            return recipientArr.count
        }
        return messagesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recipientTbl{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllMessageCell", for: indexPath as IndexPath) as! AllMessageCell
            
            // Configure the cell...
            let obj = recipientArr[indexPath.row]
            cell.userimage.sd_setImage(with: URL(string: obj.image))
//            cell.detail.textColor = UIColor.white
            if obj.businessName != nil{
            cell.name.text = obj.businessName!
            }else{
              cell.name.text = ""
            }
            cell.hireBtn.tag = indexPath.row
            cell.hireBtn.addTarget(self, action: #selector(self.ShowHireModel(_:)), for: .touchUpInside)
            if obj.canHire && obj.hireType != ""{
                hireCount = hireCount + 1
                cell.hireBtn.isHidden = false
            }else{
                cell.hireBtn.isHidden = true
            }
            cell.detail.text = obj.displayname
            if obj.skills.count > 0{
                if (obj.skills.count) > 1{
                    cell.created_at.text = "Skills: \(obj.skills[0].categoryName!) +\((obj.skills.count) - 1)"
                }else{
               cell.created_at.text = obj.skills[0].categoryName!
                }
            }else{
               cell.created_at.text = ""
            }
            cell.userBtn.tag = indexPath.row
            cell.userBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
            return cell
            
        }else{
            
        let message = messagesArray[indexPath.row]
        var cellIdentifier = "ChatMessageCell"
        if message.user_id != self.selfUserId{
            if message.attachment_type == "album_photo" || message.attachment_type == "video"{
                cellIdentifier = "ChatImageMessage"
            }else if message.attachment_type == "music_playlist_song"{
                cellIdentifier = "MusicCell"
            }else if message.attachment_type == "core_link"{
                cellIdentifier = "linkCell"
            }else{
                cellIdentifier = "ChatMessageCell"
            }
        }else{
            
            if message.attachment_type == "album_photo" || message.attachment_type == "video"{
                cellIdentifier = "ChatImageMessageUser"
            }else if message.attachment_type == "music_playlist_song"{
                cellIdentifier = "MusicCellUser"
            }else if message.attachment_type == "core_link" {
                cellIdentifier = "linkCellUser"
            }else{
                cellIdentifier = "ChatMessageCellUser"
            }
        }
         let cell = tableView.dequeueReusableCell(withIdentifier:cellIdentifier) as! ChatCell
        cell.configure(message: message)
        cell.delegate = self
        cell.tag = indexPath.row
//            if cell.backView != nil{
//                if cell.reuseIdentifier == "ChatMessageCell"{
//                    let maskPath = UIBezierPath(roundedRect: cell.backView.bounds,
//                                                byRoundingCorners: [.topLeft, .topRight, .bottomRight],
//                                                cornerRadii: CGSize(width: 18.0, height: 0.0))
//
//                    let maskLayer = CAShapeLayer()
//                    maskLayer.path = maskPath.cgPath
//                    cell.backView.layer.mask = maskLayer
//                }else{
//                    let maskPath = UIBezierPath(roundedRect: cell.backView.bounds,
//                                                byRoundingCorners: [.topLeft, .topRight, .bottomLeft],
//                                                cornerRadii: CGSize(width: 18.0, height: 0.0))
//                    let maskLayer = CAShapeLayer()
//                    maskLayer.path = maskPath.cgPath
//                    cell.backView.layer.mask = maskLayer
//                }
//
//            }
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
        return cell
        }
    
    }
   

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recipientTbl{
            let obj = recipientArr[indexPath.row]
            let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
            vc.id = obj.userId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didPickedImage(image: UIImage, url: URL) {
//        self.btnBarBadge?.badgeValue = "1"
        self.btnBarBadge?.setBadge(text: "1")
//        self.attachBottomBtn.badgeValue = "1"
        print(image)
        image_file = image
      
        image_url = url
        print(url)
        
        attachmentAdded = true
    }
    func didGotLink(url: String) {
//        self.btnBarBadge?.badgeValue = "1"
        if !Utilities.isValidUrl(userURL: url) {
            Utilities.showAlertWithTitle(title: "", withMessage: "Please enter a valid url with 'https://' or 'http://'..!", withNavigation: self)
            return
        }
        self.btnBarBadge?.setBadge(text: "1")
//        self.attachBottomBtn.badgeValue = "1"
        print(url)
        self.url_file = url
        self.attachmentAdded = true
    }

    func didPickedMusicId(id: String) {
//        self.btnBarBadge?.badgeValue = "1"
        self.btnBarBadge?.setBadge(text: "1")
//        self.attachBottomBtn.badgeValue = "1"
        music_id = id
        self.attachmentAdded = true
    }
    func didPickedVideo(id: Int, url: String, imageStr: String) {
        self.btnBarBadge?.setBadge(text: "1")
//        self.attachBottomBtn.badgeValue = "1"
        self.attachmentAdded = true
        self.video_id = String(describing: id)
        self.video_url = url
        self.imageStr = imageStr
        print(id)
        print(url)
    }
    
    func didPickedVideoFromDevice(url: URL) {
        
        self.videoFrmDeviceURL = url
        
        self.btnBarBadge?.setBadge(text: "1")
//        self.attachBottomBtn.badgeValue = "1"
        self.attachmentAdded = true
    }
    func didPressedPlayOrImage(tag: Int) {
        let message = messagesArray[tag]
        
        if message.attachment_type == "album_photo"{
            
            var images = [FSBasicImage]()

            let imgs = FSBasicImage(imageURL: URL(string:message.image)!, name: "")
            images.append(imgs)
            
            let source = FSBasicImageSource(images: images)
            let con = FSImageViewerViewController(imageSource: source)
            con.backgroundColorVisible = UIColor.black
            self.navigationController?.pushViewController(con, animated: true)
        }else if message.attachment_type == "video"{
            let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .webVC) as! WebViewViewController
            con.urlString = message.attachment["code"] as! String
            con.type = "html"
            
            self.navigationController?.pushViewController(con, animated: true)
        }
  
    }
    
    func didPressedLink(tag: Int) {
        
        let message = messagesArray[tag]
        
        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .webVC) as! WebViewViewController
        con.urlString = message.uri
        self.navigationController?.pushViewController(con, animated: true)

    }
    //MARK: - EMOICON COLLECTION VIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = self.emoArr[indexPath.row]
//        if growingTextView.text! == "Write here..."{
//            growingTextView.text = ""
//        }
//        growingTextView.text = model.symbol!
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clView{
            return emoArr.count
        }
        return selectedImagesArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.clView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emoCell", for: indexPath) as! EmoCVCell
            let model = self.emoArr[indexPath.row]
            cell.emoImg.sd_setImage(with: URL(string: model.icon))
            cell.emoBtn.tag = indexPath.row
            cell.emoBtn.addTarget(self, action: #selector(self.OnclickBackBtn(_:)), for: .touchUpInside)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! EmoCVCell
        let img = selectedImagesArr[indexPath.row]
        
        cell.configCell(img: img)
        cell.tag = indexPath.row
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.clView{
            return CGSize(width: 40, height: 40)
        }
        return CGSize(width: 220, height: 220)
    }
    // ON SELECT EMO ICON
    @objc func OnclickBackBtn(_ sender: UIButton)
    {
        if self.growingTextView.placeholderLabel.attributedText?.string == "Write here..."{
            self.growingTextView.placeholderLabel.attributedText = NSAttributedString(string: "",attributes: [NSAttributedString.Key.font: self.growingTextView.textView.font!, NSAttributedString.Key.foregroundColor: UIColor.gray
                ])
        }
        let model = self.emoArr[sender.tag]
        let strss = "\(growingTextView.textView.text!)\(model.symbol!)"
        self.selfText = "\(growingTextView.textView.text!)\(model.icon!)"
        let str = strss
        let attStr2 = AttStr(str)
        attStr2.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.gray], range:NSRangeFromString(str))
        attStr2.select(.all).link().color(UIColor.black).font(UIFont.systemFont(ofSize: 15))
        attStr2.select(.url).link()
        attStr2.select(.hashTag).link()
        self.growingTextView.textView.attributedText = attStr2
    }
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0 , y: 0, width: 230, height: 35))
        toastLabel.center = self.view.center
        toastLabel.backgroundColor = UIColor(hexString: "#FF6B02")
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    @IBAction func AddRecipient(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .composeMessageVC) as! ComposeMessageVC
        vc.suggestType = SuggestType.Recipient
        vc.userId = self.conversation_id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ShowRecipient(_ sender: UIButton)
    {
        self.view.addSubview(recipientView)
        self.recipientTbl.reloadData()
    }
    @IBAction func RemoveRecipient(_ sender: UIButton)
    {
        recipientView.removeFromSuperview()
    }
  
}

