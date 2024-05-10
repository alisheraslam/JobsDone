//
//  JobHistoryVC.swift
//  JobsDone
//
//  Created by musharraf on 21/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class JobHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var jobTabl: UITableView!
    @IBOutlet weak var skillView: UIView!
    @IBOutlet weak var skillClv2: UICollectionView!
    @IBOutlet weak var inviteBtn: UIButton!
    var totalJobs = 0
    var jobsArr  = [JobsModel]()
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var userId: Int!
    var jobSkillArr = [Category]()
    var img =  ""
    var rating: String!
    var reviews: String!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobTabl.delegate = self
        jobTabl.dataSource = self
        jobTabl.estimatedRowHeight = 99
        jobTabl.rowHeight = UITableView.automaticDimension
        jobTabl.separatorColor = UIColor.clear
        self.title = "JOB HISTORY"
        
        skillView.frame = CGRect(x: 0, y: (self.view.frame.height / 2) - 100, width: (self.view.frame.width), height: 90)
        skillView.layer.borderWidth = 5
        skillView.layer.borderColor = UIColor(hexString: "#FF6B00").cgColor
        skillView.layer.cornerRadius = 5
        skillView.center = self.view.center
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        skillClv2.collectionViewLayout = layout
        if Utilities.isGuest(){
            self.inviteBtn.isHidden = true
        }
        LoadJobHistory()
        // Do any additional setup after loading the view.
    }

    //MARK: - SHOW USER SKILLS
    @objc func ShowUserSkill(_ sender: UIButton)
    {
        let job = self.jobsArr[sender.tag]
        if job.categories.count > 0{
            self.jobSkillArr = job.categories
            self.skillClv2.delegate = self
            self.skillClv2.dataSource = self
            if self.jobSkillArr.count == 1{
                skillView.frame = CGRect(x: 0, y: self.view.frame.height / 2, width: (self.view.frame.width), height: 110)
            }else{
                var statVal: Double = 120
                if self.jobSkillArr.count > 3{
                    statVal = 100
                }
                let height = CGFloat((statVal * ceil((Double(self.jobSkillArr.count) / 2))))
                skillView.frame = CGRect(x: 0, y: self.view.frame.height / 2, width: (self.view.frame.width), height: height)
            }
            self.skillClv2.reloadData()
            self.view.addSubview(skillView)
        }
    }
    
    @IBAction func HideSkillsView(_ sender: UIButton)
    {
        self.skillView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsArr.count
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
            let cell = jobTabl.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath as IndexPath) as! HomeTVCell
            let objModel = self.jobsArr[indexPath.row]
            // Configure the cell...
            cell.userimage.sd_setImage(with: URL(string: objModel.ownerImages.imageNormal))
            cell.selfImg.sd_setImage(with: URL(string: objModel.imageNormal))
            cell.name.text = objModel.ownerTitle
            cell.rating.text = String(describing: objModel.rating!)
            cell.title.text = objModel.title!
            cell.detail.text = objModel.body
            cell.rating.text  = "\(objModel.avgRating!)"
            if Int(objModel.price) >  1000{
                cell.price.text = "$\(Int(ceilf(Float(objModel.price!) / 1000)))K"
            }else{
            cell.price.text = "$\(objModel.price!)"
            }
            cell.starImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 20, height: 20))
            cell.skillImg.image = UIImage.fontAwesomeIcon(name: .cog, textColor: UIColor.darkGray, size: CGSize(width: 20, height: 20))
            if objModel.categories.count > 0{
                if (objModel.categories.count) > 1{
                    cell.jobTypeLbl.text = "\(objModel.categories[0].categoryName!)  +\((objModel.categories.count) - 1)"
                }else{
                   cell.jobTypeLbl.text = "\(objModel.categories[0].categoryName!)"
                }
                cell.showSkillBtn.tag = indexPath.row
                cell.showSkillBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
                let url = objModel.categories[0].thumbIcon
                if url != ""{
                    cell.skillImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                        // Perform your operations here.
                        cell.skillImg.image = cell.skillImg.image?.withRenderingMode(.alwaysTemplate)
                        cell.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                    }
                }
               
            }else{
                cell.skillImg.image = #imageLiteral(resourceName: "setting")
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
    //Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.jobsArr.count - 3
        if indexPath.row == lastElement {
            if jobsArr.count < totalJobs{
                if !isDataLoading{
                    UIView.setAnimationsEnabled(false)
                    self.jobTabl.alwaysBounceVertical = false
                    self.jobTabl.bounces = false
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    if self.jobsArr.count > 0 {
                        self.lastIndex = self.jobsArr.count - 1
                    }
                    self.jobTabl.setContentOffset(jobTabl.contentOffset, animated: false)
                    self.LoadJobHistory()
                }
            }
        }
    }
    
    //MARK: - ONCLICK INVITETOJOB
    @IBAction func InviteToJobPressed(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .sendInvitationVC) as! SendInvitationVC
        vc.user_id = self.userId
        vc.image = self.img
        vc.ratingLbl = self.rating
        vc.reviewsLbl = "\(self.reviews!) Reviews"
        vc.nameLbl = self.name
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
    func LoadJobHistory()
    {
        let method = "/members/profile/jobs"
        var params = Dictionary<String,AnyObject>()
        params["user_id"] = self.userId as AnyObject
        params["limit"] = self.limit as AnyObject
        params["page"] = self.pageNo as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            print(response)
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
                        self.jobTabl.beginUpdates()
                        self.jobTabl.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                        self.jobTabl.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }else{
                        self.jobTabl.reloadData()
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    
    //MARK: - COLLECTION VIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobSkillArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeSkillCell", for: indexPath) as! SkillsCell
        var obj : Category!
        obj = jobSkillArr[indexPath.row]
        
        let url = obj.thumbIcon
        if url != ""{
            cell.imgSkill.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                // Perform your operations here.
                cell.imgSkill.image = cell.imgSkill.image?.withRenderingMode(.alwaysTemplate)
                cell.imgSkill.tintColor = UIColor.white
            }
        }
        //        cell.name.textColor = UIColor(hexString: "#FF6B00")
        cell.name.text = obj.categoryName
        if skillView.isDescendant(of: self.view)
        {
            cell.removeBtn.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var obj : Category!
        obj = jobSkillArr[indexPath.row]
        
        
        let str = obj.categoryName
        var w = str?.width(withConstraintedHeight: 40, font: UIFont.systemFont(ofSize: 15.0))
        w = w! + 70
        if collectionView == self.skillClv2
        {
            if w! > skillClv2.width / 2{
                return CGSize(width: skillClv2.width / 2 , height: 80)
            }
            return CGSize(width: skillClv2.width / 2 , height: 60)
        }else{
            return CGSize(width: w! , height: 50)
        }
    }

}
