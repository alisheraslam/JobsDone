//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class DeleteAccountTVC: UITableViewController {

    @IBOutlet weak var sendBtn: WAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.backgroundColor = UIColor(hexString: app_header_bg)
        self.addBackbutton(title: "Back")
        self.navigationItem.title = "Delete Account"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func deleteAccBtnClicked(_ sender: Any) {
        
        let dic = [:] as Dictionary<String, AnyObject>
        
        let alert = UIAlertController(title: "", message: "Do you really want to delete your account...?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Delete", style: .destructive, handler: { (action1) in
            
            ALFWebService.sharedInstance.doDeleteData(parameters: dic, method: "members/settings/delete", success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                if let scode = response["status_code"] as? Int {
                    if scode == 204 {
                        
                        Utilities.showAlertWithTitle(title: "Success", withMessage: "Deleted...!", withNavigation: self)
                        
                        Utilities.logout()
                        
                        
                    } else if scode == 401 {
                        Utilities.showAlertWithTitle(title: "Sorry", withMessage: "User does not have access to this resource!", withNavigation: self)
                    }
                }
                
            }) { (response) in
                print(response)
            }
            

        })
        let cancelActForIPhone = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { (action) in
            
        })
        let cancelActForIPad = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            
        })
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            alert.addAction(cancelActForIPad)
        } else {
            alert.addAction(cancelActForIPhone)
        }
        
        alert.addAction(action1)
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            if let popoverPresentationController = alert.popoverPresentationController {
                
                popoverPresentationController.sourceView = self.view
                
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
                //
                popoverPresentationController.permittedArrowDirections = []
                
                
                
            }
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    

    // MARK: - Table view data source

}
