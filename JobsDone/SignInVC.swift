//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import GLNotificationBar
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import TwitterCore
import LinkedinSwift
import CoreLocation
var x: Int?
class SignInVC: UIViewController ,UITextFieldDelegate{
    
    //MARK:- IBOulets
    
    @IBOutlet weak var emailTxt: UITextField? = nil
    @IBOutlet weak var passwordTxt: UITextField? = nil
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    let loginManager = LoginManager()
    var twitter_token: String?
    var twitter_secret: String?
    var user : User!
    var code: String?
    var email: String?
    var dic = Dictionary<String,AnyObject>()
    var facebook_id: String?
    var access_token: String?
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "8166u6t163muy7", clientSecret: "MWfhGjPQMh69oHCS", state: "linkedin\(Int(Date().timeIntervalSince1970))", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://t.starsfun.com/"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//       self.navTitle(titel: "Sign In")
        //Set Delegates
        emailTxt?.delegate = self
        passwordTxt?.delegate = self
        emailTxt?.borderStyle = .none
        passwordTxt?.borderStyle = .none
        emailTxt?.becomeFirstResponder()
        if DeviceType.iPad {
//            loginViewTop.constant = 500
//            loginViewHeight.constant = 300
//            topViewHeight.constant = 100
//            emailViewBot.constant = 30
        }
//        if screenWidth == 2048 {
//            topViewHeight.constant = 100
//            backBtnHeight.constant = 34
//            backBtnWidth.constant = 34
//            titleLbl.font = UIFont.systemFont(ofSize: 30)
//            
//            loginViewHeight.constant = 300
//            loginViewTop.constant = 500
//            loginViewlead.constant = 50
//            loginViewTrail.constant = 50
//            
//            emailHeight.constant = 50
//            passHeight.constant = 50
//            
//            emailImgHeight.constant = 40
//            emailImgWidth.constant = 40
//            passImgHeight.constant = 40
//            passImgWidth.constant = 40
//            
//            signInBtnHeight.constant = 70
//            
//            forgotPassBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//            signInBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
//            
//            emailTxt?.font = UIFont.systemFont(ofSize: 25)
//            passwordTxt?.font = UIFont.systemFont(ofSize: 25)
//        }

    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TextField Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if (app_header_bg != ""){
//        signInBtn.backgroundColor = UIColor(hexString: app_header_bg )
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField
        print(nextField as Any)
        if textField.tag == 1 {
            textField.resignFirstResponder()
        }
        else if nextField != nil {
            nextField?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
      textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - SIGNIN AS GUEST
    @IBAction func SignInAsGuest(_ sender: UIButton)
    {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.goInApp()
    }
    //MARK:- IBActions
    
    @IBAction func signInBtnClicked(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "oauth_token")
        UserDefaults.standard.removeObject(forKey: "oauth_secret")
        self.view.endEditing(true)
//        if emailTxt?.text?.count == 0 || passwordTxt?.text?.count == 0{
//
//            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Fields are required", withNavigation: self)
//            return
//        }
        if emailTxt?.text?.count == 0{
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Email is required", withNavigation: self)
                    return
        }else
        {
            if !(isValidEmail(testStr: (emailTxt?.text)!))
            {
                Utilities.showAlertWithTitle(title: "Validation", withMessage: "Enter Valid Email", withNavigation: self)
                return
            }
        }
        if(passwordTxt?.text?.count == 0)
        {
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Password is required", withNavigation: self)
            return
        }else if ((passwordTxt?.text?.count)! < 6)
        {
            Utilities.showAlertWithTitle(title: "Validation", withMessage: "Password must be at least 6 characters", withNavigation: self)
            return
        }
        var dic = Dictionary<String,AnyObject>()
        let method = "login?subscriptionForm=1"
        if device_token != "" {
            print(device_token)
            dic["device_token"] = device_token as AnyObject
            print(dic)
        }
        if deviceUdid != "" {
            dic["device_uuid"] = deviceUdid as AnyObject
            print(dic)
        }
        dic["email"] = emailTxt?.text as AnyObject
        dic["password"] = passwordTxt?.text as AnyObject
        dic["ip"] = "127.0.0.1" as AnyObject
        dic["device_type"] = "ios" as AnyObject
        print(dic)
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let scode = response["status_code"] as? Int {
                if scode == 200 {
                    if let body = response["body"] as? Dictionary<String, AnyObject> {
                        if let pkgId = body["package_id"] as? Int{
                            if pkgId == 0{
                                let secret = body["secret"] as? String
                                let token = body["token"] as? String
                                let userId = body["user_id"] as? Int
                             UserDefaults.standard.set(token, forKey: "oauth_token")
                            UserDefaults.standard.set(secret, forKey: "oauth_secret")
                                UserDefaults.standard.set(userId, forKey: "id")
                                let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .membershipVC) as! MembershipVC
                                    con.withImg = false
                                    con.paymentType = .SIGNIN
                                self.navigationController?.pushViewController(con, animated: true)
                            }
                        }
                        if let usr = body["user"] as? Dictionary<String, AnyObject> {
                             self.user = User.init(fromDictionary: usr)
                            if let loc = body["location"]as? String{
                                let geoCoder = CLGeocoder()
                                geoCoder.geocodeAddressString(loc) { (placemarks, error) in
                                    guard
                                        let placemarks = placemarks,
                                        let location = placemarks.first?.location
                                        else { return }
                                    print(location)
                                    var dic = Dictionary<String,AnyObject>()
                                    dic["latitude"] = location.coordinate.latitude as AnyObject
                                    dic["longitude"] = location.coordinate.longitude as AnyObject
                                
                                    
                                    let myLocation = LocationParam.init(fromDictionary: dic)
                                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: myLocation)
                                    UserDefaults.standard.set(encodedData, forKey: "locationParams")
                                    // Use your location
                                }
                                
                            }else{
                               if let loc = body["location"]as? Dictionary<String,AnyObject>{
                                   let myLocation = LocationParam.init(fromDictionary: loc)
                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: myLocation)
                                   UserDefaults.standard.set(encodedData, forKey: "locationParams")
                                }
                            }
                            if (self.user.phoneVerified != nil){
                                if self.user.phoneVerified! == 0{
                                    UserDefaults.standard.set(false, forKey: "phone_verified")
                                }else{
                                   UserDefaults.standard.set(true, forKey: "phone_verified")
                                }
                            }
                            
                            if let oauth_token = body["oauth-token"] as? String{
                                if let oauth_secret = body["oauth-secret"] as? String{
                                    self.user.oauthToken = oauth_token
                                    self.user.oauthSecret = oauth_secret
                                }
                            }
                            UserDefaults.standard.set((self.emailTxt?.text)!, forKey: "email")
                            UserDefaults.standard.set(self.user.oauthToken, forKey: "oauth_token")
                            UserDefaults.standard.set(self.user.oauthSecret, forKey: "oauth_secret")
                            UserDefaults.standard.set(self.user.displayname, forKey: "name")
                            UserDefaults.standard.set(self.user.userId, forKey: "id")
                            UserDefaults.standard.set(self.user.image, forKey: "image")
                            UserDefaults.standard.set(self.user.timezone, forKey: "timezone")
                            UserDefaults.standard.set(self.user.locale, forKey: "locale")
                            if self.user.phone != nil{
                                if self.user.phone!.count > 0{}
                            UserDefaults.standard.set(self.user.phone!, forKey: "phone")
                            }
                            if self.user.levelId != nil{
                            UserDefaults.standard.set(self.user.levelId!, forKey: "level_id")
                            }
                            let app = UIApplication.shared.delegate as! AppDelegate
                            app.isCheckLogIn()
                        }
                    }
                }
//                else if scode == 401 {
//                    let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .membershipVC) as! MembershipVC
//                    con.withImg = false
//                    con.paymentType = .SIGNIN
//                    self.navigationController?.pushViewController(con, animated: true)
//                    
//                }
                else {
                    if let message = response["message"] as? String {
                        Utilities.showAlertWithTitle(title: "Error", withMessage: message, withNavigation: self)
                    }
                    
                }
            }
            
        }) { (response) in
            print(response)
        }
        
    }
    
    @IBAction func signUpSelects(_ sender: Any) {
        
        
//        let con = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .signUpVC)
//        let nac = UINavigationController(rootViewController: con)
        //        self.present(nac, animated: true, completion: nil)
//        self.navigationController?.pushViewController(con, animated: true)
        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .signUPTblVC)
        let nac = UINavigationController(rootViewController: con)
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    
    @IBAction func loginWithFBClicked(_ sender: Any) {
        
        
//        loginManager.logIn(permissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
//            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
//            
//            if error != nil
//            {
//                print("error occured with login \(String(describing: error?.localizedDescription))")
//                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
//            }
//                
//            else if (result?.isCancelled)!
//            {
//                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
//                print("login canceled")
//            }
//                
//            else
//            {
//                if FBSDKAccessToken.current != nil
//                {
//                    
//                    FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, userResult, error) in
//                        
//                        
//                        if error != nil
//                        {
//                            print("error occured \(String(describing: error?.localizedDescription))")
//                        }
//                        else if userResult != nil
//                        {
//                            print("Login with FB is success")
//                            print(userResult! as Any)
//                            print(FBSDKAccessToken.current().tokenString)
//                            
//                            
//                            if let data = userResult as? Dictionary<String, AnyObject> {
//                                
//                                //                                UserDefaults.standard.set(data["email"]!, forKey: "fb_email")
//                                UserDefaults.standard.set(data["name"]!, forKey: "name")
//                                UserDefaults.standard.set(data["id"]!, forKey: "fb_id")
//                                UserDefaults.standard.set(data["first_name"]!, forKey: "first_name")
//                                UserDefaults.standard.set(data["last_name"]!, forKey: "last_name")
//                                
//                                if data["email"] != nil{
//                                self.email = String(describing: data["email"]!)
//                                }
//                                if self.email != nil {
//                                UserDefaults.standard.set(self.email!, forKey: "fb_email")
//                                }
//                                self.facebook_id = String(describing: data["id"]!)
//                                self.code = "%2520"
//                                self.access_token = FBSDKAccessToken.current().tokenString
//                                UserDefaults.standard.set(self.code, forKey: "code")
//                                
//                                UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: "fb_token")
//                                
//                                if let pic = data["picture"] as? Dictionary<String, AnyObject> {
//                                    if let in_data = pic["data"] as? Dictionary<String, AnyObject> {
//                                        UserDefaults.standard.set(in_data["url"]!, forKey: "image")
//                                    }
//                                }
//                                
//                                
//                            }
//                            
//                            if device_token != "" {
//                                print(device_token)
//                                self.dic["device_token"] = device_token as AnyObject
//                                
//                            }
//                            if deviceUdid != "" {
//                                self.dic["device_uuid"] = deviceUdid as AnyObject
//                            }
//                            self.dic["email"] = self.email as AnyObject
//                            self.dic["facebook_uid"] = self.facebook_id as AnyObject
//                            self.dic["access_token"] = self.access_token as AnyObject
//                            self.dic["code"] = self.code as AnyObject
//                            self.dic["ip"] = "127.0.0.1" as AnyObject
//                            self.dic["device_type"] = "ios" as AnyObject
//                            let type = "facebook"
//                            if self.email == nil{
//                                self.email = ""
//                            }
//                            self.loginSocialMethod(type: type,email: self.email!, dic: self.dic)
//                        }
//                    })
//                }
//            }
//        }
    }
    @IBAction func loginWithTwitterClicked(_ sender: Any)
    {
        x = 4
        TWTRTwitter.sharedInstance().logIn{ session, error in
            
            
            if (session != nil) {
                print(session as Any)
                print("signed in as \(session!.userName)");
                self.twitter_token = session?.authToken
                self.twitter_secret = session?.authTokenSecret
                let client = TWTRAPIClient.withCurrentUser()
                
                let request = client.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/account/verify_credentials.json", parameters: ["include_entities": "false", "include_email": "true", "skip_status": "true"], error: nil)
                client.sendTwitterRequest(request) { response, data, connectionError in
                    Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
                    print(response as Any)
                    print(data as Any)
                    if connectionError != nil {
                        Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                        print("Error: \(String(describing: connectionError))")
                        
                    }else{
                        do {
                            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                            let twitterJson = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                            print("json: \(twitterJson)")
                            let name = twitterJson["name"]
                            let firstName = name?.components(separatedBy: " ").first
                            let lastName = name?.replacingOccurrences(of: firstName!, with: "")
                            UserDefaults.standard.set(firstName!, forKey: "last_name")
                            UserDefaults.standard.set(lastName!, forKey: "first_name")
                            UserDefaults.standard.set(twitterJson["id"]!, forKey: "twitter_id")
                            UserDefaults.standard.set(self.twitter_token, forKey: "twitter_token")
                            UserDefaults.standard.set(self.twitter_secret, forKey: "twitter_secret")
                            
                            let twitter_uid = twitterJson["id"] as? Int
                            self.email = String(describing: twitterJson["email"]!)
                            UserDefaults.standard.set(self.email!, forKey: "twitter_email")
                            UserDefaults.standard.set(twitter_uid, forKey: "twitter_id")
                            if twitterJson["profile_image_url_https"] as? String != "https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png" && twitterJson["profile_image_url_https"] != nil {
                                if let in_data = twitterJson["profile_image_url_https"] as? String {
                                    UserDefaults.standard.set(in_data, forKey: "image")
                                }
                            }
                            if device_token != "" {
                                print(device_token)
                                self.dic["device_token"] = device_token as AnyObject
                                
                            }
                            if deviceUdid != "" {
                                self.dic["device_uuid"] = deviceUdid as AnyObject
                                
                            }
                            
                            self.dic["email"] = self.email as AnyObject
                            self.dic["twitter_uid"] = twitter_uid as AnyObject
                            self.dic["twitter_token"] = self.twitter_token as AnyObject
                            self.dic["twitter_secret"] = self.twitter_secret as AnyObject
                            self.dic["ip"] = "127.0.0.1" as AnyObject
                            self.dic["device_type"] = "ios" as AnyObject
                            let type = "twitter"
                            self.loginSocialMethod(type: type,email: self.email!, dic: self.dic)
                            
                        } catch let jsonError as NSError {
                            print("json error: \(jsonError.localizedDescription)")
                            
                        }
                    }
                    
                }
                
            } else {
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print("error: \(error!.localizedDescription)");
            }
            //
            //
            //        }
            
        }
    }
    //MARK: - LOGIN WITH LINKEDIN
    @IBAction func LoginWithLinkedin(_ sender: UIButton) {
        
        linkedinHelper.authorizeSuccess({(lsToken) -> Void in
            
            print("Login success lsToken: \(lsToken)")
            UserDefaults.standard.set(lsToken.accessToken!, forKey: "linkedin_token")
            self.dic["access_token"] = lsToken.accessToken! as AnyObject
            self.linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
                print("Request success with response: \(response)")
                let a = response.jsonObject
                UserDefaults.standard.set(a!["emailAddress"]!, forKey: "linkedin_email")
                self.dic["email"] = a!["emailAddress"] as AnyObject
                UserDefaults.standard.set(a!["lastName"], forKey: "last_name")
                UserDefaults.standard.set(a!["firstName"], forKey: "first_name")
                let position = a!["positions"] as? Dictionary<String,AnyObject>
                let values = position!["values"] as? [Dictionary<String,AnyObject>]
                let par = values![0] as? Dictionary<String,AnyObject>
                UserDefaults.standard.set(par!["id"] as! NSNumber, forKey: "linkedin_id")
                self.dic["linkedin_uid"] = par!["id"] as AnyObject
                self.dic["ip"] = "127.0.0.1" as AnyObject
                self.dic["device_type"] = "ios" as AnyObject
                self.dic["social"] = "linkedIn" as AnyObject
                self.dic["identifier"] = par!["id"] as AnyObject
                let type = "linkedin"
                self.loginSocialMethod(type: type,email: a!["emailAddress"] as! String, dic: self.dic)
//                UserDefaults.standard.set(self.twitter_secret, forKey: "twitter_secret")
//                self.lnData.updateValue(a?["pictureUrl"] as AnyObject, forKey: "image")
//                print(self.lnData)
                
                
            }) {(error) -> Void in
                
                print("Encounter error: \(error.localizedDescription)")
            }
            
        }, error: {(error) -> Void in
            
            print("Encounter error: \(error.localizedDescription)")
        }, cancel: {() -> Void in
            
            print("User Cancelled")
        })
        
        
    }
    
    
    func loginSocialMethod(type: String,email: String, dic: Dictionary<String, Any>){
        
        //        let dic = ["email": email, "facebook_uid": fb_id, "access_token": access_token, "code": code, "ip": ip] as Dictionary<String, AnyObject>
        
        print(dic)
        ALFWebService.sharedInstance.doPostData(parameters: dic as Dictionary<String, AnyObject>, method: "login", success: { (response) in
            print(response)
            if let status_code = response["status_code"] as? Int {
                if status_code == 200 {
                    if let body = response["body"] as? Dictionary<String, AnyObject> {
                        
                        if (body["account"] as? [Dictionary<String, AnyObject>]) != nil {
                            
                            let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .signUPTblVC) as! SignUpTblVC
                            if type == "facebook"
                            {
                                con.cameFromTw = false
                                con.cameFromFb = true
                            }else if type == "twitter"
                            {
                                con.cameFromTw = true
                                con.cameFromFb = false
                            }else if type == "linkedin"
                            {
                                con.cameFromTw = false
                                con.cameFromFb = false
                                con.cameFromLi = true
                            }
                            //                                    let nac = UINavigationController(rootViewController: con)
                            //                                    self.present(nac, animated: true, completion: nil)
                            self.navigationController?.pushViewController(con, animated: true)
                            
                        } else if let usr = body["user"] as? Dictionary<String, AnyObject> {
                            self.user = User.init(fromDictionary: usr)
                            
                            if let oauth_token = body["oauth-token"] as? String{
                                if let oauth_secret = body["oauth-secret"] as? String{
                                    self.user.oauthToken = oauth_token
                                    self.user.oauthSecret = oauth_secret
                                }
                            }
                            
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(self.user.oauthToken, forKey: "oauth_token")
                            
                            UserDefaults.standard.set(self.user.oauthSecret, forKey: "oauth_secret")
                            UserDefaults.standard.set(self.user.displayname, forKey: "name")
                            UserDefaults.standard.set(self.user.userId, forKey: "id")
                            UserDefaults.standard.set(self.user.image, forKey: "image")
                            UserDefaults.standard.set(self.user.timezone, forKey: "timezone")
                            UserDefaults.standard.set(self.user.locale, forKey: "locale")
                            
                            let app = UIApplication.shared.delegate as! AppDelegate
                            app.isCheckLogIn()
                        }
                        
                    }
                } else if status_code == 404 {
                    Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Another account already exists with same email. Please either login with email or connect that account with facebook", withNavigation: self)
                }
                
            }
            
            
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }) { (response) in
            print(response)
        }
        
    }
    @IBAction func forgetPassBtnClicked(_ sender: Any) {
        let vc = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .forgotPassVC) as! ForgotPassVC
        self.navigationController?.pushViewController(vc, animated: true)
