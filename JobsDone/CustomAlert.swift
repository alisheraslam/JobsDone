//
//  CustomAlert.swift
//  SocialNet
//
//  Created by musharraf on 13/12/2017.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit

class CustomAlert: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func titleChange(title:String)
    {
        titleLbl.text = title
    }
    func detailChange(detail: String)
    {
        detailLbl.text = detail
    }
    func deleteBtnChangeText(txt: String)
    {
        deleteBtn.setTitle(txt, for: .normal)
    }
    func cancelBtnChangeTxt(txt: String) {
        cancelBtn.setTitle(txt, for: .normal)
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
