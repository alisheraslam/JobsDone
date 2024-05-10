//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class ChatDataModel: NSObject {
    //attachments
    var attachment = Dictionary<String,AnyObject>()
    var image = ""
    var uri = ""
    var code = ""
    var title = ""
    var playlist_id : Int?
    var type  : Int?
    
    var messageImg: UIImage?
    
    var message = Dictionary<String,AnyObject>()
    var attachment_type = ""
    var body = ""
    var date = ""
    
    var recipient = Dictionary<String,AnyObject>()
    
    var sender = Dictionary<String,AnyObject>()
    var user_id : Int?
    var image_icon = ""
    var message_id : Int?
    
    
    
    
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        
        
        if !(dictionary["attachment"] is NSNull) && (dictionary["attachment"] != nil) && !(dictionary["attachment"] is String) {
            
            
            attachment = dictionary["attachment"] as! Dictionary<String,AnyObject>
            
            if !(attachment["image"] is NSNull) && (attachment["image"] != nil){
                
                image = attachment["image"] as! String
            }
            if !(attachment["uri"] is NSNull) && (attachment["uri"] != nil){
                
                uri = attachment["uri"] as! String
            }
            
            if !(attachment["title"] is NSNull) && (attachment["title"] != nil){
                
                title = attachment["title"] as! String
            }
            if !(attachment["code"] is NSNull) && (attachment["code"] != nil){
                if let cod =  attachment["code"] as? Int{
                    code = "\(cod)"
                }else{
                        code = attachment["code"] as! String
                }
                
            }
            if !(attachment["type"] is NSNull) && (attachment["type"] != nil){
                
                type = attachment["type"] as? Int
            }
            if !(attachment["playlist_id"] is NSNull) && (attachment["playlist_id"] != nil){
                
                playlist_id = attachment["playlist_id"] as? Int
            }
        }
        
        
        
        if !(dictionary["message"] is NSNull) && (dictionary["message"] != nil) && !(dictionary["message"] is String) {
            
            
            message = dictionary["message"] as! Dictionary<String,AnyObject>
            
            if !(message["attachment_type"] is NSNull) && (message["attachment_type"] != nil){
                
                attachment_type = message["attachment_type"] as! String
            }
            
            if !(message["body"] is NSNull) && (message["body"] != nil){
                if let cod =  message["body"] as? Int{
                    body = "\(cod)"
                }else{
                    body = message["body"] as! String
                }
                
            }
            
            if !(message["date"] is NSNull) && (message["date"] != nil){
                
                date = message["date"] as! String
            }
        }
        
        
        if !(dictionary["recipient"] is NSNull) && (dictionary["recipient"] != nil) && !(dictionary["recipient"] is String) {
            
            
            recipient = dictionary["recipient"] as! Dictionary<String,AnyObject>
            
        }
        

        
        if !(dictionary["sender"] is NSNull) && (dictionary["sender"] != nil) && !(dictionary["sender"] is String) {
            
            
            sender = dictionary["sender"] as! Dictionary<String,AnyObject>
            
            if !(sender["user_id"] is NSNull) && (sender["user_id"] != nil){
                
                user_id = sender["user_id"] as? Int
            }
            if !(sender["message_id"] is NSNull) && (sender["message_id"] != nil){
                
                message_id = sender["message_id"] as? Int
            }
            
            if !(sender["image_icon"] is NSNull) && (sender["image_icon"] != nil){
                
                image_icon = sender["image_icon"] as! String
            }
            
//            if !(response["title"] is NSNull) && (response["title"] != nil){
//                
//                title = response["title"] as! String
//            }
//            if !(response["attachment_type"] is NSNull) && (response["attachment_type"] != nil){
//                
//                image = response["attachment_type"] as! String
//            }
//            if !(response["body"] is NSNull) && (response["body"] != nil){
//                
//                body = response["body"] as! String
//            }
//            if !(response["date"] is NSNull) && (response["date"] != nil){
//                
//                date = response["date"] as! String
//            }
        }

        
        
    }
    


}
