//
//  SkillModel.swift
//  JobsDone
//
//  Created by musharraf on 28/02/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class SkillModel: NSObject {
    
    var category_name = ""
    var thumb_icon = ""
    var category_id : Int?
    var status : Bool?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if !(dictionary["category_name"] is NSNull) && (dictionary["category_name"] != nil){
            
            category_name = dictionary["category_name"] as! String
        }
        if !(dictionary["thumb_icon"] is NSNull) && (dictionary["thumb_icon"] != nil){
            
            thumb_icon = dictionary["thumb_icon"] as! String
        }
        if !(dictionary["category_id"] is NSNull) && (dictionary["category_id"] != nil){
            
            category_id = dictionary["category_id"] as? Int
        }
        
        if !(dictionary["status"] is NSNull) && (dictionary["status"] != nil) {
            
            status = dictionary["status"] as? Bool
            
        }
    }
}
