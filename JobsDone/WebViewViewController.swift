// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan

import UIKit
import Alertift

class WebViewViewController: UIViewController,UIWebViewDelegate {
    var type = "web"
    var urlString = String()
    @IBOutlet weak var webView: UIWebView!
    var activityIndicator: UIActivityIndicatorView!

    //------------- view controller life cycle ----------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        print(urlString)
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action:  #selector(BackButton))
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        //webView.sd_showActivityIndicatorView()
        if type == "html"{
            webView.loadHTMLString(urlString, baseURL: nil)
        }else{
        if let url = URL(string: urlString) , urlString.count > 0 {
            
            Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
            webView.loadRequest(URLRequest(url: url))
            
        }
        else{
            //..show alert
            Alertift.alert(title: "Alert", message: "No web link found.")
                .action(.default("OK"), handler: {
                    self.navigationController?.popViewController(animated: true)
                }).show()
        }
        }
        //--- [Start: add navigationbar button items ] ---
        let btnPrev = UIButton(type: .custom)
        btnPrev.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnPrev.setImage(UIImage(named: "Previous"), for: .normal)
        btnPrev.addTarget(self, action: #selector(previousButton), for: .touchUpInside)
        btnPrev.tintColor = UIColor.white
        let navbtnPrev = UIBarButtonItem(customView: btnPrev)
        
        let btnRefresh = UIButton(type: .custom)
        btnRefresh.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnRefresh.setImage(UIImage(named: "Refresh"), for: .normal)
        btnRefresh.addTarget(self, action: #selector(refreshButton), for: .touchUpInside)
        btnRefresh.tintColor = UIColor.white
        let navbtnRefresh = UIBarButtonItem(customView: btnRefresh)
        
        let btnBack = UIButton(type: .custom)
        btnBack.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnBack.setImage(UIImage(named: "Back"), for: .normal)
        btnBack.addTarget(self, action: #selector(backBrowserButton), for: .touchUpInside)
        btnBack.tintColor = UIColor.white
        let navbtnBack = UIBarButtonItem(customView: btnBack)
        
        self.navigationItem.setRightBarButtonItems([navbtnRefresh,navbtnPrev,navbtnBack], animated: true)
        //--- [End: add navigationbar button items ] ---
        
        let gesture  = UISwipeGestureRecognizer(target: self, action: #selector(BackButton))
        gesture.direction = .right
        self.view.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Navigation Bar Button
    @objc func previousButton(){
        if webView.canGoForward{
            webView.goForward()
        }
    }
    
    @objc func refreshButton(){
        webView.reload()
    }
    
    @objc func backBrowserButton(){
        if webView.canGoBack{
            webView.goBack()
        }
    }
    
    //MARK: - Others
    @objc func BackButton(){
        if  (navigationController?.popViewController(animated:true)) != nil{
            //debugPrint("Good")
        }else{
          self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Webview Methods
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
        let title = webView.stringByEvaluatingJavaScript(from: "document.title")!
        self.title = title
        activityIndicator.stopAnimating()
    }
}
