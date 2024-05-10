//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import JSQMessagesViewController
import Alamofire
import AlamofireImage
import Photos
import BSImagePicker
import ActionSheetPicker_3_0

class ChatViewController: JSQMessagesViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var messages = [JSQMessage]()
    var messageCount = 0
    var conversation_id: String!
    var senderImageUrl : String!
//      let meImage = #imageLiteral(resourceName: "profile")
    let meImage = UserDefaults.standard.value(forKey: "image")
    let id = String(describing: UserDefaults.standard.value(forKey: "id")!)
    
    var timer : Timer!
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var meImageView: JSQMessagesAvatarImage!
    var senderImageView: JSQMessagesAvatarImage!
    
    var video_id: String?
    var song_id: String?
    var image_file: UIImage?
    var url_file: String?
    var video_url: String?
    
    
//    @IBOutlet var attachVideoAlertView: WAView!
//    @IBOutlet weak var videoTypeBtn: WAButton!
//    @IBOutlet weak var videoUrl: WATextField!
//    @IBOutlet weak var chooseVideoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupBackButton()
        self.title = self.senderDisplayName
        
        
        
//        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
//        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
        
//        print("\(senderImageUrl!) and \(meImage)")
       
        findImages()
    }
   

    func findImages(){
        if senderImageUrl != nil{
            
            AF.request(senderImageUrl!).responseImage { response in
                debugPrint(response)
            
                debugPrint(response.result)
                
                if let image = response.value {
                    print("image downloaded: \(image)")
                    self.senderImageView =  JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
                }
            }
            
        }
        print(meImage!)
        AF.request((meImage as? String)!).responseImage { response in
            debugPrint(response)
            
            debugPrint(response.result)
            
            if let image = response.value {
                print("image downloaded: \(image)")
                self.meImageView =  JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
            }
        }

    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.timer.invalidate()
    }
    
    func loadMessages(){
        print(conversation_id as Any)
        let method = "messages/view/id/\(conversation_id!)"
        print(method)
        let params = Dictionary<String,AnyObject>()
//        print(self.senderId)
//        params["conversation_id"] = conversation_id as AnyObject
        
//        LilithProgressHUD.showOnView(view: (self.navigationController?.view)!)
       
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            
            print(response)
            self.messages.removeAll()
            if let body = response["body"] as? Dictionary<String,AnyObject>{
                
                if let messages1 = body["messages"] as? [Dictionary<String,AnyObject>]{
                    var date: String?
                    var bodyText: String?
                    var userID: String?
                    var name: String?
                    var sender_image: String?
                    var attached_image: String?
                    
                    for dic in messages1{
                        if let message = dic["message"] as? Dictionary<String,AnyObject> {
                            date = message["date"] as? String
                            bodyText = message["body"] as? String
                            userID = String(describing: message["user_id"]!)
                            
                        }
                        if let send = dic["sender"] as? Dictionary<String,AnyObject> {
                            name = send["displayname"] as? String
                            sender_image = send["image_profile"] as? String
                        }
                        if let attachment = dic["attachment"] as? Dictionary<String,AnyObject> {
                            
                            attached_image = attachment["image_profile"] as? String
                        }
                        print(userID!)
                        if attached_image != nil {
                            let url = URL(string: attached_image!)
                            var data: Data?
                            do {
                              data = try Data(contentsOf: url!)
                            } catch {
                                print(error.localizedDescription)
                            }
                            let image = UIImage(data: data!)
                            self.addMessageWithImage(withId: userID!, name: name!, text: bodyText!, date: date!, image: image!)
                        } else {
                            self.addMessage(withId: userID!, name: name!, text: bodyText!, date: date!)
                        }
                        
                    }
                    
                    if self.senderImageView == nil{

                        AF.request(sender_image!).responseImage { response in
                            debugPrint(response)
                            
                            debugPrint(response.result)
                            
                            if let image = response.value {
                                print("image downloaded: \(image)")
                                self.senderImageView =  JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
                            }
                        }

                    }
                    
                    if self.messages.count > self.messageCount{
                        self.finishReceivingMessage()
                        self.messageCount = self.messages.count
                    }
                    
                }

            }
            
        }) { (response) in
            
            
            print(response)
        }
        
    }
    
    
    private func addMessage(withId id: String, name: String, text: String, date: String) {
        
        
        //2017-03-07 14:42:00
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let dataDate = dateFormatter.date(from: date)!
        
        print(dataDate)
        
        if let message = JSQMessage(senderId: id, senderDisplayName: name , date: dataDate as Date?, text: text) {
            messages.append(message)
            print(messages)
        }
    }
    
    private func addMessageWithImage(withId id: String, name: String, text: String, date: String, image: UIImage) {
        //2017-03-07 14:42:00
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let dataDate = dateFormatter.date(from: date)!
        
        print(dataDate)
        
        let mediaItem = JSQPhotoMediaItem(image: nil)
        mediaItem?.appliesMediaViewMaskAsOutgoing = true
        mediaItem?.image = UIImage(data: image.jpegData(compressionQuality: 0.5)!)
        if let sendMessage = JSQMessage(senderId: id, displayName: senderDisplayName, media: mediaItem) {
//            sendMessage.text = text
            messages.append(sendMessage)
        }

//        if let message = JSQMessage(senderId: id, senderDisplayName: name , date: dataDate as Date!, text: text) {
//            messages.append(message)
//            print(messages)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
//        // messages from someone else
//        addMessage(withId: "foo", name: "Mr.Bolt", text: "I am so fast!")
//        // messages sent from local sender
//        addMessage(withId: senderId, name: "Me", text: "I bet I can run faster than you!")
//        addMessage(withId: senderId, name: "Me", text: "I like to run!")
//        // animates the receiving of a new message on the view
//        finishReceivingMessage()
        
//        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.loadMessages), userInfo: nil, repeats: true)
        
                self.loadMessages()

    }

    func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
