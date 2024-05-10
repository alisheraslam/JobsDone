//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit


class ChatListViewController: UITableViewController {

    @IBOutlet weak var connectLabelCount: UILabel!
     var dataArray = [Dictionary<String,AnyObject>]()
    let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
    
    var isChatDialogue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
//        let uName = NSUserDefaults.standardUserDefaults().objectForKey("displayname") as! String
       
//        NotificationCenter.defaultCenter.addObserver(self, selector: #selector(self.loadChatLists(_:)), name:"chatActivate", object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadChatLists(notification:)), name: NSNotification.Name(rawValue:"chatActivate"), object: nil)
        loadChatMembers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        appDelegate.chatRepeater.invalidate()
        appDelegate.dic["fresh"] = 1 as AnyObject
        appDelegate.isChat = true
        appDelegate.timeInterval = 10
        appDelegate.active()

    }
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.isChat = false
    }
    func loadChatMembers(){
        let method = "chat"
        var dic = Dictionary<String,AnyObject>()
        dic["status"] = 1 as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
            if let users = response["users"] as?  [Dictionary<String,AnyObject>]{
                
                self.dataArray = users
            }
            
            self.connectLabelCount.text = "Connections available (\(self.dataArray.count))"
            self.tableView.reloadData()
            
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
        }
    }
    
    @objc func loadChatLists(notification: NSNotification){
        
//        var dic =  Dictionary<String, AnyObject>()
//        let method = "chat"
//        dic["refresh"] = 1
//        WebServices.sharedInstance.chatService(dic, method: method, success: { (response) in
//            print(response)
//        }) { (response) in
//            print(response)
//        }
        
        print(notification.object!)
        
        if let myDict = notification.object as? Dictionary<String,AnyObject> {
            if let users = myDict["users"] as?  [Dictionary<String,AnyObject>]{
                
                dataArray = users
            }
        }
        connectLabelCount.text = "Connections available (\(dataArray.count))"
        self.tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 4
//    }

    
  override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
//        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath as IndexPath) as! ChatListCell

        // Configure the cell...
        let dic = dataArray[indexPath.row]

        cell.userImageView.setImageWith(NSURL(string: (dic["image_icon"] as? String)!)! as URL)
        cell.userName.text = dic["title"] as? String
        if (app_links_color != "")
        {
            cell.userName.textColor = UIColor(hexString: app_links_color)
        }
        if dic["state"] as! Int == 1{

            cell.onlineOfflineImage.image = UIImage(named: "onlineDot")
//            cell.onlineOfflineImage.image = UIImage(named: "dot")

        }else if dic["state"] as! Int == 2{

            cell.onlineOfflineImage.image = UIImage(named: "dot")
        }
        cell.cellBackView.backgroundColor = UIColor(hexString: navbarTint).withAlphaComponent(0.1)
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//                let chat = storyBoard.instantiateViewControllerWithIdentifier("FTChatMessageTableViewController") as! FTChatMessageTableViewController
        DispatchQueue.main.async {
            let chat =  ChatTableViewController()
            let uinav = UINavigationController(rootViewController: chat)
            //        let chat = FTChatMessageTableViewController()
            let dic = self.dataArray[indexPath.row]
            chat.user_id = dic["user_id"] as! Int
            chat.displayName = dic["title"] as! String
            self.isChatDialogue = true
            
            //                self.navigationController?.pushViewController(chat, animated: true)
            self.present(uinav, animated: true, completion: nil)
        }
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        print("disappear")
        
        if isChatDialogue == false{
            
            appDelegate.chatRepeater.invalidate()
            appDelegate.dic = ["status": 1 as AnyObject]
            appDelegate.isChat = false
            appDelegate.timeInterval = 10
            appDelegate.active()
            
        }else{
            
            isChatDialogue = false
        }
        

    }
    
//    override func viewDidUnload() {
//        
//        super.viewDidLoad()
//        print("disappear")
//        
//        appDelegate.chatRepeater.invalidate()
//        appDelegate.dic = ["status": 1]
//        appDelegate.isChat = false
//        appDelegate.timeInterval = 10
//        appDelegate.active()
//
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 60
    }
}
