//
//  NotificationVC.swift
//  JobsDone
//
//  Created by musharraf on 23/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var notificationTabl: UITableView!
    
    var notifArr = [NotificationModel]()
    var totalJobs = 0
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var refreshControl = UIRefreshControl()
    var jobSkillArr = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle(titel: "NOTIFICATIONS")
        notificationTabl.dataSource = self
        notificationTabl.delegate = self
        notificationTabl.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let editImage    = UIImage(named: "green_checked")
        let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action:#selector(self.MarkAllRead(btn:)))
        editButton.tintColor = UIColor(hexString: "#18A915")
         self.navigationItem.rightBarButtonItem = editButton
        refreshControl.addTarget(self, action: #selector(self.RefreshUsers(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            notificationTabl.refreshControl = self.refreshControl
        } else {
            notificationTabl.addSubview(self.refreshControl)
            // Fallback on earlier versions
        }
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "back_white"), for: .normal)
        button.setTitle("Back", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.CloseController(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        LoadNotifications()
    }
    
    @objc func CloseController(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func RefreshUsers(sender:AnyObject) {
        // Code to refresh table view
        self.pageNo = 1
        isDataLoading  = false
        LoadNotifications()
    }
    //MARK: - SHOW USER SKILLS
    @objc func ShowUserSkill(_ sender: UIButton)
    {
        let job = self.notifArr[sender.tag]
        vc.skillArr = job.subject.skills
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
    @objc func Remove(_ sender: UIButton)
    {
        vc.view.removeFromSuperview()
    }
    //MARK: - MARK ALL READ
    @objc func MarkAllRead(btn: UIBarButtonItem){
       
            if !Utilities.isLoggedIn(){
                Utilities.logout()
            }else{
                let refreshAlert = UIAlertController(title: "Mark all Read", message: "Are you sure you want to mark all notifications as read?", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                    let dic = Dictionary<String,AnyObject>()
                    let method = "/notifications/markallread"
                    Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
                    ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
                        print(response)
                        Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                        if let status_code = response["status_code"] as? Int{
                            if status_code == 204{
                                self.isDataLoading  = false
                                self.LoadNotifications()
                            }
                        }
                    }) { (response) in
                        Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                    }
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                }))
                Utilities.doCustomAlertBorder(refreshAlert)
                present(refreshAlert, animated: true, completion: nil)
               
            }
    }
    func leftBtnTapped(btn: UIBarButtonItem){
        self.slideMenuController()?.toggleLeft()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if notifArr.count == 0{
            return 1
        }
        return notifArr.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if notifArr.count == 0{
                
                let identifier = "Cell"
                var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
                if cell == nil {
                    tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
                }
                cell.cellLabel.text = "No Data"
                return cell
                
                
            }else{
        var idenftifier = "NotificationCell"
        let cell = notificationTabl.dequeueReusableCell(withIdentifier: idenftifier, for: indexPath as IndexPath) as! NotificationCell
        let obj = self.notifArr[indexPath.row]
        // Configure the cell...
        if obj.read == 0{
            cell.contentView.backgroundColor = UIColor(hexString: app_unread_color)
        }else{
            cell.contentView.backgroundColor = UIColor.white
                }
        if obj.subject.image != nil{
        cell.userimage.sd_setImage(with: URL(string: obj.subject.image))
        }
        cell.ratingImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 20, height: 20))
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.skillShowBtn.tag = indexPath.row
                cell.skillShowBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
        cell.goToProfile.tag = indexPath.row
        cell.goToProfile.addTarget(self, action: #selector(self.ProfileBtnPressed(_:)), for: .touchUpInside)
        cell.name.text = obj.subject.displayname
        cell.detail.text = obj.feedTitle
        cell.created_at.text = obj.notifyTimestamp
        cell.rating.text = "\(obj.subject.userRating!)"
        cell.reviews.text = "\(obj.subject.reviewCount!) Reviews"
        cell.locationImg.isHidden = true
        
                //else{
            cell.location.text = ""
                if obj.subject.skills.count > 1{
                    if (obj.subject.skills.count) > 1{
                        cell.skill.text = "\(obj.subject.skills[0].categoryName!) +\((obj.subject.skills.count) - 1)"
                    }else{
                      cell.skill.text = obj.subject.skills[0].categoryName
                    }
                    let url = obj.subject.skills[0].thumbIcon
                    if url != ""{
                        cell.skillImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                            // Perform your operations here.
                            cell.skillImg.image = cell.skillImg.image?.withRenderingMode(.alwaysTemplate)
                            cell.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                        }
                    }
                    
                }else{
                    cell.skillImg.isHidden = true
                }
        
        return cell
            }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = notifArr[indexPath.row]
        let method = "notifications/markread"
        var dic = Dictionary<String,AnyObject>()
        dic["action_id"] = obj.notificationId as AnyObject
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            print(response)
        }) { (response) in
            print(response)
        }
        obj.read = 1
        self.notificationTabl.reloadRows(at: [indexPath], with: .none)
        if obj.type == "job_feedback"{
            let con = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .feedbackDetail) as! FeedbackDetail
            con.dic["id"] = obj.objectId as AnyObject
            if obj.object.ownerId == UserDefaults.standard.value(forKey: "id") as? Int{
                con.dic["owner"] = 0 as AnyObject
            }else{
            con.dic["owner"] = 1 as AnyObject
            }
            self.navigationController?.pushViewController(con, animated: true)
        }else if obj.type == "liked" || obj.type == "commented"{
            let vc = UIStoryboard.storyBoard(withName: .Portfolio).loadViewController(withIdentifier: .portfolioProfileVC) as! PortfolioProfileVC
            vc.id = obj.object.portfolioId
            vc.userId = obj.userId
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
        let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .jobDetailVC) as! JobDetailVC
            if obj.object != nil{
        vc.jobId = obj.object.listingId
        vc.userImg = obj.subject.imageNormal
        vc.ownerId = obj.subject.userId
        self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.notifArr.count - 3
        if indexPath.row == lastElement {
            if notifArr.count < totalJobs{
                if !isDataLoading{
                    UIView.setAnimationsEnabled(false)
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    if self.notifArr.count > 0 {
                        self.lastIndex = self.notifArr.count - 1
                    }
            self.notificationTabl.setContentOffset(notificationTabl.contentOffset, animated: false)
                    LoadNotifications()
                }
            }
        }
    }
    
    //MAR: - FOR USER PROFILE
    @objc func ProfileBtnPressed(_ sender: UIButton)
    {
        let obj = notifArr[sender.tag]
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = obj.subject.userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK: - LOAD NOTIFICATIONS
    func LoadNotifications()
    {
        var dic = Dictionary<String,AnyObject>()
        dic["limit"] = self.limit as AnyObject
        dic["page"] = self.pageNo as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: "notifications", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    self.totalJobs = body!["recentUpdateTotalItemCount"] as! Int
                    if let arr = body!["recentUpdates"] as? [Dictionary<String,AnyObject>]{
                        if !self.isDataLoading{
                            self.notifArr.removeAll()
                        }
                        for obj in arr{
                            let model = NotificationModel.init(fromDictionary: obj)
                            self.notifArr.append(model)
                        }
                    }
                    if self.isDataLoading{
                        var indexPathsArray = [NSIndexPath]()
                        for index in self.lastIndex..<self.notifArr.count - 1{
                            let indexPath = NSIndexPath(row: index, section: 0)
                            indexPathsArray.append(indexPath)
                            self.isDataLoading = false
                        }
                        self.notificationTabl.setContentOffset(self.notificationTabl.contentOffset, animated: false)
                        self.notificationTabl.beginUpdates()
                        self.notificationTabl!.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                        self.notificationTabl.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }else{
                        if self.refreshControl.isRefreshing{
                            self.refreshControl.endRefreshing()
                        }
                        self.notificationTabl.contentOffset = CGPoint.zero
                        self.notificationTabl.reloadData()
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    //MARK: -

}
