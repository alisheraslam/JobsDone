//
//  DropDown.swift
//  JobsDone
//
//  Created by musharraf on 23/04/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class DropDown: NSObject {
    var key = ""
    var value = ""
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        if !(dictionary["key"] is NSNull) && (dictionary["key"] != nil){
            
            key = dictionary["key"] as! String
        }
        if !(dictionary["value"] is NSNull) && (dictionary["value"] != nil){
            
            key = dictionary["value"] as! String
        }
        
    }
}
