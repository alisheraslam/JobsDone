//
//  PortfolioImgModel.swift
//  JobsDone
//
//  Created by musharraf on 06/07/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class PortfolioImgModel : NSObject, NSCoding{
    
    var contentUrl : String!
    var creationDate : String!
    var descriptionField : String!
    var image : String!
    var imageIcon : String!
    var imageNormal : String!
    var imageProfile : String!
    var modifiedDate : String!
    var photoId : Int!
    var portfolioId : Int!
    var portfoliophotoId : Int!
    var title : String!
    var img: UIImage!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        contentUrl = dictionary["content_url"] as? String
        creationDate = dictionary["creation_date"] as? String
        descriptionField = dictionary["description"] as? String
        image = dictionary["image"] as? String
        imageIcon = dictionary["image_icon"] as? String
        imageNormal = dictionary["image_normal"] as? String
        imageProfile = dictionary["image_profile"] as? String
        modifiedDate = dictionary["modified_date"] as? String
        photoId = dictionary["photo_id"] as? Int
        portfolioId = dictionary["portfolio_id"] as? Int
        portfoliophotoId = dictionary["portfoliophoto_id"] as? Int
        title = dictionary["title"] as? String
        img = dictionary["img"] as? UIImage
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if contentUrl != nil{
            dictionary["content_url"] = contentUrl
        }
        if creationDate != nil{
            dictionary["creation_date"] = creationDate
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if image != nil{
            dictionary["image"] = image
        }
        if imageIcon != nil{
            dictionary["image_icon"] = imageIcon
        }
        if imageNormal != nil{
            dictionary["image_normal"] = imageNormal
        }
        if imageProfile != nil{
            dictionary["image_profile"] = imageProfile
        }
        if modifiedDate != nil{
            dictionary["modified_date"] = modifiedDate
        }
        if photoId != nil{
            dictionary["photo_id"] = photoId
        }
        if portfolioId != nil{
            dictionary["portfolio_id"] = portfolioId
        }
        if portfoliophotoId != nil{
            dictionary["portfoliophoto_id"] = portfoliophotoId
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
        contentUrl = aDecoder.decodeObject(forKey: "content_url") as? String
        creationDate = aDecoder.decodeObject(forKey: "creation_date") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        imageIcon = aDecoder.decodeObject(forKey: "image_icon") as? String
        imageNormal = aDecoder.decodeObject(forKey: "image_normal") as? String
        imageProfile = aDecoder.decodeObject(forKey: "image_profile") as? String
        modifiedDate = aDecoder.decodeObject(forKey: "modified_date") as? String
        photoId = aDecoder.decodeObject(forKey: "photo_id") as? Int
        portfolioId = aDecoder.decodeObject(forKey: "portfolio_id") as? Int
        portfoliophotoId = aDecoder.decodeObject(forKey: "portfoliophoto_id") as? Int
        title = aDecoder.decodeObject(forKey: "title") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if contentUrl != nil{
            aCoder.encode(contentUrl, forKey: "content_url")
        }
        if creationDate != nil{
            aCoder.encode(creationDate, forKey: "creation_date")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if imageIcon != nil{
            aCoder.encode(imageIcon, forKey: "image_icon")
        }
        if imageNormal != nil{
            aCoder.encode(imageNormal, forKey: "image_normal")
        }
        if imageProfile != nil{
            aCoder.encode(imageProfile, forKey: "image_profile")
        }
        if modifiedDate != nil{
            aCoder.encode(modifiedDate, forKey: "modified_date")
        }
        if photoId != nil{
            aCoder.encode(photoId, forKey: "photo_id")
        }
        if portfolioId != nil{
            aCoder.encode(portfolioId, forKey: "portfolio_id")
        }
        if portfoliophotoId != nil{
            aCoder.encode(portfoliophotoId, forKey: "portfoliophoto_id")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        
    }
    
}

