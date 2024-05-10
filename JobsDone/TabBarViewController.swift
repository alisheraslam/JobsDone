//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit


let screenWidth = UIScreen.main.nativeBounds.width

class TabBarViewController: UITabBarController,UITabBarControllerDelegate,UINavigationControllerDelegate {

    
    let fonAtt = [NSAttributedString.Key.foregroundColor:UIColor.init(netHex: 0xE5E5E5), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10.0)]
    
    init() {
        // perform some initialization here
        super.init(nibName: nil, bundle: nil)

 
        let home = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .HomeTVC)
        home.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"))
        home.tabBarItem.title = nil
        home.tabBarItem.tag = 0
        home.tabBarItem.imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        let homeNav = UINavigationController(rootViewController: home)
        
  
        
        let friends = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .AllMessageVC)
        friends.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "chat"), selectedImage: #imageLiteral(resourceName: "chat"))
        friends.tabBarItem.title = nil
        friends.tabBarItem.tag = 1
        friends.tabBarItem.imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        let friendsNav = UINavigationController(rootViewController: friends)
        
  
        
        let messages = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .IdeaBoardTVC)
        messages.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "bulb"), selectedImage: #imageLiteral(resourceName: "bulb"))
        messages.tabBarItem.title = nil
                messages.tabBarItem.tag = 3
        messages.tabBarItem.imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        let messagesNav = UINavigationController(rootViewController: messages)

        
        let meProfile = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .FindProfessionalVC)
        meProfile.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "professionals_search"), selectedImage: #imageLiteral(resourceName: "professionals_search"))
        meProfile.tabBarItem.title = nil
        meProfile.tabBarItem.tag = 4
        meProfile.tabBarItem.imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        let meProfileNav = UINavigationController(rootViewController: meProfile)

        
        
        self.tabBar.tintColor = UIColor(hexString: app_header_bg)
        
//        self.tabBar.barTintColor = UIColor(netHex: 0x46AD70)
        
        
        
        viewControllers = [homeNav,meProfileNav,messagesNav,friendsNav]
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       self.delegate = self
        
        

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if screenWidth == 2048 {
            self.tabBar.itemSpacing = CGFloat(UITabBar.ItemPositioning.automatic.rawValue)
            self.tabBarItem.imageInsets =  UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
            self.tabBarItem.title = nil
            self.tabBar.itemSpacing = UIScreen.main.bounds.width / 8
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        
        _ = viewController.tabBarItem.tag
        
    }
    
    private func findSelectedTagForTabBarController(tabBarController: UITabBarController?) {
        
        if let tabBarController = tabBarController {
            if let viewControllers = tabBarController.viewControllers {
                let selectedIndex = tabBarController.selectedIndex
                let selectedController: UIViewController? = viewControllers.count > selectedIndex ? viewControllers[selectedIndex] : nil
                if let tag = selectedController?.tabBarItem.tag {
                    //here you can use your tag
                    print(tag)
                }
            }
        }
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        //findSelectedTagForTabBarController(navigationController.tabBarController)
        print("print \(viewController)")
        
        
    }

}
