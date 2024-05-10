//
//  EmoModel.swift
//  SocialNet
//
//  Created by musharraf on 23/04/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class EmoModel: NSObject, NSCoding{
    
    var icon : String!
    var symbol : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        icon = dictionary["icon"] as? String
        symbol = dictionary["symbol"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if icon != nil{
            dictionary["icon"] = icon
        }
        if symbol != nil{
            dictionary["symbol"] = symbol
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        symbol = aDecoder.decodeObject(forKey: "symbol") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if icon != nil{
            aCoder.encode(icon, forKey: "icon")
        }
        if symbol != nil{
            aCoder.encode(symbol, forKey: "symbol")
        }
        
    }
    
}
