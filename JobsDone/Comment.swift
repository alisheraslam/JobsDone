//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class Comment: NSObject {
   
    var viewAllLikesBy = [Member]()
    var viewAllComments = [CommentObject]()
    
    var canComment : Bool?
    var canDelete : Bool?
    var can_share : Bool?
    var isLike : Bool?
    
    
    var getTotalLikes = 0
    var getTotalComments: Int?
    
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if !(dictionary["viewAllLikesBy"] is NSNull) && !(dictionary["viewAllLikesBy"] == nil) {
            
            if let allLikes = dictionary["viewAllLikesBy"] as? [Dictionary<String, AnyObject>]{
                for oneLike in allLikes{
                    let mem = Member.init(oneLike)
                    viewAllLikesBy.append(mem)
                }
            }
        }
        
        if !(dictionary["viewAllComments"] is NSNull) && !(dictionary["viewAllComments"] == nil) {
            
            if let allComments = dictionary["viewAllComments"] as? [Dictionary<String, AnyObject>]{
                
                for key in allComments{
                    
                    let obj = CommentObject.init(key)
                    viewAllComments.append(obj)
                }

            }
        }
        
        

        if !(dictionary["canComment"] is NSNull) && !(dictionary["canComment"] == nil) {
            
            canComment = dictionary["canComment"] as? Bool
            
        }
        if !(dictionary["canDelete"] is NSNull) && !(dictionary["canDelete"] == nil) {
            
            canDelete = dictionary["canDelete"] as? Bool
            
        }
        
        if !(dictionary["isLike"] is NSNull) && !(dictionary["isLike"] == nil) {
            
            isLike = dictionary["isLike"] as? Bool
            
        }
        if !(dictionary["getTotalLikes"] is NSNull) && !(dictionary["getTotalLikes"] == nil) {
            
            getTotalLikes = dictionary["getTotalLikes"] as! Int
            
        }
        if !(dictionary["getTotalComments"] is NSNull) && !(dictionary["getTotalComments"] == nil) {
            
            getTotalComments = dictionary["getTotalComments"] as? Int
            
        }
        
    }

}
