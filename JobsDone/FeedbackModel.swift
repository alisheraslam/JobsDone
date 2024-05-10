//
//  FeedbackModel.swift
//  JobsDone
//
//  Created by musharraf on 11/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class FeedbackModel: NSObject, NSCoding{
    
    var availability : Int!
    var avgRating : Float!
    var comments : String!
    var contentUrl : String!
    var cooperative : Int!
    var creationDate : String!
    var deadline : Int!
    var feedbackFrom : Int!
    var feedbackId : Int!
    var feedbackTo : Int!
    var finishing : Int!
    var hiredJobs : Int!
    var image : String!
    var imageIcon : String!
    var imageNormal : String!
    var imageProfile : String!
    var isFavorite : Bool!
    var listingId : Int!
    var location : String!
    var modifiedDate : String!
    var feedbackBy : String!
    var ownerTitle : String!
    var postedJobs : Int!
    var reviewCount : Int!
    var categories : [Category]!
    var totalBilled : Int!
    var userFavorite : Bool!
    var userRating : Float!
    var skills: Int!
    var runningJobs: Int!
    var feedbackUserPhotos : FeedbackUserPhoto!
    var feedbackUserRating : Float!
    
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        availability = dictionary["availability"] as? Int
        skills = dictionary["skills"] as? Int
        avgRating = dictionary["avg_rating"] as? Float
        comments = dictionary["comments"] as? String
        contentUrl = dictionary["content_url"] as? String
        cooperative = dictionary["cooperative"] as? Int
        creationDate = dictionary["creation_date"] as? String
        deadline = dictionary["deadline"] as? Int
        feedbackFrom = dictionary["feedback_from"] as? Int
        feedbackId = dictionary["feedback_id"] as? Int
        feedbackTo = dictionary["feedback_to"] as? Int
        finishing = dictionary["finishing"] as? Int
        hiredJobs = dictionary["hired_jobs"] as? Int
        image = dictionary["image"] as? String
        imageIcon = dictionary["image_icon"] as? String
        imageNormal = dictionary["image_normal"] as? String
        imageProfile = dictionary["image_profile"] as? String
        isFavorite = dictionary["is_favorite"] as? Bool
        listingId = dictionary["listing_id"] as? Int
        location = dictionary["location"] as? String
        modifiedDate = dictionary["modified_date"] as? String
        ownerTitle = dictionary["owner_title"] as? String
        postedJobs = dictionary["posted_jobs"] as? Int
        reviewCount = dictionary["review_count"] as? Int
        categories = [Category]()
        if let feedbackUserPhotosData = dictionary["feedback_user_photos"] as? [String:Any]{
            feedbackUserPhotos = FeedbackUserPhoto(fromDictionary: feedbackUserPhotosData)
        }
        if let categoriesArray = dictionary["skills"] as? [[String:Any]]{
            for dic in categoriesArray{
                let value = Category(fromDictionary: dic)
                categories.append(value)
            }
        }
        feedbackUserRating = dictionary["feedback_user_rating"] as? Float
        totalBilled = dictionary["total_billed"] as? Int
        userFavorite = dictionary["user_favorite"] as? Bool
        userRating = dictionary["user_rating"] as? Float
        feedbackBy = dictionary["feedback_by"] as? String
        runningJobs = dictionary["running_jobs"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if availability != nil{
            dictionary["availability"] = availability
        }
        if avgRating != nil{
            dictionary["avg_rating"] = avgRating
        }
        if comments != nil{
            dictionary["comments"] = comments
        }
        if contentUrl != nil{
            dictionary["content_url"] = contentUrl
        }
        if cooperative != nil{
            dictionary["cooperative"] = cooperative
        }
        if creationDate != nil{
            dictionary["creation_date"] = creationDate
        }
        if deadline != nil{
            dictionary["deadline"] = deadline
        }
        if feedbackFrom != nil{
            dictionary["feedback_from"] = feedbackFrom
        }
        if feedbackId != nil{
            dictionary["feedback_id"] = feedbackId
        }
        if feedbackTo != nil{
            dictionary["feedback_to"] = feedbackTo
        }
        if finishing != nil{
            dictionary["finishing"] = finishing
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
        if listingId != nil{
            dictionary["listing_id"] = listingId
        }
        if location != nil{
            dictionary["location"] = location
        }
        if modifiedDate != nil{
            dictionary["modified_date"] = modifiedDate
        }
        if ownerTitle != nil{
            dictionary["owner_title"] = ownerTitle
        }
        if postedJobs != nil{
            dictionary["posted_jobs"] = postedJobs
        }
        if reviewCount != nil{
            dictionary["review_count"] = reviewCount
        }
        if categories != nil{
            var dictionaryElements = [[String:Any]]()
            for categoriesElement in categories {
                dictionaryElements.append(categoriesElement.toDictionary())
            }
            dictionary["categories"] = dictionaryElements
        }
        if totalBilled != nil{
            dictionary["total_billed"] = totalBilled
        }
        if userFavorite != nil{
            dictionary["user_favorite"] = userFavorite
        }
        if userRating != nil{
            dictionary["user_rating"] = userRating
        }
        if feedbackBy != nil{
            dictionary["feedback_by"] = feedbackBy
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        availability = aDecoder.decodeObject(forKey: "availability") as? Int
        avgRating = aDecoder.decodeObject(forKey: "avg_rating") as? Float
        comments = aDecoder.decodeObject(forKey: "comments") as? String
        contentUrl = aDecoder.decodeObject(forKey: "content_url") as? String
        cooperative = aDecoder.decodeObject(forKey: "cooperative") as? Int
        creationDate = aDecoder.decodeObject(forKey: "creation_date") as? String
        deadline = aDecoder.decodeObject(forKey: "deadline") as? Int
        feedbackFrom = aDecoder.decodeObject(forKey: "feedback_from") as? Int
        feedbackId = aDecoder.decodeObject(forKey: "feedback_id") as? Int
        feedbackTo = aDecoder.decodeObject(forKey: "feedback_to") as? Int
        finishing = aDecoder.decodeObject(forKey: "finishing") as? Int
        hiredJobs = aDecoder.decodeObject(forKey: "hired_jobs") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? String
        imageIcon = aDecoder.decodeObject(forKey: "image_icon") as? String
        imageNormal = aDecoder.decodeObject(forKey: "image_normal") as? String
        imageProfile = aDecoder.decodeObject(forKey: "image_profile") as? String
        isFavorite = aDecoder.decodeObject(forKey: "is_favorite") as? Bool
        listingId = aDecoder.decodeObject(forKey: "listing_id") as? Int
        location = aDecoder.decodeObject(forKey: "location") as? String
        modifiedDate = aDecoder.decodeObject(forKey: "modified_date") as? String
        ownerTitle = aDecoder.decodeObject(forKey: "owner_title") as? String
        postedJobs = aDecoder.decodeObject(forKey: "posted_jobs") as? Int
        reviewCount = aDecoder.decodeObject(forKey: "review_count") as? Int
        categories = aDecoder.decodeObject(forKey :"categories") as? [Category]
        totalBilled = aDecoder.decodeObject(forKey: "total_billed") as? Int
        userFavorite = aDecoder.decodeObject(forKey: "user_favorite") as? Bool
        userRating = aDecoder.decodeObject(forKey: "user_rating") as? Float
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if availability != nil{
            aCoder.encode(availability, forKey: "availability")
        }
        if avgRating != nil{
            aCoder.encode(avgRating, forKey: "avg_rating")
        }
        if comments != nil{
            aCoder.encode(comments, forKey: "comments")
        }
        if contentUrl != nil{
            aCoder.encode(contentUrl, forKey: "content_url")
        }
        if cooperative != nil{
            aCoder.encode(cooperative, forKey: "cooperative")
        }
        if creationDate != nil{
            aCoder.encode(creationDate, forKey: "creation_date")
        }
        if deadline != nil{
            aCoder.encode(deadline, forKey: "deadline")
        }
        if feedbackFrom != nil{
            aCoder.encode(feedbackFrom, forKey: "feedback_from")
        }
        if feedbackId != nil{
            aCoder.encode(feedbackId, forKey: "feedback_id")
        }
        if feedbackTo != nil{
            aCoder.encode(feedbackTo, forKey: "feedback_to")
        }
        if finishing != nil{
            aCoder.encode(finishing, forKey: "finishing")
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
        if listingId != nil{
            aCoder.encode(listingId, forKey: "listing_id")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if modifiedDate != nil{
            aCoder.encode(modifiedDate, forKey: "modified_date")
        }
        if ownerTitle != nil{
            aCoder.encode(ownerTitle, forKey: "owner_title")
        }
        if postedJobs != nil{
            aCoder.encode(postedJobs, forKey: "posted_jobs")
        }
        if reviewCount != nil{
            aCoder.encode(reviewCount, forKey: "review_count")
        }
        if totalBilled != nil{
            aCoder.encode(totalBilled, forKey: "total_billed")
        }
        if userFavorite != nil{
            aCoder.encode(userFavorite, forKey: "user_favorite")
        }
        if userRating != nil{
            aCoder.encode(userRating, forKey: "user_rating")
        }
        
    }
    
}

