//
//  JobInvitationVC.swift
//  JobsDone
//
//  Created by musharraf on 10/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

public enum JobType{
    case UNANSWERED
    case ACCEPTED
    case DECLINED
    case JOBS
    case APPLIEDJOBS
    case RUNNING
    case COMPLETED
    case POSTED
    case SEARCH
}

class JobInvitationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var unanswerView: UIView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var declineView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var jobsArr  = [JobsModel]()
    var totalJobs = 0
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var didEndReached:Bool=false
    var jobType = JobType.UNANSWERED
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptView.isHidden = true
        declineView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.estimatedRowHeight = 113
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        LoadJobs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func OnclickTabBtn(_ sender: UIButton)
    {
        let title = sender.titleLabel?.text!
        if title == "UNANSWERED"{
            unanswerView.isHidden = false
            acceptView.isHidden = true
            declineView.isHidden = true
            self.jobsArr.removeAll()
            self.jobType = .UNANSWERED
            self.LoadJobs()
        }else
            if title == "ACCEPTED"{
                acceptView.isHidden = false
                unanswerView.isHidden = true
                declineView.isHidden = true
                self.jobsArr.removeAll()
                self.jobType = .ACCEPTED
                self.LoadJobs()
        }else
            if title == "DECLINED"{
             declineView.isHidden = false
             unanswerView.isHidden = true
             acceptView.isHidden = true
                self.jobsArr.removeAll()
                self.jobType = .DECLINED
                self.LoadJobs()
        }
        
    }
    
    //Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.jobsArr.count - 3
        if indexPath.row == lastElement {
            if jobsArr.count < totalJobs{
                if !isDataLoading{
                    UIView.setAnimationsEnabled(false)
                    self.tableView.alwaysBounceVertical = false
                    self.tableView.bounces = false
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    if self.jobsArr.count > 0 {
                        self.lastIndex = self.jobsArr.count - 1
                    }
                    self.tableView.setContentOffset(tableView.contentOffset, animated: false)
                    self.LoadJobs()
                }
            }
        }
    }
    // MARK: - TABLEVIEW DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jobsArr.count == 0{
            return 1
        }
        return self.jobsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if jobsArr.count == 0{
            
            let identifier = "Cell"
            var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            if cell == nil {
                tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            }
            cell.cellLabel.text = "No Data"
            return cell
            
            
        }else{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "jobInvitationCell", for: indexPath) as! HomeTVCell
        let objModel = self.jobsArr[indexPath.row]
        // Configure the cell...
        cell.userimage.sd_setImage(with: URL(string: objModel.imageNormal))
        cell.name.text = objModel.ownerTitle
        cell.rating.text = String(describing: objModel.rating!)
        cell.detail.text = objModel.title!
        if objModel.location.count >= 25
        {
            let str = objModel.location!
            let show = str.substring(to:str.index(str.startIndex, offsetBy: 25))
            cell.jobLocation.text = "\(show).."
        }else{
             cell.jobLocation.text = objModel.location!
        }
            let dateStr = Utilities.dateFromString(objModel.creationDate!)
        cell.jobDate.text = Utilities.timeAgoSinceDate(date: dateStr, numericDates: true)
        cell.reviews.text  = "\(objModel.reviewCount!) Reviews"
        cell.starImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 20, height: 20))
            
        if objModel.categories.count > 0{
                let url = objModel.categories[0].thumbIcon
                if url != ""{
                    cell.skillImg.sd_setImage(with: URL(string: url!), placeholderImage: nil)
                    cell.skillImg.image = cell.skillImg.image?.withRenderingMode(.alwaysTemplate)
                    cell.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                }
                if (objModel.categories.count) > 1{
                    cell.skillCount.text = "\(objModel.categories[0].categoryName!) +\((objModel.categories.count) - 1)"
                }else{
                    cell.skillCount.text = ""
            }
            }
        return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = jobsArr[indexPath.row]
        let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .jobDetailVC) as! JobDetailVC
        vc.jobId = obj.listingId
        vc.userImg = obj.imageNormal
        vc.ownerId = obj.ownerId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - LOAD JOB INVITATION
    func LoadJobs()
    {
        var method = ""
        var params = Dictionary<String,AnyObject>()
        if jobType == .UNANSWERED{
            method = "/jobs/invitations"
            params["status"] = "pending" as AnyObject
        }else
            if jobType == .ACCEPTED{
                method = "/jobs/invitations"
                params["status"] = "accepted" as AnyObject
        }else
            if jobType == .DECLINED{
            method = "/jobs/invitations"
            params["status"] = "declined" as AnyObject
        }
        params["limit"] = self.limit as AnyObject
        params["page"] = self.pageNo as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    self.totalJobs = body!["totalItemCount"] as! Int
                    if let jobs   = body!["response"] as? [Dictionary<String,AnyObject>]
                    {
                        for job in jobs
                        {
                            let objModel = JobsModel.init(fromDictionary: job)
                            self.jobsArr.append(objModel)
                        }
                    }
                    if self.isDataLoading{
                        var indexPathsArray = [NSIndexPath]()
                        for index in self.lastIndex..<self.jobsArr.count - 1{
                            let indexPath = NSIndexPath(row: index, section: 0)
                            indexPathsArray.append(indexPath)
                            self.isDataLoading = false
                        }
                        UIView.setAnimationsEnabled(false)
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                        self.tableView.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }else{
                        self.tableView.reloadData()
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
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
