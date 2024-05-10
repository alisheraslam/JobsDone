//
//  SuggestionModel.swift
//  SchoolChain
//
//  Created by musharraf on 5/11/17.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit

class SuggestionModel: NSObject {
    
    var response = [UsersModel]()
    var totalItemCount: Int?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if !(dictionary["totalItemCount"] is NSNull) &&  dictionary["totalItemCount"] != nil{
            
            totalItemCount = dictionary["totalItemCount"] as? Int
        }

        if !(dictionary["response"] is NSNull) &&  dictionary["response"] != nil{
            
            if let respons = dictionary["response"] as? [Dictionary<String,AnyObject>] {
                for res in respons {
                  
                    let data = UsersModel.init(res)
                    self.response.append(data)
                    
                }
            }
        }

    }
}
