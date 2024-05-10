//
//  IdeaBoardModel.swift
//  JobsDone
//
//  Created by musharraf on 31/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class IdeaBoardModel: NSObject {
    var contentUrl : String!
    var creationDate : String!
    var descriptionField : String!
    var image : String!
    var imageIcon : String!
    var imageNormal : String!
    var imageProfile : String!
    var isFavorite : Bool!
    var isIdeaBoard : Int!
    var jobId : Int!
    var modifiedDate : String!
    var ownerImages : OwnerImage!
    var ownerTitle : String!
    var photoId : Int!
    var portfolioId : Int!
    var skills : [Category]!
    var title : String!
    var userId : Int!
    
    
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
        isFavorite = dictionary["is_favorite"] as? Bool
        isIdeaBoard = dictionary["is_idea_board"] as? Int
        jobId = dictionary["job_id"] as? Int
        modifiedDate = dictionary["modified_date"] as? String
        if let ownerImagesData = dictionary["owner_images"] as? [String:Any]{
            ownerImages = OwnerImage(fromDictionary: ownerImagesData)
        }
        ownerTitle = dictionary["owner_title"] as? String
        photoId = dictionary["photo_id"] as? Int
        portfolioId = dictionary["portfolio_id"] as? Int
        skills = [Category]()
        if let skillsArray = dictionary["skills"] as? [[String:Any]]{
            for dic in skillsArray{
                let value = Category.init(fromDictionary: dic)
                skills.append(value)
            }
        }
        title = dictionary["title"] as? String
        userId = dictionary["user_id"] as? Int
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
        if isFavorite != nil{
            dictionary["is_favorite"] = isFavorite
        }
        if isIdeaBoard != nil{
            dictionary["is_idea_board"] = isIdeaBoard
        }
        if jobId != nil{
            dictionary["job_id"] = jobId
        }
        if modifiedDate != nil{
            dictionary["modified_date"] = modifiedDate
        }
        if ownerImages != nil{
            dictionary["owner_images"] = ownerImages.toDictionary()
        }
        if ownerTitle != nil{
            dictionary["owner_title"] = ownerTitle
        }
        if photoId != nil{
            dictionary["photo_id"] = photoId
        }
        if portfolioId != nil{
            dictionary["portfolio_id"] = portfolioId
        }
        if skills != nil{
            var dictionaryElements = [[String:Any]]()
            for skillsElement in skills {
                dictionaryElements.append(skillsElement.toDictionary())
            }
            dictionary["skills"] = dictionaryElements
        }
        if title != nil{
            dictionary["title"] = title
        }
        if userId != nil{
            dictionary["user_id"] = userId
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
        isFavorite = aDecoder.decodeObject(forKey: "is_favorite") as? Bool
        isIdeaBoard = aDecoder.decodeObject(forKey: "is_idea_board") as? Int
        jobId = aDecoder.decodeObject(forKey: "job_id") as? Int
        modifiedDate = aDecoder.decodeObject(forKey: "modified_date") as? String
        ownerImages = aDecoder.decodeObject(forKey: "owner_images") as? OwnerImage
        ownerTitle = aDecoder.decodeObject(forKey: "owner_title") as? String
        photoId = aDecoder.decodeObject(forKey: "photo_id") as? Int
        portfolioId = aDecoder.decodeObject(forKey: "portfolio_id") as? Int
        skills = aDecoder.decodeObject(forKey :"skills") as? [Category]
        title = aDecoder.decodeObject(forKey: "title") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? Int
        
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
        if isFavorite != nil{
            aCoder.encode(isFavorite, forKey: "is_favorite")
        }
        if isIdeaBoard != nil{
            aCoder.encode(isIdeaBoard, forKey: "is_idea_board")
        }
        if jobId != nil{
            aCoder.encode(jobId, forKey: "job_id")
        }
        if modifiedDate != nil{
            aCoder.encode(modifiedDate, forKey: "modified_date")
        }
        if ownerImages != nil{
            aCoder.encode(ownerImages, forKey: "owner_images")
        }
        if ownerTitle != nil{
            aCoder.encode(ownerTitle, forKey: "owner_title")
        }
        if photoId != nil{
            aCoder.encode(photoId, forKey: "photo_id")
        }
        if portfolioId != nil{
            aCoder.encode(portfolioId, forKey: "portfolio_id")
        }
        if skills != nil{
            aCoder.encode(skills, forKey: "skills")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        
    }
}
