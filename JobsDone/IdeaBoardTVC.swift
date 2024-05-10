//
//  IdeaBoardTVC.swift
//  JobsDone
//
//  Created by musharraf on 19/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class IdeaBoardTVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var userTabl: UITableView!
    @IBOutlet weak var skillClv: UICollectionView!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var catViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var searchCheckBtn1: UIButton!
    @IBOutlet weak var searchCheckBtn2: UIButton!
    @IBOutlet weak var searchCheckBtn3: UIButton!
    @IBOutlet weak var searchCheckBox1: UIImageView!
    @IBOutlet weak var searchCheckBox2: UIImageView!
    @IBOutlet weak var searchCheckBox3: UIImageView!
    @IBOutlet weak var searchCheckLbl: UILabel!
    @IBOutlet weak var kmField: UITextField!
    @IBOutlet weak var kmLbl: UILabel!
    @IBOutlet weak var kmView: UIView!
    @IBOutlet weak var checkboxView: UIStackView!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    let vc =  SkillVC(nibName: "SkillVC", bundle: nil)
    var ideaArr = [IdeaBoardModel]()
    var totalJobs = 0
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var refreshControl = UIRefreshControl()
    var skillArr = [Category]()
    var params = Dictionary<String,AnyObject>()
    var btnArr = [UIButton]()
    var checkArr = [UIImageView]()
    var jobSkillArr = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle(titel: "IDEA BOARD")
        //MARK: - SEARCH VIEW INITIALIZE
        searchViewHeight.constant = 0
        catViewHeight.constant = 0
        catView.isHidden = true
        searchView.isHidden = true
        //MARK: - TABLE VIEW INITIALIZE
        userTabl.dataSource = self
        userTabl.delegate = self
        userTabl.separatorStyle = .none
        userTabl.estimatedRowHeight = 250
        userTabl.rowHeight = UITableView.automaticDimension
        skillClv.delegate = self
        skillClv.dataSource = self
        //MARK: - CHECKBOX INITIALIZE
        kmView.isHidden = true
        kmLbl.isHidden = true
        kmField.isHidden = true
        checkboxView.isHidden = true
        locationImg.image = locationImg.image?.withRenderingMode(.alwaysTemplate)
        locationImg.tintColor = UIColor.lightGray
        btnArr = [searchCheckBtn1,searchCheckBtn2,searchCheckBtn3]
        checkArr = [searchCheckBox1,searchCheckBox2,searchCheckBox3]
        for i in 0 ..< btnArr.count{
            btnArr[i].tag = i
            checkArr[i].tag = i
            let btn = btnArr[i]
            checkArr[i].setFAIconWithName(icon: .FASquareO, textColor: UIColor.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 30, height: 30))
        }
        // Uncomment the following line to preserve selection between
        LoadFeatured()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        NotificationCenter.default.addObserver(self, selector: #selector(self.LoadSelectedSkills(_:)), name: NSNotification.Name(rawValue: "SelectedSkillForIdea"), object: nil)
        let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(self.leftBtnTapped(btn:)))
        self.navigationItem.leftBarButtonItem = leftBtn
        //MARK - RIGHT BUTTON
        let editImage    = #imageLiteral(resourceName: "plus-button")
        let searchImage  = UIImage(named:  "search")
        let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action:#selector(self.CreateJobClick(_:)))
         let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(self.SearchBtnClick(_:)))
        editButton.tintColor = UIColor(hexString: "D5D5D5")
        searchButton.tintColor = UIColor(hexString: "D5D5D5")
        if let id = UserDefaults.standard.value(forKey: "level_id") as? Int{
            if id != 7 && id != 8{
                navigationItem.rightBarButtonItems = [editButton,searchButton]
            }else{
               navigationItem.rightBarButtonItem = searchButton
            }
        }
        
        refreshControl.addTarget(self, action: #selector(self.RefreshUsers(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            userTabl.refreshControl = self.refreshControl
        } else {
            userTabl.addSubview(self.refreshControl)
            // Fallback on earlier versions
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IdeaBoardTVC.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
       
    }
    @objc func dismissKeyboard1() {
        view.endEditing(true)
        
    }
    
    //MARK: - SHOW USER SKILLS
    @objc func ShowUserSkill(_ sender: UIButton)
    {
        let user = self.ideaArr[sender.tag]
        self.jobSkillArr = user.skills
        vc.skillArr = self.jobSkillArr
        if self.jobSkillArr.count > 0{
            let statVal: Double = 80
            let height = CGFloat((statVal * ceil((Double(self.jobSkillArr.count) / 2))))
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
    //MARK: - CATEGORY BUTTON
    @IBAction func OnclickCategory(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
        vc.parentType = .IDEA
        vc.selectSkillData = self.skillArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - SHOW LOCATION SEARCH OR HIDE
    @IBAction func HandleLocation(_ sender: UIButton)
    {
        if checkboxView.isHidden{
            checkboxView.isHidden = false
            locationImg.image = locationImg.image?.withRenderingMode(.alwaysTemplate)
            locationImg.tintColor = UIColor(hexString: "#FF6B00")
        }else{
            self.params["provincial_search"] = 0 as AnyObject
            self.params["radius_search"] = 0 as AnyObject
            self.params["radius"] = nil
            self.params["national_search"] = 0 as AnyObject
            checkboxView.isHidden = true
            locationImg.image = locationImg.image?.withRenderingMode(.alwaysTemplate)
            locationImg.tintColor = UIColor.lightGray
        }
    }
    //MARK: - FAVOURITE HANDLE
    @IBAction func HandleFavourite(_ sender: UIButton)
    {
        if sender.tag == 0{
            self.params["favorite"] = 1 as AnyObject
            sender.tag = 1
            favImg.image = favImg.image?.withRenderingMode(.alwaysTemplate)
            favImg.tintColor = UIColor(hexString: "#FF6B00")
        }else{
            sender.tag = 0
            self.params["favorite"] = 0 as AnyObject
            favImg.image = favImg.image?.withRenderingMode(.alwaysTemplate)
            favImg.tintColor = UIColor.lightGray
        }
        
    }
    
    //MARK: - HANDLE CHECKBOX
    @IBAction func HandleCheckbox(_ sender: UIButton)
    {
        if sender.tag == 0 {
            self.searchCheckLbl.isHidden = true
            kmView.isHidden = false
            kmLbl.isHidden = false
            kmField.isHidden = false
        }else{
            self.searchCheckLbl.isHidden = false
            kmView.isHidden = true
            kmLbl.isHidden = true
            kmField.isHidden = true
        }
        for check in checkArr{
            if check.tag == sender.tag{
                
                check.setFAIconWithName(icon: .FACheckSquare, textColor: UIColor(hexString: app_header_bg), backgroundColor: .clear, size: CGSize(width: 30, height: 30))
                
            }else{
                check.setFAIconWithName(icon: .FASquareO, textColor: UIColor.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 30, height: 30))
                
            }
            if sender.tag == 0{
                self.params["radius_search"] = 1 as AnyObject
                self.params["radius"] = self.kmField.text! as AnyObject
                //
                self.params["provincial_search"] = 0 as AnyObject
                self.params["national_search"] = 0 as AnyObject
            }else if sender.tag == 1{
                self.params["provincial_search"] = 1 as AnyObject
                //
                self.params["radius_search"] = 0 as AnyObject
                self.params["radius"] = nil
                self.params["national_search"] = 0 as AnyObject
            }else if sender.tag == 2{
                self.params["national_search"] = 1 as AnyObject
                //
                self.params["radius_search"] = 0 as AnyObject
                self.params["radius"] = nil
                self.params["provincial_search"] = 0 as AnyObject
            }
        }
    }
    @objc func LoadSelectedSkills(_ notifcation: NSNotification)
    {
        if let skills = notifcation.userInfo!["skills"] as? [Category] {
            skillArr = skills
            if skillArr.count > 0{
                catViewHeight.constant = 60
                catView.isHidden = false
                searchViewHeight.constant = 350
                skillClv.reloadData()
            }
        }
    }
    
    @objc func RefreshUsers(sender:AnyObject) {
        // Code to refresh table view
        self.pageNo = 1
        isDataLoading  = false
        LoadFeatured()
    }
    
    //MARK: - SEARCH BTN PRESSED
    @objc func SearchBtnClick(_ sender: UIBarButtonItem)
    {
        let barButtonItems = self.navigationItem.rightBarButtonItems
        
        if !searchView.isHidden {
            searchViewHeight.constant = 0
            searchView.isHidden = true
            barButtonItems![1].tintColor = UIColor(hexString: "#D5D5D5")
        }else{
            barButtonItems![1].tintColor = UIColor(hexString: "#FF6B00")
            if catView.isHidden{
                searchViewHeight.constant = 290
            }else{
                searchViewHeight.constant = 350
            }
            searchView.isHidden = false
        }
        view.layoutIfNeeded()
        UIView.animate(withDuration: 2.0, animations: {
            self.view.layoutIfNeeded()
        })
    }

    @objc func CreateJobClick(_ sender: UIBarButtonItem)
    {
        let vc = UIStoryboard.storyBoard(withName: .Portfolio).loadViewController(withIdentifier: .createPortfolioVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func leftBtnTapped(btn: UIBarButtonItem){
        self.slideMenuController()?.toggleLeft()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ideaArr.count
    }
    //MARK: - Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.ideaArr.count - 3
        if indexPath.row == lastElement {
            if ideaArr.count < totalJobs{
                if !isDataLoading{
                    UIView.setAnimationsEnabled(false)
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    if self.ideaArr.count > 0 {
                        self.lastIndex = self.ideaArr.count - 1
                    }
                    self.userTabl.setContentOffset(userTabl.contentOffset, animated: false)
                    LoadFeatured()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTabl.dequeueReusableCell(withIdentifier: "IdeaBoardCell", for: indexPath as IndexPath) as! IdeaBoardCell
        
        let obj = self.ideaArr[indexPath.row]
        
        // Configure the cell...
        if obj.ownerImages != nil{
        cell.userimage.sd_setImage(with: URL(string: obj.ownerImages.image))
        }
        cell.userProfileBtn.tag = indexPath.row
        cell.userProfileBtn.addTarget(self, action: #selector(self.ProfileBtnPressed(_:)), for: .touchUpInside)
        cell.name.text = obj.ownerTitle
        cell.starImg.tag = indexPath.row
        cell.starImg.addTarget(self, action: #selector(self.FavBtnPressed(_:)), for: .touchUpInside)
        if obj.isFavorite{
            cell.starImg.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 30, height: 30)), for: .normal)
        }else{
            cell.starImg.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor.lightGray, size: CGSize(width: 30, height: 30)), for: .normal)
        }
        if obj.skills.count > 0{
        cell.skill.text = obj.skills[0].categoryName
        cell.showSkillBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
        cell.showSkillBtn.tag = indexPath.row
        let url = obj.skills[0].thumbIcon
            if url != ""{
                cell.skillImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                    // Perform your operations here.
                    cell.skillImg.image = cell.skillImg.image?.withRenderingMode(.alwaysTemplate)
                    cell.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                }
            }else{
                cell.skillImg.image = #imageLiteral(resourceName: "setting")
            }
        }else{
            cell.skillImg.image = #imageLiteral(resourceName: "setting")
        }
        if (obj.skills.count) > 1{
            cell.skillCount.text = "+\((obj.skills.count) - 1)"
        }
        cell.detail.text = obj.title
        let width  = UIScreen.main.bounds.width
        cell.heightImg.constant = width / 1.5
        cell.workImg.contentMode = .redraw
//        cell.workImg.sd_setShowActivityIndicatorView(true)
//        cell.workImg.sd_setIndicatorStyle(.gray)
        cell.workImg.sd_setImage(with: URL(string: obj.image))
        if Utilities.isGuest(){
            cell.starImg.isHidden = true
        }else{
            cell.starImg.isHidden = false
        }
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.ideaArr[indexPath.row]
        let vc = UIStoryboard.storyBoard(withName: .Portfolio).loadViewController(withIdentifier: .portfolioProfileVC) as! PortfolioProfileVC
        vc.id = obj.portfolioId
        vc.userId = obj.userId
        if obj.title != ""{
        vc.title = obj.title
        }else{
            vc.title = "PORTFOLIO DETAIL"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func ProfileBtnPressed(_ sender: UIButton)
    {
        let obj = self.ideaArr[sender.tag]
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = obj.userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - CLICK DOWNBAR
    @IBAction func ClickDownBar(_ sender: UIButton)
    {
        let barButtonItems = self.navigationItem.rightBarButtonItems
        self.SearchBtnClick(barButtonItems![1] )
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
    
    //MARK: - REMOVE CATEGORY
    @objc func RemoveCategory(_ sender: UIButton)
    {
        let obj = skillArr[sender.tag]
        skillArr.remove(at: sender.tag)
        let indexp = IndexPath(item: sender.tag, section: 0)
        self.skillClv.performBatchUpdates({
            self.skillClv.deleteItems(at: [indexp])
        }) { (finished) in
            self.skillClv.reloadItems(at: self.skillClv.indexPathsForVisibleItems)
        }
        if skillArr.count == 0{
            catViewHeight.constant = 0
            catView.isHidden = true
            searchViewHeight.constant = 290
        }
    }
    
    //MARK: CLEAR BUTTON
    @IBAction func OnclickClearBtn(_ sender: UIButton)
    {
        searchTxt.text = ""
        self.skillArr.removeAll()
        let barButtonItems = self.navigationItem.rightBarButtonItems
        favImg.image = favImg.image?.withRenderingMode(.alwaysTemplate)
        favImg.tintColor = UIColor.lightGray
        locationImg.image = locationImg.image?.withRenderingMode(.alwaysTemplate)
        locationImg.tintColor = UIColor.lightGray
        for i in 0 ..< btnArr.count{
            checkArr[i].setFAIconWithName(icon: .FASquareO, textColor: UIColor.darkGray, backgroundColor: UIColor.clear, size: CGSize(width: 30, height: 30))
        }
        self.searchCheckLbl.isHidden = false
        kmView.isHidden = true
        kmLbl.isHidden = true
        kmField.isHidden = true
        self.checkboxView.isHidden = true
        self.SearchBtnClick(barButtonItems![1] )
        self.pageNo = 1
        catViewHeight.constant = 0
        catView.isHidden = true
        self.params.removeAll()
        LoadFeatured()
    }
    
    @IBAction func SearchBtnClicked(_ sender: UIButton)
    {
        let search = searchTxt.text
        var i = 0
        var categeory_ids = ""
        for obModel in self.skillArr{
            categeory_ids = "\(categeory_ids),\(obModel.categoryId! )"
            i = i + 1
        }
        params["title"] = search as AnyObject
        params["category_ids"] = categeory_ids as AnyObject
        self.pageNo = 1
        searchViewHeight.constant = 0
        searchView.isHidden = true
        self.LoadFeatured()
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
    //MARK: - LOAD PROFESSIONALS
    func LoadFeatured()
    {
        let method = "jobs/ideaboard"
        params["limit"] = limit as AnyObject
        params["page"] = pageNo as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    if let body =  response["body"] as? Dictionary<String,AnyObject>{
                        self.totalJobs = body["totalItemCount"] as! Int
                        self.totalLbl.text = String(describing: body["totalItemCount"] as! Int)
                        if let userList = body["response"] as? [Dictionary<String,AnyObject>]{
                            if !self.isDataLoading{
                                self.ideaArr.removeAll()
                            }
                            for user in userList{
                                let model =  IdeaBoardModel.init(fromDictionary: user)
                                self.ideaArr.append(model)
                            }
                        }
                        if self.isDataLoading{
                            var indexPathsArray = [NSIndexPath]()
                            for index in self.lastIndex..<self.ideaArr.count - 1{
                                let indexPath = NSIndexPath(row: index, section: 0)
                                indexPathsArray.append(indexPath)
                                self.isDataLoading = false
                            }
                            self.userTabl.beginUpdates()
                            self.userTabl!.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                            self.userTabl.endUpdates()
                            UIView.setAnimationsEnabled(true)
                        }else{
                            if self.refreshControl.isRefreshing{
                                self.refreshControl.endRefreshing()
                            }
                            self.userTabl.reloadData()
                        }
                    }
                }
            }
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    //MARK: - ONCLICK FAVOURITE BUTTON
    @objc func FavBtnPressed(_ sender: UIButton)
    {
        let obj = self.ideaArr[sender.tag]
        var dic = Dictionary<String,AnyObject>()
        let method = "like"
        dic["subject_id"]  = obj.portfolioId as AnyObject
        dic["subject_type"] = "user_portfolio" as AnyObject
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            let status = response["status_code"] as? Int
            if status == 200
            {
                obj.isFavorite = true
                let indx = IndexPath(row: sender.tag, section: 0)
                self.userTabl.reloadRows(at: [indx], with: .fade)
            }else {
                let mxg = (response["message"] as? String) ?? ""
                Utilities.showAlertWithTitle(title: mxg, withMessage: "", withNavigation: self)
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
}
