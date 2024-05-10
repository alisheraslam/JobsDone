//
//  LikeMembersViewController.swift
//  JobsDone
//
//  Created by musharraf on 01/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class LikeMembersViewController:  UITableViewController,memberCellDelegate {
    
    var membersArray = [Member]()
    
    @IBOutlet weak var allLabel: UILabel!
    var page = 1
    var act_id: Int?
    var comment_id: Int?
    var commentDic = Comment()
    
    //    var isRefresfing = false
    //    var memberCount = 0
    //    fileprivate var dataSourceCount = PageSize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackbutton(title: "Back")
        self.navigationItem.title = "Likes"
        self.loadMembers()
        allLabel.textColor = UIColor.lightGray
        //        self.tableView.contentInset = UIEdgeInsetsMake(54, 0, 0, 0)
        
        //        setupPullToRefresh()
    }
    //    deinit {
    //        self.tableView.removeAllPullToRefresh()
    //    }
    //    func setupPullToRefresh() {
    //
    //        let topRefresh = PullToRefresh()
    //        topRefresh.position = .top
    //
    //        self.tableView.addPullToRefresh(topRefresh) { [weak self] in
    //
    //            self?.dataSourceCount = PageSize
    //
    //            if (self?.membersArray.count)! < (self?.memberCount)! {
    //                self?.isRefresfing = true
    //                self?.page = (self?.page)! + 1
    //                self?.loadMembers()
    //            } else {
    //                self?.tableView.endRefreshing(at: .top)
    //                self?.isRefresfing = false
    //
    //            }
    //
    //        }
    //
    //    }
    
    func loadMembers(){
        //        dic.removeAll()
        var dic = Dictionary<String,AnyObject>()
        
        dic["viewAllComments"] = 0 as AnyObject
        dic["viewAllLikes"] = 1 as AnyObject
        //        dic["limit"] = 5 as AnyObject
        //        dic["page"] = page as AnyObject
        
        var method = "/likes-comments"
        dic["subject_type"] = "user_portfolio" as AnyObject
        dic["subject_id"] = act_id as AnyObject
        dic["viewAllComments"] = 0 as AnyObject
        dic["viewAllLikes"] = 1 as AnyObject
       
        
        if comment_id != nil{
            dic["comment_id"] = comment_id as AnyObject
        }
        
        
        
        //        if !self.isRefresfing {
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        //        }
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            
            print(response)
            if let scode = response["status_code"] as? Int {
                if scode == 200 {
                    //                    self.isPagination = false getTotalLikes
                    let res = response["body"] as! Dictionary<String, AnyObject>
                    
                    let getTotallike = res["getTotalLikes"] as! Int
                    //                    self.memberCount = getTotallike
                    
                    self.commentDic = Comment.init(res)
                    for obj in self.commentDic.viewAllLikesBy{
                        //                        if self.isRefresfing {
                        //                            self.membersArray.insert(obj, at: 0)
                        //                        } else {
                        self.membersArray.append(obj)
                        //                        }
                    }
                    
                    //                    if !self.isRefresfing {
                    //                        self.membersArray.reverse()
                    //                    }
                    //                    self.isRefresfing = false
                    
                    self.allLabel.text = "All likes (\(self.membersArray.count))"
                    self.tableView.reloadData()
                    
                } else {
                    
                }
            }
            
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.membersArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        let member = self.membersArray[indexPath.row]
        // Configure the cell...
        let imgurl = URL(string: member.imageProfile)
        cell.profileImage.sd_setImage(with: imgurl)
        cell.memberName.text = member.displayname
        cell.memberName.textColor = UIColor(hexString: "#FF6B00")
        
        
        if member.menus.label == ""{
            
            cell.addConnectionButton.isHidden = true
            
            
        }else{
            cell.delegate = self
            
            cell.addConnectionButton.isHidden = false
            if member.menus.label == "Add Friend"{
                
                
                cell.addConnectionButton.setFAIcon(icon: .FAUserPlus, iconSize: 20, forState: .normal)
                
            }else if member.menus.label == "Remove Friend"{
                
                cell.addConnectionButton.setFAIcon(icon: .FAUserTimes, iconSize: 20, forState: .normal)
                
            }else if member.menus.label == "Cancel Request"{
                
                cell.addConnectionButton.setFAIcon(icon: .FATimes, iconSize: 20, forState: .normal)
            }
            else if member.menus.label  == "Accept Request"{
                
                cell.addConnectionButton.setFAIcon(icon: .FAUserPlus, iconSize: 20, forState: .normal)
            }
            
            cell.addConnectionButton.tag = indexPath.row
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = self.membersArray[indexPath.row]
//        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .tabProfileVC) as! TabProfileViewController
//        con.tabProfileType = .member
//        con.id = member.userId
//        self.navigationController?.pushViewController(con, animated: true)
    }
    
    func didPressedConnectionButton(sender: UIButton) {
        
        let member = self.membersArray[sender.tag]
        
        var meth : String?
        var params =  Dictionary<String,AnyObject>()
        
        meth = member.menus.url
        params = member.menus.urlParams
        print(meth!)
        print("method is \(meth!) and params are \(params)")
        
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
        ALFWebService.sharedInstance.doPostData(parameters: params, method: meth!, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
            print(response)
            if let body = response["body"] as? Dictionary<String,AnyObject>{
                if  let res = body["response"] as? Dictionary<String,AnyObject>{
                    if  let menus = res["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                        
                        for men in menus{
                            if men["label"] as! String == "Add Friend" || men["label"] as! String == "Remove Friend" || men["label"] as! String == "Cancel Request"||men["label"] as! String == "Accept Request"{
                                
                                let gut = GutterMenuModel.init(men)
                                member.menus = gut
                            }
                        }
                    }
                }
            }
            let indexPath = IndexPath(row: sender.tag, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            
        }) { (response) in
            
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
            
        }
        
    }
    
}

