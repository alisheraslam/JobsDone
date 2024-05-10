//
//  FavProfessionalVC.swift
//  JobsDone
//
//  Created by musharraf on 07/03/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class FavProfessionalVC: UIViewController ,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate{
    @IBOutlet weak var favTbl: UITableView!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    var usersArr  = [User]()
    var totalUser = 0
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    var didEndReached:Bool=false
    var jobSkillArr = [Category]()
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favTbl.delegate = self
        self.favTbl.dataSource = self
        self.favTbl.separatorStyle = .none
        self.title = "FAVOURITE"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        notesView.layer.borderWidth = 5
        notesView.layer.borderColor = UIColor(hexString: "#FF6B00").cgColor
        notesView.layer.cornerRadius = 5
        notesView.center = self.view.center
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "back_white"), for: .normal)
        button.setTitle("Back", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.ShowPop(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        loadUsers()
        // Do any additional setup after loading the view.
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            UIView.animate(withDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
                self.notesView.frame.origin.y = 60
            })
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            UIView.animate(withDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
                self.notesView.frame.origin.y = 50
            })
            
        }
        
    }
    @objc func ShowPop(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func CancelPressed(_ sender: UIButton)
    {
        self.notesView.removeFromSuperview()
    }
    
    @IBAction func SavePressed(_ sender: UIButton)
    {
        let user = self.usersArr[sender.tag]
        var param = Dictionary<String,AnyObject>()
        param["user_id"] = user.userId as AnyObject
        param["notes"] = self.notesField.text as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: param, method: "members/profile/notes", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 204{
                    self.usersArr[sender.tag].notes = self.notesField.text
                    self.notesView.removeFromSuperview()
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    self.favTbl.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    //MARK: - SHOW NOTES
    @objc func ShowNotes(_ sender: UIButton)
    {
        let user = self.usersArr[sender.tag]
        self.notesField.text = user.notes ?? ""
        saveBtn.tag = sender.tag
        
        self.view.addSubview(notesView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - PAGINATION
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((favTbl.contentOffset.y + favTbl.frame.size.height) >= favTbl.contentSize.height)
        {
            if usersArr.count < totalUser{
                if !isDataLoading{
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    //                self.offset=self.limit * self.pageNo
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
            cell.secondStarImg.tag = indexPath.row
            cell.pencilBtn.tag = indexPath.row
            cell.pencilBtn.addTarget(self, action: #selector(self.ShowNotes(_:)), for: .touchUpInside)
            cell.secondStarImg.addTarget(self, action: #selector(self.FavBtnPressed(_:)), for: .touchUpInside)
            cell.secondStarImg.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 30, height: 30)), for: .normal)
            cell.mxgImg.setImage(UIImage.fontAwesomeIcon(name: .envelope, textColor: UIColor.lightGray, size: CGSize(width: 30, height: 30)), for: .normal)
            cell.pencilImg.image = UIImage.fontAwesomeIcon(name: .pencil, textColor: UIColor.lightGray, size: CGSize(width: 30, height: 30))
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
            if obj.notes != "" && obj.notes != nil{
                cell.pencilImg.image = cell.pencilImg.image?.withRenderingMode(.alwaysTemplate)
                cell.pencilImg.tintColor = UIColor(hexString: "#FF6B00")
            }else{
                cell.pencilImg.image = cell.pencilImg.image?.withRenderingMode(.alwaysTemplate)
                cell.pencilImg.tintColor = UIColor.lightGray
            }
            cell.showSkillBtn.tag = indexPath.row
            cell.showSkillBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(self.didPressedInviteBtn(_:)), for: .touchUpInside)
            cell.mxgImg.tag = indexPath.row
            cell.mxgImg.addTarget(self, action: #selector(self.ChatBtnPressed(_:)), for: .touchUpInside)
            if UserDefaults.standard.value(forKey: "id") as? Int == obj.userId{
                cell.mxgImg.isHidden = true
                cell.pencilImg.isHidden = true
                cell.favBtn.isHidden = true
            }
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
    
    
    //MARK: - LOAD PROFESSIONALS
    func loadUsers()
    {
        let method = "members/favorite-professionals"
        var dic = Dictionary<String,AnyObject>()
        dic["page"] = pageNo as AnyObject
        dic["limit"] = limit as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            
            print(response)
            let body = response["body"] as? Dictionary<String,AnyObject>
            self.totalUser = body!["totalItemCount"] as! Int
            self.totalLbl.text = String(describing: self.totalUser)
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
                self.favTbl.reloadData()
            }
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }) { (response) in
             Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
   
    //MARK: - CELL DELEGATES
    @objc func didPressedInviteBtn(_ sender: UIButton) {
        let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .sendInvitationVC) as! SendInvitationVC
        let obj = self.usersArr[sender.tag]
        vc.user_id = obj.userId
        vc.image = obj.image
        vc.ratingLbl = String(describing: obj.avgRating!)
       vc.reviewsLbl = "\(obj.reviewCount!) Reviews"
        vc.nameLbl = obj.displayname
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didPressedInviteBtn(tag: Int) {
        
    }
    
    //MARK: - ONCLICK FAVOURITE BUTTON
    @objc func FavBtnPressed(_ sender: UIButton)
    {
        var indexPath : IndexPath!
        if let cell = sender.superview?.superview?.superview as? FavouriteCell{
             indexPath = self.favTbl.indexPath(for: cell)
            
        }
        let obj = self.usersArr[indexPath.row]
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
                    // Now delete the table cell
                    self.usersArr.remove(at: indexPath!.row)
                if self.usersArr.count == 0{
                    self.favTbl.reloadData()
                }else{
                    self.favTbl.beginUpdates()
                    self.favTbl.deleteRows(at: [indexPath!], with: .fade)
                    self.favTbl.endUpdates()
                }
                self.totalLbl.text = "\(Int(self.totalLbl.text!)! - 1)"
                
            }
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
    
    @IBAction func ChatBtnPressed(_ sender: UIButton)
    {
        let obj = self.usersArr[sender.tag]
        let user = UsersModel()
        user.id = String(describing: obj.userId!)
        user.label = obj.displayname
        let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .composeMessageVC) as! ComposeMessageVC
        vc.selectedUsers.append(user)
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

}
