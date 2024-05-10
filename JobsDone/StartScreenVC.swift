// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan

import UIKit
import ActionSheetPicker_3_0

class StartScreenVC: UIViewController {

    @IBOutlet weak var schoolBtn: WAButton!
    @IBOutlet weak var continueBtn: WAButton!
    
    var schKey = ""
    var achVal = "Select School"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolBtn.setTitle("Select School", for: .normal)
        if schoolBtn.currentTitle == "Select School" {
            continueBtn.isHidden = true
        } else {
            continueBtn.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        
        UserDefaults.standard.set(self.schKey, forKey: "schoolKey")
        
        let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .mainScreenVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func chooseSchoolBtnClicked(_ sender: Any) {
        
        let schoolTypes = ["Select School","Weltall","Vignan","Demo"]
        let schoolKeys = ["","weltall","vignan","demo"]
        ActionSheetStringPicker.show(withTitle: "", rows: schoolTypes , initialSelection: 0, doneBlock: {picker, values, indexes in
            self.schKey = schoolKeys[values]
            self.schoolBtn.setTitle(schoolTypes[values], for: .normal)
            
            if self.schoolBtn.currentTitle == "Select School" {
                self.continueBtn.isHidden = true
            } else {
                self.continueBtn.isHidden = false
            }
            
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
    }

}
