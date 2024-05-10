//
//  HelpModel.swift
//  JobsDone
//
//  Created by musharraf on 26/02/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class HelpModel: NSObject {
    var answer = ""
    var question = ""
    var id : Int?
   

    
    
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
       
        if !(dictionary["answer"] is NSNull) && (dictionary["answer"] != nil){
            
            answer = dictionary["answer"] as! String
        }
        if !(dictionary["question"] is NSNull) && (dictionary["question"] != nil){
            if  let lab = dictionary["question"] as? Int{
                question = "\(question)"
            }  else{
                question = dictionary["question"] as! String
            }
            
        }
        if !(dictionary["id"] is NSNull) && (dictionary["id"] != nil){
            
            id = dictionary["id"] as? Int
        }
    }
    
}
