//
// LaunchVC.swift
// SocialNet
//
// Created by musharraf on 02/01/2018.
// Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

var app_header_bg = ""
var app_header_color = ""
var app_drawer_heading_bg = ""
var app_drawer_heading_color = ""
var app_drawer_bg = ""
var app_drawer_color = ""
var app_drawer_icon = ""
var app_tabs_bg = ""
var app_tabs_active = ""
var app_tabs_color = ""
var app_light_bg = ""
var app_dark_bg = ""
var app_unread_color = ""
var app_links_color = ""


let app = UIApplication.shared.delegate as! AppDelegate

class LaunchVC: UIViewController {
    var toastLabel = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        let params = Dictionary<String,AnyObject>()
        ALFWebService.sharedInstance.doGetData(parameters: params, method: "/app/setting", success: { (response) in
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    if let admob_app = body!["ios_admob_appid"] as? String
                    {
                        admob_appid = admob_app
                    }
                    if let admob_unit = body!["ios_admob_unitid"] as? String
                    {
                        admob_unitid = admob_unit
                    }
                    if let facebook_log = body!["facebook_login"] as? Bool
                    {
                        facebook_login = facebook_log
                    }
                    if let twitter_log = body!["twitter_login"] as? Bool
                    {
                        twitter_login = twitter_log
                    }
                    if let app_header_b = body!["app_header_bg"] as? String
                    {
                        app_header_bg = app_header_b
                    }
                    if let app_header_col = body!["app_header_color"] as? String
                    {
                        app_header_color = app_header_col
                    }
                    if let app_drawer_heading_b = body!["app_drawer_heading_bg"] as? String
                    {
                        app_drawer_heading_bg = app_drawer_heading_b
                    }
                    if let app_drawer_heading_col = body!["app_drawer_heading_color"] as? String
                    {
                        app_drawer_heading_color = app_drawer_heading_col
                    }
                    if let app_drawer_b = body!["app_drawer_bg"] as? String
                    {
                        app_drawer_bg = app_drawer_b
                    }
                    if let app_drawer_col = body!["app_drawer_color"] as? String
                    {
                        app_drawer_color = app_drawer_col
                    }
                    if let app_drawer_ic = body!["app_drawer_icon"] as? String
                    {
                        app_drawer_icon = app_drawer_ic
                    }
                    if let app_tabs_b = body!["app_tabs_bg"] as? String
                    {
                        app_tabs_bg = app_tabs_b
                    }
                    if let app_tabs_act = body!["app_tabs_active"] as? String
                    {
                        app_tabs_active = app_tabs_act
                    }
                    if let app_tabs_col = body!["app_tabs_color"] as? String
                    {
                        app_tabs_color = app_tabs_col
                    }
                    if let app_light_b = body!["app_light_bg"] as? String
                    {
                        app_light_bg = app_light_b
                    }
                    if let app_dark_b = body!["app_dark_bg"] as? String
                    {
                        app_dark_bg = app_dark_b
                    }
                    if let app_unread_col = body!["app_unread_color"] as? String
                    {
                        app_unread_color = app_unread_col
                    }
                    if let app_links_col = body!["app_links_color"] as? String
                    {
                        app_links_color = app_links_col
                    }
                    if let ios_show_ad = body!["ios_show_ads"] as? Bool
                    {
                        ios_show_ads = ios_show_ad
                    }
                    
                    let bar = UINavigationBar.appearance()
                    if (app_header_bg != ""){
                        bar.tintColor = UIColor(hexString: app_header_bg)
                        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "FF6B00")]
                    }
                    app.isCheckLogIn()
                    
                }else if status_code == 400{
                    let bar = UINavigationBar.appearance()
                    
                    bar.tintColor = UIColor(hexString: app_header_bg)
                    bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "FF6B00")]
                    let tabBar = UITabBar.appearance()
//                    tabBar.barTintColor = UIColor.white
                    let  message = response["message"] as! String
                    Utilities.showAlertWithTitle(title: "Alert", withMessage: message, withNavigation: self)
                    app.isCheckLogIn()
                }
            }
        }) { (response) in
            print(response)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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

