//
//  FeedbackVC.swift
//  JobsDone
//
//  Created by musharraf on 05/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tblView: UITableView!
    
    var user_id = ""
    var feedArr = [FeedbackModel]()
    var total = 0
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var refreshControl = UIRefreshControl()
    var jobSkillArr = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        self.title = "REVIEWS"
        tblView.separatorColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(self.RefreshUsers(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tblView.refreshControl = self.refreshControl
        } else {
            tblView.addSubview(self.refreshControl)
            // Fallback on earlier versions
        }
        
        LoadDetail()
        // Do any additional setup after loading the view.
    }
    @objc func RefreshUsers(sender:AnyObject) {
        // Code to refresh table view
        self.pageNo = 1
        isDataLoading  = false
        LoadDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - SHOW USER SKILLS
    @objc func ShowUserSkill(_ sender: UIButton)
    {
        let job = self.feedArr[sender.tag]
        vc.skillArr = job.categories
        if job.categories.count > 0{
            let statVal: Double = 80
            let height = CGFloat((statVal * ceil((Double(job.categories.count) / 2))))
            let skillMid = (height + 40) * 0.5
            vc.view.frame = CGRect(x: 0, y: self.view.frame.midY - (skillMid), width: (self.view.frame.width ), height: height + 40)
            vc.skillCl.reloadData()
            vc.removeBtn.addTarget(self, action: #selector(self.Remove(_:)), for: .touchUpInside)
            self.view.addSubview(vc.view)
            vc.view.center = self.view.center
        }
    }
    @objc func Remove(_ sender: UIButton)
    {
        vc.view.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedArr.count
    }
    
    //MARK: - Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.feedArr.count - 3
        if indexPath.row == lastElement {
            if feedArr.count < total{
                if !isDataLoading{
                    UIView.setAnimationsEnabled(false)
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    if self.feedArr.count > 0 {
                        self.lastIndex = self.feedArr.count - 1
                    }
                    self.tblView.setContentOffset(tblView.contentOffset, animated: false)
                    LoadDetail()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if feedArr.count == 0{
            
            let identifier = "Cell"
            var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            if cell == nil {
                tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            }
            cell.cellLabel.text = "No Data"
            return cell
            
            
        }else{
        let idenftifier = "NotificationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: idenftifier, for: indexPath as IndexPath) as! NotificationCell
        let obj = self.feedArr[indexPath.row]
        // Configure the cell...
            cell.goToProfile.tag = indexPath.row
            cell.goToProfile.addTarget(self, action: #selector(self.ProfileBtnPressed(_:)), for: .touchUpInside)
        cell.name.text = obj.feedbackBy
        cell.userimage.sd_setImage(with: URL(string: obj.feedbackUserPhotos.image))
        cell.ratingImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6A00"), size: CGSize(width: 20, height: 20))
            cell.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6A00"), size: CGSize(width: 30, height: 30)), for: .normal)
            do{
                cell.rating.text = String(describing: obj.feedbackUserRating!)
                cell.reviews.text = String(describing: obj.avgRating!)
                
            }catch{
               cell.rating.text = ""
            }
            if obj.categories.count > 0{
                cell.skillShowBtn.tag = indexPath.row
                cell.skillShowBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
                cell.skillImg.sd_setImage(with: URL(string: obj.categories[0].thumbIcon), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                    // Perform your operations here.
                    cell.skillImg.image = cell.skillImg.image?.withRenderingMode(.alwaysTemplate)
                    cell.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                }
            }
            if (obj.categories.count) > 1{
                cell.skill.text = "\(obj.categories[0].categoryName!)  +\((obj.categories.count) - 1)"
            }else{
                if obj.categories.count == 1{
                cell.skill.text = obj.categories[0].categoryName!
                }
            }
            cell.detail.text = obj.comments
        return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.feedArr[indexPath.row]
        let con = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .feedbackDetail) as! FeedbackDetail
        con.dic["id"] = obj.listingId as AnyObject
        con.dic["owner"] = "1" as AnyObject
        self.navigationController?.pushViewController(con, animated: true)
    }
    @objc func ProfileBtnPressed(_ sender: UIButton)
    {
        let obj = feedArr[sender.tag]
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = obj.feedbackFrom
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
    //MARK: - LOAD FEEDBACK
    func LoadDetail()
    {
        var dic = Dictionary<String,AnyObject>()
        dic["user_id"] = user_id as AnyObject
        dic["limit"] = self.limit as AnyObject
        dic["page"] = self.pageNo as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: "/members/profile/reviews/", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        self.total = body["totalItemCount"] as! Int
                        if let res = body["response"] as? [Dictionary<String,AnyObject>]{
                            if !self.isDataLoading{
                                self.feedArr.removeAll()
                            }
                            for obj in res{
                               let model = FeedbackModel.init(fromDictionary: obj)
                                self.feedArr.append(model)
                            }
                        }
                        if self.isDataLoading{
                            var indexPathsArray = [NSIndexPath]()
                            for index in self.lastIndex..<self.feedArr.count - 1{
                                let indexPath = NSIndexPath(row: index, section: 0)
                                indexPathsArray.append(indexPath)
                                self.isDataLoading = false
                            }
                            self.tblView.beginUpdates()
                            self.tblView!.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                            self.tblView.endUpdates()
                            UIView.setAnimationsEnabled(true)
                        }else{
                            if self.refreshControl.isRefreshing{
                                self.refreshControl.endRefreshing()
                            }
                            self.tblView.reloadData()
                        }
                    }
                }
            }
            
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    
    

}
