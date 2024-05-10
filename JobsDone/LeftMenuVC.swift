//
//  RightMenuVC.swift
//  TestFrontPage
//
//  Created by musharraf on 09/10/2017.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import FBSDKLoginKit
import FBSDKCoreKit


var gDashMenu : RighMenuModel!

class LeftMenuVC: UIViewController {
    

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profile_pic: WAImageView!
    var not = false
    var dashMenu : RighMenuModel?
    var payment_id : Int!
    var payment_email :String!
    var menu = [String]()
    var notifArr = [NotificationModel]()
    var notPictures = [String]()
    var jobPictures = [String]()
    var notPicCount = 0
    var jobPicCount = 0
    var currentPic = [String]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.tableFooterView = UIView(frame: CGRect.zero)
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 55
        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMenuAgain(not:)), name: Notification.Name("loadMenu"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.LoadPaymentMethod), name: NSNotification.Name(rawValue: "PaymentMethodUpdated"), object: nil)
        refreshControl.addTarget(self, action: #selector(self.RefreshJobs(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tblView.refreshControl = self.refreshControl
        } else {
            tblView.addSubview(self.refreshControl)
            // Fallback on earlier versions
        }
        LoadNotifications()
        LoadJobPictures()
        LoadPaymentMethod()
        
    }
    @objc func RefreshJobs(sender:AnyObject) {
        // Code to refresh table view
        LoadNotifications()
        LoadJobPictures()
        LoadPaymentMethod()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if loadMenu {
            loadDashBoardMenu()
        } else {
            
        }
        if Utilities.isGuest() {
            userNameLabel.text = "Guest User"
//            chaneImageIcon.isHidden = true
        }else {
//            chaneImageIcon.isHidden = false
//            userNameButton.setTitle((UserDefaults.standard.value(forKey: "name") as? String)!, for: .normal)
            userNameLabel.text = (UserDefaults.standard.value(forKey: "name") as? String)!
            
        }
        if UserDefaults.standard.value(forKey: "image") != nil{
            let img = UserDefaults.standard.value(forKey: "image") as? String
            profile_pic.sd_setImage(with: URL(string: img!))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Notifications Handle
    @objc func loadMenuAgain(not: Notification){
        loadDashBoardMenu()
    }
    //MARK:- Custom Methods
    
    func loadDashBoardMenu(){
        
        let method = "get-dashboard-menus"
        
        var dic = Dictionary<String,AnyObject>()
        dic["type"] = "ios" as AnyObject
        
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            
            print(response)
            loadMenu = false
            if let dic = response as? Dictionary<String,AnyObject> {
                let menu = RighMenuModel.init(fromDictionary: dic)
                self.dashMenu = menu
                gDashMenu = menu
            }
            self.tblView.reloadData()
            self.LoadPaymentMethod()
        }) { (response) in
            
            print(response)
        }
        
    }
    func signOut(nav: UINavigationController){
        
        let alert = UIAlertController(title: "Alert", message: "Are You Sure to Sign Out from the App?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (alert) in
            
            loadMenu = true
            
            if (AccessToken.current != nil) {
                LoginManager().logOut()
            }
            
            let method = "logout"
            var params = Dictionary<String, AnyObject>()
            params["device_uuid"] = deviceUdid as AnyObject
            print(method)
            print("method is \(method) and params are \(params)")
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: params, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                
                if let scode = response["status_code"] as? Int {
                    if scode == 204 {
                        Utilities.logout()
                    }
                }
            }) { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (alert) in
            
        }))
        nav.present(alert, animated: true, completion: nil)
        
    }
    

    //MARK: - LOAD NOTIFICATIONS
    func LoadNotifications()
    {
        let myparam = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: myparam, method: "notifications/icons", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    self.notPicCount = (body!["totalItemCount"] as? Int)!
                    if let arr = body!["notifications"] as? [Dictionary<String,AnyObject>]{
                        for obj in arr{
                            let model = PhotosArr.init(fromDictionary: obj)
                            self.notPictures.append(model.image)
                        }
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    //MARK: - LOAD NOTIFICATIONS
    func LoadJobPictures()
    {
        let myparam = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: myparam, method: "jobs/icons", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    self.jobPicCount = (body!["totalItemCount"] as? Int)!
                    if let arr = body!["response"] as? [Dictionary<String,AnyObject>]{
                        for obj in arr{
                            let model = PhotosArr.init(fromDictionary: obj)
                            self.jobPictures.append(model.image)
                        }
                    }
                }
                self.loadDashBoardMenu()
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
}

//MARK:- TableViewDelegates

extension LeftMenuVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return menu.count
        if dashMenu != nil {
            return (dashMenu?.body.menus.count)!
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = "cell"
        if dashMenu?.body.menus[indexPath.row].label == "LOGOUT"{
            identifier = "btnCell"
        }else if dashMenu?.body.menus[indexPath.row].name == "core_mini_notification" || dashMenu?.body.menus[indexPath.row].name == "core_main_jobs_manage"{
            identifier = "JobCell"
        }
        else{
         identifier = "rightCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier ) as! MenuCell
        if cell.reuseIdentifier == "btnCell"{
            cell.logoutBtn.addTarget(self, action: #selector(DidPressedLogout(_:)), for: .touchUpInside)
        }else
        if dashMenu?.body.menus[indexPath.row].label != "LOGOUT" {
            cell.lblTitle.text = dashMenu?.body.menus[indexPath.row].label
            cell.iconLbl.font = UIFont.fontAwesome(ofSize: 15)
            cell.iconLbl.textColor = UIColor(hexString: "#3B3B3B")
            let str1 = (dashMenu?.body.menus[indexPath.row].icon as? String)!
            var str : String!
            
            if str1 == ""{
                str = "\u{f15c}"
            }else if str1 == "f2b5"{
                str = "\u{f15c}"
            }else{
                let unicodeIcon = Character(UnicodeScalar(UInt32(hexString: "\(str1)")!)!)
                str = "\(unicodeIcon)"
            }
            if dashMenu?.body.menus[indexPath.row].name == "core_mini_notification"  {
                self.not = false
                cell.imgArr = self.notPictures
                cell.jobCount = self.notPicCount
                cell.LoadClView()
            }
            else if dashMenu?.body.menus[indexPath.row].name == "core_main_jobs_manage" {
                cell.imgArr = self.jobPictures
                cell.jobCount = self.jobPicCount
                cell.LoadClView()
            }
            cell.iconLbl.text = str //"/\"\(str)\""
        }
        
        
        return cell
    }
    @objc func DidPressedLogout(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to Sign Out?", preferredStyle: UIAlertController.Style.alert)
        if DeviceType.iPad {
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert) in
                
                
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
                
                
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            print("captureVideoPressed and camera available.")
            let method = "logout"
            var params = Dictionary<String, AnyObject>()
            params["device_uuid"] = UserDefaults.standard.value(forKey: "device_uuid") as AnyObject
            print(method)
            if Utilities.isGuest(){
              Utilities.logout()
                return
            }
            print("method is \(method) and params are \(params)")
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: params, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                
                if let scode = response["status_code"] as? Int {
                    if scode == 204 {
                        Utilities.logout()
                    }
                }
            }) { (response) in
                
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                
            }
        }))
        
        if let popoverPresentationController = alert.popoverPresentationController {
        }
        Utilities.doCustomAlertBorder(alert)
        self.present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.slideMenuController()?.closeRight()
            let men = self.dashMenu?.body.menus[indexPath.row]
            self.slideMenuController()?.toggleLeft()
            let tab = self.slideMenuController()?.mainViewController as! UITabBarController
            let current = tab.viewControllers?[tab.selectedIndex] as! UINavigationController
             if men?.name == "home"{
                let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
                vc.id = UserDefaults.standard.value(forKey: "id") as! Int
                current.pushViewController(vc, animated: true)
            }
            else if men?.name == "core_main_jobs_manage" {
                let menu = MyJobVC()
                if UserDefaults.standard.value(forKey: "level_id") as? Int == 7 || UserDefaults.standard.value(forKey: "level_id") as? Int == 8{
                    menu.tabTitles = ["POSTED","COMPLETED"]
                }else{
                menu.tabTitles = ["INVITATIONS","APPLIED","RUNNING","COMPLETED","POSTED"]
                }
                menu.navTitle = "MY JOBS"
//                self.navigationController?.pushViewController(menu, animated: true)
                current.pushViewController(menu, animated: true)
                
            } else if men?.name == "core_mini_notification" {
                let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .NotificationVC) as! NotificationVC
                current.pushViewController(vc, animated: true)
                
            } else if men?.label == "Favorites" {
 
                let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .favProfessionalVC) as! FavProfessionalVC
                current.pushViewController(vc, animated: true)
                
            } else if men?.name == "core_main_member_profile" {
                
                let tab = self.slideMenuController()?.mainViewController as! UITabBarController
                let vc = tab.viewControllers?[tab.selectedIndex] as! UINavigationController
                vc.tabBarController?.selectedIndex = 4
                
            } else if men?.name == "core_main_membership" {
                let vc = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .membershipVC) as! MembershipVC
                vc.paymentType = .MEMBERSHIP
                current.pushViewController(vc, animated: true)

            } else if men?.name == "core_main_payment" {
                let vc : UIViewController!
                if self.payment_id != nil {
                  let  mc = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .paypalVC) as! PaypalVC
                    mc.parentViewType = .PROFILE
                    mc.emailTxt = self.payment_email
                    mc.emailId = self.payment_id
                    current.pushViewController(mc, animated: true)
                }else{
                vc = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .addPaymentVC) as! AddPaymentVC
                    current.pushViewController(vc, animated: true)
                }
               
            } else if men?.name == "core_main_table_registration" {
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1/2)) {
//                    let tab = self.slideMenuController()?.mainViewController as! UITabBarController
//                    let tabVc = tab.viewControllers?[tab.selectedIndex] as! UINavigationController
//                    let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .tableRegisterVC) as! TableRegisterVC
//
//                    tabVc.pushViewController(vc, animated: true)
                
//                }
                
            } else if men?.name == "core_main_hygienic_guide_line" {
                let tab = self.slideMenuController()?.mainViewController as! UITabBarController
                let vc = tab.viewControllers?[tab.selectedIndex] as! UINavigationController
                
//                let con = WebViewController(url: URL(string: "http://neighcook.com/pages/hygienic-guide-line?disableHeaderAndFooter=1")!)
//                vc.pushViewController(con, animated: true)
            } else if men?.name == "signout" {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1/2)) {
                    
                    let tab = self.slideMenuController()?.mainViewController as! UITabBarController
                    let vc = tab.viewControllers?[tab.selectedIndex] as! UINavigationController
                    self.signOut(nav: vc)
                }
                
            } else if men?.label == "Help"{
                let tab = self.slideMenuController()?.mainViewController as! UITabBarController
                let current = tab.viewControllers?[tab.selectedIndex] as! UINavigationController
                let vc = UIStoryboard.storyBoard(withName: .Help ).loadViewController(withIdentifier: .helpVC) as! HelpVC
                
                let nav = UINavigationController(rootViewController: vc)
                //                self.navigationController?.present(vc, animated: true)
                current.pushViewController(vc, animated: true)
                
            }else if men?.name == "user_settings"{
                let tab = self.slideMenuController()?.mainViewController as! UITabBarController
                let current = tab.viewControllers?[tab.selectedIndex] as! UINavigationController
                let vc = UIStoryboard.storyBoard(withName: .Setting ).loadViewController(withIdentifier: .settingRGTab) as! SettingRGTab
                vc.dashMenu = self.dashMenu
                
                let nav = UINavigationController(rootViewController: vc)
                //                self.navigationController?.present(vc, animated: true)
                current.pushViewController(vc, animated: true)
                
            }
        }
        
    }
    @objc func LoadPaymentMethod()
    {
        let method = "members/settings/method"
        var dic = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let res = body["response"] as? Dictionary<String,AnyObject>
                        {
                            self.payment_id = res["paymentmethod_id"] as? Int
                            self.payment_email = res["email"] as? String
                            let type = res["method_type"] as? String
                            
                            if type == "debit"{
                                self.payment_email = String(describing: res["cardnumber"] as! Int)
                                let last4 = self.payment_email.substring(from:self.payment_email.index(self.payment_email.endIndex, offsetBy: -4))
                                self.payment_email = "**** **** **** \(last4)"
                            }else{
                                self.payment_email = nil
                                self.payment_id = nil
                            }
                        }else{
                            self.payment_email = nil
                            self.payment_id = nil
                        }
                    }
                }
            }
            if self.refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    
    
    @IBAction func NameOrImgPressed(_ sender: UIButton)
    {
        self.slideMenuController()?.toggleLeft()
        let tab = self.slideMenuController()?.mainViewController as! UITabBarController
        let current = tab.viewControllers?[tab.selectedIndex] as! UINavigationController
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = UserDefaults.standard.value(forKey: "id") as! Int
        current.pushViewController(vc, animated: true)
    }
}