//        let alert = UIAlertController(title: "Alert", message: "Please enter your email to reset your password", preferredStyle: .alert)
//        alert.addTextField { (textField) in
//            if self.emailTxt?.text == "" {
//                textField.text = ""
//
//            } else {
//                textField.text = self.emailTxt?.text
//
//            }
//
//        }
//        let textField = alert.textFields![0]
//        var oauth_token: String?
//        var oauth_secret: String?
//        if (UserDefaults.standard.value(forKey: "oauth_token") != nil) {
//            oauth_token = UserDefaults.standard.value(forKey: "oauth_token") as? String
//        }
//        if (UserDefaults.standard.value(forKey: "oauth_secret") != nil) {
//            oauth_secret = UserDefaults.standard.value(forKey: "oauth_secret") as? String
//        }
//
//        let action = UIAlertAction(title: "OK", style: .default, handler: { alrt in
//
//            let dic = ["email": textField.text as AnyObject, "oauth_token": oauth_token as AnyObject, "oauth_secret": oauth_secret as AnyObject] as Dictionary<String,AnyObject>
//            ALFWebService.sharedInstance.doPostData(parameters: dic, method: "forgot-password", success: { (response) in
//
//                print(response)
//
//                let info = response as? Dictionary<String,AnyObject>
//                let success = info?["success"] as? Bool
////                let message = info?["message"] as? String
//
//                let notificationBar = GLNotificationBar(title: "Reset Password", message: "Please Check your email to reset password.", preferredStyle: .simpleBanner , handler: { (notify) in
//                    print("selected")
//
//                })
//
//                notificationBar.showTime(3)
//                if success == true {
//
//                } else {
//
//
//                }
//
//            }, fail: { (response) in
//
//                print(response)
//
//            })
//        })
//        let cancelActForIPhone = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: { (action) in
//
//        })
//        let cancelActForIPad = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
//
//        })
//        alert.addAction(action)
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
//            alert.addAction(cancelActForIPad)
//        } else {
//            alert.addAction(cancelActForIPhone)
//        }
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
//            if let popoverPresentationController = alert.popoverPresentationController {
//
//                popoverPresentationController.sourceView = self.view
//
//                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
//                //
//                popoverPresentationController.permittedArrowDirections = []
//
//
//
//            }
//            self.present(alert, animated: true, completion: nil)
//
//        } else {
//            self.present(alert, animated: true, completion: nil)
//        }
        
    }
    
    @IBAction func goBackBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
