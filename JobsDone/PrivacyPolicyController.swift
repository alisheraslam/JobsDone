//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

enum pageType{
    
    case policy
    case terms
    case contactus
    case website
}


class PrivacyPolicyController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    var pageTypes : pageType = pageType.policy
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackbutton(title: "Back")
        if pageTypes == .website{
            self.webView.loadRequest(URLRequest(url: URL(string: url)!))
        }else{
            loadWebView()
        }
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func loadWebView(){
        
        var method = ""
        
        if pageTypes == .policy{
            self.title = "Policy"
            method = "help/privacy"
        }else if pageTypes == .terms{
            self.title = "Terms"
            method = "help/terms"
        }else{
            self.title = "Contact us"
            method = "help/contact"
        }
            
        let dic = Dictionary<String,AnyObject>()
        self.activityIndicator.startAnimating()
        ALFWebService.sharedInstance.doGetDataPrivacyAndTerms(parameters: dic, method: method, success: { (response) in
            print(response)
            let body = response["body"] as? String
            self.webView.loadHTMLString(body!, baseURL: nil)
            
        }) { (response) in
            print(response)
        }
        
        self.webView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    func webViewDidStartLoad(_ webView: UIWebView){
        
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

}
