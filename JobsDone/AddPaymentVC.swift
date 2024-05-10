//
//  AddPaymentVC.swift
//  JobsDone
//
//  Created by musharraf on 17/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit


class AddPaymentVC: UIViewController {
    @IBOutlet weak var paymentBtn: UIButton!
    var payment_id: Int!
    var payment_email : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onclickPayBtn(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .SignUp).loadViewController(withIdentifier: .paymentVC) as! PaymentVC
        vc.parentViewType = .PROFILE
        self.navigationController?.pushViewController(vc, animated: true)
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