//        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.red)
    }

    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
//        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor(hexString: "#75d71e"))
    }
    
    
    private func setupSenderImage() -> JSQMessagesAvatarImage {
       
        return JSQMessagesAvatarImageFactory.avatarImage(with: #imageLiteral(resourceName: "chat"), diameter: 30)
    }
    
    private func setupRecieverImage() -> JSQMessagesAvatarImage {
       return JSQMessagesAvatarImageFactory.avatarImage(with: #imageLiteral(resourceName: "chat"), diameter: 30)
    }

    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId {
            // 2
            if senderImageView != nil{
             return senderImageView
            }
            return nil
        } else { // 3
            if meImageView != nil{
                
                return meImageView
            }
            return nil
        }
        
//        return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "Tausif", backgroundColor: .blue, textColor: .red, font: UIFont.systemFont(ofSize: 5), diameter: 10)
//        return JSQMessagesAvatarImageFactory.avatarImage(with: #imageLiteral(resourceName: "chat"), diameter: 30)

    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        // Displaying names above messages
        //Mark: Removing Sender Display Name
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         */
        
//        if messages.senderId == self.senderId() {
//            return nil
//        }
//        
//        return NSAttributedString(string: messages.senderDisplayName)
//        
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId {
        } else {
        }
        print(message.senderDisplayName)
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
//        if (indexPath.item % 3 == 0) {
//            let message = self.messages[indexPath.item]
//            print(message.date)
//            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
//        }
        
        let message = self.messages[indexPath.item]
        print(message.date)
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
//        if indexPath.item % 3 == 0 {
//            return kJSQMessagesCollectionViewCellLabelHeightDefault
//        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
//        return kJSQMessagesCollectionViewCellLabelHeightDefault;
        return 0
    }

   
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        
        print(messages)
        print(message.senderId!)
        print(id)
        
        if message.senderId! == id { // 2
            return incomingBubbleImageView
        } else { // 3
            return outgoingBubbleImageView
        }
    }
    
    
    
