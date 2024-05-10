//
//  HelpVC.swift
//  JobsDone
//
//  Created by musharraf on 26/02/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class HelpVC: UIViewController,UITableViewDelegate,UITableViewDataSource,helpCelldelegate {
    
    
    
    @IBOutlet weak var imgMxg: UIImageView!
    @IBOutlet weak var questionTbl: UITableView!
    var helpArr = [HelpModel]()
    var questionArr = [HelpModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HELP"
        let checkinImage = #imageLiteral(resourceName: "envelope")
        let checkintintedImage = checkinImage.withRenderingMode(.alwaysTemplate)
        imgMxg.image = checkintintedImage
//        imgMxg.setImage(checkintintedImage, for: .normal)
        imgMxg.tintColor = UIColor(hexString: "#FF6A00")
        self.questionTbl.dataSource = self
        self.questionTbl.delegate = self
        self.questionTbl.separatorStyle = .none
        loadQuestion()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.helpArr.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  identifier = "helpCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier ) as! HelpCell
        let help = questionArr[indexPath.row]
        cell.delegate = self
        cell.questionLbl.text = help.question
//        cell.questionLbl.setTitle(help.question, for: .normal)
        cell.questionBtn.tag = indexPath.row
        cell.ansLbl.text = help.answer
//        cell.ansLbl.isHidden = true
        return cell
    }
    
    @IBAction func CallBtnPressed(_ sender: UIButton)
    {
        let phone = "+1.604.910.6840"
        phone.makeAColl()
    }
    
    @IBAction func ContactUsPressed(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .contactUSTVC) as! ContactUSTVC
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
    func loadQuestion()
    {
        let method = "help/faqs"
        var dic = Dictionary<String,AnyObject>()
        //        dic[""] = "ios" as AnyObject
        
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            
            print(response)
            let body = response["body"] as? Dictionary<String,AnyObject>
            if let dic = body!["response"] as? [Dictionary<String,AnyObject>] {
                for di in dic
                {
                    let menu = HelpModel.init(di)
                    self.helpArr.append(menu)
                    let helpModel = HelpModel()
                    helpModel.question = menu.question
                    self.questionArr.append(helpModel)
                }
               
            }
            
            self.questionTbl.reloadData()
            
        }) { (response) in
            
            print(response)
        }
    }
    
    func didPressedQuestion(tag: Int) {
        let obj = self.helpArr[tag]
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = questionTbl.cellForRow(at: indexPath) as! HelpCell
        let questObj = self.questionArr[tag]
        if questObj.answer == ""
        {
            questObj.answer = obj.answer
            cell.rightImg.image = #imageLiteral(resourceName: "right-down")
        } else {
            questObj.answer = ""
            cell.rightImg.image = #imageLiteral(resourceName: "right-up")
        }
        self.questionTbl.reloadRows(at: [indexPath], with: .bottom)
        

    }

}
