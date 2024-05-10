//
//	Subject.swift
//
//	Create by musharraf on 8/6/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Subject : NSObject, NSCoding{

	var approved : Int!
	var commentCount : Int!
	var creationDate : String!
	var displayPhotoId : Int!
	var displayname : String!
	var enabled : Int!
	var extraInvites : Int!
	var featured : Int!
	var googleRating : Int!
	var googleRatingImported : Int!
	var image : String!
	var imageIcon : String!
	var imageNormal : String!
	var imageProfile : String!
	var invitesUsed : Int!
	var language : String!
	var lastloginDate : String!
	var levelId : Int!
	var likeCount : Int!
	var locale : String!
	var location : String!
	var memberCount : Int!
	var mobileUpdate : Int!
	var modifiedDate : String!
	var phone : AnyObject!
	var phoneVerified : Int!
	var photoId : Int!
	var photoUpdated : Int!
	var placeId : AnyObject!
	var search : Int!
	var showProfileviewers : Int!
	var skills : [Category]!
	var skillsChanged : AnyObject!
	var specialSignup : Int!
	var status : AnyObject!
	var statusDate : AnyObject!
	var timezone : String!
	var updateDate : AnyObject!
	var userId : Int!
	var username : AnyObject!
	var verified : Int!
	var viewCount : Int!
    var userRating: NSNumber!
    var reviewCount: NSNumber!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		approved = dictionary["approved"] as? Int
		commentCount = dictionary["comment_count"] as? Int
		creationDate = dictionary["creation_date"] as? String
		displayPhotoId = dictionary["display_photo_id"] as? Int
		displayname = dictionary["displayname"] as? String
		enabled = dictionary["enabled"] as? Int
		extraInvites = dictionary["extra_invites"] as? Int
		featured = dictionary["featured"] as? Int
		googleRating = dictionary["google_rating"] as? Int
		googleRatingImported = dictionary["google_rating_imported"] as? Int
		image = dictionary["image"] as? String
		imageIcon = dictionary["image_icon"] as? String
		imageNormal = dictionary["image_normal"] as? String
		imageProfile = dictionary["image_profile"] as? String
		invitesUsed = dictionary["invites_used"] as? Int
		language = dictionary["language"] as? String
		lastloginDate = dictionary["lastlogin_date"] as? String
		levelId = dictionary["level_id"] as? Int
		likeCount = dictionary["like_count"] as? Int
		locale = dictionary["locale"] as? String
		location = dictionary["location"] as? String
		memberCount = dictionary["member_count"] as? Int
		mobileUpdate = dictionary["mobile_update"] as? Int
		modifiedDate = dictionary["modified_date"] as? String
		phone = dictionary["phone"] as? AnyObject
		phoneVerified = dictionary["phone_verified"] as? Int
		photoId = dictionary["photo_id"] as? Int
		photoUpdated = dictionary["photo_updated"] as? Int
		placeId = dictionary["place_id"] as? AnyObject
		search = dictionary["search"] as? Int
		showProfileviewers = dictionary["show_profileviewers"] as? Int
		skills = [Category]()
		if let skillsArray = dictionary["skills"] as? [[String:Any]]{
			for dic in skillsArray{
				let value = Category(fromDictionary: dic)
				skills.append(value)
			}
		}
		skillsChanged = dictionary["skills_changed"] as? AnyObject
		specialSignup = dictionary["special_signup"] as? Int
		status = dictionary["status"] as? AnyObject
		statusDate = dictionary["status_date"] as? AnyObject
		timezone = dictionary["timezone"] as? String
		updateDate = dictionary["update_date"] as? AnyObject
		userId = dictionary["user_id"] as? Int
		username = dictionary["username"] as? AnyObject
		verified = dictionary["verified"] as? Int
		viewCount = dictionary["view_count"] as? Int
        userRating = dictionary["user_rating"] as? NSNumber
        reviewCount = dictionary["review_count"] as? NSNumber
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
		if commentCount != nil{
			dictionary["comment_count"] = commentCount
		}
		if creationDate != nil{
			dictionary["creation_date"] = creationDate
		}
		if displayPhotoId != nil{
			dictionary["display_photo_id"] = displayPhotoId
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
		if featured != nil{
			dictionary["featured"] = featured
		}
		if googleRating != nil{
			dictionary["google_rating"] = googleRating
		}
		if googleRatingImported != nil{
			dictionary["google_rating_imported"] = googleRatingImported
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
		if location != nil{
			dictionary["location"] = location
		}
		if memberCount != nil{
			dictionary["member_count"] = memberCount
		}
		if mobileUpdate != nil{
			dictionary["mobile_update"] = mobileUpdate
		}
		if modifiedDate != nil{
			dictionary["modified_date"] = modifiedDate
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if phoneVerified != nil{
			dictionary["phone_verified"] = phoneVerified
		}
		if photoId != nil{
			dictionary["photo_id"] = photoId
		}
		if photoUpdated != nil{
			dictionary["photo_updated"] = photoUpdated
		}
		if placeId != nil{
			dictionary["place_id"] = placeId
		}
		if search != nil{
			dictionary["search"] = search
		}
		if showProfileviewers != nil{
			dictionary["show_profileviewers"] = showProfileviewers
		}
		if skills != nil{
			var dictionaryElements = [[String:Any]]()
			for skillsElement in skills {
				dictionaryElements.append(skillsElement.toDictionary())
			}
			dictionary["skills"] = dictionaryElements
		}
		if skillsChanged != nil{
			dictionary["skills_changed"] = skillsChanged
		}
		if specialSignup != nil{
			dictionary["special_signup"] = specialSignup
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
         commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
         creationDate = aDecoder.decodeObject(forKey: "creation_date") as? String
         displayPhotoId = aDecoder.decodeObject(forKey: "display_photo_id") as? Int
         displayname = aDecoder.decodeObject(forKey: "displayname") as? String
         enabled = aDecoder.decodeObject(forKey: "enabled") as? Int
         extraInvites = aDecoder.decodeObject(forKey: "extra_invites") as? Int
         featured = aDecoder.decodeObject(forKey: "featured") as? Int
         googleRating = aDecoder.decodeObject(forKey: "google_rating") as? Int
         googleRatingImported = aDecoder.decodeObject(forKey: "google_rating_imported") as? Int
         image = aDecoder.decodeObject(forKey: "image") as? String
         imageIcon = aDecoder.decodeObject(forKey: "image_icon") as? String
         imageNormal = aDecoder.decodeObject(forKey: "image_normal") as? String
         imageProfile = aDecoder.decodeObject(forKey: "image_profile") as? String
         invitesUsed = aDecoder.decodeObject(forKey: "invites_used") as? Int
         language = aDecoder.decodeObject(forKey: "language") as? String
         lastloginDate = aDecoder.decodeObject(forKey: "lastlogin_date") as? String
         levelId = aDecoder.decodeObject(forKey: "level_id") as? Int
         likeCount = aDecoder.decodeObject(forKey: "like_count") as? Int
         locale = aDecoder.decodeObject(forKey: "locale") as? String
         location = aDecoder.decodeObject(forKey: "location") as? String
         memberCount = aDecoder.decodeObject(forKey: "member_count") as? Int
         mobileUpdate = aDecoder.decodeObject(forKey: "mobile_update") as? Int
         modifiedDate = aDecoder.decodeObject(forKey: "modified_date") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? AnyObject
         phoneVerified = aDecoder.decodeObject(forKey: "phone_verified") as? Int
         photoId = aDecoder.decodeObject(forKey: "photo_id") as? Int
         photoUpdated = aDecoder.decodeObject(forKey: "photo_updated") as? Int
         placeId = aDecoder.decodeObject(forKey: "place_id") as? AnyObject
         search = aDecoder.decodeObject(forKey: "search") as? Int
         showProfileviewers = aDecoder.decodeObject(forKey: "show_profileviewers") as? Int
         skills = aDecoder.decodeObject(forKey :"skills") as? [Category]
         skillsChanged = aDecoder.decodeObject(forKey: "skills_changed") as? AnyObject
         specialSignup = aDecoder.decodeObject(forKey: "special_signup") as? Int
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
		if commentCount != nil{
			aCoder.encode(commentCount, forKey: "comment_count")
		}
		if creationDate != nil{
			aCoder.encode(creationDate, forKey: "creation_date")
		}
		if displayPhotoId != nil{
			aCoder.encode(displayPhotoId, forKey: "display_photo_id")
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
		if featured != nil{
			aCoder.encode(featured, forKey: "featured")
		}
		if googleRating != nil{
			aCoder.encode(googleRating, forKey: "google_rating")
		}
		if googleRatingImported != nil{
			aCoder.encode(googleRatingImported, forKey: "google_rating_imported")
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
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if memberCount != nil{
			aCoder.encode(memberCount, forKey: "member_count")
		}
		if mobileUpdate != nil{
			aCoder.encode(mobileUpdate, forKey: "mobile_update")
		}
		if modifiedDate != nil{
			aCoder.encode(modifiedDate, forKey: "modified_date")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if phoneVerified != nil{
			aCoder.encode(phoneVerified, forKey: "phone_verified")
		}
		if photoId != nil{
			aCoder.encode(photoId, forKey: "photo_id")
		}
		if photoUpdated != nil{
			aCoder.encode(photoUpdated, forKey: "photo_updated")
		}
		if placeId != nil{
			aCoder.encode(placeId, forKey: "place_id")
		}
		if search != nil{
			aCoder.encode(search, forKey: "search")
		}
		if showProfileviewers != nil{
			aCoder.encode(showProfileviewers, forKey: "show_profileviewers")
		}
		if skills != nil{
			aCoder.encode(skills, forKey: "skills")
		}
		if skillsChanged != nil{
			aCoder.encode(skillsChanged, forKey: "skills_changed")
		}
		if specialSignup != nil{
			aCoder.encode(specialSignup, forKey: "special_signup")
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
