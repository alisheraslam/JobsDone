//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
//import FTIndicator


class ChatTableViewController: FTChatMessageTableViewController{

    
    var messagesCount = 0
    var sender : FTChatMessageUserModel!
    var me : FTChatMessageUserModel!
    var user_id = Int()
    var displayName = String()
    let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
    
//    let sender1 = FTChatMessageUserModel.init(id: "1", name: "Someone", icon_url: "http://ww3.sinaimg.cn/mw600/6cca1403jw1f3lrknzxczj20gj0g0t96.jpg", extra_data: nil, isSelf: false)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.inputView?.isUserInteractionEnabled = true
        self.inputView?.inputView?.isUserInteractionEnabled = true
        let but = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        self.navigationItem.leftBarButtonItem = but
        
        self.title = displayName
        appDelegate.chatRepeater.invalidate()
        appDelegate.dic["fresh"] = 1 as AnyObject
        appDelegate.isChat = true
        appDelegate.timeInterval = 5
        appDelegate.active()
        //        self.loadDefaultMessages()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadDefaultMessages(notification:)), name:NSNotification.Name(rawValue:"chatActivate"), object: nil)
        appDelegate.isChat = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.isChat = false
    }
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        messageAccessoryView.setupWithDataSource(self , accessoryViewDelegate : self)
        loadMessages()
    }

    //MARK: - addNewIncomingMessage

    @objc func loadDefaultMessages(notification:NSNotification)  {

        print(notification.object!)
        
        if let myDict = notification.object as? Dictionary<String,AnyObject> {
            if let users = myDict["users"] as?  [Dictionary<String,AnyObject>]{
                
                for user in users{
                    if user_id == user["user_id"] as! Int{
                        
                        sender = FTChatMessageUserModel.init(id: String(user_id), name: user["title"] as? String, icon_url: user["image_icon"] as? String, extra_data: nil, isSelf: false)
                        let defauls = UserDefaults.standard
                        
                        let id = defauls.value(forKey: "id") as! Int
                        me = FTChatMessageUserModel.init(id: String(id), name: defauls.value(forKey: "displayname") as? String, icon_url: defauls.value(forKey: "image") as? String, extra_data: nil, isSelf: true)
                        
                        if let messages = user["messages"] as?  [Dictionary<String,AnyObject>]{
                            
                            chatMessageDataArray.removeAll()
                            var msgs = [FTChatMessageModel]()
                            for mess in messages{
                                
                                var sMessage : FTChatMessageModel!
                                print(mess)
                                
                                if mess["sender_id"] as! Int == defauls.value(forKey: "id") as! Int{
                                    let dateStamp = Utilities.dateFromString(mess["date"] as! String)
                                    let timeStamp = Utilities.timeAgoSinceDateForChat(date: dateStamp, numericDates: true)

                                    sMessage = FTChatMessageModel.init(data: mess["body"] as? String, time: timeStamp, from: me, type: FTChatMessageType.text)

                                }else{
                                    let dateStamp = Utilities.dateFromString(mess["date"] as! String)
                                    let timeStamp = Utilities.timeAgoSinceDateForChat(date: dateStamp, numericDates: true)

                                    sMessage = FTChatMessageModel.init(data: mess["body"] as? String, time: timeStamp, from: sender, type: FTChatMessageType.text)
                                    
                                }
                                
                                msgs.append(sMessage)
                            }
                            chatMessageDataArray = msgs
//                            self.messageTableView.reloadData()
                            self.origanizeAndReload()
                            if messagesCount < chatMessageDataArray.count{
                                
                                self.scrollToBottom(true)
                                messagesCount = chatMessageDataArray.count
                                
                            }else{
                                
                                messagesCount = chatMessageDataArray.count
                                
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    func loadMessages(){
        let method = "chat"
        var dic = Dictionary<String,AnyObject>()
        dic["status"] = 1 as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
            if let users = response["users"] as?  [Dictionary<String,AnyObject>]{
                
                for user in users{
                    if self.user_id == user["user_id"] as! Int{
                        
                        self.sender = FTChatMessageUserModel.init(id: String(self.user_id), name: user["title"] as? String, icon_url: user["image_icon"] as? String, extra_data: nil, isSelf: false)
                        let defauls = UserDefaults.standard
                        
                        let id = defauls.value(forKey: "id") as! Int
                        self.me = FTChatMessageUserModel.init(id: String(id), name: defauls.value(forKey: "displayname") as? String, icon_url: defauls.value(forKey: "image") as? String, extra_data: nil, isSelf: true)
                        
                        if let messages = user["messages"] as?  [Dictionary<String,AnyObject>]{
                            
                            self.chatMessageDataArray.removeAll()
                            var msgs = [FTChatMessageModel]()
                            for mess in messages{
                                
                                var sMessage : FTChatMessageModel!
                                print(mess)
                                
                                if mess["sender_id"] as! Int == defauls.value(forKey: "id") as! Int{
                                    let dateStamp = Utilities.dateFromString(mess["date"] as! String)
                                    let timeStamp = Utilities.timeAgoSinceDateForChat(date: dateStamp, numericDates: true)

                                    sMessage = FTChatMessageModel.init(data: mess["body"] as? String, time: timeStamp, from: self.me, type: FTChatMessageType.text)
                                    
                                }else{
                                    let dateStamp = Utilities.dateFromString(mess["date"] as! String)
                                    let timeStamp = Utilities.timeAgoSinceDateForChat(date: dateStamp, numericDates: true)

                                    sMessage = FTChatMessageModel.init(data: mess["body"] as? String, time: timeStamp, from: self.sender, type: FTChatMessageType.text)
                                    
                                }
                                
//                                messageArray.append(sMessage)
                                msgs.append(sMessage)
                            }
                            self.chatMessageDataArray = msgs
//                            self.messageTableView.reloadData()
                            self.origanizeAndReload()
                            if self.messagesCount < self.chatMessageDataArray.count{
                                
                                self.scrollToBottom(true)
                                self.messagesCount = self.chatMessageDataArray.count
                                
                            }else{
                                
                                self.messagesCount = self.chatMessageDataArray.count
                                
                            }
                            
                        }
                        
                    }
                }
                
            }
            
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
        }
    }
    
//    func getAccessoryItemTitleArray() -> [String] {
//        return ["Alarm","Camera","Contacts","Mail","Messages","Music","Phone","Photos","Settings","VideoChat","Videos","Weather"]
//    }
    
    
//    //MARK: - FTChatMessageAccessoryViewDataSource
//    
//    func ftChatMessageAccessoryViewModelArray() -> [FTChatMessageAccessoryViewModel] {
//        var array : [FTChatMessageAccessoryViewModel] = []
//        let titleArray = self.getAccessoryItemTitleArray()
//        for i in 0...titleArray.count-1 {
//            let string = titleArray[i]
//            array.append(FTChatMessageAccessoryViewModel.init(title: string, iconImage: UIImage(named: string)!))
//        }
//        return array
//    }

//    //MARK: - FTChatMessageAccessoryViewDelegate
//    
//    func ftChatMessageAccessoryViewDidTappedOnItemAtIndex(_ index: NSInteger) {
//        
//        if index == 0 {
//            
//            let imagePicker : UIImagePickerController = UIImagePickerController()
//            imagePicker.sourceType = .photoLibrary
//            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//            imagePicker.delegate = self
//            self.present(imagePicker, animated: true, completion: { 
//                
//            })
//        }else{
//            let string = "I just tapped at accessory view at index : \(index)"
//            
//            print(string)
//            
//            //        FTIndicator.showInfo(withMessage: string)
//            
//            let message2 = FTChatMessageModel(data: string, time: "4.12 21:09:51", from: sender2, type: .text)
//            
//            self.addNewMessage(message2)
//        }
//    }
    
//    override func ft_chatMessageInputViewShouldDoneWithText(_ textString: String) {
//        
//        var dic1 =  Dictionary<String, AnyObject>()
//        let method = "chat/whisper"
//        dic1["user_id"] = user_id as AnyObject
//        dic1["message"] = textString as AnyObject
//    
//        ALFWebService.sharedInstance.doPostData(parameters: dic1, method: method, success: { (response) in
//            print(response)
////                self.messageInputView.inputTextView.text = ""
////                self.messageInputView.inputTextView.resignFirstResponder()
////               let msg = FTChatMessageModel.init(data: textString, time:Utilities.stringFromDate(Date()), from: self.me, type: FTChatMessageType.text)
//            let msg = FTChatMessageModel.init(data: textString, time:Utilities.timeAgoSinceDateForChat(date: Date() as NSDate, numericDates: true), from: self.me, type: FTChatMessageType.text)
//            self.chatMessageDataArray.append(msg)
//            
//            self.origanizeAndReload()
//            
//            self.scrollToBottom(true)
//        }) { (response) in
//            print(response)
//        }
//    }
    
    

}
