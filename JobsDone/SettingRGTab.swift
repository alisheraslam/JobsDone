//
//  SettingRGTab.swift
//  JobsDone
//
//  Created by musharraf on 26/02/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import RGPageViewController
class SettingRGTab: RGPageViewController,RGPageViewControllerDelegate,RGPageViewControllerDataSource {
    var proImg = ""
    var dashMenu : RighMenuModel?
    
    var id : Int!
    var numberofRow = 0
    
    var action_id: Int!
    let guttCon = GutterMenuHandler()
    
    var frmPushNot = false
   
    
    var tabTitles : [String]!
    
    
    var tabCountArr = [String]()
   
    var response = Dictionary<String,AnyObject>()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        datasource = self
        delegate = self
        self.title = "SETTINGS"
        let result = gDashMenu?.body.menus.filter{men in men.label == "Membership"}
        if result!.count > 0{
            if let id  = UserDefaults.standard.value(forKey: "level_id") as? Int{
                if id == 7 || id == 8{
                    self.tabTitles = ["PROFILE","EMAIL","PASSWORD","CHANGE PHONE","PAYMENT METHOD","NOTIFICATIONS","DELETE ACCOUNT"]
                }else{
                    self.tabTitles = ["PROFILE","SKILLS","EMAIL","PASSWORD","CHANGE PHONE","PAYMENT METHOD","NOTIFICATIONS","DELETE ACCOUNT"]
                }
            }
            
        }else{
            if let id  = UserDefaults.standard.value(forKey: "level_id") as? Int{
                if id == 7 || id == 8{
                    self.tabTitles = ["PROFILE","EMAIL","PASSWORD","CHANGE PHONE","NOTIFICATIONS","DELETE ACCOUNT"]
                }else{
                    self.tabTitles = ["PROFILE","SKILLS","EMAIL","PASSWORD","CHANGE PHONE","NOTIFICATIONS","DELETE ACCOUNT"]
                }
            }
           
        }
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
    
//    override var tabIndicatorWidthOrHeight: CGFloat {
//        return 44.0
//    }
    
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
            return UIColor(hexString: "FF6A00")
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
            (tabView as! UILabel).textColor = UIColor(hexString: "#FF6A00")
            
