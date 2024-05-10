//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import NextGrowingTextView



private let PageSize = 20

enum commentScreen{
    
    case feeds
    case albums
    case videos
    case blogs
    case classifieds
    case music
    case polls
    case documents
    case lostAndFound
    case jobs
}

class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CommentCellProtocolDelegate,GutterMenuProtocol{
    
    var indexOrCount = 0
    var labels : UILabel!
    var commentScreenType = commentScreen.feeds
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var growingTextView: NextGrowingTextView!
    @IBOutlet weak var sendBtn: WAButton!
    
    
    var refresh = UIRefreshControl()
    var isPagination = false
    let guttMenuHandler = GutterMenuHandler()
    
    var delegate: CommentCellProtocolDelegate?
    var commentDic = Comment()
    var allComments = [CommentObject]()
    var act_id: Int?
    var cout: Int?
    var cellSection: IndexPath?
    
    
    var page = 1
    var isRefresfing = false
    var commentCount = 0
    
    fileprivate var dataSourceCount = PageSize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Utilities.isGuest() {
            growingTextView.isHidden = true
            sendBtn.isHidden = true
        } else {
            growingTextView.isHidden = false
            sendBtn.isHidden = false
        }
        sendBtn.backgroundColor = UIColor(hexString: "FF6B00")
        self.title = "Comments"
        guttMenuHandler.delegate = self
        tbl.tableFooterView = UIView()
//        tbl.rowHeight = UITableViewAutomaticDimension
//        tbl.estimatedRowHeight = 75
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentVC.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentVC.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.growingTextView.layer.cornerRadius = 4
        self.growingTextView.backgroundColor = UIColor(white: 1, alpha: 1)
        self.growingTextView.layer.borderWidth = 0.5
        self.growingTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.growingTextView.backgroundColor = UIColor(hexString: "F2F2F2").withAlphaComponent(0.5)
        self.growingTextView.textView.textContainerInset = UIEdgeInsets(top: 7, left: 0, bottom: 5, right: 0)
        self.growingTextView.placeholderLabel.attributedText = NSAttributedString(string: "Write here...",attributes: [NSAttributedString.Key.font: self.growingTextView.textView.font!, NSAttributedString.Key.foregroundColor: UIColor.gray
            ])
        
        getComments()
        
//        let but = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backs))
//
//        self.navigationItem.leftBarButtonItem = but
        if #available(iOS 10.0, *) {
            self.tbl.refreshControl = refresh
        } else {
            self.tbl.addSubview(refresh)
        }
        refresh.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.allComments.removeAll()
        page = 1
        self.isRefresfing = true
        self.refresh.beginRefreshing()
        self.getComments()
        
    }
    

    func backs(){
        self.navigationController?.popViewController(animated: true)
    }

