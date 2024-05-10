//
//	Object.swift
//
//	Create by musharraf on 8/6/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Object : NSObject, NSCoding{

	var approved : Int!
	var approvedDate : String!
	var body : String!
	var closed : Int!
	var commentCount : Int!
	var contentUrl : String!
	var creationDate : String!
	var draft : Int!
	var duration : Int!
	var endDate : AnyObject!
	var featured : Int!
	var image : String!
	var imageIcon : String!
	var imageNormal : String!
	var imageProfile : String!
	var interviewCount : Int!
	var inviteOnly : AnyObject!
	var jobStatus : String!
	var jobType : Int!
	var likeCount : Int!
	var listingId : Int!
	var location : String!
	var modifiedDate : String!
	var nationalSearch : AnyObject!
	var networksPrivacy : AnyObject!
	var overview : AnyObject!
	var ownerId : Int!
	var photoId : Int!
	var price : Int!
	var profileType : Int!
	var provincialSearch : AnyObject!
	var radius : AnyObject!
	var radiusSearch : AnyObject!
	var rating : Int!
	var reviewCount : Int!
	var search : Int!
	var sponsored : Int!
	var title : String!
	var url : String!
	var viewCount : Int!
    var portfolioId: Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		approved = dictionary["approved"] as? Int
		approvedDate = dictionary["approved_date"] as? String
		body = dictionary["body"] as? String
		closed = dictionary["closed"] as? Int
		commentCount = dictionary["comment_count"] as? Int
		contentUrl = dictionary["content_url"] as? String
		creationDate = dictionary["creation_date"] as? String
		draft = dictionary["draft"] as? Int
		duration = dictionary["duration"] as? Int
		endDate = dictionary["end_date"] as? AnyObject
		featured = dictionary["featured"] as? Int
		image = dictionary["image"] as? String
		imageIcon = dictionary["image_icon"] as? String
		imageNormal = dictionary["image_normal"] as? String
		imageProfile = dictionary["image_profile"] as? String
		interviewCount = dictionary["interview_count"] as? Int
		inviteOnly = dictionary["invite_only"] as? AnyObject
		jobStatus = dictionary["job_status"] as? String
		jobType = dictionary["job_type"] as? Int
		likeCount = dictionary["like_count"] as? Int
		listingId = dictionary["listing_id"] as? Int
		location = dictionary["location"] as? String
		modifiedDate = dictionary["modified_date"] as? String
		nationalSearch = dictionary["national_search"] as? AnyObject
		networksPrivacy = dictionary["networks_privacy"] as? AnyObject
		overview = dictionary["overview"] as? AnyObject
		ownerId = dictionary["owner_id"] as? Int
		photoId = dictionary["photo_id"] as? Int
		price = dictionary["price"] as? Int
		profileType = dictionary["profile_type"] as? Int
		provincialSearch = dictionary["provincial_search"] as? AnyObject
		radius = dictionary["radius"] as? AnyObject
		radiusSearch = dictionary["radius_search"] as? AnyObject
		rating = dictionary["rating"] as? Int
		reviewCount = dictionary["review_count"] as? Int
		search = dictionary["search"] as? Int
		sponsored = dictionary["sponsored"] as? Int
		title = dictionary["title"] as? String
		url = dictionary["url"] as? String
		viewCount = dictionary["view_count"] as? Int
        portfolioId = dictionary["portfolio_id"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if approved != nil{
			dictionary["approved"] = approved
		}
		if approvedDate != nil{
			dictionary["approved_date"] = approvedDate
		}
		if body != nil{
			dictionary["body"] = body
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
		if interviewCount != nil{
			dictionary["interview_count"] = interviewCount
		}
		if inviteOnly != nil{
			dictionary["invite_only"] = inviteOnly
		}
		if jobStatus != nil{
			dictionary["job_status"] = jobStatus
		}
		if jobType != nil{
			dictionary["job_type"] = jobType
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
		if photoId != nil{
			dictionary["photo_id"] = photoId
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
		if url != nil{
			dictionary["url"] = url
		}
		if viewCount != nil{
			dictionary["view_count"] = viewCount
		}
        if portfolioId != nil{
            dictionary["portfolio_id"] = portfolioId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         approved = aDecoder.decodeObject(forKey: "approved") as? Int
         approvedDate = aDecoder.decodeObject(forKey: "approved_date") as? String
         body = aDecoder.decodeObject(forKey: "body") as? String
         closed = aDecoder.decodeObject(forKey: "closed") as? Int
         commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
         contentUrl = aDecoder.decodeObject(forKey: "content_url") as? String
         creationDate = aDecoder.decodeObject(forKey: "creation_date") as? String
         draft = aDecoder.decodeObject(forKey: "draft") as? Int
         duration = aDecoder.decodeObject(forKey: "duration") as? Int
         endDate = aDecoder.decodeObject(forKey: "end_date") as? AnyObject
         featured = aDecoder.decodeObject(forKey: "featured") as? Int
         image = aDecoder.decodeObject(forKey: "image") as? String
         imageIcon = aDecoder.decodeObject(forKey: "image_icon") as? String
         imageNormal = aDecoder.decodeObject(forKey: "image_normal") as? String
         imageProfile = aDecoder.decodeObject(forKey: "image_profile") as? String
         interviewCount = aDecoder.decodeObject(forKey: "interview_count") as? Int
         inviteOnly = aDecoder.decodeObject(forKey: "invite_only") as? AnyObject
         jobStatus = aDecoder.decodeObject(forKey: "job_status") as? String
         jobType = aDecoder.decodeObject(forKey: "job_type") as? Int
         likeCount = aDecoder.decodeObject(forKey: "like_count") as? Int
         listingId = aDecoder.decodeObject(forKey: "listing_id") as? Int
         location = aDecoder.decodeObject(forKey: "location") as? String
         modifiedDate = aDecoder.decodeObject(forKey: "modified_date") as? String
         nationalSearch = aDecoder.decodeObject(forKey: "national_search") as? AnyObject
         networksPrivacy = aDecoder.decodeObject(forKey: "networks_privacy") as? AnyObject
         overview = aDecoder.decodeObject(forKey: "overview") as? AnyObject
         ownerId = aDecoder.decodeObject(forKey: "owner_id") as? Int
         photoId = aDecoder.decodeObject(forKey: "photo_id") as? Int
         price = aDecoder.decodeObject(forKey: "price") as? Int
         profileType = aDecoder.decodeObject(forKey: "profile_type") as? Int
         provincialSearch = aDecoder.decodeObject(forKey: "provincial_search") as? AnyObject
         radius = aDecoder.decodeObject(forKey: "radius") as? AnyObject
         radiusSearch = aDecoder.decodeObject(forKey: "radius_search") as? AnyObject
         rating = aDecoder.decodeObject(forKey: "rating") as? Int
         reviewCount = aDecoder.decodeObject(forKey: "review_count") as? Int
         search = aDecoder.decodeObject(forKey: "search") as? Int
         sponsored = aDecoder.decodeObject(forKey: "sponsored") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String
         url = aDecoder.decodeObject(forKey: "url") as? String
         viewCount = aDecoder.decodeObject(forKey: "view_count") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if approved != nil{
			aCoder.encode(approved, forKey: "approved")
		}
		if approvedDate != nil{
			aCoder.encode(approvedDate, forKey: "approved_date")
		}
		if body != nil{
			aCoder.encode(body, forKey: "body")
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
		if interviewCount != nil{
			aCoder.encode(interviewCount, forKey: "interview_count")
		}
		if inviteOnly != nil{
			aCoder.encode(inviteOnly, forKey: "invite_only")
		}
		if jobStatus != nil{
			aCoder.encode(jobStatus, forKey: "job_status")
		}
		if jobType != nil{
			aCoder.encode(jobType, forKey: "job_type")
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
		if photoId != nil{
			aCoder.encode(photoId, forKey: "photo_id")
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
		if url != nil{
			aCoder.encode(url, forKey: "url")
		}
		if viewCount != nil{
			aCoder.encode(viewCount, forKey: "view_count")
		}

	}

}
