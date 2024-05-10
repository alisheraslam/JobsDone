//
//  GutterMenuHandler.swift
//  SchoolChain
//
//  Created by musharraf on 11/05/2017.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Photos
import BSImagePicker


enum pluginType : String{
    case groups = "groups"
    case myGroups = "groups/manage"
    case albums  = "albums"
    case myAlbums  = "albums/manage"
    case upComingEvents = "events"
    case pastEvents = "events/past"
    case myEvents = "events/manage"
    case myTickets = "tickets"
    case videos = "videos"
    case myVideos = "videos/manage"
    case blogs = "blogs"
    case myBlogs = "blogs/manage"
    case classified = "classifieds"
    case myClassified = "classifieds/manage"
    case music = "music"
    case myMusic = "music/manage"
    case polls = "polls"
    case myPolls = "polls/manage"
    case jobs = "jobs"
    case myJobs = "jobs/manage"
    case documents = "documents"
    case myDocuments = "documents/manage"
    case myLostAndFounds = "lostfounds/manage"
    case lostsAndFounds = "lostfounds/browse",losts,founds
    case miscellaneous
    case myProfile = "profile"
    case topic = "topic"
    case portfolio = "portfolio"
    
    var description: String {
        switch self {
        case .losts:
            return "lostfounds/browse"
        case .founds:
            return "lostfounds/browse"
        default:
            return rawValue
        }
    }
}

@objc protocol GutterMenuProtocol {
    
    @objc optional func deleteDoneWithIndex(index:Int)
    @objc optional func removeMemberDoneWithIndex(index:Int)
    @objc optional func approveRequestDoneWithIndex(gutModel:[GutterMenuModel],index:Int)
    @objc optional func rejectRequestDoneWithIndex(gutModel:[GutterMenuModel])
    @objc optional func rejectMemberDoneWithIndex(index:Int)
    @objc optional func makeOfficerDoneWithIndex(gutModel:[GutterMenuModel],index:Int)
    @objc optional func shareDoneWithIndex(index:Int)
    @objc optional func changeProfileImgPressed()
    
    @objc optional func addPhotosPressed(menu:GutterMenuModel)
    
    @objc optional func likeDoneWithIndex(gutModel:GutterMenuModel,index:Int)
    @objc optional func leaveOrJoinDoneWithMenu(gutMenu:[GutterMenuModel],index:Int)
    @objc optional func requestMemberDoneWithMenu(gutMenu:[GutterMenuModel],index:Int)
    
}

class GutterMenuHandler: NSObject,UITextViewDelegate,ReportAlertViewDelegate{
    
    var views : ReportAlertView!
    var viewss : EmailAttachmentView!
    var blurEffectView : UIView!
    
    var con: UIViewController!
    