            (tabView as! UILabel).sizeToFit()
            //            tabView.backgroundColor = UIColor(netHex: 0x1D599C)
            
        } else {
            //            tabView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 115.0, height: 164.0))
            //            //            tabView = UIImageView(frame: CGRectMake(0.0, 0.0, 115.0, 164.0))
            //            let imageName: String = tabTitles[index]
            //
            //            tabView.contentMode = UIViewContentMode.scaleAspectFill
            //            tabView.backgroundColor = UIColor.black
            //
            //            (tabView as! UIImageView).image = UIImage(named: "\(imageName)_poster.jpg")
            
            tabView = UILabel()
            
            (tabView as! UILabel).font = UIFont.systemFont(ofSize: 17)
            (tabView as! UILabel).text = tabTitles[index]
            
            (tabView as! UILabel).textColor = UIColor(hexString: "#FF6A00")
            
            
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
        if tabTitles[index] == "Members" || tabTitles[index] == "Members (\(count))" || tabTitles[index] == "Guests" || tabTitles[index] == "Guests (\(count))"{
            //            let members = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .memberOrGuestController) as! MembersOrGuestsController
            //            members.method = "groups/member/list"
            //
            //            members.dic["group_id"] = id as AnyObject
            //            members.dic["waiting"] = 0 as AnyObject
            //            members.profileType = "group"
            
            print(pageViewController)
        }
    }
    func pageViewController(_ pageViewController: RGPageViewController, viewControllerForPageAt index: Int) -> UIViewController? {
        print(tabCountArr)
        print(tabTitles)
        
        var count = ""
        if tabCountArr.count != 0 {
            count = tabCountArr[index]
        }
        

       
        if tabTitles[index] == "PROFILE" {

            let createFormTVC = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .editProfileVC) as! EditProfileVC
            
            createFormTVC.sTypw = pluginType.myProfile
            createFormTVC.formTypeValue = .edit
            createFormTVC.pluginEditUrl = "members/edit/profile"
            return createFormTVC
            
        }
        if tabTitles[index] == "SKILLS" {
            let members = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
            return members
            
        }
        if tabTitles[index] == "EMAIL" {
            let members = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .changePasswordTVC) as! ChangePasswordTVC
            members.controllType = CONTROLLTYPE.EMAILCHANGE
            return members
            
        }
        if tabTitles[index] == "PASSWORD" {
            let members = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .changePasswordTVC) as! ChangePasswordTVC
            members.controllType = CONTROLLTYPE.PASSWORDCHANGE
            return members
            
        }
        if tabTitles[index] == "CHANGE PHONE" {
            let members = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .changePasswordTVC) as! ChangePasswordTVC
            members.controllType = CONTROLLTYPE.PHONECHANGE
            return members
            
        }
        if tabTitles[index] == "DELETE ACCOUNT"{
            let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .deleteAccountTVC) as! DeleteAccountTVC
            return vc
        }
        if tabTitles[index] == "NOTIFICATIONS"{
            let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier:.privacySettingsVC) as! PrivacySettingsViewController
            con.sType = .Notifications
            return con
        }
        if tabTitles[index] == "PAYMENT METHOD"{
            let members = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .cardVC) as! CardVC
            members.parentViewType = .PROFILE
            return members
        }
        
        
        //for Member Tabs
     
        
        let home = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .exapmleVC)
        return home
    }
    
    
    
    //    func moveNextPage()
    //    {
    //        currentTabIndex += 1
    //        selectTabAtIndex(currentTabIndex, updatePage: true)
    //    }
    //    func movePreviousPage()
    //    {
    //        currentTabIndex -= 1
    //        selectTabAtIndex(currentTabIndex, updatePage: true)
    //    }
    
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
            //            var tabSize = (tabTitles[index] as! String).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17)])
            //
            //            tabSize.width += 32
            //
            //            return tabSize.width
            
            
            //            let screenSize: CGRect = UIScreen.mainScreen().bounds
            //            let screenWidth = screenSize.width
            //            return screenWidth/5 + 15
            
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
        
        var method = ""
        var dic = Dictionary<String,AnyObject>()
      
            print(method)
            //            if frmPushNot {
            //                dic["user_id"] = id as AnyObject
            //            }
            //            dic["user_id"] = id as AnyObject
        
       
        print("\(method) \n \(dic)")
        if self.navigationController?.view == nil {
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        } else {
            Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
        }
        
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            
            if self.navigationController?.view == nil {
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            } else {
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
            }
            
            
            print(response)
            if let error = response["error"] as? Bool{
                if error {
                    let message = response["message"] as? String
                    //Utilities.showAlertWithTitle(title: "Sorry", withMessage: message!, withNavigation: self)
                    Alertift.alert(title: "Sorry", message: message!)
                        .action(.default("OK"), handler: {
                            self.navigationController?.popViewController(animated: true)
                            
                        }) .show()
                }
            }
            if let body = response["body"] as? Dictionary<String,AnyObject>{
                
                self.tabTitles.removeAll()
                self.tabCountArr.removeAll()
                let response = body["response"] as! Dictionary<String, AnyObject>
               
               
             
                
                
                print(self.tabTitles)
                print(self.tabCountArr)
                //                if self.tabProfileType == .group || self.tabProfileType == .event{
                //                    self.embeddedViewController.tabTitles.insert("Info", at: 0)
                //                    self.embeddedViewController.tabCountArr.insert("", at: 0)
                //
                //
                //                }
                self.tabTitles.insert("Stats", at: 0)
                self.tabCountArr.insert("", at: 0)
                self.tabTitles.insert("Line Up", at: 0)
                self.tabCountArr.insert("", at: 0)
        
                self.tabTitles.insert("Summary", at: 0)
                self.tabCountArr.insert("", at: 0)
                print(self.tabTitles)
                //                self.numberofRow = 1
                //                self.tableView.reloadData()
                self.reloadData()
            }
        }) { (response) in
            if self.navigationController?.view == nil {
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            } else {
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
            }
            print(response)
        }
        
    }
    
}
