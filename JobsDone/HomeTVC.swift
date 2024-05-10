//
//  HomeTVC.swift
//  JobsDone
//
//  Created by musharraf on 18/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import GooglePlaces
import ActionSheetPicker_3_0

public protocol MainPageProtocol{
    func deleteDoneWithIndex(index: Int)
}

class HomeTVC: UIViewController,UITableViewDataSource,UITableViewDelegate,SlideMenuControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MainPageProtocol {
    
    @IBOutlet weak var userTabl: UITableView!
    @IBOutlet weak var skillClv: UICollectionView!
    @IBOutlet weak var totalJobLbl: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var catViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locatioBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var headingView: UIView!
    @IBOutlet weak var headingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    let vc =  SkillVC(nibName: "SkillVC", bundle: nil)
    var refreshControl = UIRefreshControl()
    var params = Dictionary<String,AnyObject>()
    var jobsArr  = [JobsModel]()
    var relatedJobsArr  = [JobsModel]()
    var skillArr = [Category]()
    var jobSkillArr = [Category]()
    var locationDic = Dictionary<String, AnyObject>()
    var totalJobs = 0
    var totalRelatedJobs = 0
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var didEndReached:Bool=false
    var jobType = JobType.JOBS
    var locationArr = [LocationModel]()
    var space = 0
    var isRelatedJobs = 1
    //    var jobType
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK- LEFT BUTTON
        vc.view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if jobType != .POSTED &&  jobType != .COMPLETED {
            onceLoaded = true
        }
        searchViewHeight.constant = 0
        catViewHeight.constant = 0
        catView.isHidden = true
        searchView.isHidden = true
        headingView.isHidden = true
        headingViewHeight.constant = 0
        self.navTitle(titel: "FIND JOBS")
        let leftBtn = UIBarButtonItem(image:  #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(self.leftBtnTapped(btn:)))
        self.navigationItem.leftBarButtonItem = leftBtn
        locationImg.image = locationImg.image?.withRenderingMode(.alwaysTemplate)
        locationImg.tintColor = UIColor.lightGray
        //MARK - RIGHT BUTTON
        topSpace.constant = CGFloat(space)
        let editImage    = UIImage(named: "edit")
        let searchImage  = UIImage(named:  "search")
        let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(CreateJobClick(_:)))
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(SearchBtnClick(_:)))
        editButton.tintColor = UIColor(hexString: "#D5D5D5")
        searchButton.tintColor = UIColor(hexString: "#D5D5D5")
        if !Utilities.isGuest(){
        navigationItem.rightBarButtonItems = [editButton, searchButton]
        }else{
            navigationItem.rightBarButtonItem = searchButton
        }
        userTabl.dataSource = self
        userTabl.delegate = self
        userTabl.rowHeight = UITableView.automaticDimension
        userTabl.estimatedRowHeight = 194
        skillClv.delegate = self
        skillClv.dataSource = self
        userTabl.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(self.LoadSelectedSkills(_:)), name: NSNotification.Name(rawValue: "SelectedSkill"), object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeTVC.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        refreshControl.addTarget(self, action: #selector(self.RefreshJobs(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            userTabl.refreshControl = self.refreshControl
        } else {
            userTabl.addSubview(self.refreshControl)
            // Fallback on earlier versions
        }
        self.navigationController?.navigationBar.isTranslucent = false
        
        loadjobs()
        LoadLocations()
    }
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        
        vc.view.center = self.view.center
    }
    @objc func RefreshJobs(sender:AnyObject) {
        // Code to refresh table view
        
        self.pageNo = 1
        isDataLoading  = false
        self.isRelatedJobs = 1
        loadjobs()
    }
    @objc func dismissKeyboard1() {
        view.endEditing(true)
        
    }
    
    @objc func LoadSelectedSkills(_ notifcation: NSNotification)
    {
        if let skills = notifcation.userInfo!["skills"] as? [Category] {
            skillArr = skills
            if skillArr.count > 0{
                catViewHeight.constant = 60
                catView.isHidden = false
                searchViewHeight.constant = 314
                skillClv.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func leftBtnTapped(btn: UIBarButtonItem){
        self.slideMenuController()?.toggleLeft()
    }
    @objc func CreateJobClick(_ sender: UIBarButtonItem)
    {
        let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .createJobVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func SearchBtnClick(_ sender: UIBarButtonItem)
    {
        if jobType == .JOBS || jobType == .SEARCH{
            if !searchView.isHidden {
                searchViewHeight.constant = 0
                searchView.isHidden = true
                sender.tintColor = UIColor(hexString: "#D5D5D5")
            }else{
                if catView.isHidden{
                    searchViewHeight.constant = 254
                }else{
                    searchViewHeight.constant = 314
                }
                searchView.isHidden = false
                sender.tintColor = UIColor(hexString: "#FF6B00")
            }
            view.layoutIfNeeded()
            UIView.animate(withDuration: 2.0, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func deleteDoneWithIndex(index: Int) {
        let indexPath = IndexPath(row: index, section: 1)
        self.userTabl.deleteRows(at: [indexPath], with: .fade)
        self.jobsArr.remove(at: index)
    }
    @IBAction func ClickDownBar(_ sender: UIButton)
    {
        let barButtonItems = self.navigationItem.rightBarButtonItems
        if Utilities.isGuest(){
            self.SearchBtnClick(barButtonItems![0] )
        }else{
        self.SearchBtnClick(barButtonItems![1] )
        }
    }
    
    //Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var lastElement = 0
            lastElement  = self.jobsArr.count - 3
        if self.jobType == .JOBS{
            if indexPath.row == lastElement || lastElement < 0 {
                if jobsArr.count - 1 < totalJobs {
                    if !isDataLoading{
                        UIView.setAnimationsEnabled(false)
                        isDataLoading = true
                        self.pageNo=self.pageNo+1
                        if self.jobsArr.count > 0 {
                            self.lastIndex = self.jobsArr.count - 1
                        }
                        if self.totalJobs == 0 && jobType == .JOBS{
                            self.pageNo = 1
                            isDataLoading  = false
                            self.isRelatedJobs = 1
                            loadjobs()
                        }
                        self.userTabl.setContentOffset(userTabl.contentOffset, animated: false)
                        self.loadjobs()
                    }
                }
                else if self.isRelatedJobs == 1{
                    if let levelId = UserDefaults.standard.value(forKey: "level_id") as? Int{
                        if levelId != 7 && levelId != 8{
                    if !isDataLoading{
                        self.isRelatedJobs = 0
                        isDataLoading = true
                        self.pageNo = 1
                        if self.jobsArr.count > 0 {
                            self.lastIndex = self.jobsArr.count - 1
                        }
                        let dic = Dictionary<String,AnyObject>()
                        let obj = JobsModel.init(fromDictionary: dic)
                        obj.jobType = 2112
                        self.jobsArr.append(obj)
                        self.userTabl.setContentOffset(userTabl.contentOffset, animated: false)
                        self.loadjobs()
                            }
                        }
                    }
                }else if self.jobsArr.count - 2 < totalJobs + totalRelatedJobs{
                    if let levelId = UserDefaults.standard.value(forKey: "level_id") as? Int{
                        if levelId != 7 && levelId != 8{
                            if !isDataLoading{
                                UIView.setAnimationsEnabled(false)
                                isDataLoading = true
                                self.pageNo=self.pageNo+1
                                if self.jobsArr.count > 0 {
                                    self.lastIndex = self.jobsArr.count - 1
                                }
                                self.userTabl.setContentOffset(userTabl.contentOffset, animated: false)
                                self.loadjobs()
                            }
                        }
                    }
                }
            }
        }else{
            lastElement  = self.jobsArr.count - 3
            if indexPath.row == lastElement {
                if jobsArr.count < totalJobs{
                    if !isDataLoading{
                        UIView.setAnimationsEnabled(false)
                        isDataLoading = true
                        self.pageNo=self.pageNo+1
                        if self.jobsArr.count > 0 {
                            self.lastIndex = self.jobsArr.count - 1
                        }
                        self.userTabl.setContentOffset(userTabl.contentOffset, animated: false)
                        self.loadjobs()
                    }
                }
            }
        }
        }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        if self.jobType == .JOBS{
//            return 2
//        }
        return 1
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HomeTVCell
//        if section == 0{
//            cell.headerTxt.text = "RELATED JOBS"
//            cell.countTxt.text = "\(self.totalRelatedJobs)"
//        }else{
//            cell.headerTxt.text = "OTHER JOBS"
//            cell.countTxt.text = "\(self.totalJobs)"
//        }
//        return cell.contentView
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.jobType == .JOBS{
//            if section == 0{
//                return self.relatedJobsArr.count
//            }else{
//                return self.jobsArr.count
//            }
//        }
        // #warning Incomplete implementation, return the number of rows
        //        lastIndex = jobsArr.count - 1
        if jobsArr.count == 0{
            return 1
        }
        return jobsArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objModel : JobsModel!
            if (jobsArr.count == 0) || (jobType == .JOBS && jobsArr.count == 1){
                let identifier = "Cell"
                var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
                if cell == nil {
                    tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
                }
                cell.cellLabel.text = "No Data"
                return cell
            }else{
                objModel = self.jobsArr[indexPath.row]
            }
        var identifier = "HomeTVCell"
        if objModel.jobType == 1221 || objModel.jobType == 2112{
            identifier = "HeaderCell"
        }
        let cell = userTabl.dequeueReusableCell(withIdentifier: identifier, for: indexPath as IndexPath) as! HomeTVCell
        // Configure the cell...
        if objModel.jobType == 1221{
            cell.headerTxt.text = "RELATED JOBS"
            cell.countTxt.text = "\(self.totalJobs)"
            return cell
        }else if objModel.jobType == 2112{
            cell.headerTxt.text = "OTHER JOBS"
            cell.countTxt.text = "\(self.totalRelatedJobs)"
            return cell
        }
        cell.userimage.sd_setImage(with: URL(string: objModel.imageNormal))
        cell.name.text = objModel.ownerTitle
        if objModel.rating != nil{
            cell.rating.text = String(describing: objModel.rating!)
        }else{
            cell.rating.text = ""
        }
        if objModel.title != nil{
            cell.detail.text = objModel.title!
        }else{
            cell.detail.text = ""
        }
        if objModel.body != nil{
            cell.title.text = objModel.body!
        }else{ cell.title.text = "" }
        if objModel.location != nil{
            cell.distance.text = "\(objModel.location!)"
        }else{
            cell.distance.text = ""
        }
        if objModel.distance != nil{
            cell.distance.text = "\(cell.distance.text ?? ""). \(objModel.distance!)Km away"
        }else{
            cell.distance.text = cell.distance.text
        }
        cell.jobTypeLbl.text = objModel.jobTypeLabel
        var dur = "\(objModel.duration!)"
        if objModel.duration > 1{
            dur = "\(objModel.duration!)s"
        }
        if objModel.jobDurationLabel! == ""{
            cell.jobDurationLbl.text = "Not Applicable"
        }else{
            cell.jobDurationLbl.text = "\(objModel.jobDurationLabel! ?? "Not Applicable")"
        }
        cell.rating.text = "\(objModel.avgRating!)"
        cell.reviews.text  = "\(objModel.reviewCount!) Reviews"
        cell.price.text = "$\(objModel.price!)"
        cell.jobStatus.text = objModel.jobStatus
        cell.starImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 20, height: 20))
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.profileBtn.tag = indexPath.row
        cell.showSkillBtn.tag = indexPath.row
        cell.profileBtn.addTarget(self, action: #selector(self.ProfileBtnPressed(_:)), for: .touchUpInside)
        cell.showSkillBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
        if objModel.categories.count > 0{
            let url = objModel.categories[0].thumbIcon
            cell.skillLbl.text = objModel.categories[0].categoryName
            if url != ""{
                cell.skillImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                    // Perform your operations here.
                    cell.skillImg.image = cell.skillImg.image?.withRenderingMode(.alwaysTemplate)
                    cell.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                }
            }else{
                cell.skillImg.image =  #imageLiteral(resourceName: "setting")
            }
            if (objModel.categories.count) > 1{
                cell.skillCount.text = "+\((objModel.categories.count) - 1)"
            }else{
                cell.skillCount.text = ""
            }
        }else{
            cell.skillImg.image =  #imageLiteral(resourceName: "setting")
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj: JobsModel!
        obj = jobsArr[indexPath.row]
        if obj.jobType == 1221 || obj.jobType == 2112{ return }
        let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .jobDetailVC) as! JobDetailVC
        vc.jobId = obj.listingId
        vc.userImg = obj.imageNormal
        vc.ownerId = obj.ownerId
        vc.indexPath = indexPath
        if self.parent?.navigationController != nil{
            self.parent?.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func ProfileBtnPressed(_ sender: UIButton)
    {
        guard let cell = sender.superview?.superview as? HomeTVCell else{ return }
        let indexPath = self.userTabl.indexPath(for: cell) as! IndexPath
        let obj: JobsModel!
         obj = jobsArr[indexPath.row]
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = obj.ownerId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - SHOW USER SKILLS
    @objc func ShowUserSkill(_ sender: UIButton)
    {
        guard let cell = sender.superview?.superview?.superview?.superview as? HomeTVCell else{ return }
        let indexPath = self.userTabl.indexPath(for: cell) as! IndexPath
        let obj: JobsModel!
        
        obj = jobsArr[indexPath.row]
        self.jobSkillArr = obj.categories
        vc.skillArr = jobSkillArr
        
        if obj.categories.count > 0{
            let statVal: Double = 80
            let height = CGFloat((statVal * ceil((Double(self.jobSkillArr.count) / 2))))
            let skillMid = (height + 40) * 0.5
            vc.view.frame = CGRect(x: 0, y: self.view.frame.midY - (skillMid), width: (self.view.frame.width ), height: height + 40)
            vc.skillCl.reloadData()
            self.view.addSubview(vc.view)
            vc.view.center = self.view.center
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func loadjobs()
    {
        //for different controller
        var method = "/jobs"
        headingView.isHidden = true
        headingViewHeight.constant = 0
        params["page"] = pageNo as AnyObject
        params["limit"] = limit as AnyObject
        
        if jobType == .JOBS{
            method = "/jobs"
            if isRelatedJobs == 1{
                if !Utilities.isGuest(){
                params["match_skills"] = 1 as AnyObject
                }
            }else{
                 if !Utilities.isGuest(){
                params["match_skills"] = 0 as AnyObject
                }
            }
        }else if jobType == .APPLIEDJOBS{
            method = "/jobs/applied"
        }else
            if jobType == .RUNNING{
                method = "/jobs/running"
            }else
                if jobType == .RUNNING{
                    method = "/jobs/running"
                }else
                    if jobType == .COMPLETED{
                        method = "/jobs/completed"
                    }else
                        if jobType == .POSTED{
                            method = "/jobs/posted"
                        }else if jobType == .SEARCH{
                            method = "/jobs"
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    
                    if self.isRelatedJobs == 0{
                        self.totalRelatedJobs = body!["totalItemCount"] as! Int
                    }else{
                        self.totalJobs = body!["totalItemCount"] as! Int
                    }
                    if let jobs   = body!["response"] as? [Dictionary<String,AnyObject>]
                    {
                        if !self.isDataLoading{
                            self.jobsArr.removeAll()
                            self.relatedJobsArr.removeAll()
                            if self.jobType == .JOBS {
                                let dic = Dictionary<String,AnyObject>()
                                let job = JobsModel.init(fromDictionary: dic)
                                job.jobType = 1221
                                self.jobsArr.append(job)
                            }
                        }
                        
                        for job in jobs
                        {
                            let objModel = JobsModel.init(fromDictionary: job)
                            self.jobsArr.append(objModel)
                            
                        }
                    }
                    if self.isDataLoading{
                        
                        if self.jobsArr.count > 0 {
                        var indexPathsArray = [NSIndexPath]()
                        for index in self.lastIndex..<self.jobsArr.count - 1{
                            let indexPath = NSIndexPath(row: index, section: 0)
                            indexPathsArray.append(indexPath)
                            self.isDataLoading = false
                        }
                        UIView.setAnimationsEnabled(false)
                        self.userTabl.beginUpdates()
                        self.userTabl!.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                        self.userTabl.endUpdates()
                        UIView.setAnimationsEnabled(true)
                        }
                    }else{
                        if self.refreshControl.isRefreshing{
                            self.refreshControl.endRefreshing()
                        }
                        self.userTabl.contentOffset = CGPoint.zero
                        self.userTabl.reloadData()
                        
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    
    
    @IBAction func OnclickCategory(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
        vc.parentType = .CATEGORY
        vc.selectSkillData = self.skillArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - COLLECTION VIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.skillArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeSkillCell", for: indexPath) as! SkillsCell
        var obj : Category!
        obj = skillArr[indexPath.row]
        
        let url =  obj.thumbIcon
        if url != ""{
            cell.imgSkill.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                // Perform your operations here.
                cell.imgSkill.image = cell.imgSkill.image?.withRenderingMode(.alwaysTemplate)
                cell.imgSkill.tintColor = UIColor.white
            }
        }
        
        cell.name.text = obj.categoryName
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(self.RemoveCategory(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var obj : Category!
        obj = skillArr[indexPath.row]
        
        
        let str = obj.categoryName
        var w = str?.width(withConstraintedHeight: 40, font: UIFont.systemFont(ofSize: 15.0))
        w = w! + 70
        return CGSize(width: w! , height: 50)
        
    }
    @objc func RemoveCategory(_ sender: UIButton)
    {
        let obj = skillArr[sender.tag]
        skillArr.remove(at: sender.tag)
        let indexp = IndexPath(item: sender.tag, section: 0)
        let txt = self.categoryBtn.titleLabel?.text
        let remainingTxt = txt?.replacingOccurrences(of: obj.categoryName, with: "")
        self.categoryBtn.setTitle(remainingTxt, for: .normal)
        self.skillClv.performBatchUpdates({
            self.skillClv.deleteItems(at: [indexp])
        }) { (finished) in
            self.skillClv.reloadItems(at: self.skillClv.indexPathsForVisibleItems)
        }
        if skillArr.count == 0{
            catViewHeight.constant = 0
            catView.isHidden = true
            searchViewHeight.constant = 254
            self.categoryBtn.setTitleColor(UIColor.lightGray, for: .normal)
            self.categoryBtn.setTitle("Select Category", for: .normal)
        }
    }
    @IBAction func onClickLocationPicker(_ sender: UIButton)
    {
        //        let autocompleteController = GMSAutocompleteViewController()
        //        autocompleteController.delegate = self
        //        let filter = GMSAutocompleteFilter()
        //        filter.type = .establishment  //suitable filter type
        //        filter.country = "CA"  //appropriate country code
        //        autocompleteController.autocompleteFilter = filter
        //        present(autocompleteController, animated: true, completion: nil)
        var val = [String]()
        var key = [Int]()
        for obj in self.locationArr{
            key.append(obj.locationId)
            val.append(obj.location)
            for city in obj.cities{
                key.append(city.locationId!)
                val.append("--\(city.location!)")
            }
        }
        ActionSheetStringPicker.show(withTitle: "Select Location", rows: val , initialSelection: 0, doneBlock: {picker, values, indexes in
            sender.setTitle(val[values], for: .normal)
            if val[values] != "Select"{
                self.params["location_id"] = key[values] as AnyObject
            }
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
    }
    @IBAction func SearchBtnClicked(_ sender: UIButton)
    {
        self.jobType = .SEARCH
        self.jobsArr.removeAll()
        let search = searchTxt.text
        var i = 0
        var categeory_ids = ""
        for obModel in self.skillArr{
            categeory_ids = "\(categeory_ids),\(obModel.categoryId! )"
            i = i + 1
        }
        params["search"] = search as AnyObject
        params["category_ids"] = categeory_ids as AnyObject
        params["page"] = 1 as AnyObject
        searchViewHeight.constant = 0
        searchView.isHidden = true
        SearchJobs()
    }
    func SearchJobs()
    {
        headingView.isHidden = false
        headingViewHeight.constant = 35
        print(params)
        if (self.params["search"] as? String == "" || self.params["search"] == nil) && (self.skillArr.count == 0) && (self.params["location_id"] == nil){
            let barButtonItems = self.navigationItem.rightBarButtonItems
            if Utilities.isGuest(){
                barButtonItems![0].tintColor = UIColor(hexString: "#D5D5D5")
            }else{
            barButtonItems![1].tintColor = UIColor(hexString: "#D5D5D5")
            }
        } else{
            let barButtonItems = self.navigationItem.rightBarButtonItems
            if Utilities.isGuest(){
                barButtonItems![0].tintColor = UIColor(hexString: "#D5D5D5")
            } else{
            barButtonItems![1].tintColor = UIColor(hexString: "#FF6B00")
            }
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: params, method: "/jobs", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    self.totalJobs = body!["totalItemCount"] as! Int
                    self.totalJobLbl.text = "\(self.totalJobs)"
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
                        self.userTabl.beginUpdates()
                        self.userTabl!.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                        self.userTabl.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }else{
                        self.userTabl.reloadData()
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    
    @IBAction func OnclickClearBtn(_ sender: UIButton)
    {
        skillArr.removeAll()
        self.jobsArr.removeAll()
        searchTxt.text = ""
        self.categoryBtn.setTitle("Select Categories", for: .normal)
        self.categoryBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.locatioBtn.setTitle("Select Location", for: .normal)
        self.locatioBtn.setTitleColor(UIColor.lightGray, for: .normal)
        let barButtonItems = self.navigationItem.rightBarButtonItems
        if Utilities.isGuest(){
            self.SearchBtnClick(barButtonItems![0] )
        }else{
        self.SearchBtnClick(barButtonItems![1] )
        }
        jobType = .JOBS
        self.pageNo = 1
        self.params.removeAll()
        catViewHeight.constant = 0
        catView.isHidden = true
        isDataLoading = false
        loadjobs()
    }
    func LoadLocations()
    {
        let method = "members/index/locations"
        let dic = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    if let locationArr = body!["response"] as? [Dictionary<String,AnyObject>]
                    {
                        let dic = Dictionary<String,AnyObject>()
                        let model = LocationModel.init(fromDictionary: dic)
                        model.location = "Select"
                        model.locationId = 010
                        self.locationArr.append(model)
                        for obj in locationArr{
                            let model = LocationModel.init(fromDictionary: obj)
                            self.locationArr.append(model)
                        }
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
        
    }
}
extension HomeTVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        self.locationDic["location"] = place.formattedAddress! as AnyObject
        self.locationDic["latitude"] = (String(describing: place.coordinate.latitude)) as AnyObject
        self.locationDic["longitude"] = (String(describing: place.coordinate.longitude)) as AnyObject
        self.locationDic["formatted_address"] = place.formattedAddress! as AnyObject
        self.locationDic["address"] = place.formattedAddress! as AnyObject
        if place.addressComponents!.indices.contains(6){
            self.locationDic["country"] = place.addressComponents![6].name as AnyObject
        }
        if place.addressComponents!.indices.contains(7){
            self.locationDic["zipcode"] = place.addressComponents![7].name as AnyObject
        }
        if place.addressComponents!.indices.contains(3){
            self.locationDic["city"] = place.addressComponents![3].name as AnyObject
        }
        if place.addressComponents!.indices.contains(3){
            self.locationDic["state"] = place.addressComponents![3].name as AnyObject
        }
        self.locatioBtn.setTitle(place.formattedAddress!, for: .normal)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}

