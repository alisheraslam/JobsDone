//
//  FindProfessionalVC.swift
//  JobsDone
//
//  Created by musharraf on 17/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class FindProfessionalVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var featureProftbl: UITableView!
    @IBOutlet weak var skillClv: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var catViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locatioBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var locationImg: UIImageView!
    
    
    var lastCell = false
    var preferedArr = [User]()
    var featuredArr = [User]()
    var refreshControl = UIRefreshControl()
    var totalJobs = 0
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var params = Dictionary<String,AnyObject>()
    var skillArr = [Category]()
    var locationArr = [LocationModel]()
    var userSkillArr = [Category]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewHeight.constant = 0
        catViewHeight.constant = 0
        catView.isHidden = true
        searchView.isHidden = true
        self.navTitle(titel: "FIND PROFESSIONAL")
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FF6B00")
        ]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(self.leftBtnTapped(btn:)))
        self.navigationItem.leftBarButtonItem = leftBtn
        locationImg.image = locationImg.image?.withRenderingMode(.alwaysTemplate)
        locationImg.tintColor = UIColor.lightGray
        //MARK - RIGHT BUTTON
//        let editImage    = UIImage(named: "edit")
        let searchImage  = UIImage(named:  "search")
//        let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(self.CreateJobClick(_:)))
         let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(self.SearchBtnClick(_:)))
