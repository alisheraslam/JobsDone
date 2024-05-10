//
//  WellcomeVC.swift
//  JobsDone
//
//  Created by musharraf on 12/04/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class WellcomeVC: UIViewController {
    var dic3 = [:] as Dictionary<String, AnyObject>
    var packageArr = [PackageModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConfirmClicked(_ sender: Any) {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.isCheckLogIn()
//        let alert = UIAlertController(title: "Thanks for joining!", message:"Welcome! A verification message has been sent to your email address with instructions for activating your account. Once you have activated your account, you will be able to sign in.", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK, Thanks", style: .default) { (action) -> Void in
//            
//        }
//        alert.addAction(action)
//        if DeviceType.iPad{
//            if let popoverPresentationController = alert.popoverPresentationController {
//                popoverPresentationController.sourceView = self.view
//                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
//                popoverPresentationController.permittedArrowDirections = []
//            }
//        }
//        self.present(alert, animated: true, completion: nil)
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