//    override func didPressAccessoryButton(_ sender: UIButton!) {
//        self.view.endEditing(true)
//        Alertift.actionSheet(title: "", message: "")
//            .action(.default("Attach Image")) {
//                let vc = BSImagePickerViewController()
//                
//                vc.takePhotos = true
//                vc.maxNumberOfSelections = 1
//                
//                self.bs_presentImagePickerController(vc, animated: true, select: { (asset: PHAsset) -> Void in
//                }, deselect: { (asset: PHAsset) -> Void in
//                    
//                }, cancel: { (assets: [PHAsset]) -> Void in
//                    // User cancelled. And thmessageTxtis where the assets currently selected.
//                }, finish: { (assets: [PHAsset]) -> Void in
//                    
//                    let image = Utilities.getAssetThumbnail(asset: assets[0])
//                    print(image)
//                    
//                    self.image_file = image
//                    Utilities.showAlertWithTitle(title: "Success", withMessage: "Successfully attached!", withNavigation: self)
////                    self.imagePicked(image: image)
//                    
//                }, completion: nil)
//            }
//            .action(.default("Attach Link")) {
//                Alertift.alert(title: "Attach Link", message: "Enter url:")
//                    .textField { textField in
//                        textField.placeholder = "Enter URL"
//                    }
//                    .action(.cancel("Cancel"))
//                    .action(.default("Done"), textFieldsHandler: { textFields in
//                        let url = textFields?.first?.text ?? ""
//                        if url.isEmpty {
//                            Alertift.alert(title: "Error", message: "Please enter url:")
//                                .action(.cancel("Dismiss"))
//                                .show()
//                        } else {
//                            if Utilities.isValidUrl(userURL: url) {
//                                Utilities.showAlertWithTitle(title: "Success", withMessage: "Successfully attached!", withNavigation: self)
//                                self.url_file = url
//                            } else {
//                                Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Url is not Valid. Please Enter a valid url!", withNavigation: self)
//                                return
//                            }
//                            
////                            self.urlPicked(url: url)
//                            
//                        }
//                    })
//                    .show(on: self, completion: nil)
//            }
//            .action(.default("Attach Video")) {
////                let view = UINib(nibName: "", bundle: nil)
////                let view = VideoAttachAlertView.init(frame: CGRect(x: 0, y: 120, width: self.view.frame.width - 30, height: 140))
////                print(view)
////                self.view.addSubview(self.attachVideoAlertView)
//                
//            }
//            .action(.default("Attach Music")) {
////                let vc = MediaPickVC()
////                vc.delegate = self
////                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            .action(.cancel("Cancel")) {
//                
//            }
//            .show(on: self, completion: nil)
//        
//
//    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(senderId!)
        
        if self.image_file != nil{
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem?.appliesMediaViewMaskAsOutgoing = true
            
            mediaItem?.image = UIImage(data: self.image_file!.jpegData(compressionQuality: 0.5)!)
            let sendMessage = JSQMessage(senderId: id, displayName: senderDisplayName, media: mediaItem)
            
            print(messages)
            //        messages.append(md)
            messages.append(sendMessage!)
            finishSendingMessage()
        } else {
            let md : JSQMessage = JSQMessage(senderId: id, displayName: senderDisplayName, text: text)
            print(md)
            messages.append(md)
            finishSendingMessage()
        }
        
        
        let method = "messages/view/id/\(conversation_id!)"
        var params = Dictionary<String,AnyObject>()

        if image_file != nil {
            params["post_attach"] = "1" as AnyObject
            params["type"] = "photo" as AnyObject
            if text == nil || text.isEmpty {
                params["body"] = "" as AnyObject?
            } else {
                params["body"] = text as AnyObject?
            }
            print(params)
//            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            
            ALFWebService.sharedInstance.doPostDataWithImage(parameters: params as! [String : String], method: method, image: image_file, success: { (response) in
                print(response)
//                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            }, fail: { (response) in
//                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
            })
        } else {
            
            if url_file != nil {
                params["uri"] = url_file as AnyObject
                params["post_attach"] = "1" as AnyObject
                params["type"] = "link" as AnyObject
                if text == nil || text.isEmpty {
                    params["body"] = "" as AnyObject?
                } else {
                    params["body"] = text as AnyObject?
                }

            } else if video_id != nil {
                
                params["video_id"] = video_id as AnyObject
                params["post_attach"] = "1" as AnyObject
                params["type"] = "video" as AnyObject
                if text == nil || text.isEmpty {
                    params["body"] = "" as AnyObject?
                } else {
                    params["body"] = text as AnyObject?
                }

            } else if  song_id != nil {
                
                params["song_id"] = song_id as AnyObject
                params["post_attach"] = "1" as AnyObject
                params["type"] = "music" as AnyObject
                if text == nil || text.isEmpty {
                    params["body"] = "" as AnyObject?
                } else {
                    params["body"] = text as AnyObject?
                }
                
            } else {
                params["body"] = text as AnyObject?
            }
             print(params)
//            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: params, method: method, success: { (response) in
                print(response)
//                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            }) { (response) in
                print(response)
//                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            }
            
        }

