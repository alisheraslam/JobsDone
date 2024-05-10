// @BundleId SocialNet iOS App
// @copyright Copyright 2017-2022 Stars Developer
// @license https://starsdeveloper.com/license/
// @version 2.0 2017-11-10
// @author Stars Developer, Lahore, Pakistan

import UIKit
import CoreData
import FBSDKLoginKit
import FBSDKCoreKit
import UserNotifications
import GLNotificationBar
import TwitterKit
import TwitterCore
import SlideMenuControllerSwift
import GoogleMaps
import GooglePlaces


var loadMenu = true
var place: CLPlacemark?
var locationGot = false
var deviceUdid = ""
var device_token = ""

var admob_appid = ""
var admob_unitid = ""
var facebook_login: Bool?
var twitter_login: Bool?
var ios_show_ads: Bool?
var onceLoaded = false
let vc =  SkillVC(nibName: "SkillVC", bundle: nil)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    
    var dic = Dictionary<String, AnyObject>()
    var chatRepeater : Timer!
    var tabRepeater : Timer!
    var timeInterval : TimeInterval = 10
    var isPaused = false
    var isChat = false
    var locationManager:CLLocationManager!
    var notificationCountRepeater : Timer!
    var timeIntervalForNotifications : TimeInterval = 30
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        deviceUdid = UIDevice.current.identifierForVendor!.uuidString
        print(deviceUdid)
        UserDefaults.standard.set(deviceUdid, forKey: "device_uuid")
//        UIApplication.shared.statusBarStyle = .lightContent
//        if let statusbar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
//            statusbar.backgroundColor = UIColor(hexString: "FF6B00")
//        }

        registerNotification(application: application)
        TWTRTwitter.sharedInstance().start(withConsumerKey:"phYNOSadugIpvyaaEayucfiP2", consumerSecret: "aRFm4Xsf7fDplo82r3zO5a0JGu6fvp3hguN0MT7ieuIrd7Q6eA")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .launchVC)
        vc.view.contentMode = .scaleToFill
//        let nac = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = vc
        
        self.window?.makeKeyAndVisible()
        self.window?.isUserInteractionEnabled = true
//        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AT3odGApsJPI63Xg8A1sRgDHxf7Is3WmSSLovf2qlCVSpWiEDyFZxeOkHOBB9O4lhfKz4Jn5T7hJveAP",
//                                                                PayPalEnvironmentSandbox: "AT3odGApsJPI63Xg8A1sRgDHxf7Is3WmSSLovf2qlCVSpWiEDyFZxeOkHOBB9O4lhfKz4Jn5T7hJveAP"])
        GMSServices.provideAPIKey("AIzaSyCRwtX-JBlzKMMonL3nH4EAm2QUDQlL4Hg")
        GMSPlacesClient.provideAPIKey("AIzaSyCRwtX-JBlzKMMonL3nH4EAm2QUDQlL4Hg")
        determineMyCurrentLocation()
        return true
    }
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            print(placeMark)
            place = placeMark
            locationGot = true
            NotificationCenter.default.post(name: Notification.Name("LocationGot"), object: nil)
            // Address dictionary
            
            if placeMark != nil{
                // Location name
                if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                    print(locationName)
                }
                // Street address
                if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                    print(street)
                }
                // City
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                    print(city)
                }
                // Zip code
                if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                    print(zip)
                }
                // Country
                if let country = placeMark.addressDictionary!["Country"] as? NSString {
                    print(country)
                }
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
    func isCheckLogIn() {
        if Utilities.isLoggedIn() == true {
            let leftVC = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .LeftMenuVC) as! LeftMenuVC
            
            let slideMenuController = SlideMenuController(mainViewController: TabBarViewController(), leftMenuViewController: leftVC)
            if UserDefaults.standard.value(forKey: "level_id") as? Int != nil{
                let levelId = UserDefaults.standard.value(forKey: "level_id") as? Int
                if levelId == 7 || levelId == 8{
                    let tab = slideMenuController.mainViewController as! UITabBarController
                    tab.selectedIndex = 1
                }
                
            }
            self.window?.rootViewController = slideMenuController
            self.window?.makeKeyAndVisible()
            tabRepeater = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.repeatFunctionOfNotifications), userInfo: nil, repeats: true)
            
        }else {
            let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .signInVC)
            vc.view.contentMode = .scaleToFill
            let nac = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = nac
        }
        
    }
    
    func goInApp() {
        
        let leftVC = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .LeftMenuVC) as! LeftMenuVC
        
        let slideMenuController = SlideMenuController(mainViewController: TabBarViewController(), leftMenuViewController: leftVC)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let vc = TabBarViewController()