    var delegate : GutterMenuProtocol? = nil
    var homeDelegate: MainPageProtocol!
    // MARK:- Set Gutter Menu for Feeds
    func setGutterMenu(menu:[GutterMenuModel], con:UIViewController, index:Int?, type:pluginType?, senderr: AnyObject, view: UIView, btnTyp: String?){
        self.con = con
        
        let alertController = UIAlertController(title: "Choose Options", message: "", preferredStyle: .actionSheet)
        print(menu)
        for men in menu{
            
            let action = UIAlertAction(title: men.label, style: self.actionStyle(label: men.name), handler: { (action) in
                
                if men.name == "delete_feed"{
                    
                    self.deleteMenu(menu: men, con: con, index: index)
                    
                }
//
                if men.name == "share"{
                    
                    self.shareMenu(menu: men, con: con, index: index)
                }
                if men.name == "delete" {
                    
                    self.deleteMenu(menu: men, con: con, index: index)
                }
                if men.name == "close" || men.name == "open"{
                    
                    self.closeMenu(menu: men, con: con, index: index)
                }
                
                if men.name == "join" || men.name == "leave" || men.name == "cancel_request" || men.name == "add_friend" || men.name == "remove_friend" || men.name == "user_profile_block" || men.name == "user_profile_unblock" || men.name == "accept_request" || men.name == "subscribe" || men.name == "unsubscribe" || men.name == "close" || men.name == "watch_topic" || men.name == "stop_watch_topic" {
                    
                    self.joinLeaveAction(menu: men, con: con, index: index)
                }
                if men.name == "request_member" {
                    
                    self.requestMemberAction(menu: men, con: con, index: index)
                }
                if men.name == "edit"{
                    
                    self.editAction(menu: men, con: con, type:type!)
                }
                
                if men.name == "cancel_invite"{
                    self.cancelInvitationAction(menu: men, con: con, index: index)
                    
                }
                if men.name == "user_home_edit"{
                    
                    self.editAction(menu: men, con: con, type:type!)
                }
                if men.name == "user_edit_photo"{
                    self.delegate?.changeProfileImgPressed!()
                    //                    self.editAction(menu: men, con: con, type:type!)
                }
                if men.name == "invite"{
                    self.inviteAction(menu: men, con: con, type:type!)
                }
                if men.name == "report_feed" || men.name == "report"{
                    self.reportAction(menu: men, con: con, index: nil)
                }
                if men.name == "remove_member"{

                    self.removeMember(menu: men, con: con, index: index)
                }
                if men.name == "approved_member"{
                    
                 self.approveMemberAction(menu: men, con: con, index: index)
                }
                if men.name == "reject_member"{
                    
                 self.rejectMemberAction(menu: men, con: con, index: index)
                }
                if men.name == "reject_request"{
                    
                    self.rejectRequestAction(menu: men, con: con, index: index)
                }
                if men.name == "make_officer"{
                    self.makeOfficerAction(menu: men, con: con, index: index)
                }
                if men.name == "download"{
                    self.downloadAction(menu: men, con: con, index: nil)
                }
                
                if men.name == "email"{
                    self.emailAction(menu: men, con: con, index: nil)
                }
                if men.name == "photo"{
                    self.addPhotoAction(menu: men, con: con, index: nil)
                }
                if men.name == "add"{
                    self.addPhotoAction(menu: men, con: con, index: nil)
                }
                if men.name == "view_applicants"{
                    self.OpenApplicantsView(menu: men, con: con, type: type!)
                }
                if men.name == "view_invites"{
                    self.OpenApplicantsView(menu: men, con: con, type: type!)
                }
                
             
                
            })
            
            
            
            // which are not show for gutter for time being
           
            if men.name == "update_save_feed" || men.name == "hide" || men.name == "disable_comment" || men.name == "lock_this_feed" || men.name == "create" || men.name == "post_reply" || men.name == "browse"{
                
            }else{
                
                alertController.addAction(action)
            }
            
        }
        
        if alertController.actions.count > 0{
            
            let cancelActForIPhone = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                
            })
            let cancelActForIPad = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
                alertController.addAction(cancelActForIPad)
            } else {
                alertController.addAction(cancelActForIPhone)
            }
            Utilities.doCustomAlertBorder(alertController)
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
                if let popoverPresentationController = alertController.popoverPresentationController {
                    
                    if btnTyp == "barBtn" {
                        popoverPresentationController.sourceView = senderr as? UIView
                        popoverPresentationController.barButtonItem = senderr as? UIBarButtonItem
                    } else if btnTyp == "btn" {
                        popoverPresentationController.sourceView = senderr as? UIView
                        popoverPresentationController.sourceRect = senderr.bounds
                        
                    }

                }
                con.present(alertController, animated: true, completion: nil)
                
            } else {
                con.present(alertController, animated: true, completion: nil)
            }

        }
        
    }
    
    
    
    
    
    
    // Action Style function
    func actionStyle(label:String)->UIAlertAction.Style{
        
        if label == "Hide" || label == "delete_feed" || label == "Lock this Feed" || label == "leave" || label == "delete" || label == "report_feed" || label == "report" || label == "remove_member" || label == "reject_member"{
            return .destructive
        }
        
        return .default
    }
    
    
    
    
    // MARK: - Remove Member
    func removeMember(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        
        
        let alertController = UIAlertController(title: "Remove",message: "Do you want to Remove this member?", preferredStyle: .alert)
        
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: "Remove", style:.destructive  , handler: { action in
            
            
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doDeleteData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                self.delegate?.removeMemberDoneWithIndex!(index: index!)
                
            }, fail: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
            })
            
        })
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        Utilities.doCustomAlertBorder(alertController)
        
        con.present(alertController, animated: true, completion: {})
    }
    
    // MARK: - DELETE
    func deleteMenu(menu:GutterMenuModel, con:UIViewController, index:Int?){
        let alertController = UIAlertController(title: menu.label,message: "Do you want to \(menu.label) ?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: "Delete", style:.destructive  , handler: { action in
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                con.navigationController?.popViewController(animated: true)
                if index == nil {
                    self.delegate?.deleteDoneWithIndex!(index: 0)
                } else {
//                    self.homeDelegate.deleteDoneWithIndex(index: index!)
                    self.delegate?.deleteDoneWithIndex!(index: index!)
                }
            }, fail: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
            })
            
        })
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        Utilities.doCustomAlertBorder(alertController)
        
        con.present(alertController, animated: true, completion: {})
    }
    // MARK: - Close
    func closeMenu(menu:GutterMenuModel, con:UIViewController, index:Int?){
        let alertController = UIAlertController(title: menu.label,message: "Do you want to \(menu.label) ?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: menu.name, style:.destructive  , handler: { action in
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                con.navigationController?.popViewController(animated: true)
            }, fail: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
            })
            
        })
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        Utilities.doCustomAlertBorder(alertController)
        
        con.present(alertController, animated: true, completion: {})
    }
    
    
    // MARK: - Share
    func shareMenu(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        let alertController = UIAlertController(title: "Share this by re-posting it with your own message! \n\n\n\n\n", message: "", preferredStyle: .alert)
        
        let rect        = CGRect(x: 15, y: 75, width: 240, height: 100.0)
        let textView    = UITextView(frame: rect)
        
        textView.font               = UIFont(name: "Helvetica", size: 15)
        textView.textColor          = UIColor.lightGray
        textView.backgroundColor    = UIColor.white
        textView.layer.borderColor  = UIColor.lightGray.cgColor
        textView.layer.borderWidth  = 1.0
        textView.text               = "Enter message here"
        textView.delegate           = self
        
        alertController.view.addSubview(textView)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Share", style: UIAlertAction.Style.default, handler: { action in
            
            let msg = textView.text
            print(msg as Any)
            if (msg?.isEmpty)! {
                Utilities.showAlertWithTitle(title: "Alert", withMessage: "Please Write Comment to Post!", withNavigation: con)
                return
            } else {
                self.delegate?.shareDoneWithIndex!(index: index!)
                let url = menu.url
                var urlParams = Dictionary<String,AnyObject>()
                urlParams = menu.urlParams
                print("url is \(url) \n and parms are \(urlParams)" )
                urlParams["body"] = msg as AnyObject
                ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
                    
                    print(response)
                    let scode = response["status_code"] as! Int
                    if scode == 204 {
                        Utilities.showAlertWithTitle(title: "Success", withMessage: "Successfully Sahred!", withNavigation: con)
                    } else {
                        
                    }
                }) { (response) in
                    
                    print(response)
                }
            }
            
        })
        alertController.addAction(cancel)
        alertController.addAction(action)
        Utilities.doCustomAlertBorder(alertController)
        con.present(alertController, animated: true, completion: {
            textView.becomeFirstResponder()
        })
        
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        if textView.text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        //        self.view.endEditing(true)
        if textView.text.isEmpty {
            textView.text = ""
            textView.textColor = UIColor.lightGray
        }
    }
    // MARK: - Add Photos
    func addPhotoAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        delegate?.addPhotosPressed!(menu: menu)
        
    }
    
    
    // MARK: - LIKE
    func likeAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        let url = menu.url
        var urlParams = Dictionary<String,AnyObject>()
        urlParams = menu.urlParams
        print("url is \(url) \n and parms are \(urlParams)" )
        Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
        ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView:(con.navigationController?.view)!)
            print(response)
            let scode = response["status_code"] as! Int
            if scode == 200 {
                if let body = response["body"] as? Dictionary<String,AnyObject>{
                    if let gut = body["like"] as? Dictionary<String,AnyObject>{
                        let gutmod = GutterMenuModel.init(gut)
                        self.delegate?.likeDoneWithIndex!(gutModel: gutmod, index: index!)
                    }
                }
            } else {
                
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView:(con.navigationController?.view)!)
            print(response)
            
        }
        
    }
    
    
    
    // MARK: - JOIN LEAVE
    func joinLeaveAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        
        let alertController = UIAlertController(title: menu.label,message: "Do you want to \(menu.name) it?", preferredStyle: .alert)
        
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: menu.label, style:self.actionStyle(label: menu.name)  , handler: { action in
            
            
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let gut = body["response"] as? Dictionary<String,AnyObject>{
                            if let guts = gut["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                                var arr = [GutterMenuModel]()
                                for men in guts{
                                    let gutmod = GutterMenuModel.init(men)
                                    arr.append(gutmod)
                                    
                                }
                                
//                                self.delegate?.leaveOrJoinDoneWithMenu!(gutMenu: arr, index: index!)
                                self.delegate?.leaveOrJoinDoneWithMenu!(gutMenu: arr, index: 0)
                            }
                        }
                        
                        
                        if let guts = body["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                            var arr = [GutterMenuModel]()
                            for men in guts{
                                let gutmod = GutterMenuModel.init(men)
                                arr.append(gutmod)
                                
                            }
                            
                            self.delegate?.leaveOrJoinDoneWithMenu!(gutMenu: arr, index: 0)
                        }
                    }
                } else {
                    
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                
            }
        })
        
        
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        
        Utilities.doCustomAlertBorder(alertController)
        con.present(alertController, animated: true, completion: {})
    }
    //MARK:- request_member
    func requestMemberAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        
        let alertController = UIAlertController(title: menu.label,message: "Do you want to \(menu.name) it?", preferredStyle: .alert)
        
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: menu.label, style:self.actionStyle(label: menu.name)  , handler: { action in
            
            
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let gut = body["response"] as? Dictionary<String,AnyObject>{
                            if let guts = gut["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                                var arr = [GutterMenuModel]()
                                for men in guts{
                                    let gutmod = GutterMenuModel.init(men)
                                    arr.append(gutmod)
                                    
                                }
                                
                                self.delegate?.requestMemberDoneWithMenu!(gutMenu: arr, index: 0)
                            }
                        }
                        
                        
                        if let guts = body["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                            var arr = [GutterMenuModel]()
                            for men in guts{
                                let gutmod = GutterMenuModel.init(men)
                                arr.append(gutmod)
                                
                            }
                            
                            self.delegate?.leaveOrJoinDoneWithMenu!(gutMenu: arr, index: 0)
                        }
                    }
                } else {
                    
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                
            }
        })
        
        
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        Utilities.doCustomAlertBorder(alertController)
        
        con.present(alertController, animated: true, completion: {})
    }
    //MARK:- Reject Member
    func rejectMemberAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        print(index!)
        let alertController = UIAlertController(title: menu.label,message: "Do you want to reject this member?", preferredStyle: .alert)
        
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: menu.label, style:self.actionStyle(label: menu.label)  , handler: { action in
            
            
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let gut = body["response"] as? Dictionary<String,AnyObject>{
                            if let guts = gut["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                                var arr = [GutterMenuModel]()
                                for men in guts{
                                    let gutmod = GutterMenuModel.init(men)
                                    arr.append(gutmod)
                                    
                                }
                                print(index!)
                                
                                self.delegate?.rejectMemberDoneWithIndex!(index: index!)
                            }
                        }
                    }
                } else {
                    
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                
            }
        })
        
        
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        Utilities.doCustomAlertBorder(alertController)
        
        con.present(alertController, animated: true, completion: {})
    }
    //MARK:- Reject Request
    func rejectRequestAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        
        let alertController = UIAlertController(title: menu.label,message: "Do you want to reject this member?", preferredStyle: .alert)
        
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: menu.label, style:self.actionStyle(label: menu.label)  , handler: { action in
            
            
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let gut = body["response"] as? Dictionary<String,AnyObject>{
                            if let guts = gut["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                                var arr = [GutterMenuModel]()
                                for men in guts{
                                    let gutmod = GutterMenuModel.init(men)
                                    arr.append(gutmod)
                                    
                                }
                                
                                self.delegate?.rejectRequestDoneWithIndex!(gutModel: arr)
                            }
                        }
                    }
                } else {
                    
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                
            }
        })
        
        
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        Utilities.doCustomAlertBorder(alertController)
        
        con.present(alertController, animated: true, completion: {})
    }
    //MARK:- cancel Invitation
    func cancelInvitationAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        print(index!)
        let alertController = UIAlertController(title: menu.label,message: "Do you want to cancel Invitation of this member?", preferredStyle: .alert)
        
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: menu.label, style:self.actionStyle(label: menu.label)  , handler: { action in
            
            
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doDeleteData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let gut = body["response"] as? Dictionary<String,AnyObject>{
                            if let guts = gut["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                                var arr = [GutterMenuModel]()
                                for men in guts{
                                    let gutmod = GutterMenuModel.init(men)
                                    arr.append(gutmod)
                                    
                                }
                                print(index!)
                                self.delegate?.rejectMemberDoneWithIndex!(index: index!)
                            }
                        }
                    }
                } else {
                    
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                
            }
        })
        
        
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        Utilities.doCustomAlertBorder(alertController)
        
        con.present(alertController, animated: true, completion: {})
    }
    //MARK:- Approve Member
    func approveMemberAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        
        let alertController = UIAlertController(title: menu.label,message: "Do you want to approve this member?", preferredStyle: .alert)
        
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: menu.label, style:self.actionStyle(label: menu.label)  , handler: { action in
            
            
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let gut = body["response"] as? Dictionary<String,AnyObject>{
                            if let guts = gut["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                                var arr = [GutterMenuModel]()
                                for men in guts{
                                    let gutmod = GutterMenuModel.init(men)
                                    arr.append(gutmod)
                                    
                                }
                            
                                self.delegate?.approveRequestDoneWithIndex!(gutModel: arr, index: index!)
                            }
                        }
                        
            
                    }
                } else {
                    
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                
            }
        })
        
        
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        Utilities.doCustomAlertBorder(alertController)
        
        con.present(alertController, animated: true, completion: {})
    }
    //MARK:- Make Officer
    func makeOfficerAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        
        let alertController = UIAlertController(title: menu.label,message: "Do you want to make this member 'officer'?", preferredStyle: .alert)
        
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAct = UIAlertAction(title: menu.label, style:self.actionStyle(label: menu.label)  , handler: { action in
            
            
            let url = menu.url
            var urlParams = Dictionary<String,AnyObject>()
            urlParams = menu.urlParams
            
            print("url is \(url) \n and parms are \(urlParams)" )
            Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                let scode = response["status_code"] as! Int
                if scode == 200 {
                    if let body = response["body"] as? Dictionary<String,AnyObject>{
                        if let gut = body["response"] as? Dictionary<String,AnyObject>{
                            if let guts = gut["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                                var arr = [GutterMenuModel]()
                                for men in guts{
                                    let gutmod = GutterMenuModel.init(men)
                                    arr.append(gutmod)
                                    
                                }
                                
//                                self.delegate?.approveRequestDoneWithIndex!(gutModel: arr, index: index!)
                            }
                        }
                      
                    }
                } else {
                    
                }
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (con.navigationController?.view)!)
                print(response)
                
            }
        })
        
        
        
        alertController.addAction(noAction)
        alertController.addAction(deleteAct)
        
        Utilities.doCustomAlertBorder(alertController)
        
        con.present(alertController, animated: true, completion: {})
    }
    func OpenApplicantsView(menu: GutterMenuModel, con: UIViewController, type: pluginType)
    {
        let vc = UIStoryboard.storyBoard(withName: .MyJob).loadViewController(withIdentifier: .applicantsVC) as! ApplicantsVC
        vc.jobId = menu.urlParams["id"] as? Int
        vc.menu = menu
        vc.inviteId = menu.urlParams["invite_id"] as? Int
        con.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //    MARK: - Invite ACTION
    
    func inviteAction(menu:GutterMenuModel, con:UIViewController, type:pluginType){
        
//        let inviteVC = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .inviteGuestVC) as! InviteGuestVC
//
//        inviteVC.dic = menu.urlParams
//        inviteVC.method = menu.url
//        con.navigationController?.pushViewController(inviteVC, animated: true)
        
    }
    //    MARK: - EDIT ACTION
    
    func editAction(menu:GutterMenuModel, con:UIViewController, type:pluginType){
        if type == .jobs{
            let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .createJobVC) as! CreateJobVC
            vc.controllerType = .EDIT
            vc.dic = menu.urlParams
            con.navigationController?.pushViewController(vc, animated: true)
        }else if type == .portfolio{
            let vc = UIStoryboard.storyBoard(withName: .Portfolio).loadViewController(withIdentifier: .createPortfolioVC) as! CreatePortfolioVC
                vc.portfolioType = .Edit
                vc.urlParams = menu.urlParams
                vc.url = menu.url
                con.navigationController?.pushViewController(vc, animated: true)
        }
//        let createFormTVC = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .createFormTVC) as! CreateFormTVC
//        
//        createFormTVC.sTypw = type
//        createFormTVC.formTypeValue = .edit
//        createFormTVC.pluginEditUrl = menu.url
//        let navCreateFormTVC = UINavigationController(rootViewController: createFormTVC)
//        con.present(navCreateFormTVC, animated: true, completion: nil)
        
    }
    
    //    MARK: - REPORT ACTION
    func reportAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        views = ReportAlertView.init(frame: CGRect(x: con.view.frame.size.width/2 - 150, y: 84 , width: 300, height: 260))
        views.layer.borderColor = UIColor(hexString: navbarTint).cgColor
        views.layer.borderWidth = 5
        views.layer.cornerRadius = 5
        views.con = con
        views.menu = menu
        
        
        //        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        //        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView = UIView(frame: con.view.frame)
        blurEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didPressedCancelButton))
        blurEffectView.addGestureRecognizer(tap)
        
        //always fill the view
        //        blurEffectView.frame = con.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            con.view.addSubview(blurEffectView)
        } else {
            
        }
        
        con.view.addSubview(views)
        views.delegating = self
        
    }
    
    func didPressedCancelButton() {
        
        views.removeFromSuperview()
        blurEffectView.removeFromSuperview()
    }
    
    func didPressedReportButton() {
        views.removeFromSuperview()
        blurEffectView.removeFromSuperview()
    }
    
    func didPressedReportTypeButton(){
        
        let rows = ["spam","abuse","inappropriate","licensed","other"]
        ActionSheetStringPicker.init(title: "Select Type", rows: rows, initialSelection: 0, doneBlock: { (piker, index, value) in
            self.views.reportTypeButton.setTitle(rows[index], for: .normal)
        }, cancel: { (picker) in
            
        }, origin: views.reportTypeButton).show()
        
    }
    
    //    MARK: - DOWNLOAD ACTION
    
    
    func downloadAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        //        let cons = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .webVC) as! WebViewViewController
        //        cons.urlString = menu.url
        //        con.navigationController?.pushViewController(cons, animated: true)
        
        UIApplication.shared.openURL(URL(string:menu.url)!)
    }
    
    
    
    //    MARK: - EMAIL ACTION
    
    func emailAction(menu:GutterMenuModel, con:UIViewController, index:Int?){
        
        viewss = EmailAttachmentView.init(frame: CGRect(x: con.view.frame.size.width/2 - 150, y: 84 , width: 300, height: 275))
        viewss.con = con
        viewss.menu = menu
        
        
        //        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        //        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView = UIView(frame: con.view.frame)
        blurEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didPressedCancelButton))
        //        blurEffectView.addGestureRecognizer(tap)
        viewss.blurrView = blurEffectView
        
        //always fill the view
        //        blurEffectView.frame = con.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            con.view.addSubview(blurEffectView)
        } else {
            
        }
        
        con.view.addSubview(viewss)
        //        views.delegating = self
        
    }
    
    
}
