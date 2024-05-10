//
//  JobsModel.swift
//  JobsDone
//
//  Created by musharraf on 02/03/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class JobsModel : NSObject, NSCoding{
    
    var appliedCount : Int!
    var approved : Int!
    var approvedDate : String!
    var avgBid : String!
    var avgRating : NSNumber!
    var body : String!
    var canApply : Bool!
    var categories : [Category]!
    var closed : Int!
    var commentCount : Int!
    var contentUrl : String!
    var creationDate : String!
    var draft : Int!
    var duration : Int!
    var endDate : String!
    var featured : Int!
    var hiredJobs : Int!
    var image : String!
    var imageIcon : String!
    var imageNormal : String!
    var imageProfile : String!
    var inviteCount : Int!
    var inviteId : Int!
    var inviteOnly : AnyObject!
    var inviteStatus : String!
    var isApplied : Bool!
    var isFavorite : Bool!
    var jobDurationLabel : String!
    var jobStatus : String!
    var jobType : Int!
    var jobTypeLabel : String!
    var likeCount : Int!
    var listingId : Int!
    var hiredId : Int!
    var location : String!
    var locationParams : LocationParam!
    var modifiedDate : String!
    var nationalSearch : AnyObject!
    var networksPrivacy : AnyObject!
    var overview : AnyObject!
    var ownerId : Int!
    var ownerTitle : String!
    var photoId : Int!
    var photos : [Photo]!
    var postedJobs : Int!
    var price : NSNumber!
    var profileType : Int!
    var provincialSearch : AnyObject!
    var radius : AnyObject!
    var radiusSearch : AnyObject!
    var rating : Int!
    var reviewCount : Int!
    var search : Int!
    var sponsored : Int!
    var title : String!
    var totalBilled : AnyObject!
    var userFavorite : Bool!
    var viewCount : Int!
    var ownerImages : OwnerImage!
    var userFeedback: Float!
    var ownerFeedback: Float!
    var canEdit: Bool!
    var interviewCount: NSNumber!
    var runningJobs: NSNumber!
    var hireId: Int!
    var canFeedback: Bool!
    var canEnd: Bool!
    var isHired: Bool!
    var distance:Float!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        appliedCount = dictionary["applied_count"] as? Int
        approved = dictionary["approved"] as? Int
        approvedDate = dictionary["approved_date"] as? String
        avgBid = dictionary["avg_bid"] as? String
        avgRating = dictionary["avg_rating"] as? NSNumber
        body = dictionary["body"] as? String
        canApply = dictionary["can_apply"] as? Bool
        categories = [Category]()
        if let categoriesArray = dictionary["categories"] as? [[String:Any]]{
            for dic in categoriesArray{
                let value = Category(fromDictionary: dic)
                categories.append(value)
            }
        }
        if let ownerImagesData = dictionary["owner_images"] as? [String:Any]{
            ownerImages = OwnerImage(fromDictionary: ownerImagesData)
        }
        canFeedback = dictionary["can_feedback"] as? Bool
        closed = dictionary["closed"] as? Int
        commentCount = dictionary["comment_count"] as? Int
        contentUrl = dictionary["content_url"] as? String
        creationDate = dictionary["creation_date"] as? String
        draft = dictionary["draft"] as? Int
        duration = dictionary["duration"] as? Int
        endDate = dictionary["end_date"] as? String
        featured = dictionary["featured"] as? Int
        hiredJobs = dictionary["hired_jobs"] as? Int
        image = dictionary["image"] as? String
        imageIcon = dictionary["image_icon"] as? String
        imageNormal = dictionary["image_normal"] as? String
        imageProfile = dictionary["image_profile"] as? String
        inviteCount = dictionary["invite_count"] as? Int
        inviteId = dictionary["invite_id"] as? Int
        inviteOnly = dictionary["invite_only"] as? AnyObject
        inviteStatus = dictionary["invite_status"] as? String
        isApplied = dictionary["is_applied"] as? Bool
        isFavorite = dictionary["is_favorite"] as? Bool
        jobDurationLabel = dictionary["job_duration_label"] as? String
        jobStatus = dictionary["job_status"] as? String
        jobType = dictionary["job_type"] as? Int
        jobTypeLabel = dictionary["job_type_label"] as? String
        likeCount = dictionary["like_count"] as? Int
        listingId = dictionary["listing_id"] as? Int
        location = dictionary["location"] as? String
        canEdit = dictionary["can_edit"] as? Bool
        canEnd = dictionary["can_end"] as? Bool
        isHired = dictionary["is_hired"] as? Bool
        if let locationParamsData = dictionary["locationParams"] as? [String:Any]{
            locationParams = LocationParam(fromDictionary: locationParamsData)
        }
        distance = dictionary["distance"] as? Float
        modifiedDate = dictionary["modified_date"] as? String
        nationalSearch = dictionary["national_search"] as? AnyObject
        networksPrivacy = dictionary["networks_privacy"] as? AnyObject
        overview = dictionary["overview"] as? AnyObject
        ownerId = dictionary["owner_id"] as? Int
        ownerTitle = dictionary["owner_title"] as? String
        photoId = dictionary["photo_id"] as? Int
        hiredId = dictionary["hired_id"] as? Int
        hireId = dictionary["hire_id"] as? Int
        photos = [Photo]()
        if let photosArray = dictionary["photos"] as? [[String:Any]]{
            for dic in photosArray{
                let value = Photo(fromDictionary: dic)
                photos.append(value)
            }
        }
        postedJobs = dictionary["posted_jobs"] as? Int
        price = dictionary["price"]  as? NSNumber
        profileType = dictionary["profile_type"] as? Int
        provincialSearch = dictionary["provincial_search"] as? AnyObject
        radius = dictionary["radius"] as? AnyObject
        radiusSearch = dictionary["radius_search"] as? AnyObject
        rating = dictionary["rating"] as? Int
        reviewCount = dictionary["review_count"] as? Int
        search = dictionary["search"] as? Int
        sponsored = dictionary["sponsored"] as? Int
        title = dictionary["title"] as? String
        totalBilled = dictionary["total_billed"] as? AnyObject
        userFavorite = dictionary["user_favorite"] as? Bool
        viewCount = dictionary["view_count"] as? Int
        userFeedback = dictionary["user_feedback"] as? Float
        ownerFeedback = dictionary["owner_feedback"] as? Float
        interviewCount = dictionary["interview_count"] as? NSNumber
        runningJobs = dictionary["running_jobs"] as? NSNumber
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if appliedCount != nil{
            dictionary["applied_count"] = appliedCount
        }
        if approved != nil{
            dictionary["approved"] = approved
        }
        if approvedDate != nil{
            dictionary["approved_date"] = approvedDate
        }
        if avgBid != nil{
            dictionary["avg_bid"] = avgBid
        }
        if avgRating != nil{
            dictionary["avg_rating"] = avgRating
        }
        if body != nil{
            dictionary["body"] = body
        }
        if canApply != nil{
            dictionary["can_apply"] = canApply
        }
        if hiredId != nil{
            dictionary["hire_id"] = canApply
        }
        if categories != nil{
            var dictionaryElements = [[String:Any]]()
            for categoriesElement in categories {
                dictionaryElements.append(categoriesElement.toDictionary())
            }
            dictionary["categories"] = dictionaryElements
        }
        if ownerImages != nil{
            dictionary["owner_images"] = ownerImages.toDictionary()
        }
        if closed != nil{
            dictionary["closed"] = closed
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
        if draft != nil{
            dictionary["draft"] = draft
        }
        if duration != nil{
            dictionary["duration"] = duration
        }
        if endDate != nil{
            dictionary["end_date"] = endDate
        }
        if featured != nil{
            dictionary["featured"] = featured
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
        if inviteCount != nil{
            dictionary["invite_count"] = inviteCount
        }
        if inviteId != nil{
            dictionary["invite_id"] = inviteId
        }
        if inviteOnly != nil{
            dictionary["invite_only"] = inviteOnly
        }
        if inviteStatus != nil{
            dictionary["invite_status"] = inviteStatus
        }
        if isApplied != nil{
            dictionary["is_applied"] = isApplied
        }
        if isFavorite != nil{
            dictionary["is_favorite"] = isFavorite
        }
        if jobDurationLabel != nil{
            dictionary["job_duration_label"] = jobDurationLabel
        }
        if jobStatus != nil{
            dictionary["job_status"] = jobStatus
        }
        if jobType != nil{
            dictionary["job_type"] = jobType
        }
        if jobTypeLabel != nil{
            dictionary["job_type_label"] = jobTypeLabel
        }
        if likeCount != nil{
            dictionary["like_count"] = likeCount
        }
        if listingId != nil{
            dictionary["listing_id"] = listingId
        }
        if location != nil{
            dictionary["location"] = location
        }
        if locationParams != nil{
            dictionary["locationParams"] = locationParams.toDictionary()
        }
        if modifiedDate != nil{
            dictionary["modified_date"] = modifiedDate
        }
        if nationalSearch != nil{
            dictionary["national_search"] = nationalSearch
        }
        if networksPrivacy != nil{
            dictionary["networks_privacy"] = networksPrivacy
        }
        if overview != nil{
            dictionary["overview"] = overview
        }
        if ownerId != nil{
            dictionary["owner_id"] = ownerId
        }
        if ownerTitle != nil{
            dictionary["owner_title"] = ownerTitle
        }
        if photoId != nil{
            dictionary["photo_id"] = photoId
        }
        if photos != nil{
            var dictionaryElements = [[String:Any]]()
            for photosElement in photos {
                dictionaryElements.append(photosElement.toDictionary())
            }
            dictionary["photos"] = dictionaryElements
        }
        if postedJobs != nil{
            dictionary["posted_jobs"] = postedJobs
        }
        if price != nil{
            dictionary["price"] = price
        }
        if profileType != nil{
            dictionary["profile_type"] = profileType
        }
        if provincialSearch != nil{
            dictionary["provincial_search"] = provincialSearch
        }
        if radius != nil{
            dictionary["radius"] = radius
        }
        if radiusSearch != nil{
            dictionary["radius_search"] = radiusSearch
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if reviewCount != nil{
            dictionary["review_count"] = reviewCount
        }
        if search != nil{
            dictionary["search"] = search
        }
        if sponsored != nil{
            dictionary["sponsored"] = sponsored
        }
        if title != nil{
            dictionary["title"] = title
        }
        if totalBilled != nil{
            dictionary["total_billed"] = totalBilled
        }
        if userFavorite != nil{
            dictionary["user_favorite"] = userFavorite
        }
        if viewCount != nil{
            dictionary["view_count"] = viewCount
        }
        if userFeedback != nil{
            dictionary["user_feedback"] = userFeedback
        }
        if ownerFeedback != nil{
            dictionary["owner_feedback"] = ownerFeedback
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        appliedCount = aDecoder.decodeObject(forKey: "applied_count") as? Int
        approved = aDecoder.decodeObject(forKey: "approved") as? Int
        approvedDate = aDecoder.decodeObject(forKey: "approved_date") as? String
        avgBid = aDecoder.decodeObject(forKey: "avg_bid") as? String
        avgRating = aDecoder.decodeObject(forKey: "avg_rating") as? NSNumber
        body = aDecoder.decodeObject(forKey: "body") as? String
        canApply = aDecoder.decodeObject(forKey: "can_apply") as? Bool
        categories = aDecoder.decodeObject(forKey :"categories") as? [Category]
        closed = aDecoder.decodeObject(forKey: "closed") as? Int
        commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
        contentUrl = aDecoder.decodeObject(forKey: "content_url") as? String
        creationDate = aDecoder.decodeObject(forKey: "creation_date") as? String
        draft = aDecoder.decodeObject(forKey: "draft") as? Int
        duration = aDecoder.decodeObject(forKey: "duration") as? Int
        endDate = aDecoder.decodeObject(forKey: "end_date") as? String
        featured = aDecoder.decodeObject(forKey: "featured") as? Int
        hiredJobs = aDecoder.decodeObject(forKey: "hired_jobs") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? String
        imageIcon = aDecoder.decodeObject(forKey: "image_icon") as? String
        imageNormal = aDecoder.decodeObject(forKey: "image_normal") as? String
        imageProfile = aDecoder.decodeObject(forKey: "image_profile") as? String
        inviteCount = aDecoder.decodeObject(forKey: "invite_count") as? Int
        inviteId = aDecoder.decodeObject(forKey: "invite_id") as? Int
        inviteOnly = aDecoder.decodeObject(forKey: "invite_only") as? AnyObject
        inviteStatus = aDecoder.decodeObject(forKey: "invite_status") as? String
        isApplied = aDecoder.decodeObject(forKey: "is_applied") as? Bool
        isFavorite = aDecoder.decodeObject(forKey: "is_favorite") as? Bool
        jobDurationLabel = aDecoder.decodeObject(forKey: "job_duration_label") as? String
        jobStatus = aDecoder.decodeObject(forKey: "job_status") as? String
        jobType = aDecoder.decodeObject(forKey: "job_type") as? Int
        jobTypeLabel = aDecoder.decodeObject(forKey: "job_type_label") as? String
        likeCount = aDecoder.decodeObject(forKey: "like_count") as? Int
        listingId = aDecoder.decodeObject(forKey: "listing_id") as? Int
        location = aDecoder.decodeObject(forKey: "location") as? String
        locationParams = aDecoder.decodeObject(forKey: "locationParams") as? LocationParam
        modifiedDate = aDecoder.decodeObject(forKey: "modified_date") as? String
        nationalSearch = aDecoder.decodeObject(forKey: "national_search") as? AnyObject
        networksPrivacy = aDecoder.decodeObject(forKey: "networks_privacy") as? AnyObject
        overview = aDecoder.decodeObject(forKey: "overview") as? AnyObject
        ownerId = aDecoder.decodeObject(forKey: "owner_id") as? Int
        ownerTitle = aDecoder.decodeObject(forKey: "owner_title") as? String
        photoId = aDecoder.decodeObject(forKey: "photo_id") as? Int
        photos = aDecoder.decodeObject(forKey :"photos") as? [Photo]
        postedJobs = aDecoder.decodeObject(forKey: "posted_jobs") as? Int
        price = aDecoder.decodeObject(forKey: "price") as? NSNumber
        profileType = aDecoder.decodeObject(forKey: "profile_type") as? Int
        provincialSearch = aDecoder.decodeObject(forKey: "provincial_search") as? AnyObject
        radius = aDecoder.decodeObject(forKey: "radius") as? AnyObject
        radiusSearch = aDecoder.decodeObject(forKey: "radius_search") as? AnyObject
        rating = aDecoder.decodeObject(forKey: "rating") as? Int
        reviewCount = aDecoder.decodeObject(forKey: "review_count") as? Int
        search = aDecoder.decodeObject(forKey: "search") as? Int
        sponsored = aDecoder.decodeObject(forKey: "sponsored") as? Int
        title = aDecoder.decodeObject(forKey: "title") as? String
        totalBilled = aDecoder.decodeObject(forKey: "total_billed") as? AnyObject
        userFavorite = aDecoder.decodeObject(forKey: "user_favorite") as? Bool
        viewCount = aDecoder.decodeObject(forKey: "view_count") as? Int
        hiredId = aDecoder.decodeObject(forKey: "hire_id") as? Int
         ownerImages = aDecoder.decodeObject(forKey: "owner_images") as? OwnerImage
        userFeedback = aDecoder.decodeObject(forKey: "user_feedback") as? Float
        ownerFeedback = aDecoder.decodeObject(forKey: "owner_feedback") as? Float
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if appliedCount != nil{
            aCoder.encode(appliedCount, forKey: "applied_count")
        }
        if approved != nil{
            aCoder.encode(approved, forKey: "approved")
        }
        if approvedDate != nil{
            aCoder.encode(approvedDate, forKey: "approved_date")
        }
        if avgBid != nil{
            aCoder.encode(avgBid, forKey: "avg_bid")
        }
        if avgRating != nil{
            aCoder.encode(avgRating, forKey: "avg_rating")
        }
        if body != nil{
            aCoder.encode(body, forKey: "body")
        }
        if canApply != nil{
            aCoder.encode(canApply, forKey: "can_apply")
        }
        if categories != nil{
            aCoder.encode(categories, forKey: "categories")
        }
        if closed != nil{
            aCoder.encode(closed, forKey: "closed")
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
        if draft != nil{
            aCoder.encode(draft, forKey: "draft")
        }
        if duration != nil{
            aCoder.encode(duration, forKey: "duration")
        }
        if endDate != nil{
            aCoder.encode(endDate, forKey: "end_date")
        }
        if featured != nil{
            aCoder.encode(featured, forKey: "featured")
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
        if inviteCount != nil{
            aCoder.encode(inviteCount, forKey: "invite_count")
        }
        if inviteId != nil{
            aCoder.encode(inviteId, forKey: "invite_id")
        }
        if inviteOnly != nil{
            aCoder.encode(inviteOnly, forKey: "invite_only")
        }
        if inviteStatus != nil{
            aCoder.encode(inviteStatus, forKey: "invite_status")
        }
        if isApplied != nil{
            aCoder.encode(isApplied, forKey: "is_applied")
        }
        if isFavorite != nil{
            aCoder.encode(isFavorite, forKey: "is_favorite")
        }
        if jobDurationLabel != nil{
            aCoder.encode(jobDurationLabel, forKey: "job_duration_label")
        }
        if jobStatus != nil{
            aCoder.encode(jobStatus, forKey: "job_status")
        }
        if jobType != nil{
            aCoder.encode(jobType, forKey: "job_type")
        }
        if jobTypeLabel != nil{
            aCoder.encode(jobTypeLabel, forKey: "job_type_label")
        }
        if likeCount != nil{
            aCoder.encode(likeCount, forKey: "like_count")
        }
        if listingId != nil{
            aCoder.encode(listingId, forKey: "listing_id")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if locationParams != nil{
            aCoder.encode(locationParams, forKey: "locationParams")
        }
        if modifiedDate != nil{
            aCoder.encode(modifiedDate, forKey: "modified_date")
        }
        if nationalSearch != nil{
            aCoder.encode(nationalSearch, forKey: "national_search")
        }
        if networksPrivacy != nil{
            aCoder.encode(networksPrivacy, forKey: "networks_privacy")
        }
        if overview != nil{
            aCoder.encode(overview, forKey: "overview")
        }
        if ownerId != nil{
            aCoder.encode(ownerId, forKey: "owner_id")
        }
        if ownerTitle != nil{
            aCoder.encode(ownerTitle, forKey: "owner_title")
        }
        if photoId != nil{
            aCoder.encode(photoId, forKey: "photo_id")
        }
        if photos != nil{
            aCoder.encode(photos, forKey: "photos")
        }
        if postedJobs != nil{
            aCoder.encode(postedJobs, forKey: "posted_jobs")
        }
        if price != nil{
            aCoder.encode(price, forKey: "price")
        }
        if profileType != nil{
            aCoder.encode(profileType, forKey: "profile_type")
        }
        if provincialSearch != nil{
            aCoder.encode(provincialSearch, forKey: "provincial_search")
        }
        if radius != nil{
            aCoder.encode(radius, forKey: "radius")
        }
        if radiusSearch != nil{
            aCoder.encode(radiusSearch, forKey: "radius_search")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if reviewCount != nil{
            aCoder.encode(reviewCount, forKey: "review_count")
        }
        if search != nil{
            aCoder.encode(search, forKey: "search")
        }
        if sponsored != nil{
            aCoder.encode(sponsored, forKey: "sponsored")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if totalBilled != nil{
            aCoder.encode(totalBilled, forKey: "total_billed")
        }
        if userFavorite != nil{
            aCoder.encode(userFavorite, forKey: "user_favorite")
        }
        if viewCount != nil{
            aCoder.encode(viewCount, forKey: "view_count")
        }
        if ownerImages != nil{
            aCoder.encode(ownerImages, forKey: "owner_images")
        }
        if hiredId != nil{
            aCoder.encode(hiredId,forKey: "hire_id")
        }
        if userFeedback != nil{
            aCoder.encode(userFeedback,forKey: "user_feedback")
        }
        if ownerFeedback != nil{
            aCoder.encode(ownerFeedback,forKey: "owner_feedback")
        }
        
    }
    
}