//
//        ALFWebService.sharedInstance.doPostData(parameters: params, method: method, success: { (response) in
//            print(response)
//        }) { (response) in
//            print(response)
//        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        attachVideoAlertView.removeFromSuperview()
//        
//        let videoUrl = info[UIImagePickerControllerMediaURL]as! URL
//        print(videoUrl)
//        
//        //        videoUrl.lastPathComponent as AnyObject
//        var params = Dictionary<String, AnyObject>()
//        
//        params["post_attach"] = "1" as AnyObject
//        params["type"] = 3 as AnyObject
//        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
//        
//        AFNWebService.sharedInstance.doPostDataWithMedia(parameters: params, method: "videos/create", media: videoUrl, name: "filedata", success: { (response) in
//            print(response)
//            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
//            if let status_code = response["status_code"] as? Int {
//                if status_code == 200 {
//                    if let body = response["body"] as? Dictionary<String,AnyObject> {
//                        if let response = body["response"] as? Dictionary<String,AnyObject> {
//                            print(response["video_id"]!)
//                            self.video_id = String(describing: response["video_id"]!)
//                            Utilities.showAlertWithTitle(title: "Success", withMessage: "", withNavigation: self)
//                        }
//                    }
//                } else {
//                    Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Error Occured, Try Again", withNavigation: self)
//                }
//            }
//            
//        }, fail: { (response) in
//            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
//            print(response)
//            
//        })
//        
//        self.dismiss(animated: true, completion: nil)
//    }
    
    // MARK:- IBActions
//    @IBAction func videoAlertOkBtnClicked(_ sender: Any) {
//        video_url = videoUrl.text
//        attachVideoAlertView.removeFromSuperview()
//        let url = URL(string: video_url!)
//        
//        var params = Dictionary<String, AnyObject>()
//        
//        params["post_attach"] = "1" as AnyObject
//        params["url"] = video_url as AnyObject
//        if videoTypeBtn.currentTitle == "youtube" {
//            params["type"] = 1 as AnyObject
//        } else if videoTypeBtn.currentTitle == "vimeo" {
//            params["type"] = 2 as AnyObject
//        }
//        
//        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
//        print(params)
//        
//        ALFWebService.sharedInstance.doPostData(parameters: params, method: "videos/create", success: { (response) in
//            print(response)
//            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
//            if let status_code = response["status_code"] as? Int {
//                if status_code == 200 {
//                    if let body = response["body"] as? Dictionary<String,AnyObject> {
//                        if let response = body["response"] as? Dictionary<String,AnyObject> {
//                            print(response["video_id"]!)
//                            self.video_id = String(describing: response["video_id"]!)
//                            Utilities.showAlertWithTitle(title: "Success", withMessage: "", withNavigation: self)
//                        }
//                    }
//                } else {
//                    Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Error Occured, Try Again", withNavigation: self)
//                }
//            }
//            
//        }, fail: { (response) in
//            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
//            print(response)
//            
//        })
//        
//    }
//    
//    @IBAction func videoAlertCancelBtnClicked(_ sender: Any) {
//        
//        attachVideoAlertView.removeFromSuperview()
//    }
//    
//    @IBAction func videoTypeBtnClicked(_ sender: Any) {
//        
//        let videoTypes = ["youtube", "viemo", "My Device"]
//        
//        ActionSheetStringPicker.show(withTitle: "--- Select Video Type ---", rows: videoTypes , initialSelection: 0, doneBlock: {picker, values, indexes in
//            self.videoTypeBtn.setTitle(videoTypes[values], for: .normal)
//            if self.videoTypeBtn.currentTitle == "My Device" {
//                self.chooseVideoBtn.isHidden = false
//                self.videoUrl.isHidden = true
//            } else {
//                self.chooseVideoBtn.isHidden = true
//                self.videoUrl.isHidden = false
//            }
//        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
//        
//    }
    
   
    
//    @IBAction func chooseVideoBtnClicked(_ sender: Any) {
//        
//        
//        Alertift.actionSheet(title: "", message: "Select Source")
//            .action(.default("Open Gallery")) {
//                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//                    print("captureVideoPressed and camera available.")
//                    
//                    let imagePicker = UIImagePickerController()
//                    
//                    imagePicker.delegate = self
//                    imagePicker.sourceType = .photoLibrary
////                        imagePicker.mediaTypes = kutype
//                    imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//                    
//                    
//                    self.present(imagePicker, animated: true, completion: nil)
//                } else {
//                    print("Camera not available.")
//                }
//            }
//            .action(.cancel("Cancel")) {
//                
//            }
//            .show(on: self, completion: nil)
//        
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
//        let message = messages[indexPath.item]
//        
//        if message.senderId == senderId {
//            cell.textView?.textColor = UIColor.white
//        } else {
//            cell.textView?.textColor = UIColor.black
//        }
//        return cell
//    }
//    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
