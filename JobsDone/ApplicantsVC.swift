//
//  ApplicantsVC.swift
//  JobsDone
//
//  Created by musharraf on 07/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class ApplicantsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var favTbl: UITableView!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var hireView: UIView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var bodyTxt: UITextView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var hireBtn: UIButton!

    
    var refreshControl = UIRefreshControl()
    var usersArr  = [User]()
    var totalUser = 0
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var didEndReached:Bool=false
    var jobSkillArr = [Category]()
    var jobId: Int!
    var inviteId: Int!
    var menu: GutterMenuModel!
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VIEW INVITES"
        self.favTbl.delegate = self
        self.favTbl.dataSource = self
        self.favTbl.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(self.RefreshUsers(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            favTbl.refreshControl = self.refreshControl
        } else {
            favTbl.addSubview(self.refreshControl)
            // Fallback on earlier versions
        }
        self.hideKeyboardWhenTappedAround()
        self.btn1.addTarget(self, action: #selector(self.SetRadioBtn(_:)), for: .touchUpInside)
        self.btn2.addTarget(self, action: #selector(self.SetRadioBtn(_:)), for: .touchUpInside)
        loadUsers()
        // Do any additional setup after loading the view.
    }
    
    @objc func SetRadioBtn(_ sender: UIButton)
    {
        if sender == btn1{
            btn1.tag = 1
            btn2.tag = 0
           self.img1.setFAIconWithName(icon: FAType.FACircle, textColor: UIColor(hexString: "#FF6B00"))
            self.img2.setFAIconWithName(icon: FAType.FACircleThin, textColor: UIColor.lightGray)
        }else{
            btn1.tag = 0
            btn2.tag = 1
            self.img2.setFAIconWithName(icon: FAType.FACircle, textColor: UIColor(hexString: "#FF6B00"))
            self.img1.setFAIconWithName(icon: FAType.FACircleThin, textColor: UIColor.lightGray)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            favTbl.refreshControl = self.refreshControl
        } else {
            favTbl.addSubview(self.refreshControl)
            // Fallback on earlier versions
        }
    }
    @objc func RefreshUsers(sender:AnyObject) {
        // Code to refresh table view
        self.pageNo = 1
        isDataLoading  = false
        self.refreshControl.beginRefreshing()
        self.usersArr.removeAll()
        loadUsers()
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    //MARK: - PAGINATION
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.usersArr.count - 3
        if indexPath.row == lastElement {
            
            if usersArr.count < totalUser{
                if !isDataLoading{
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    self.lastIndex = self.usersArr.count - 1
                    loadUsers()
                    
                }
            }
        }
    }
    
    //MARK: - CELL DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usersArr.count == 0{
            return 1
        }
        return usersArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if usersArr.count == 0{
            
            let identifier = "Cell"
            var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            if cell == nil {
                tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            }
            cell.cellLabel.text = "No Data"
            return cell
            
            
        }else{
        let obj = self.usersArr[indexPath.row]
        var identifier = "FavouriteCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath as IndexPath) as! FavouriteCell
        
        if cell.reuseIdentifier == "FavouriteCell"{
            cell.starImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 20, height: 20))
            if obj.isFavorite{
            cell.secondStarImg.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 30, height: 30)), for: .normal)
            }else{
            cell.secondStarImg.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor.lightGray.withAlphaComponent(0.5), size: CGSize(width: 30, height: 30)), for: .normal)
                }
            let img = #imageLiteral(resourceName: "message")
            let im = img.withRenderingMode(.alwaysTemplate)
            cell.mxgImg.setImage(im, for: .normal)
            cell.mxgImg.tintColor = UIColor.lightGray
            cell.mxgImg.tag = indexPath.row
            cell.userimage.sd_setImage(with: URL(string: obj.image))
            cell.name.text = obj.displayname
            cell.rating.text = String(describing: obj.avgRating!)
            cell.reviews.text = "\(obj.reviewCount!) Reviews"
            cell.price.text = "$\(obj.hourlyRate!)"
            
            
            if obj.skills.count > 0{
                let url = obj.skills[0].thumbIcon
                if url != ""{
                    cell.skill.text = obj.skills[0].categoryName
                    cell.skillImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                        // Perform your operations here.
                        cell.skillImg.image = cell.skillImg.image?.withRenderingMode(.alwaysTemplate)
                        cell.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                    }
                }
                if (obj.skills.count) > 1{
                    cell.skillCount.text = "+\((obj.skills.count) - 1)"
                }
            }
            cell.showSkillBtn.tag = indexPath.row
            cell.showSkillBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
            cell.favBtn.tag = indexPath.row
            cell.secondStarImg.tag = indexPath.row
            cell.secondStarImg.addTarget(self, action: #selector(self.postFavourite(_:)), for: .touchUpInside)
            cell.favBtn.addTarget(self, action: #selector(self.ShowHireModel(_:)), for: .touchUpInside)
            cell.mxgImg.addTarget(self, action: #selector(self.ChatBtnPressed(_:)), for: .touchUpInside)
            if obj.jobHired {
                if obj.isHired{
                    cell.favBtn.isEnabled = false
                    cell.favBtn.setTitle("Hired", for: .normal)
                    cell.btnStack.arrangedSubviews[1].isHidden = true
                }else{
                    cell.btnStackHeight.constant = 0
                }
            }else{
                    if obj.isHired{
                        cell.favBtn.isEnabled = false
                        cell.favBtn.setTitle("Hired", for: .normal)
                        cell.btnStack.arrangedSubviews[1].isHidden = true
                    }else
                    if obj.inviteStatus == "pending"{
                        cell.favBtn.setTitle(obj.inviteStatus.uppercased(), for: .normal)
                        cell.favBtn.isEnabled = false
                    }else if obj.inviteStatus == "accepted"{
                        cell.favBtn.isEnabled = true
                        cell.btnStack.arrangedSubviews[1].isHidden = true
                    }else if obj.inviteStatus == "cancelled"{
                        cell.favBtn.setTitle(obj.inviteStatus.uppercased(), for: .normal)
                        cell.favBtn.isEnabled = false
                        cell.btnStack.arrangedSubviews[1].isHidden = true
                    }else if obj.inviteStatus == "declined"{
                        cell.favBtn.setTitle(obj.inviteStatus.uppercased(), for: .normal)
                        cell.favBtn.isEnabled = false
                        cell.btnStack.arrangedSubviews[1].isHidden = true
                    }else{
                     cell.btnStack.arrangedSubviews[1].isHidden = true
                }
            }
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(self.CancelInvite(_:)), for: .touchUpInside)
            return cell
            }
            
           return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.usersArr[indexPath.row]
        
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = obj.userId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: - CANCEL INVITE
    @objc func CancelInvite(_ sender: UIButton)
    {
        let obj = usersArr[sender.tag]
        let method = "jobs/invitestatus"
        var param = Dictionary<String,AnyObject>()
        param["status"] = "cancelled" as AnyObject
        param["id"] = obj.jobInvitationId as AnyObject
        let refreshAlert = UIAlertController(title: "INVITATION", message: "Do you want to cancel Invitation for this Job?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            ALFWebService.sharedInstance.doPostData(parameters: param, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                print(response)
                let status = response["status_code"] as? Int
                if status == 204
                {
                    
                    self.usersArr[sender.tag].inviteStatus = "cancelled"
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    self.favTbl.reloadRows(at: [indexPath], with: .fade)
                    
                }else{
                    let mxg = response["message"] as? String
                    Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
                }
            }){ (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    //MARK: - LOAD PROFESSIONALS
    func loadUsers()
    {
        var method = "jobs/applicants"
        if menu.name == "view_invites"{
          method = "jobs/jobinvitations"
        }
        var dic = Dictionary<String,AnyObject>()
        dic["page"] = pageNo as AnyObject
        dic["limit"] = limit as AnyObject
        dic["id"] = self.jobId as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            print(response)
            let body = response["body"] as? Dictionary<String,AnyObject>
            self.totalUser = body!["totalItemCount"] as! Int
            if let dic = body!["response"] as? [Dictionary<String,AnyObject>] {
                for di in dic
                {
                    let menu = User.init(fromDictionary: di)
                    self.usersArr.append(menu)
                }
            }
            if self.isDataLoading{
                var indexPathsArray = [NSIndexPath]()
                for index in self.lastIndex..<self.usersArr.count - 1{
                    let indexPath = NSIndexPath(row: index, section: 0)
                    indexPathsArray.append(indexPath)
                    self.isDataLoading = false
                }
                UIView.setAnimationsEnabled(false)
                self.favTbl.beginUpdates()
                self.favTbl!.insertRows(at: indexPathsArray as [IndexPath], with: .fade)
                self.favTbl.endUpdates()
                UIView.setAnimationsEnabled(true)
            }else{
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                self.favTbl.reloadData()
            }
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    @objc func ChatBtnPressed(_ sender: UIButton)
    {
        let obj = self.usersArr[sender.tag]
        let user = UsersModel()
        user.id = String(describing: obj.userId!)
        user.label = obj.displayname
        let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .composeMessageVC) as! ComposeMessageVC
        vc.selectedUsers.append(user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - CELL DELEGATES
    func didPressedInviteBtn(_ sender: UIButton) {
        let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .sendInvitationVC) as! SendInvitationVC
        let obj = self.usersArr[sender.tag]
        vc.user_id = obj.userId
        vc.image = obj.image
        vc.ratingLbl = String(describing: obj.avgRating!)
        vc.reviewsLbl = "\(obj.reviewCount!) Reviews"
        vc.nameLbl = obj.displayname
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - SHOW HIRE MODAL
    @objc func ShowHireModel(_ sender: UIButton)
    {
        self.hireView.frame = CGRect(x: 10, y: 50, width: self.view.width - 20, height: 350)
        self.hireView.layer.cornerRadius = 10
        self.hireView.layer.borderColor = UIColor(hexString: "#FF6B00").cgColor
        self.hireView.layer.borderWidth = 5
        self.hireBtn.tag = sender.tag
        btn1.tag = 1
        self.img1.setFAIconWithName(icon: FAType.FACircle, textColor: UIColor(hexString: "#FF6B00"))
        self.img2.setFAIconWithName(icon: FAType.FACircleThin, textColor: UIColor.lightGray)
        self.view.addSubview(self.hireView)
    }
    @IBAction func CancelHire(_ sender: UIButton)
    {
        self.hireView.removeFromSuperview()
    }
    //MARK: - ONCLICK FAVOURITE BUTTON
    @IBAction func HireBtn(_ sender: UIButton)
    {
        let obj = self.usersArr[sender.tag]
        var dic = Dictionary<String,AnyObject>()
        dic["user_id"]  = obj.userId as AnyObject
        dic["id"] = self.jobId! as AnyObject
        dic["body"] = self.bodyTxt.text as AnyObject
        if btn1.tag == 1{
        dic["job_status"] = "hired" as AnyObject
        }else{
            dic["job_status"] = "" as AnyObject
        }
        if menu.name == "view_invites"{
            dic["type"] = "invite" as AnyObject
        }else{
            dic["type"] = "applied" as AnyObject
        }
        let method = "/jobs/hire"
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            let status = response["status_code"] as? Int
            if status == 204
            {
                self.hireView.removeFromSuperview()
                self.usersArr.removeAll()
                self.loadUsers()
//                obj.isHired = true
//                let indx = IndexPath(row: sender.tag, section: 0)
//                self.favTbl.reloadRows(at: [indx], with: .fade)
            }else{
                let mxg = response["message"] as? String
                Utilities.showAlertWithTitle(title: mxg!, withMessage: "", withNavigation: self)
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    @objc func postFavourite(_ sender: UIButton)
    {
         let obj = self.usersArr[sender.tag]
        var dic = Dictionary<String,AnyObject>()
        dic["user_id"] = obj.userId! as AnyObject
        let method = "/members/favorite"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            let status = response["status_code"] as? Int
            if status == 204
            {
                if obj.isFavorite{
                    obj.isFavorite = false
                }else{
                obj.isFavorite = true
                }
                let indx = IndexPath(row: sender.tag, section: 0)
                self.favTbl.reloadRows(at: [indx], with: .fade)
                return
            }else
            {
                
                Utilities.showAlertWithTitle(title: "Alert", withMessage: response["message"] as! String, withNavigation: self)
                return
            }
            
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    //MARK: - SHOW USER SKILLS
    @objc func ShowUserSkill(_ sender: UIButton)
    {
        let job = self.usersArr[sender.tag]
        vc.skillArr = job.skills
        if vc.skillArr.count > 0{
            let statVal: Double = 80
            let height = CGFloat((statVal * ceil((Double(vc.skillArr.count) / 2))))
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
    
    
}
