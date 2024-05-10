//
//  AllMessageVC.swift
//  JobsDone
//
//  Created by musharraf on 19/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class AllMessageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var messageTabl: UITableView!
    @IBOutlet weak var countLbl: UILabel!
    var mxgArr = [MessageMode]()
    var totalJobs = 0
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle(titel: "MESSAGES")

        messageTabl.dataSource = self
        messageTabl.delegate = self
        messageTabl.separatorStyle = .none
        messageTabl.rowHeight = 69
        messageTabl.estimatedRowHeight = UITableView.automaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(self.leftBtnTapped(btn:)))
        self.navigationItem.leftBarButtonItem = leftBtn
        //MARK - RIGHT BUTTON
        refreshControl.addTarget(self, action: #selector(self.RefreshUsers(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            messageTabl.refreshControl = self.refreshControl
        } else {
            messageTabl.addSubview(self.refreshControl)
            // Fallback on earlier versions
        }
        LoadMxgs()
    }
    @objc func RefreshUsers(sender:AnyObject) {
        // Code to refresh table view
        self.pageNo = 1
        isDataLoading  = false
        LoadMxgs()
    }
    @objc func leftBtnTapped(btn: UIBarButtonItem){
        self.slideMenuController()?.toggleLeft()
    }
    func CreateJobClick(_ sender: UIBarButtonItem)
    {
        let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .createJobVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if mxgArr.count == 0{
            return 1
        }
        return mxgArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if mxgArr.count == 0{
            
            let identifier = "Cell"
            var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            if cell == nil {
                tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            }
            cell.cellLabel.text = "No Conversations"
            return cell
            
            
        }
        let cell = messageTabl.dequeueReusableCell(withIdentifier: "AllMessageCell", for: indexPath as IndexPath) as! AllMessageCell
        
        // Configure the cell...
        let obj = mxgArr[indexPath.row]
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if UserDefaults.standard.value(forKey: "id") as? Int == obj.sender.userId{
           cell.name.text = "2 people"
            cell.userimage.image = #imageLiteral(resourceName: "profile_gray")
        }else{
        cell.userimage.sd_setImage(with: URL(string: obj.sender.image))
        let name = Utilities.stringFromHtml(string: obj.sender.displayname)
        cell.name.attributedText = name
        cell.name.font = UIFont.systemFont(ofSize: 12.0)
        }
        cell.detail.text = obj.message.title
        let dat = Utilities.dateFromString(obj.message.date)
        let timeSince = Utilities.timeAgoSinceDate(date: dat, numericDates: true)
        cell.created_at.text = "\(timeSince)"
        cell.rubbishBtn.addTarget(self, action: #selector(self.RemoveThread(_:)), for: .touchUpInside)
        cell.chatBtn.tag = indexPath.row
        cell.chatBtn.addTarget(self, action: #selector(self.OpenChat(_:)), for: .touchUpInside)
        cell.videochatBtn.addTarget(self, action: #selector(self.OpenChat(_:)), for: .touchUpInside)
        cell.userBtn.addTarget(self, action: #selector(self.UserProfile(_:)), for: .touchUpInside)
        return cell
    }
    //MARK: - Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.mxgArr.count - 3
        if indexPath.row == lastElement {
            if mxgArr.count < totalJobs{
                if !isDataLoading{
                    UIView.setAnimationsEnabled(false)
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    if self.mxgArr.count > 0 {
                        self.lastIndex = self.mxgArr.count - 1
                    }
                self.messageTabl.setContentOffset(messageTabl.contentOffset, animated: false)
                    LoadMxgs()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.mxgArr[indexPath.row]
        let chatView = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .chatVC) as! ChatVC
        chatView.conversation_id = obj.message.conversationId
        chatView.senderName = obj.sender.displayname
        chatView.img = obj.sender.image
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - REMOVE THREAD
    @objc func RemoveThread(_ sender: UIButton)
    {
        if let cell = sender.superview?.superview as? AllMessageCell{
            let indexPath = self.messageTabl.indexPath(for: cell) as! IndexPath
            let obj = self.mxgArr[indexPath.row]
            
            let alertController = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your Conversation?", preferredStyle: .alert)
            let sendButton = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
                let method = "messages/delete"
                var params = Dictionary<String,AnyObject>()
                params["conversation_ids"] = obj.message.conversationId as AnyObject
                Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
                ALFWebService.sharedInstance.doPostData(parameters: params, method: method, success: { (response) in
                    print(response)
                   Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                    let status = response["status_code"] as! Int
                    if status == 204{
                        self.mxgArr.remove(at: indexPath.row)
                        self.messageTabl.deleteRows(at: [indexPath], with: .none)
                    }
                }) { (response) in
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
            })
            let  deleteButton = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
                print("Delete button Cancel")
            })
            alertController.addAction(sendButton)
            alertController.addAction(deleteButton)
            Utilities.doCustomAlertBorder(alertController)
            self.navigationController!.present(alertController, animated: true, completion: nil)
            
        }
    }
    @objc func UserProfile(_ sender: UIButton)
    {
        if let cell = sender.superview?.superview as? AllMessageCell{
            let indexPath = self.messageTabl.indexPath(for: cell) as! IndexPath
            let obj = self.mxgArr[indexPath.row]
            let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
            if obj.sender.userId != nil{
            vc.id = obj.sender.userId
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
   @objc func OpenChat(_ sender: UIButton)
    {
        let model = self.mxgArr[sender.tag]
        let userPhone = String(describing: model.sender.phone!)
        if userPhone != "" && userPhone != "<null>"{
            userPhone.makeAColl()
        }else{
            self.showToast(message: "User does not have Number")
        }
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
    //MARK: - LOAD Messages
    func LoadMxgs()
    {
        var dic = Dictionary<String,AnyObject>()
        dic["limit"] = limit as AnyObject
        dic["page"] = pageNo as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: "messages/inbox", success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    self.totalJobs = body!["getTotalItemCount"] as! Int
                    if let arr = body!["response"] as? [Dictionary<String,AnyObject>]{
                        if !self.isDataLoading{
                            self.mxgArr.removeAll()
                        }
                        for obj in arr{
                            let model = MessageMode.init(fromDictionary: obj)
                            self.mxgArr.append(model)
                        }
                    }
                    if self.isDataLoading{
                        var indexPathsArray = [NSIndexPath]()
                        for index in self.lastIndex..<self.mxgArr.count - 1{
                            let indexPath = NSIndexPath(row: index, section: 0)
                            indexPathsArray.append(indexPath)
                            self.isDataLoading = false
                        }
                        self.messageTabl.beginUpdates()
                        self.messageTabl!.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                        self.messageTabl.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }else{
                        if self.refreshControl.isRefreshing{
                            self.refreshControl.endRefreshing()
                        }
                        self.messageTabl.contentOffset = CGPoint.zero
                        self.messageTabl.reloadData()
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }

}
