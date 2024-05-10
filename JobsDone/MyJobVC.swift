//
//  MyJob.swift
//  JobsDone
//
//  Created by musharraf on 08/03/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import RGPageViewController

class MyJobVC: RGPageViewController,RGPageViewControllerDelegate,RGPageViewControllerDataSource {
    
    var tabTitles : [String] = [String]()
    var camefrom = ""
    
    override var pagerOrientation: UIPageViewController.NavigationOrientation {
        get {
            if DeviceType.iPad {
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
    
    //    override var tabIndicatorWidthOrHeight: CGFloat{
    //        get{
    //            return 2.0
    //        }
    //    }
    
    override var tabbarPosition: RGTabbarPosition {
        get {
            if DeviceType.iPad {
                //                return .right
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
            return UIColor(hexString: app_header_bg)
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
    var navTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        datasource = self
        delegate = self
        let img = #imageLiteral(resourceName: "back_white")
        let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(self.RemoveAll(_:)))
        self.navigationItem.leftBarButtonItem = btn
//        self.addBackbutton(title: "Back")
        self.navigationItem.title = navTitle
    }
    
    @objc func RemoveAll(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func numberOfPages(for pageViewController: RGPageViewController) -> Int {
        
        return tabTitles.count
    }
    
    func pageViewController(_ pageViewController: RGPageViewController, tabViewForPageAt index: Int) -> UIView {
        var tabView: UIView!
        if !DeviceType.iPad {
            tabView = UILabel()
            
            (tabView as! UILabel).font = UIFont.systemFont(ofSize: 17)
            (tabView as! UILabel).text = tabTitles[index]
            //            (tabView as! UILabel).textColor = UIColor(netHex: 0x1D599C)
            (tabView as! UILabel).textColor = UIColor(hexString: app_header_bg)
            (tabView as! UILabel).sizeToFit()
            //            tabView.backgroundColor = UIColor(netHex: 0x1D599C)
            
        } else {
            tabView = UILabel()
            
            (tabView as! UILabel).font = UIFont.systemFont(ofSize: 17)
            (tabView as! UILabel).text = tabTitles[index]
            //            (tabView as! UILabel).textColor = UIColor(netHex: 0x1D599C)
            (tabView as! UILabel).textColor = UIColor(hexString: app_header_bg)
            (tabView as! UILabel).sizeToFit()
        }
        
        return tabView
        
    }
    
    func pageViewController(_ pageViewController: RGPageViewController, viewControllerForPageAt index: Int) -> UIViewController? {
        
       let menu = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .HomeTVC) as! HomeTVC
        if camefrom == "invitation"{
            menu.space = 50
        }
                let title = tabTitles[index]
                if title == "INVITATIONS"{
                    let menu = UIStoryboard.storyBoard(withName: .MyJob).loadViewController(withIdentifier: .jobInvitationVC) as! JobInvitationVC
                    menu.jobType = .UNANSWERED
                    return menu
                }
                if title == "APPLIED"{
                    menu.jobType = .APPLIEDJOBS
                    let nav = UINavigationController(rootViewController: menu)
                    return nav
        
                }
                if title == "RUNNING"{
                    
                    menu.jobType = .RUNNING
                    let nav = UINavigationController(rootViewController: menu)
                    return nav
                }
                if title == "COMPLETED"{
                    menu.jobType = .COMPLETED
                    if !onceLoaded{
                        if UserDefaults.standard.value(forKey: "level_id") as? Int == 7 || UserDefaults.standard.value(forKey: "level_id") as? Int == 8{
                            menu.space = 50
                        }
                    }else{
                        menu.space = 0
                    }
                    let nav = UINavigationController(rootViewController: menu)
                    return nav
                }
                if title == "POSTED"{
                    menu.jobType = .POSTED
                    if !onceLoaded{
                        if UserDefaults.standard.value(forKey: "level_id") as? Int == 7 || UserDefaults.standard.value(forKey: "level_id") as? Int == 8{
                            menu.space = 50
                        }
                    }else{
                        menu.space = 0
                    }
                    let nav = UINavigationController(rootViewController: menu)
                    return nav
                }
             let nav = UINavigationController(rootViewController: menu)
                return nav
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
    
}