//    func setupPullToRefresh() {
//
//        let topRefresh = PullToRefresh()
//        topRefresh.position = .top
//
//        let bottomRefresh = PullToRefresh()
//        bottomRefresh.position = .bottom
//
//
//        tbl.addPullToRefresh(topRefresh) { [weak self] in
//
//            self?.dataSourceCount = PageSize
//
//            if (self?.allComments.count)! < (self?.commentCount)! {
//                self?.isRefresfing = true
//                self?.page = (self?.page)! + 1
//                self?.getComments()
//            } else {
//                self?.tbl.endRefreshing(at: .top)
//                self?.isRefresfing = false
//
//            }
//
//        }
//
//    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        growingTextView.resignFirstResponder()
        self.view.endEditing(true)
    }
    func textViewDidChange(_ textView: UITextView) {
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if Utilities.isGuest() {
            return false
        }
        print("sdfds")
        return true
    }
    
    @IBAction func handleSendButton(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        print(growingTextView.textView.text)
        if growingTextView.textView.text.isEmpty {
            Utilities.showAlertWithTitle(title: "Alert", withMessage: "Please Write Comment to Post!", withNavigation: self)
            return
        }
        
        var method = "comment-create"
        var dic = Dictionary<String,AnyObject>()
        dic["body"] = growingTextView.textView.text as AnyObject
        dic["subject_id"] = act_id as AnyObject
        dic["subject_type"] = "user_portfolio" as AnyObject
        dic["viewAllComments"] = 1 as AnyObject
       
        if !self.isRefresfing {
//            self.refesh
        }
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            
            print(response)
            
            let scode = response["status_code"] as! Int
            if scode == 200 {
                self.growingTextView.textView.text = ""
                if let body = response["body"] as? Dictionary<String,AnyObject>{
                    let obj = CommentObject.init(body)
//                    self.allComments.insert(obj, at: 0)
//                    self.commentDic = Comment.init(body)
                    self.allComments.append(obj)
                    self.commentCount = self.commentCount + 1
                    var index = Int()
                    if self.allComments.count == 0{
                        index = 0
                    }else{
                        index = self.allComments.count - 1
                    }
                    
//                    self.tbl.insertRows(at: [IndexPath(row:index,section:0)], with: .none)
                    self.tbl.reloadData()
                }
                
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "commentAdded"), object: nil)
                
            }
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
        }) { (response) in
            
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
        }
        
    }
    
    func getComments(){
        
//        commentDic.viewAllComments.removeAll()
        
        let method = "likes-comments"
        var dic = Dictionary<String,AnyObject>()
        dic["viewAllComments"] = 1 as AnyObject
        dic["viewAllLikes"] = 0 as AnyObject
        dic["limit"] = 5 as AnyObject
        dic["page"] = page as AnyObject
        dic["subject_id"] = self.act_id as AnyObject
        dic["subject_type"] = "user_portfolio" as AnyObject
        
     
        if !self.isRefresfing {
            if self.navigationController?.view == nil {
                Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            } else{
                Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
            }
            
        }
      
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            
            print(response)
            if self.navigationController?.view == nil {
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            } else{
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
            }
            
            
            let scode = response["status_code"] as! Int
            if scode == 200 {
                let res = response["body"] as! Dictionary<String, AnyObject>
                let getTotalComments = res["getTotalComments"] as! Int
                self.commentCount = getTotalComments

                self.commentDic = Comment.init(res)
                for obj in self.commentDic.viewAllComments{
                    if self.isRefresfing {
                        self.allComments.insert(obj, at: 0)
                    } else {
                        self.allComments.append(obj)
                    }
                    
                }
                if !self.isRefresfing {
                    self.allComments.reverse()
                }
                if self.isRefresfing == true{
                    self.refresh.endRefreshing()
                    self.isRefresfing = false
                }
                self.isRefresfing = false
                
                self.tbl.reloadData()
 
            } else {
                
            }

             
        }) { (response) in
            if self.navigationController?.view == nil {
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            } else{
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
            }

            print(response)

        }
        
        
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                self.inputContainerViewBottom.constant =  0
                //textViewBottomConstraint.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.inputContainerViewBottom.constant = keyboardHeight - 45
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.allComments.count)
        if allComments.count == 0 {
            return 1
        } else {
            if (self.allComments.count) < (self.commentCount) {
                return allComments.count + 1
            } else {
                return allComments.count + 1
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if (self.allComments.count) < (self.commentCount) {
                return 30
            } else {
                if self.allComments.count == 0 {
                    return 75
                } else {
                   return 0
                }
            }

        } else {
//           return 75
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if (self.allComments.count) < (self.commentCount) {
                return 30
            } else {
                return 0
            }
            
        } else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if allComments.count == 0 {
            
            let identifier = "Cell"
            var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            if cell == nil {
                tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
            }
            cell.cellLabel.text = "No comment posted yet"
            self.tbl.separatorStyle = .none
            return cell
            
        } else {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pullCell")
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CommentCell
                
                let arr = allComments[indexPath.row - 1]
                
                if arr.like?.isLike == false {
                    
                    cell.likeBtn.setTitle("Like", for: .normal)
                    
                } else {
                    
                    cell.likeBtn.setTitle("Unlike", for: .normal)
                }
                if self.commentDic.canComment != nil{
                if self.commentDic.canComment! {
                    cell.likeBtn.isHidden = false
                    
                } else {
                    cell.likeBtn.isHidden = true
                    
                }
                }
                if self.commentDic.canDelete! {
                    cell.deleteBtn.isHidden = false
                } else {
                    cell.deleteBtn.isHidden = false
                }
                if arr.like_count == 0 {
                    cell.likesImgWidth.constant = 0
                    cell.likesLbl.isHidden = true
                    cell.likesImgLead.constant = 0
                } else {
                    cell.likesImgWidth.constant = 21
                    cell.likesLbl.isHidden = false
                    cell.likesImgLead.constant = 8
                }
                print(commentDic.getTotalLikes)
                cell.likesLbl.text = String(describing: arr.like_count)
                cell.deleteBtn.isHidden = (arr.delete != nil) ? false : true
                
                cell.pImg.setImageWith(URL(string:arr.author_image_icon)!)
                
                //        let date = Utilities.dateFromString(arr.comment_date)
                //        let str = Utilities.timeAgoSinceDate(date: date, numericDates: true)
                print(arr.comment_timestamp)
                var time_stamp = ""
                if arr.comment_timestamp == "" {
                    time_stamp = "a seconds ago"
                } else {
                    time_stamp = arr.comment_timestamp
                }
                cell.configCell(name: arr.author_title, comment: arr.comment_body, time: time_stamp)
//                cell.cellBackView.backgroundColor = UIColor(hexString: navbarTint).withAlphaComponent(0.1)
                cell.delegate = self
                cell.tag = indexPath.row
                
                return cell
            }
            
        }
        
    }
    
    
    func didPressedLikeButton(tag: Int) {
        if Utilities.isGuest() {
            return
        }
        let arr = allComments[tag - 1]
        if arr.like?.isLike == false{
                arr.like_count = arr.like_count + 1
        }else{
            arr.like_count = arr.like_count - 1
        }
        arr.like?.isLike = !(arr.like?.isLike)!
        self.tbl.reloadRows(at: [IndexPath(row:tag,section:0)], with: .none)
        guttMenuHandler.likeAction(menu: arr.like!, con: self, index: tag)

    }
    func didPressedLikeImg(tag: Int) {
        
//        let arr = allComments[tag - 1]
//        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .likeMembersViewController) as! LikeMembersViewController
//        con.act_id = act_id
//        con.comment_id = arr.comment_id
//        self.navigationController?.pushViewController(con, animated: true)
        
    }
    func didPressedDeleteButton(tag: Int) {
        if Utilities.isGuest() {
            return
        }
        let arr = allComments[tag - 1]
        
        guttMenuHandler.deleteMenu(menu: arr.delete!, con: self, index: tag)
    }
    
    func didPressedUserNameOrImageButton(tag: Int) {
//        let arr = allComments[tag - 1]
//        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .tabProfileVC) as! TabProfileViewController
//        con.tabProfileType = .member
//        con.id = arr.user_id
//        self.navigationController?.pushViewController(con, animated: true)
    }
    

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
    }
    
    //    MARK: - GUTTER HANDLER
    func deleteDoneWithIndex(index: Int) {
        let newIndex = index - 1
        allComments.remove(at: newIndex)
        self.commentCount = self.commentCount - 1
        
        self.tbl.reloadData()
    }
    func addPhotosPressed(menu: GutterMenuModel) {
        
    }
    func likeDoneWithIndex(gutModel: GutterMenuModel, index: Int) {
        let newIndex = index - 1
        self.allComments[newIndex].like = gutModel
        
        
    }
    func shareDoneWithIndex(index: Int) {
        
    }
    func leaveOrJoinDoneWithMenu(gutMenu: [GutterMenuModel], index: Int) {
    }
    func requestMemberDoneWithMenu(gutMenu: [GutterMenuModel], index: Int) {
     
    }
    func changeProfileImgPressed() {
        
    }
    func quoteDoneWithIndex(index: Int?) {
        //
    }
    
    func postReplyWithIndex() {
        //
    }
}

