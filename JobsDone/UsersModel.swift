//
//  UsersModel.swift
//  SchoolChain
//
//  Created by musharraf on 5/11/17.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit

class UsersModel: NSObject {
    var content_url: String?
    var guid: String?
    var id: String?
    var image: String?
    var image_normal: String?
    var image_profile: String?
    var label: String?
    var type: String?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if !(dictionary["content_url"] is NSNull) &&  dictionary["content_url"] != nil{

            content_url = dictionary["content_url"] as? String
        }
        if !(dictionary["guid"] is NSNull) &&  dictionary["guid"] != nil{

            guid = dictionary["guid"] as? String
        }

        if !(dictionary["id"] is NSNull) &&  dictionary["id"] != nil{

            id = String(describing: dictionary["id"]!)
        }

        if !(dictionary["image"] is NSNull) &&  dictionary["image"] != nil{

            image = dictionary["image"] as? String
        }

        if !(dictionary["image_normal"] is NSNull) &&  dictionary["image_normal"] != nil{

            image_normal = dictionary["image_normal"] as? String
        }

        if !(dictionary["image_profile"] is NSNull) &&  dictionary["image_profile"] != nil{

            image_profile = dictionary["image_profile"] as? String
        }
        if !(dictionary["label"] is NSNull) &&  dictionary["label"] != nil{
            if ((dictionary["label"] as? Int) != nil){
                label = String(describing: dictionary["label"]!)
            }else{
            label = dictionary["label"] as? String
            }
        }
        if !(dictionary["type"] is NSNull) &&  dictionary["type"] != nil{
            
            type = dictionary["type"] as? String
        }

        
    }
}
