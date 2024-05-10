//
//  InvitationSuccess.swift
//  JobsDone
//
//  Created by musharraf on 08/03/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

public enum Type{
    case Invitation
    case Apply
}

class InvitationSuccess: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    var name = ""
    var image = ""
    var type = Type.Invitation
    override func viewDidLoad() {
        super.viewDidLoad()
        userImg.setImageWith(URL(string: image)!)
        nameLbl.text = name
        if type == .Apply{
            firstLbl.text = "JOB APPLICATION HAS"
            secondLbl.text = "BEEN SENT TO"
            submitBtn.setTitle("VIEW APPLIED JOBS", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if !(self.navigationController?.isNavigationBarHidden)!{
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if (self.navigationController?.isNavigationBarHidden)!{
            self.navigationController?.isNavigationBarHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ViewAppsPressed(_ sender: UIButton)
    {
        let menu =  MyJobVC()
        if UserDefaults.standard.value(forKey: "level_id") as? Int == 7 || UserDefaults.standard.value(forKey: "level_id") as? Int == 8{
            menu.tabTitles = ["POSTED","COMPLETED"]
        }else{
            menu.tabTitles = ["INVITATIONS","APPLIED","RUNNING","COMPLETED","POSTED"]
        }
        menu.navTitle = "MY JOBS"
        menu.currentTabIndex = 1
        menu.camefrom = "invitation"
        let tab = self.slideMenuController()?.mainViewController as! UITabBarController
         let current = tab.viewControllers?[tab.selectedIndex] as! UINavigationController
//        current.pushViewController(menu, animated: true)
        self.navigationController?.pushViewController(menu, animated: true)
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
