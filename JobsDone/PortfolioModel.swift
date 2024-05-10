//
//  PortfolioModel.swift
//  JobsDone
//
//  Created by musharraf on 22/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class PortfolioModel: NSObject {
    
    var avgRating : Float!
    var commentCount : Int!
    var contentUrl : String!
    var creationDate : String!
    var descriptionField : String!
    var hiredJobs : Int!
    var image : String!
    var imageIcon : String!
    var imageNormal : String!
    var imageProfile : String!
    var isFavorite : Bool!
    var isIdeaBoard : Int!
    var jobCount : Int!
    var jobId : Int!
    var likeCount : Int!
    var location : String!
    var modifiedDate : String!
    var ownerImages : OwnerImage!
    var ownerTitle : String!
    var photoId : Int!
    var portfolioId : Int!
    var runningJobs: Int!
    var postedJobs : Int!
    var reviewCount : Int!
    var skills : [Category]!
    var title : String!
    var totalBilled : Int!
    var userId : Int!
    var isLike : Bool!
    var photosArr : [Photo]!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        avgRating = dictionary["avg_rating"] as? Float
        commentCount = dictionary["comment_count"] as? Int
        contentUrl = dictionary["content_url"] as? String
        creationDate = dictionary["creation_date"] as? String
        descriptionField = dictionary["description"] as? String
        hiredJobs = dictionary["hired_jobs"] as? Int
        image = dictionary["image"] as? String
        imageIcon = dictionary["image_icon"] as? String
        imageNormal = dictionary["image_normal"] as? String
        imageProfile = dictionary["image_profile"] as? String
        isFavorite = dictionary["is_favorite"] as? Bool
        isIdeaBoard = dictionary["is_idea_board"] as? Int
        jobCount = dictionary["job_count"] as? Int
        jobId = dictionary["job_id"] as? Int
        likeCount = dictionary["like_count"] as? Int
        location = dictionary["location"] as? String
        modifiedDate = dictionary["modified_date"] as? String
        if let ownerImagesData = dictionary["owner_images"] as? [String:Any]{
            ownerImages = OwnerImage(fromDictionary: ownerImagesData)
        }
        ownerTitle = dictionary["owner_title"] as? String
        photoId = dictionary["photo_id"] as? Int
        portfolioId = dictionary["portfolio_id"] as? Int
        runningJobs = dictionary["running_jobs"] as? Int
        postedJobs = dictionary["posted_jobs"] as? Int
        reviewCount = dictionary["review_count"] as? Int
        isLike = dictionary["is_like"] as? Bool
        skills = [Category]()
        if let skillsArray = dictionary["skills"] as? [[String:Any]]{
            for dic in skillsArray{
                let value = Category.init(fromDictionary: dic)
                skills.append(value)
            }
        }
        photosArr = [Photo]()
        if let photosAr = dictionary["photos"] as? [[String: AnyObject]]{
            for obj in photosAr{
                let ob = Photo.init(fromDictionary: obj)
                photosArr.append(ob)
            }
        }
        title = dictionary["title"] as? String
        totalBilled = dictionary["total_billed"] as? Int
        userId = dictionary["user_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if avgRating != nil{
            dictionary["avg_rating"] = avgRating
        }
        if commentCount != nil{
            dictionary["comment_count"] = commentCount
        }
        if contentUrl != nil{
            dictionary["content_url"] = contentUrl
        }
        if creationDate != nil{
            dictionary["creation_date"] = creationDate
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if hiredJobs != nil{
            dictionary["hired_jobs"] = hiredJobs
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
        if jobCount != nil{
            dictionary["job_count"] = jobCount
        }
        if jobId != nil{
            dictionary["job_id"] = jobId
        }
        if likeCount != nil{
            dictionary["like_count"] = likeCount
        }
        if location != nil{
            dictionary["location"] = location
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
        if postedJobs != nil{
            dictionary["posted_jobs"] = postedJobs
        }
        if reviewCount != nil{
            dictionary["review_count"] = reviewCount
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
        if totalBilled != nil{
            dictionary["total_billed"] = totalBilled
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
        avgRating = aDecoder.decodeObject(forKey: "avg_rating") as? Float
        commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
        contentUrl = aDecoder.decodeObject(forKey: "content_url") as? String
        creationDate = aDecoder.decodeObject(forKey: "creation_date") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        hiredJobs = aDecoder.decodeObject(forKey: "hired_jobs") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? String
        imageIcon = aDecoder.decodeObject(forKey: "image_icon") as? String
        imageNormal = aDecoder.decodeObject(forKey: "image_normal") as? String
        imageProfile = aDecoder.decodeObject(forKey: "image_profile") as? String
        isFavorite = aDecoder.decodeObject(forKey: "is_favorite") as? Bool
        isIdeaBoard = aDecoder.decodeObject(forKey: "is_idea_board") as? Int
        jobCount = aDecoder.decodeObject(forKey: "job_count") as? Int
        jobId = aDecoder.decodeObject(forKey: "job_id") as? Int
        likeCount = aDecoder.decodeObject(forKey: "like_count") as? Int
        location = aDecoder.decodeObject(forKey: "location") as? String
        modifiedDate = aDecoder.decodeObject(forKey: "modified_date") as? String
        ownerImages = aDecoder.decodeObject(forKey: "owner_images") as? OwnerImage
        ownerTitle = aDecoder.decodeObject(forKey: "owner_title") as? String
        photoId = aDecoder.decodeObject(forKey: "photo_id") as? Int
        portfolioId = aDecoder.decodeObject(forKey: "portfolio_id") as? Int
        postedJobs = aDecoder.decodeObject(forKey: "posted_jobs") as? Int
        reviewCount = aDecoder.decodeObject(forKey: "review_count") as? Int
        skills = aDecoder.decodeObject(forKey :"skills") as? [Category]
        title = aDecoder.decodeObject(forKey: "title") as? String
        totalBilled = aDecoder.decodeObject(forKey: "total_billed") as? Int
        userId = aDecoder.decodeObject(forKey: "user_id") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if avgRating != nil{
            aCoder.encode(avgRating, forKey: "avg_rating")
        }
        if commentCount != nil{
            aCoder.encode(commentCount, forKey: "comment_count")
        }
        if contentUrl != nil{
            aCoder.encode(contentUrl, forKey: "content_url")
        }
        if creationDate != nil{
            aCoder.encode(creationDate, forKey: "creation_date")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if hiredJobs != nil{
            aCoder.encode(hiredJobs, forKey: "hired_jobs")
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
        if jobCount != nil{
            aCoder.encode(jobCount, forKey: "job_count")
        }
        if jobId != nil{
            aCoder.encode(jobId, forKey: "job_id")
        }
        if likeCount != nil{
            aCoder.encode(likeCount, forKey: "like_count")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
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
        if postedJobs != nil{
            aCoder.encode(postedJobs, forKey: "posted_jobs")
        }
        if reviewCount != nil{
            aCoder.encode(reviewCount, forKey: "review_count")
        }
        if skills != nil{
            aCoder.encode(skills, forKey: "skills")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if totalBilled != nil{
            aCoder.encode(totalBilled, forKey: "total_billed")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        
    }

}
