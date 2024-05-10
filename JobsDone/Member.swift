//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class Member: NSObject {
    
    
    var menus = GutterMenuModel()
    var menu = [GutterMenuModel]()
    var modifiedDate = ""
    var locale = ""
    var lastloginDate = ""
    var levelId : Int?
    var extraInvites : Int?
    var imageIcon = ""
    var creationDate = ""
    var approved : Int?
    var timezone = ""
    var username = ""
    var invitesUsed : Int?
    var search : Int?
    var verified : Int?
    var userId : Int?
    var photoId : Int?
    var imageProfile = ""
    var enabled : Int?
    var memberCount : Int?
    var showProfileviewers : Int?
    var status = ""
    var image = ""
    var imageNormal = ""
    var contentUrl = ""
    var updateDate = ""
    var statusDate = ""
    var language = ""
    var staff = ""
    var viewCount : Int?
    var post_count : Int?
    var is_owner : Int?
    
    var displayname = ""
    
    
    
    //
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if !(dictionary["approved"] is NSNull) && (dictionary["approved"] != nil){
            
            approved = dictionary["approved"] as? Int
        }

        if !(dictionary["post_count"] is NSNull) && (dictionary["post_count"] != nil){
            
            post_count = dictionary["post_count"] as? Int
        }
        if !(dictionary["is_owner"] is NSNull) && (dictionary["is_owner"] != nil){
            
            is_owner = dictionary["is_owner"] as? Int
        }

        if !(dictionary["content_url"] is NSNull) && (dictionary["content_url"] != nil){
            
            contentUrl = dictionary["content_url"] as! String
        }
        
        if !(dictionary["content_url"] is NSNull) && (dictionary["creation_date"] != nil){
            
            creationDate = dictionary["creation_date"] as! String
        }
        if !(dictionary["displayname"] is NSNull) && (dictionary["displayname"] != nil){
            
            displayname = dictionary["displayname"] as! String
        }
        if !(dictionary["enabled"] is NSNull) && (dictionary["enabled"] != nil){
            
            enabled = dictionary["enabled"] as? Int
        }
        if !(dictionary["extra_invites"] is NSNull) && (dictionary["extra_invites"] != nil){
            
            extraInvites = dictionary["extra_invites"] as? Int
        }
        if !(dictionary["image"] is NSNull) && (dictionary["image"] != nil){
            
            image = dictionary["image"] as! String
        }
        if !(dictionary["image_icon"] is NSNull) && (dictionary["image_icon"] != nil){
            
            imageIcon = dictionary["image_icon"] as! String
        }
        if !(dictionary["image_normal"] is NSNull) && (dictionary["image_normal"] != nil){
            
            imageNormal = dictionary["image_normal"] as! String
        }
        if !(dictionary["image_profile"] is NSNull) && (dictionary["image_profile"] != nil){
            
            imageProfile = dictionary["image_profile"] as! String
        }
        if !(dictionary["invites_used"] is NSNull) && (dictionary["invites_used"] != nil){
            
            invitesUsed = dictionary["invites_used"] as? Int
        }
        if !(dictionary["language"] is NSNull) && (dictionary["language"] != nil){
            
            language = dictionary["language"] as! String
        }
        if !(dictionary["staff"] is NSNull) && (dictionary["staff"] != nil){
            
            staff = dictionary["staff"] as! String
        }
        if !(dictionary["lastlogin_date"] is NSNull) && (dictionary["lastlogin_date"] != nil){
            
            lastloginDate = dictionary["lastlogin_date"] as! String
        }
        if !(dictionary["level_id"] is NSNull) && (dictionary["level_id"] != nil){
            
            levelId = dictionary["level_id"] as? Int
        }
        if !(dictionary["locale"] is NSNull) && (dictionary["locale"] != nil){
            
            locale = dictionary["locale"] as! String
        }
        if !(dictionary["member_count"] is NSNull) && (dictionary["member_count"] != nil){
            
            memberCount = dictionary["member_count"] as? Int
        }
        if !(dictionary["menus"] is NSNull) && (dictionary["menus"] != nil) && !(dictionary["menus"] is String) {
            
            if !(dictionary["menus"] is NSArray) {
                if let men = dictionary["menus"] as? Dictionary<String,AnyObject>{
                
                    menus = GutterMenuModel.init(men)
                }
                
            
            } 

        }
        if !(dictionary["menu"] is NSNull) && (dictionary["menu"] != nil) && !(dictionary["menu"] is String) {
            
            if let men = dictionary["menu"] as? [Dictionary<String,AnyObject>]{
                for m in men {
                    self.menu.append(GutterMenuModel.init(m))
                }
                
            }
        
        }
        if !(dictionary["modified_date"] is NSNull) && (dictionary["modified_date"] != nil){
            
            modifiedDate = dictionary["modified_date"] as! String
        }
        if !(dictionary["photo_id"] is NSNull) && (dictionary["photo_id"] != nil){
            
            photoId = dictionary["photo_id"] as? Int
        }
        if !(dictionary["search"] is NSNull) && (dictionary["search"] != nil){
            
            search = dictionary["search"] as? Int
        }
        if !(dictionary["show_profileviewers"] is NSNull) && (dictionary["show_profileviewers"] != nil){
            
            showProfileviewers = dictionary["show_profileviewers"] as? Int
        }
        if !(dictionary["status"] is NSNull) && (dictionary["status"] != nil){
            
            status = dictionary["status"] as! String
        }
        if !(dictionary["status_date"] is NSNull) && (dictionary["status_date"] != nil){
            
            statusDate = dictionary["status_date"] as! String
        }
        if !(dictionary["timezone"] is NSNull) && (dictionary["timezone"] != nil){
            
            timezone = dictionary["timezone"] as! String
        }
        if !(dictionary["update_date"] is NSNull) && (dictionary["update_date"] != nil){
            
            updateDate = dictionary["update_date"] as! String
        }
        if !(dictionary["user_id"] is NSNull) && (dictionary["user_id"] != nil){
            
            userId = dictionary["user_id"] as? Int
        }
        if !(dictionary["username"] is NSNull) && (dictionary["username"] != nil) && dictionary["username"] is String{
            
            username = dictionary["username"] as! String
        }
        if !(dictionary["verified"] is NSNull) && (dictionary["verified"] != nil){
            
            verified = dictionary["verified"] as? Int
        }
        if !(dictionary["view_count"] is NSNull) && (dictionary["view_count"] != nil){
            
            viewCount = dictionary["view_count"] as? Int
        }
    }
    
    func getDate(object: AnyObject?) -> NSDate? {
        // parse the object as a date here and replace the next line for your wish...
        return object as? NSDate
    }

}
