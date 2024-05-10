//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class MessageTVC: UITableViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var method = ""
    var height = 0
    var dic = Dictionary<String,AnyObject>()
    var message = MessageModel()
    var shouldUpdate = true
    var isRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: .valueChanged)

        tblView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        if SystemVersion.greaterThanOrEqual("11.0") {
            self.tblView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
            
        } else {
            self.tblView.contentInset = UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.newMessagePosted(btn:)), name: NSNotification.Name(rawValue: "newMessagePosted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newMessageDeleted(btn:)), name: NSNotification.Name(rawValue: "newMessageDeleted"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if shouldUpdate == true{
            getMessageData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        if Utilities.isGuest() {
            isRefreshing = false
            self.refreshControl?.endRefreshing()
            
        } else {
            isRefreshing = true
            self.refreshControl?.beginRefreshing()
            self.tblView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl!.frame.size.height - self.topLayoutGuide.length), animated: true)
            self.getMessageData()
        }
        
    }
   
    
    @objc func newMessagePosted(btn: UIBarButtonItem){
        getMessageData()
    }
    @objc func newMessageDeleted(btn: UIBarButtonItem){
        getMessageData()
    }
    //MARK:- Private Methods
    
    func getMessageData(){
        print(method)
        if Utilities.isGuest() {
            return
        }
        let param = [:] as? Dictionary<String,AnyObject>
        
        if !self.isRefreshing {
            if self.navigationController?.view != nil {
                Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
            } else {
                Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            }
        }
        
        
        
        ALFWebService.sharedInstance.doGetData(parameters: param!, method: method, success: { (response) in
            if !self.isRefreshing {
                if self.navigationController?.view != nil {
                    Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
                } else {
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
            } else {
                self.isRefreshing = false
                self.refreshControl?.endRefreshing()
            }
            
            print(response)
            self.shouldUpdate = false
            if let status_code = response["status_code"] as? Int {
                if status_code == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject> {
//                        let objModel = MessageModel.init(body)
                        self.message = MessageModel.init(body)
//                        self.messageDataArr.append(objModel)
                    }
                    self.tblView.reloadData()
                } else {
                    
                }
            }
        }) { (response) in
            if !self.isRefreshing {
                if self.navigationController?.view != nil {
                    Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
                } else {
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
            } else {
                self.isRefreshing = false
                self.refreshControl?.endRefreshing()
            }
            print(response)
        }
    }
    
    func readUnRead(id: String, isRead: String){
        var param = Dictionary<String,AnyObject>()
        param["message_id"] = id as AnyObject
        param["is_read"] = isRead as AnyObject
        
        ALFWebService.sharedInstance.doPostData(parameters: param, method: "messages/mark-message-read-unread", success: { (response) in
            print(response)
        }) { (response) in
            print(response)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if message.response.count == 0 {
            return 1
        } else {
            return message.response.count
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if message.response.count == 0 {
            let identifier = "Cell"
            var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            if cell == nil {
                tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            }
            if Utilities.isGuest() {
                cell.cellLabel.text = "Please Login to view Messages."
            } else {
                cell.cellLabel.text = "No Message"
            }
            
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCell
            var name: String?
            var title: String?
            var date: String?
            var img_url: String?
            
            let response = message.response
            let res = response[indexPath.row]
            
            
            if let recp = res["recipient"] as? Dictionary<String,AnyObject> {
                
                if let read = recp["inbox_read"] as? Int {
                    if self.method == "messages/inbox" {
                        if read == 0{
                            
                            cell.cellBackView.backgroundColor = UIColor(hexString: app_unread_color)
                        }else{
                            
                            cell.cellBackView.backgroundColor = UIColor(hexString: topTabBarBGColor).withAlphaComponent(0.2)
                        }
                    } else {
                        cell.cellBackView.backgroundColor = UIColor(hexString: topTabBarBGColor).withAlphaComponent(0.2)
                    }
                    
                    
//                    if read == 0{
//                        cell.backgroundColor = UIColor.groupTableViewBackground
//                        
//                    }else{
//                        cell.backgroundColor = UIColor.white
//                    }
                }
                
            }
            
            
            if let mess = res["message"] as? Dictionary<String,AnyObject> {
                title = mess["title"] as? String
                date = mess["date"] as? String
            }
            if let send = res["sender"] as? Dictionary<String,AnyObject> {
                if (send["displayname"] as? String) != nil{
                    
                    name = send["displayname"] as? String
                }else{
                    name = "Deleted User"
                }
                
                img_url = send["image_profile"] as? String
            }
            
            let dateStamp = Utilities.dateFromString(date!)
            let timeStamp = Utilities.timeAgoSinceDate(date: dateStamp, numericDates: true)
            
            cell.dateLabel.text = timeStamp
            cell.messageLabel.text = title
            cell.userNameLabel.text = name
            cell.userNameLabel.textColor = UIColor(hexString: app_links_color)
            
            let url = URL(string: img_url!)
            
            cell.userImageView.sd_setImage(with: url)
            
            return cell

        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let chatView = ChatViewController()
        let chatView = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .chatVC) as! ChatVC
        let response = message.response
        
        let res = response[indexPath.row]
        if let recp = res["recipient"] as? Dictionary<String,AnyObject> {
            if self.method == "messages/inbox" {
                if let read = recp["inbox_read"] as? Int {
                    if read == 0{
                        if self.tabBarController?.tabBar.items?[2].badgeValue != nil {
                            let str = self.tabBarController?.tabBar.items?[2].badgeValue
                            var badge = Int(str!)
                            
                            
                            if badge != 0{
                                badge = badge! - 1
                                if badge == 0 {
                                    self.tabBarController?.tabBar.items?[2].badgeValue = nil
                                } else {
                                    self.tabBarController?.tabBar.items?[2].badgeValue = "\(String(describing: badge!))"
                                }
                                
                                
                                let msgId = String(describing: recp["conversation_id"]!)
                                self.readUnRead(id: msgId, isRead: "1")
                                self.shouldUpdate = true
                            }
                        }
                        
                    } else {
                        self.shouldUpdate = true
                    }
                }else {
                    self.shouldUpdate = true
                }
            }
            
            
        }
        if let mess = res["message"] as? Dictionary<String,AnyObject> {
            
            chatView.conversation_id = mess["conversation_id"]! as! Int
        }
        if let send = res["sender"] as? Dictionary<String,AnyObject> {
            if let disName = send["displayname"] as? String{
                    chatView.senderName = disName
            }else{
                chatView.senderName = "Deleted User"
            }
            
        }

        
        self.navigationController?.pushViewController(chatView, animated: true)

    }
}
