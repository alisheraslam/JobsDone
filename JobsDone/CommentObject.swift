//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class CommentObject: NSObject {
 
   
    var author_image_icon = ""
    var author_title = ""
    var comment_body = ""
    var comment_date = ""
    var comment_timestamp = ""
    var user_id : Int!
    var comment_id : Int!
    var like_count = 0
    
    var like : GutterMenuModel?
    var delete : GutterMenuModel?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        
        
        
        if !(dictionary["author_title"] is NSNull) && !(dictionary["author_title"] == nil) {
            
            author_title = (dictionary["author_title"] as? String)!
            
        }
        if !(dictionary["comment_timestamp"] is NSNull) && !(dictionary["comment_timestamp"] == nil) {
            
            comment_timestamp = (dictionary["comment_timestamp"] as? String)!
            
        }

        
        if !(dictionary["author_image_icon"] is NSNull) && !(dictionary["author_image_icon"] == nil) {
            
            author_image_icon = (dictionary["author_image_icon"] as? String)!
            
        }
        
        if !(dictionary["comment_body"] is NSNull) && !(dictionary["comment_body"] == nil) {
            
            comment_body = String(describing: dictionary["comment_body"]!)
            
        }
        if !(dictionary["comment_date"] is NSNull) && !(dictionary["comment_date"] == nil) {
            
            comment_date = (dictionary["comment_date"] as? String)!
            
        }
        
        if !(dictionary["user_id"] is NSNull) && !(dictionary["user_id"] == nil) {
            
            user_id = dictionary["user_id"] as! Int
            
        }
        if !(dictionary["like_count"] is NSNull) && !(dictionary["like_count"] == nil) {
            
            like_count = dictionary["like_count"] as! Int
            
        }
        
        if !(dictionary["comment_id"] is NSNull) && !(dictionary["comment_id"] == nil) {
            
            comment_id = dictionary["comment_id"] as! Int
            
        }
        
        
        
        
        if !(dictionary["like"] is NSNull) && !(dictionary["like"] == nil) {
            
            if let likes = dictionary["like"] as? Dictionary<String,AnyObject>{
                
                like = GutterMenuModel.init(likes)
            }

        }
        
        if !(dictionary["delete"] is NSNull) && !(dictionary["delete"] == nil) {
            
            if let likes = dictionary["delete"] as? Dictionary<String,AnyObject>{
                
                delete = GutterMenuModel.init(likes)
            }
            
        }
        
        
        
        
    }
    
}
