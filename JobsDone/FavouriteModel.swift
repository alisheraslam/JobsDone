//
//	RootClass.swift
//
//	Create by musharraf on 7/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class FavouriteModel : NSObject, NSCoding{

	var approved : Int!
	var avgRating : Float!
	var commentCount : Int!
	var contentUrl : String!
	var creationDate : String!
	var displayname : String!
	var enabled : Int!
	var extraInvites : Int!
	var image : String!
	var imageIcon : String!
	var imageNormal : String!
	var imageProfile : String!
	var invitesUsed : Int!
	var isFavorite : IsFavorite!
	var language : String!
	var lastloginDate : String!
	var levelId : Int!
	var likeCount : Int!
	var locale : String!
	var memberCount : Int!
	var modifiedDate : String!
	var phoneVerified : Int!
	var photoId : Int!
	var reviewCount : Int!
	var search : Int!
	var showProfileviewers : Int!
	var status : AnyObject!
	var statusDate : AnyObject!
	var timezone : String!
	var updateDate : AnyObject!
	var userId : Int!
	var username : AnyObject!
	var verified : Int!
	var viewCount : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		approved = dictionary["approved"] as? Int
		avgRating = dictionary["avg_rating"] as? Float
		commentCount = dictionary["comment_count"] as? Int
		contentUrl = dictionary["content_url"] as? String
		creationDate = dictionary["creation_date"] as? String
		displayname = dictionary["displayname"] as? String
		enabled = dictionary["enabled"] as? Int
		extraInvites = dictionary["extra_invites"] as? Int
		image = dictionary["image"] as? String
		imageIcon = dictionary["image_icon"] as? String
		imageNormal = dictionary["image_normal"] as? String
		imageProfile = dictionary["image_profile"] as? String
		invitesUsed = dictionary["invites_used"] as? Int
		if let isFavoriteData = dictionary["is_favorite"] as? [String:Any]{
			isFavorite = IsFavorite(fromDictionary: isFavoriteData)
		}
		language = dictionary["language"] as? String
		lastloginDate = dictionary["lastlogin_date"] as? String
		levelId = dictionary["level_id"] as? Int
		likeCount = dictionary["like_count"] as? Int
		locale = dictionary["locale"] as? String
		memberCount = dictionary["member_count"] as? Int
		modifiedDate = dictionary["modified_date"] as? String
		phoneVerified = dictionary["phone_verified"] as? Int
		photoId = dictionary["photo_id"] as? Int
		reviewCount = dictionary["review_count"] as? Int
		search = dictionary["search"] as? Int
		showProfileviewers = dictionary["show_profileviewers"] as? Int
		status = dictionary["status"] as? AnyObject
		statusDate = dictionary["status_date"] as? AnyObject
		timezone = dictionary["timezone"] as? String
		updateDate = dictionary["update_date"] as? AnyObject
		userId = dictionary["user_id"] as? Int
		username = dictionary["username"] as? AnyObject
		verified = dictionary["verified"] as? Int
		viewCount = dictionary["view_count"] as? Int
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
		if displayname != nil{
			dictionary["displayname"] = displayname
		}
		if enabled != nil{
			dictionary["enabled"] = enabled
		}
		if extraInvites != nil{
			dictionary["extra_invites"] = extraInvites
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
		if invitesUsed != nil{
			dictionary["invites_used"] = invitesUsed
		}
		if isFavorite != nil{
			dictionary["is_favorite"] = isFavorite.toDictionary()
		}
		if language != nil{
			dictionary["language"] = language
		}
		if lastloginDate != nil{
			dictionary["lastlogin_date"] = lastloginDate
		}
		if levelId != nil{
			dictionary["level_id"] = levelId
		}
		if likeCount != nil{
			dictionary["like_count"] = likeCount
		}
		if locale != nil{
			dictionary["locale"] = locale
		}
		if memberCount != nil{
			dictionary["member_count"] = memberCount
		}
		if modifiedDate != nil{
			dictionary["modified_date"] = modifiedDate
		}
		if phoneVerified != nil{
			dictionary["phone_verified"] = phoneVerified
		}
		if photoId != nil{
			dictionary["photo_id"] = photoId
		}
		if reviewCount != nil{
			dictionary["review_count"] = reviewCount
		}
		if search != nil{
			dictionary["search"] = search
		}
		if showProfileviewers != nil{
			dictionary["show_profileviewers"] = showProfileviewers
		}
		if status != nil{
			dictionary["status"] = status
		}
		if statusDate != nil{
			dictionary["status_date"] = statusDate
		}
		if timezone != nil{
			dictionary["timezone"] = timezone
		}
		if updateDate != nil{
			dictionary["update_date"] = updateDate
		}
		if userId != nil{
			dictionary["user_id"] = userId
		}
		if username != nil{
			dictionary["username"] = username
		}
		if verified != nil{
			dictionary["verified"] = verified
		}
		if viewCount != nil{
			dictionary["view_count"] = viewCount
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
         avgRating = aDecoder.decodeObject(forKey: "avg_rating") as? Float
         commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
         contentUrl = aDecoder.decodeObject(forKey: "content_url") as? String
         creationDate = aDecoder.decodeObject(forKey: "creation_date") as? String
         displayname = aDecoder.decodeObject(forKey: "displayname") as? String
         enabled = aDecoder.decodeObject(forKey: "enabled") as? Int
         extraInvites = aDecoder.decodeObject(forKey: "extra_invites") as? Int
         image = aDecoder.decodeObject(forKey: "image") as? String
         imageIcon = aDecoder.decodeObject(forKey: "image_icon") as? String
         imageNormal = aDecoder.decodeObject(forKey: "image_normal") as? String
         imageProfile = aDecoder.decodeObject(forKey: "image_profile") as? String
         invitesUsed = aDecoder.decodeObject(forKey: "invites_used") as? Int
         isFavorite = aDecoder.decodeObject(forKey: "is_favorite") as? IsFavorite
         language = aDecoder.decodeObject(forKey: "language") as? String
         lastloginDate = aDecoder.decodeObject(forKey: "lastlogin_date") as? String
         levelId = aDecoder.decodeObject(forKey: "level_id") as? Int
         likeCount = aDecoder.decodeObject(forKey: "like_count") as? Int
         locale = aDecoder.decodeObject(forKey: "locale") as? String
         memberCount = aDecoder.decodeObject(forKey: "member_count") as? Int
         modifiedDate = aDecoder.decodeObject(forKey: "modified_date") as? String
         phoneVerified = aDecoder.decodeObject(forKey: "phone_verified") as? Int
         photoId = aDecoder.decodeObject(forKey: "photo_id") as? Int
         reviewCount = aDecoder.decodeObject(forKey: "review_count") as? Int
         search = aDecoder.decodeObject(forKey: "search") as? Int
         showProfileviewers = aDecoder.decodeObject(forKey: "show_profileviewers") as? Int
         status = aDecoder.decodeObject(forKey: "status") as? AnyObject
         statusDate = aDecoder.decodeObject(forKey: "status_date") as? AnyObject
         timezone = aDecoder.decodeObject(forKey: "timezone") as? String
         updateDate = aDecoder.decodeObject(forKey: "update_date") as? AnyObject
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int
         username = aDecoder.decodeObject(forKey: "username") as? AnyObject
         verified = aDecoder.decodeObject(forKey: "verified") as? Int
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
		if displayname != nil{
			aCoder.encode(displayname, forKey: "displayname")
		}
		if enabled != nil{
			aCoder.encode(enabled, forKey: "enabled")
		}
		if extraInvites != nil{
			aCoder.encode(extraInvites, forKey: "extra_invites")
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
		if invitesUsed != nil{
			aCoder.encode(invitesUsed, forKey: "invites_used")
		}
		if isFavorite != nil{
			aCoder.encode(isFavorite, forKey: "is_favorite")
		}
		if language != nil{
			aCoder.encode(language, forKey: "language")
		}
		if lastloginDate != nil{
			aCoder.encode(lastloginDate, forKey: "lastlogin_date")
		}
		if levelId != nil{
			aCoder.encode(levelId, forKey: "level_id")
		}
		if likeCount != nil{
			aCoder.encode(likeCount, forKey: "like_count")
		}
		if locale != nil{
			aCoder.encode(locale, forKey: "locale")
		}
		if memberCount != nil{
			aCoder.encode(memberCount, forKey: "member_count")
		}
		if modifiedDate != nil{
			aCoder.encode(modifiedDate, forKey: "modified_date")
		}
		if phoneVerified != nil{
			aCoder.encode(phoneVerified, forKey: "phone_verified")
		}
		if photoId != nil{
			aCoder.encode(photoId, forKey: "photo_id")
		}
		if reviewCount != nil{
			aCoder.encode(reviewCount, forKey: "review_count")
		}
		if search != nil{
			aCoder.encode(search, forKey: "search")
		}
		if showProfileviewers != nil{
			aCoder.encode(showProfileviewers, forKey: "show_profileviewers")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if statusDate != nil{
			aCoder.encode(statusDate, forKey: "status_date")
		}
		if timezone != nil{
			aCoder.encode(timezone, forKey: "timezone")
		}
		if updateDate != nil{
			aCoder.encode(updateDate, forKey: "update_date")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}
		if verified != nil{
			aCoder.encode(verified, forKey: "verified")
		}
		if viewCount != nil{
			aCoder.encode(viewCount, forKey: "view_count")
		}

	}

}
