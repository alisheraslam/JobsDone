//
//  GutterMenuModel.swift
//  SchoolChain
//
//  Created by musharraf on 19/04/2017.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit

class GutterMenuModel: NSObject {
    
    
    
    var urlParams = Dictionary<String,AnyObject>()
    var name = ""
    var url = ""
    var label = ""
    var totalItemCount : Int?
    var isLike : Bool?
    
    
    
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        if !(dictionary["urlParams"] is NSNull) && !(dictionary["urlParams"] is String) && (dictionary["urlParams"] != nil){
            
            if !(dictionary["urlParams"] is NSArray) && (dictionary["urlParams"] != nil){
                print(dictionary["urlParams"]!)
                urlParams = dictionary["urlParams"] as! Dictionary<String,AnyObject>
            }
            
        }
        if !(dictionary["name"] is NSNull) && (dictionary["name"] != nil){
            
            name = dictionary["name"] as! String
        }
        if !(dictionary["url"] is NSNull) && (dictionary["url"] != nil){
            
            url = dictionary["url"] as! String
        }
        if !(dictionary["label"] is NSNull) && (dictionary["label"] != nil){
            
            label = dictionary["label"] as! String
        }
        if !(dictionary["totalItemCount"] is NSNull) && (dictionary["totalItemCount"] != nil){
            
            totalItemCount = dictionary["totalItemCount"] as? Int
        }
        
        if !(dictionary["isLike"] is NSNull) && (dictionary["isLike"] != nil) {
            
            isLike = dictionary["isLike"] as? Bool
            
        }
    }

    

}