//        editButton.tintColor = UIColor(hexString: "D5D5D5")
        searchButton.tintColor = UIColor(hexString: "D5D5D5")
        navigationItem.rightBarButtonItem = searchButton
        self.featureProftbl.delegate = self
        self.featureProftbl.dataSource = self
        self.featureProftbl.separatorStyle = .none
        skillClv.delegate = self
        skillClv.dataSource = self
       
        refreshControl.addTarget(self, action: #selector(self.RefreshUsers(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            featureProftbl.refreshControl = self.refreshControl
        } else {
            featureProftbl.addSubview(self.refreshControl)
            // Fallback on earlier versions
        }
       
         NotificationCenter.default.addObserver(self, selector: #selector(self.LoadSelectedSkills(_:)), name: NSNotification.Name(rawValue: "SelectedProfessionalSkill"), object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        LoadFeatured()
        LoadPrefered()
        LoadLocations()
       
        // Do any additional setup after loading the view.
    }
    override func dismissKeyboard() {
        view.endEditing(true)
        
    }
    @objc func RefreshUsers(sender:AnyObject) {
        // Code to refresh table view
        self.pageNo = 1
        isDataLoading  = false
        LoadFeatured()
        LoadPrefered()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if skillArr.count > 0{
//            catViewHeight.constant = 60
//            catView.isHidden = false
//            searchViewHeight.constant = 314
            DispatchQueue.main.async {
                self.skillClv.reloadData()
            }
//        }
    }
    //MARK : - LOAD SELECTED SKILL
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
    //DOWNBAR
    @IBAction func ClickDownBar(_ sender: UIButton)
    {
        let barButtonItems = self.navigationItem.rightBarButtonItem
        self.SearchBtnClick(barButtonItems! )
    }
    
   
    
    func CreateJobClick(_ sender: UIBarButtonItem)
    {
        let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .createJobVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func leftBtnTapped(btn: UIBarButtonItem){
        self.slideMenuController()?.toggleLeft()
    }
    //MARK: - CLEAR BTN
    @IBAction func OnclickClearBtn(_ sender: UIButton)
    {
        searchTxt.text = ""
        self.categoryBtn.setTitle("Select Categories", for: .normal)
        self.categoryBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.locatioBtn.setTitle("Select Location", for: .normal)
        self.locatioBtn.setTitleColor(UIColor.lightGray, for: .normal)
        let barButtonItems = self.navigationItem.rightBarButtonItem
        self.SearchBtnClick(barButtonItems! )
        self.pageNo = 1
        self.params.removeAll()
        self.skillArr.removeAll()
        self.skillClv.reloadData()
        catViewHeight.constant = 0
        catView.isHidden = true
        LoadPrefered()
        LoadFeatured()
    }
    //MARK: - SEARCH BTN PRESSED
    @objc func SearchBtnClick(_ sender: UIBarButtonItem)
    {
        let barButtonItems = self.navigationItem.rightBarButtonItem
        
        if !searchView.isHidden {
            searchViewHeight.constant = 0
            searchView.isHidden = true
            barButtonItems!.tintColor = UIColor(hexString: "#D5D5D5")
        }else{
            barButtonItems!.tintColor = UIColor(hexString: "#FF6B00")
            if catView.isHidden{
                searchViewHeight.constant = 254
            }else{
                searchViewHeight.constant = 314
            }
            searchView.isHidden = false
        }
        view.layoutIfNeeded()
        UIView.animate(withDuration: 2.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func SearchBtnClicked(_ sender: UIButton)
    {
        var i = 0
        var categeory_ids = ""
        for obModel in self.skillArr{
            categeory_ids = "\(categeory_ids),\(obModel.categoryId! )"
            i = i + 1
        }
        let search = searchTxt.text
        params["search"] = search as AnyObject
        params["category_ids"] = categeory_ids as AnyObject
        params["page"] = 1 as AnyObject
        searchViewHeight.constant = 0
        searchView.isHidden = true
        self.featuredArr.removeAll()
        self.LoadPrefered()
        self.LoadFeatured()
        
//        let barButtonItems = self.navigationItem.rightBarButtonItems
//        barButtonItems![1].tintColor = UIColor(hexString: "#FF6B00")
//        self.SearchBtnClick(barButtonItems![1] )
    }
    //MARK: - ONCLICK CATEGORY BTN
    @IBAction func OnclickCategory(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Setting).loadViewController(withIdentifier: .skillsVC) as! SkillsVC
        vc.parentType = .PROFESSIONAL
        vc.selectSkillData = self.skillArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - COLLECTION VIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == skillClv{
        return self.skillArr.count
        }
            return userSkillArr.count
        
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
        cell.cellView.layer.cornerRadius = 15
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
        }
    }
    //MARK: - ONCLICK LOCATION PICKER
    @IBAction func onClickLocationPicker(_ sender: UIButton)
    {
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
            }else{
              self.params["location_id"] = nil
            }
        }, cancel: {ActionMultipleStringCancelBlock in return}, origin: sender)
    }
    
    //MARK: - SHOW USER SKILLS
    @objc func ShowUserSkill(_ sender: UIButton)
    {
        let user = self.preferedArr[sender.tag]
        self.userSkillArr = user.skills
        
        vc.skillArr = self.userSkillArr
        if self.userSkillArr.count > 0{
            let statVal: Double = 80
            let height = CGFloat((statVal * ceil((Double(self.userSkillArr.count) / 2))))
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return items.count
//    }
    //Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! FindProfessionalTVcell
        if cell.reuseIdentifier == "secondCell"
        {
            cell.parent = self
            cell.featuredArr = self.featuredArr
            DispatchQueue.main.async {
                cell.collectionViewTbl.reloadData()
            }
            cell.configCell(identifier : cell.reuseIdentifier!)
            
        }
        let lastElement = self.preferedArr.count - 3
        let paths =  tableView.indexPathsForVisibleRows
        for path in paths!{
        if path.row == lastElement && indexPath.section == 1 {
            if preferedArr.count < totalJobs{
                if !isDataLoading{
                    UIView.setAnimationsEnabled(false)
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    if self.preferedArr.count > 0 {
                        self.lastIndex = self.preferedArr.count - 1
                    }
                    self.featureProftbl.setContentOffset(featureProftbl.contentOffset, animated: false)
                    self.LoadPrefered()
                    
                }
            }
        }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK- NUMBER OF ROWS IN SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        return preferedArr.count
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 48
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//         let cell = tableView.dequeueReusableCell(withIdentifier: "thirdCell") as! FindProfessionalTVcell
//        cell.contentView.backgroundColor = UIColor.white
//        if section == 0{
//            cell.name.text = "FEATURED PROFESSIONALS"
//            cell.skillCount.text = String(describing: self.featuredArr.count)
//        }else {
//             cell.name.text = "PROFESSIONALS"
//            cell.skillCount.text = String(describing: self.totalJobs)
//        }
//            return cell
//    }
   
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && indexPath.section == 0
        {
            return 200
        }
        if (indexPath.row == 0 && indexPath.section == 0) || (indexPath.section == 1 && indexPath.row == 0) {
            return 48
        }
        return UITableView.automaticDimension
    }
    //MARK- CELL FOR ROW AT INDEX
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = "FindProfessionalCell"
        if indexPath.row == 0 && indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "thirdCell", for: indexPath as IndexPath) as! FindProfessionalTVcell
            cell.name.text = "FEATURED PROFESSIONALS"
            cell.skillCount.text = String(describing: self.featuredArr.count)
            return cell
            
        }
        if indexPath.row == 0 && indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "thirdCell", for: indexPath as IndexPath) as! FindProfessionalTVcell
            cell.name.text = "PROFESSIONALS"
            cell.skillCount.text = String(describing: self.totalJobs)
            return cell
            
        }
        if indexPath.row == 1 && indexPath.section == 0{
            identifier = "secondCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath as IndexPath) as! FindProfessionalTVcell
        if cell.reuseIdentifier == "secondCell"
        {
            cell.parent = self
            cell.featuredArr = self.featuredArr
//            DispatchQueue.global().async {
                cell.collectionViewTbl.reloadData()
//            }
            cell.searching = self.searching
            cell.configCell(identifier : cell.reuseIdentifier!)
            
        }
        if cell.reuseIdentifier == "FindProfessionalCell"{
            let obj = self.preferedArr[indexPath.row]
            cell.starImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 20, height: 20))
            cell.favBtn.tag = indexPath.row
            cell.inviteBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(self.FavBtnPressed(_:)), for: .touchUpInside)
            cell.inviteBtn.addTarget(self, action: #selector(self.InviteToJobPressed(_:)), for: .touchUpInside)
            if obj.isFavorite{
                cell.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 30, height: 30)), for: .normal)
            }else{
                cell.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor.lightGray, size: CGSize(width: 30, height: 30)), for: .normal)
            }
            cell.mxgImg.setImage(UIImage.fontAwesomeIcon(name: .envelope, textColor: UIColor.lightGray.withAlphaComponent(0.5), size: CGSize(width: 30, height: 30)), for: .normal)
            
            cell.userimage.sd_setImage(with: URL(string: obj.image))
            cell.name.text = obj.displayname
            cell.businessName.text = obj.businessName
            cell.rating.text =  String(format: "%.1f", obj.avgRating!)
            cell.reviews.text = "\(obj.reviewCount!) Reviews"
            cell.price.text =  "$\(obj.hourlyRate!)"
            
                if obj.location != nil && obj.location != "<null>"{
                    cell.distance.text = "\(obj.location!)"
                } else{
                    cell.distance.text = ""
                }
                if obj.distance != nil{
                    cell.distance.text = "\(cell.distance.text ?? ""). \(obj.distance!)Km away"
                }else{
                    cell.distance.text = cell.distance.text
                }
            
            cell.showSkillBtn.tag = indexPath.row
            if obj.skills.count > 0{
                cell.showSkillBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
                
                cell.skill.text = obj.skills[0].categoryName
                let url = obj.skills[0].thumbIcon
                if url != ""{
                    cell.skillImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                        // Perform your operations here.
                        cell.skillImg.image = cell.skillImg.image?.withRenderingMode(.alwaysTemplate)
                        cell.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                    }
                }
                if (obj.skills.count) > 1{
                    cell.skillCount.text = "+\((obj.skills.count) - 1)"
                }else{
                   cell.skillCount.text = ""
                }
            }else{
               cell.skillImg.image = #imageLiteral(resourceName: "setting")
               cell.skill.text = ""
               cell.skillCount.text = ""
            }
            cell.mxgImg.tag = indexPath.row
            cell.mxgImg.addTarget(self, action: #selector(self.ChatBtnPressed(_:)), for: .touchUpInside)
            //MAKR: - CHECK IF USER GUEST OR SELF
           if Utilities.isGuest(){
                cell.favBtn.isHidden = true
                cell.inviteBtn.isHidden = true
                cell.mxgImg.isHidden = true
                
            } else if Utilities.isSelfUser(userID: obj.userId) || obj.levelId == 7
            {
                cell.mxgImg.isHidden = true
                cell.inviteBtn.isHidden = true
                cell.favBtn.isHidden = true
            }
           else{
                cell.inviteBtn.isHidden = false
                cell.mxgImg.isHidden = false
                cell.favBtn.isHidden = false
            }
            return cell
        }
        return cell
            }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 || (indexPath.section == 0 && indexPath.row == 1){
        let obj = self.preferedArr[indexPath.row]
        if indexPath.section == 1 {
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = obj.userId
        vc.featured = false
        self.navigationController?.pushViewController(vc, animated: true)
        }
        }
    }
    
    func onClickItem(obj: User)
    {
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = obj.userId
        vc.featured = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - ONCLICK INVITETOJOB
    @objc func InviteToJobPressed(_ sender: UIButton)
    {
        let obj = self.preferedArr[sender.tag]
        let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .sendInvitationVC) as! SendInvitationVC
        vc.user_id = obj.userId
        vc.image = obj.image
        vc.ratingLbl = String(describing: obj.avgRating!)
        vc.reviewsLbl = "\(obj.reviewCount!) Reviews"
        vc.nameLbl = obj.displayname
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - ONCLICK FAVOURITE BUTTON
    @objc func FavBtnPressed(_ sender: UIButton)
    {
        let obj = self.preferedArr[sender.tag]
        var dic = Dictionary<String,AnyObject>()
        dic["user_id"]  = obj.userId as AnyObject
         let method = "/members/favorite"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            let status = response["status_code"] as? Int
            if status == 204
            {
                obj.isFavorite = !(obj.isFavorite)
                let indx = IndexPath(row: sender.tag, section: 1)
                self.featureProftbl.reloadRows(at: [indx], with: .automatic)   
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    
    //MARK: - LOAD PROFESSIONALS
    func LoadFeatured()
    {
        let method = "members/featured-professionals"
//        var dic = Dictionary<String,AnyObject>()
//        self.params["search"] = self.searchTxt.text! as AnyObject
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    if let body =  response["body"] as? Dictionary<String,AnyObject>{
                        if let userList = body["response"] as? [Dictionary<String,AnyObject>]{
                            if !self.isDataLoading{
                                self.featuredArr.removeAll()
                            }
                            for user in userList{
                                let model =  User.init(fromDictionary: user)
                                self.featuredArr.append(model)
                            }
                        }
                        if self.refreshControl.isRefreshing{
                            self.refreshControl.endRefreshing()
                        }
                        let indexPath = IndexPath(row: 1, section: 0)
                        self.featureProftbl.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    //MARK:- LOAD PREFERED
    func LoadPrefered()
    {
        let method = "members"
        self.params["limit"] = self.limit as AnyObject
        self.params["page"] = self.pageNo as AnyObject
        if (self.params["search"] as? String == "" || self.params["search"] == nil) && (self.skillArr.count == 0) && (self.params["location_id"] == nil){
            self.searching = false
            let barButtonItems = self.navigationItem.rightBarButtonItem
            barButtonItems!.tintColor = UIColor(hexString: "#D5D5D5")
        }else{
            self.searching = true
            let barButtonItems = self.navigationItem.rightBarButtonItem
            barButtonItems!.tintColor = UIColor(hexString: "#FF6B00")
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: self.params, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    if let body =  response["body"] as? Dictionary<String,AnyObject>{
                        self.totalJobs = body["totalItemCount"] as! Int
                        if let userList = body["response"] as? [Dictionary<String,AnyObject>]{
                            if !self.isDataLoading{
                                self.preferedArr.removeAll()
                                let dic = Dictionary<String,AnyObject>()
                                var user = User.init(fromDictionary: dic)
                                self.preferedArr.append(user)
                            }
                            for user in userList{
                                let model =  User.init(fromDictionary: user)
                                self.preferedArr.append(model)
                            }
                        }
                    }
                    if self.isDataLoading{
                        var indexPathsArray = [NSIndexPath]()
                        for index in self.lastIndex..<self.preferedArr.count - 1{
                            let indexPath = NSIndexPath(row: index, section: 1)
                            indexPathsArray.append(indexPath)
                            self.isDataLoading = false
                        }
                        UIView.setAnimationsEnabled(false)
                        self.featureProftbl.beginUpdates()
                        self.featureProftbl!.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                        self.featureProftbl.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }else{
                        if self.refreshControl.isRefreshing{
                            self.refreshControl.endRefreshing()
                        }
                        self.featureProftbl.reloadData()
                    }
                }
            }
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    @IBAction func ChatBtnPressed(_ sender: UIButton)
    {
        let obj = self.preferedArr[sender.tag]
        let user = UsersModel()
        user.id = String(describing: obj.userId!)
        user.label = obj.displayname
        let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .composeMessageVC) as! ComposeMessageVC
        vc.selectedUsers.append(user)
        self.navigationController?.pushViewController(vc, animated: true)
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
extension UIView {
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 1, offSet: CGSize, radius: CGFloat = 5, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
