//
//  PhotosArr.swift
//  JobsDone
//
//  Created by musharraf on 21/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class PhotosArr: NSObject {
    
    var photoId : Int!
    var photoUrl : String!
    var title : String!
    
    
    var image : String!
    var imageIcon : String!
    var imageNormal : String!
    var imageProfile : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        photoId = dictionary["photo_id"] as? Int
        photoUrl = dictionary["photo_url"] as? String
        title = dictionary["title"] as? String
        
        image = dictionary["image"] as? String
        imageIcon = dictionary["image_icon"] as? String
        imageNormal = dictionary["image_normal"] as? String
        imageProfile = dictionary["image_profile"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if photoId != nil{
            dictionary["photo_id"] = photoId
        }
        if photoUrl != nil{
            dictionary["photo_url"] = photoUrl
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        photoId = aDecoder.decodeObject(forKey: "photo_id") as? Int
        photoUrl = aDecoder.decodeObject(forKey: "photo_url") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if photoId != nil{
            aCoder.encode(photoId, forKey: "photo_id")
        }
        if photoUrl != nil{
            aCoder.encode(photoUrl, forKey: "photo_url")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        
    }


}
