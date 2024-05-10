//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import RGPageViewController

class MessageVC: RGPageViewController,RGPageViewControllerDelegate,RGPageViewControllerDataSource {
    
    let inbox = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .messageTVC) as! MessageTVC
    let sent = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .messageTVC) as! MessageTVC
    
    var tabTitles : [String] = ["Inbox","Sent"]
    var id = Int()
//    var tabProfileType = TabProfile.
    
    override var pagerOrientation: UIPageViewController.NavigationOrientation {
        get {
            if DeviceType.iPad {
//                return .vertical
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
            return UIColor(hexString: app_tabs_color)
        }
    }
    
    override var barTintColor: UIColor? {
        get {
            return UIColor(hexString: app_tabs_bg)
        }
    }
    
    override var tabbarHidden: Bool {
        get {
            return false
        }
    }
    
    override var tabStyle: RGTabStyle {
        get {
            return .inactiveFaded
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        datasource = self
        delegate = self
        
        self.navigationController?.navigationBar.topItem?.title = "Messages"
//        self.title = "Messages"
        
        if !Utilities.isGuest() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(plusTapped))
        }
        
//        btnBarBadge?.setBadge(text: "2")
//        navigationItem.rightBarButtonItem?.setBadge(text: "4")
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @objc func plusTapped(sender: UIBarButtonItem) {
        let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .composeMessageVC) as! ComposeMessageVC
        let chatNavigationController = UINavigationController(rootViewController: vc)

        self.present(chatNavigationController, animated: true, completion: nil)
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
            (tabView as! UILabel).textColor = UIColor(hexString: app_tabs_color)
            (tabView as! UILabel).sizeToFit()
//            tabView.backgroundColor = UIColor(netHex: 0x1D599C)
            
        } else {
//            tabView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 115.0, height: 164.0))
////            tabView = UIImageView(frame: CGRectMake(0.0, 0.0, 115.0, 164.0))
//            let imageName: String = tabTitles[index]
//            
//            tabView.contentMode = UIViewContentMode.scaleAspectFill
//            tabView.backgroundColor = UIColor.black
//            
//            (tabView as! UIImageView).image = UIImage(named: "\(imageName)_poster.jpg")
            
            tabView = UILabel()
            (tabView as! UILabel).font = UIFont.boldSystemFont(ofSize: 19)
            (tabView as! UILabel).text = tabTitles[index]
            (tabView as! UILabel).textColor = UIColor(hexString: app_tabs_color)
            (tabView as! UILabel).sizeToFit()

        }
        
        return tabView
        
    }
    
    func pageViewController(_ pageViewController: RGPageViewController, viewControllerForPageAt index: Int) -> UIViewController? {
        var vc: UIViewController?
        if tabTitles[index] == "Inbox"{

            
            inbox.method = "messages/inbox"

//            friends.dic["user_id"] = id as AnyObject
            inbox.height = 44
            vc = inbox
            
        }
        if tabTitles[index] == "Sent"{
           
            sent.method = "messages/outbox"
//            members.dic["group_id"] = id as AnyObject
            sent.height = 44
            vc = sent
            
        }
        return vc
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
    

    
}


