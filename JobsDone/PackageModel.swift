//
//  PackageModel.swift
//  ScoutMe
//
//  Created by musharraf on 26/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class PackageModel: NSObject {
    var package_id : Int?
    var label = ""
    var detail = ""
    var price = 0
    var currency = ""
    var active: Bool!
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        if !(dictionary["package_id"] is NSNull) && (dictionary["package_id"] != nil){
            
            package_id = dictionary["package_id"] as? Int
        }
        if !(dictionary["label"] is NSNull) && (dictionary["label"] != nil){
            
            label = dictionary["label"] as! String
        }
        if !(dictionary["description"] is NSNull) && (dictionary["description"] != nil){
            
            detail = dictionary["description"] as! String
        }
        if !(dictionary["price"] is NSNull) && (dictionary["price"] != nil){
            
            price = dictionary["price"] as! Int
        }
        if !(dictionary["currency"] is NSNull) && (dictionary["currency"] != nil){
            
            currency = dictionary["currency"] as! String
        }
        if !(dictionary["active"] is NSNull) && (dictionary["active"] != nil){
            
            active = dictionary["active"] as! Bool
        }
    }
}