//        vc.view.contentMode = .scaleToFill
//        self.window?.rootViewController = vc
//        self.window?.makeKeyAndVisible()
        self.window?.isUserInteractionEnabled = true
        
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if x == 4{
            return TWTRTwitter.sharedInstance().application(application, open: url, options: options)
        }else{
            let sourceApplication: String? = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: nil)
        }
    }
    func registerNotification(application: UIApplication){
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        device_token = deviceTokenString
        
        // Persist it in your backend in case it's new
    }
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        print(data["id"] as Any)
        print(data["type"] as Any)
        
        handleNotification(data: data as! [String : Any], state: application.applicationState)
    }
    
    func handleNotification(data:[String:Any],state:UIApplication.State){
        
        let slidet = (self.window?.rootViewController as! SlideMenuController).mainViewController as! UITabBarController
        let vc = slidet.viewControllers?[slidet.selectedIndex] as! UINavigationController
        
        print(vc)
        // let vc = TabBarViewController()
        let type = data["type"]! as? String
        print(data)
        if state == .background || state == .inactive{
            
            let id = data["id"]! as? Int
            let uid = data["id"]! as? Int
            let act_id = data["id"]! as? Int
            let owner_id = data["owner_id"]! as? Int
            print(uid!)
            
            print(type!)
            if type! == "messages_conversation" {
                slidet.selectedIndex = 3
            }else if type! == "list_listing"{
                let con = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .jobDetailVC) as! JobDetailVC
                con.jobId = id
//                vc.userImg = obj.imageNormal
                con.ownerId = owner_id
                con.indexPath = IndexPath(row: 0, section: 0)
                vc.navigationController?.pushViewController(con, animated: true)
            }else if type! == "user_portfolio"{
                let con = UIStoryboard.storyBoard(withName: .Portfolio).loadViewController(withIdentifier: .portfolioProfileVC) as! PortfolioProfileVC
                con.id = id
                con.userId = owner_id
                vc.navigationController?.pushViewController(con, animated: true)
            }
            else {
                
                
            }
            
            
        }else{
            if !isChat{
                if let aps = data["aps"] as? [String:Any]{
                    if let alert = aps["alert"] as? [String:Any]{
                        if let body = alert["body"] as? String{
                            let notificationBar = GLNotificationBar(title: body, message: "", preferredStyle: .simpleBanner, handler: { (notify) in
                                print("selected")
                                self.handleNotification(data: data, state: .inactive)
                                
                            })
                            
                            notificationBar.showTime(7)
                        }
                    }
                }
            }
            
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // tabRepeater.invalidate()
        isPaused = true
        
        // if Utilities.isLoggedIn(){
        // var dic1 = Dictionary<String, AnyObject>()
        // let method = "chat/status"
        // dic1["status"] = 2 as AnyObject
        // ALFWebService.sharedInstance.doPostData(parameters: dic1, method: method, success: { (response) in
        // print(response)
        // }) { (response) in
        // print(response)
        // }
        // }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        if Utilities.isLoggedIn() {
            // self.repeatFunctionOfNotifications()
            tabRepeater = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.repeatFunctionOfNotifications), userInfo: nil, repeats: true)
        }
        if !Utilities.isGuest() {
            active()
        }
        
    }
    func active(){
        
        isPaused = false
//        repeatFunction()
//        chatRepeater = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.repeatFunction), userInfo: nil, repeats: true)
        
    }
    @objc func repeatFunctionOfNotifications(){
        
        let isLoggedIn = Utilities.isLoggedIn()
        
        if isLoggedIn == true{
            let method = "notifications/new-updates"
            let dic = Dictionary<String,AnyObject>()
            ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
                print(response)
                if let body = response["body"] as? Dictionary<String,AnyObject>{
                    
                    if let slidet = self.window?.rootViewController as? UITabBarController {
                        if let noti = body["notifications"] as? Int{
                            if noti != 0{
                                slidet.tabBar.items?[4].badgeValue = "\(String(describing: body["notifications"]!))"
                                let notis = slidet.viewControllers?[4] as! UINavigationController
                               
                               
                            }else{
//                                slidet.tabBar.items?[4].badgeValue = nil
                            }
                        }
                        
                        if let noti = body["messages"] as? Int{
                            if noti != 0{
                                slidet.tabBar.items?[2].badgeValue = "\(String(describing: body["messages"]!))"
                                
                                let notis = slidet.viewControllers?[2] as! UINavigationController
                                let notis2 = notis.viewControllers[0] as! MessageVC
                                notis2.inbox.shouldUpdate = true
                            }else{
                                slidet.tabBar.items?[2].badgeValue = nil
                            }
                        }
                        
                        if let noti = body["friend_requests"] as? Int{
                            if noti != 0{
                                slidet.tabBar.items?[3].badgeValue = "\(String(describing: body["friend_requests"]!))"
                                
                                let notis = slidet.viewControllers?[3] as! UINavigationController
                                
                            }else{
                                slidet.tabBar.items?[3].badgeValue = nil
                            }
                        }
                    }
                    
                }
            }) { (response) in
                print(response)
            }
            
        }
        
        
    }
    
    func repeatFunction(){
        
        print("repeat")
        
        
        let isLoggedIn = Utilities.isLoggedIn()
        
        if isLoggedIn == true && isPaused == false{
            
            let method = "chat"
            dic["status"] = 1 as AnyObject
            ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
                print(response)
                if self.isChat == true{
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatActivate"), object: response)
                }
                
                print(response)
            }) { (response) in
                print(response)
            }
            
        }
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        // self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // lazy var persistentContainer: NSPersistentContainer = {
    // /*
    // The persistent container for the application. This implementation
    // creates and returns a container, having loaded the store for the
    // application to it. This property is optional since there are legitimate
    // error conditions that could cause the creation of the store to fail.
    // */
    // let container = NSPersistentContainer(name: "SchoolChain")
    // container.loadPersistentStores(completionHandler: { (storeDescription, error) in
    // if let error = error as NSError? {
    // // Replace this implementation with code to handle the error appropriately.
    // // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //
    // /*
    // Typical reasons for an error here include:
    // * The parent directory does not exist, cannot be created, or disallows writing.
    // * The persistent store is not accessible, due to permissions or data protection when the device is locked.
    // * The device is out of space.
    // * The store could not be migrated to the current model version.
    // Check the error message to determine what the actual problem was.
    // */
    // fatalError("Unresolved error \(error), \(error.userInfo)")
    // }
    // })
    // return container
    // }()
    //
    // // MARK: - Core Data Saving support
    //
    // func saveContext () {
    // let context = persistentContainer.viewContext
    // if context.hasChanges {
    // do {
    // try context.save()
    // } catch {
    // // Replace this implementation with code to handle the error appropriately.
    // // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    // let nserror = error as NSError
    // fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    // }
    // }
    // }
    
}

