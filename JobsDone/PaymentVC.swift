//
//  PaymentVC.swift
//  JobsDone
//
//  Created by musharraf on 17/04/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import RGPageViewController



class PaymentVC: RGPageViewController,RGPageViewControllerDelegate,RGPageViewControllerDataSource {
    var proImg = ""
    let guttCon = GutterMenuHandler()
   var parentViewType = ParentViewType.SIGNUP
    var id : Int!
    var numberofRow = 0
   
    var action_id: Int!
    var dic3 = [:] as Dictionary<String, AnyObject>
    var guttermenu = [GutterMenuModel]()
    var frmPushNot = false
    var withImg = false
    var tabTitles : [String] = [""]
    
    
    var tabCountArr = [String]()
   
    var response = Dictionary<String,AnyObject>()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        datasource = self
        delegate = self
        self.title = "ADD PAYMENT METHOD"
//        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ellipsisV"), style: .done, target: self, action: #selector(OpenGutterMenu))
        
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        loadProfile()
    }
    @objc func OpenGutterMenu(_ sender: UIBarButtonItem){
        guttCon.setGutterMenu(menu: guttermenu, con: self, index: 0, type: pluginType.upComingEvents, senderr: sender, view: self.view, btnTyp: "barBtn")
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    override var pagerOrientation: UIPageViewController.NavigationOrientation {
        get {
            if DeviceType.iPad {
                //return .vertical
                return .horizontal
            }
            return .horizontal
        }
    }
    
    override var tabbarHeight: CGFloat {
        get {
            return 44.0
        }
    }
    
    
    override var tabbarPosition: RGTabbarPosition {
        get {
            if DeviceType.iPad {
                //return .right
                return .top
            }
            return .top
        }
    }
    
    override var tabbarStyle: RGTabbarStyle {
        get {
            if DeviceType.iPad {
                return .solid
            }
            return .solid
        }
    }
    
    override var tabIndicatorColor: UIColor {
        get {
            return UIColor(hexString: "#FF6B00")
        }
    }
    
    override var barTintColor: UIColor? {
        get {
            return UIColor.white
        }
    }
    
    override var tabbarHidden: Bool {
        get {
            return false
        }
    }
    
    override var tabStyle: RGTabStyle {
        return .inactiveFaded
    }
    
    override var tabbarWidth: CGFloat {
        get {
            return 140.0
        }
    }
    
    override var tabMargin: CGFloat {
        get {
            return 0.0
        }
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.currentTabIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.currentTabIndex = 0
    }
    
    
    func memberApprovedFunc(not: Notification){
        NotificationCenter.default.removeObserver(self, name: Notification.Name("memberApproved"), object: nil)
        print(tabTitles)
        print(tabCountArr)
        print(currentTabIndex)
        print(tabCountArr[currentTabIndex])
        tabCountArr[currentTabIndex] = String(Int(tabCountArr[currentTabIndex])! + 1)
        _ = pageViewController(self, tabViewForPageAt: currentTabIndex)
        return
    }
    func numberOfPages(for pageViewController: RGPageViewController) -> Int {
        
        return tabTitles.count
    }
    
    func pageViewController(_ pageViewController: RGPageViewController, tabViewForPageAt index: Int) -> UIView {
        var tabView: UIView!
        if !DeviceType.iPad {
            tabView = UILabel()
            
            (tabView as! UILabel).font = UIFont.boldSystemFont(ofSize: 17)
            (tabView as! UILabel).text = tabTitles[index]
            (tabView as! UILabel).textColor = UIColor(hexString: "#FF6B00")
            
            (tabView as! UILabel).sizeToFit()
            //            tabView.backgroundColor = UIColor(netHex: 0x1D599C)
            
        } else {
            tabView = UILabel()
            
            (tabView as! UILabel).font = UIFont.systemFont(ofSize: 17)
            (tabView as! UILabel).text = tabTitles[index]
            
            (tabView as! UILabel).textColor = UIColor(hexString: "#FF6B00")
            
            
            (tabView as! UILabel).sizeToFit()
        }
        
        return tabView
        
    }
    func pageViewController(_ pageViewController: RGPageViewController, willChangePageTo index: Int, fromIndex from: Int) {
        
    }
    func pageViewController(_ pageViewController: RGPageViewController, didChangePageTo index: Int) {
        var count = ""
        if tabCountArr.count != 0 {
            count = tabCountArr[index]
        }
        
        if tabTitles[index] == "PAYPAL"{
            let members = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .paypalVC) as! PaypalVC
            members.dic3 = self.dic3
            members.withImg = self.withImg
            members.parentViewType = self.parentViewType
            
            
        }
        if tabTitles[index] == "DEBIT/CREDIT CARD"{
            let members = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .cardVC) as! CardVC
            members.dic3 = self.dic3
            members.withImg = self.withImg
            members.parentViewType = self.parentViewType
            
            
        }
    }
    func pageViewController(_ pageViewController: RGPageViewController, viewControllerForPageAt index: Int) -> UIViewController? {
        print(tabCountArr)
        print(tabTitles)
        
        var count = ""
        if tabCountArr.count != 0 {
            count = tabCountArr[index]
        }
        
        
        print(tabTitles[index])
        if tabTitles[index] == "PAYPAL"{
            let members = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .paypalVC) as! PaypalVC
            members.dic3 = self.dic3
            members.withImg = self.withImg
            members.parentViewType = self.parentViewType
            return members
            
        }
        if tabTitles[index] == "DEBIT/CREDIT CARD"{
            let members = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .cardVC) as! CardVC
            members.dic3 = self.dic3
            members.withImg = self.withImg
            members.parentViewType = self.parentViewType
            return members
            
        }
       
        
        let home = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .exapmleVC)
        return home
    }
    
    
    func pageViewController(_ pageViewController: RGPageViewController, widthForTabAt index: Int) -> CGFloat {
        
        if DeviceType.iPad {
            //            return tabbarWidth
            if tabTitles.count == 2{
                return ScreenSize.screenWidth/2
            }
            let label = UILabel(frame: CGRect.zero)
            label.text = tabTitles[index]
            label.font = UIFont.systemFont(ofSize: 17)
            label.sizeToFit()
            let size = label.bounds.size
            return size.width + 30
        } else {
            if tabTitles.count == 2{
                return ScreenSize.screenWidth/2
            }
            let label = UILabel(frame: CGRect.zero)
            label.text = tabTitles[index]
            label.font = UIFont.systemFont(ofSize: 17)
            label.sizeToFit()
            let size = label.bounds.size
            return size.width + 30
            
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: -  LOAD PROFILE
    func loadProfile(){
        self.tabTitles.removeAll()
        self.tabCountArr.removeAll()
//        self.tabTitles.insert("PAYPAL", at: 0)
//        self.tabCountArr.insert("", at: 0)
        self.tabTitles.insert("DEBIT/CREDIT CARD", at: 0)
        self.tabCountArr.insert("", at: 0)
//        self.reloadData()
        var method = ""
        var dic = Dictionary<String,AnyObject>()
//        if tabProfileType == .group{
//            method = "groups/view"
//            dic["group_id"] = id as AnyObject
//        }
//        if tabProfileType == .member{
//            method = "user/profile/\(id!)"
//            if action_id != nil {
//                if action_id != 0 {
//                    dic["action_id"] = action_id! as AnyObject
//                }
//
//            }
//        }
//        if tabProfileType == .event{
//
//            method = "events/view"
//            dic["event_id"] = id as AnyObject
//        }
//        if tabProfileType == .job{
//
//            method = "jobs/view"
//            dic["job_id"] = id as AnyObject
//
//        }
//        print("\(method) \n \(dic)")
//        if self.navigationController?.view == nil {
//            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
//        } else {
//            Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
//        }
//
//        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
//
//            if self.navigationController?.view == nil {
//                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
//            } else {
//                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
//            }
//
//
//            print(response)
//            if let error = response["error"] as? Bool{
//                if error {
//                    let message = response["message"] as? String
//                    //Utilities.showAlertWithTitle(title: "Sorry", withMessage: message!, withNavigation: self)
//                    Alertift.alert(title: "Sorry", message: message!)
//                        .action(.default("OK")) {
//                            self.navigationController?.popViewController(animated: true)
//
//                        } .show()
//                }
//            }
//            if let body = response["body"] as? Dictionary<String,AnyObject>{
//                if let gutter = body["gutterMenu"] as? [Dictionary<String,AnyObject>]{
//                    for gut in gutter{
//                        let model = GutterMenuModel.init(gut)
//                        self.guttermenu.append(model)
//                    }
//                }
//                self.tabTitles.removeAll()
//                self.tabCountArr.removeAll()
//                let response = body["response"] as! Dictionary<String, AnyObject>
//
//                self.profileData = TabProfileObject.init(body)
//                self.tabProfileObj = self.profileData
//                self.response = self.profileData.response
//
//                for gut in self.profileData.profile_tabs{
//                    if /*gut.label == "Info" || gut.label == "Forum Posts" ||*/ gut.label == "Polls" {
//
//
//                    }else{
//                        //                        var str = ""
//                        //                        if gut.totalItemCount != nil{
//                        //                            str = "\(gut.label)(\(String(describing: gut.totalItemCount!)))"
//                        //                        }else{
//                        //                            str = gut.label
//                        //                        }
//                        var count = ""
//                        if gut.totalItemCount != nil {
//                            count = String(describing: gut.totalItemCount!)
//                        }
//
//                        if count == ""{
//                            self.tabCountArr.append("")
//                            self.tabTitles.append(gut.label)
//                        } else if count == "0" {
//                            //                            self.embeddedViewController.tabCountArr.append("")
//                            //                            self.embeddedViewController.tabTitles.append(gut.label)
//                        }
//                        else {
//                            let lbl = "\(gut.label) (\(count))"
//                            self.tabCountArr.append(count)
//                            self.tabTitles.append(lbl)
//                        }
//
//                    }
//
//                }
//                print(self.tabTitles)
//                print(self.tabCountArr)
//
//                //                self.tabTitles.insert("Timeline", at: 0)
//                //                self.tabCountArr.insert("", at: 0)
//
//
//
//                self.tabTitles.insert("PAYPAL", at: 0)
//                self.tabCountArr.insert("", at: 0)
//                self.tabTitles.insert("DEBIT/CREDIT CARD", at: 0)
//                self.tabCountArr.insert("", at: 0)
//                self.reloadData()
//            }
//        }) { (response) in
//            if self.navigationController?.view == nil {
//                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
//            } else {
//                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
//            }
//            print(response)
//        }
        
    }
}
