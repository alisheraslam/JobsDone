//
//  MessageModel.swift
//  SchoolChain
//
//  Created by musharraf on 5/9/17.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit

class MessageModel: NSObject {

 
    var getTotalItemCount: String?
    var getUnreadMessageCount: String?
    var response = [Dictionary<String,AnyObject>]()
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if !(dictionary["getTotalItemCount"] is NSNull) &&  dictionary["getTotalItemCount"] != nil{
            
            getTotalItemCount = String(describing: dictionary["avatar_receiver"])
        }
        if !(dictionary["getUnreadMessageCount"] is NSNull) &&  dictionary["getUnreadMessageCount"] != nil{
            
            getUnreadMessageCount = String(describing: dictionary["getUnreadMessageCount"])
        }
        if !(dictionary["response"] is NSNull) &&  dictionary["response"] != nil{
            
            response = dictionary["response"] as! [Dictionary<String,AnyObject>]
        }
       
    }
}
