//
//	Photo.swift
//
//	Create by musharraf on 6/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import UIKit


class Photo : NSObject, NSCoding{

	var albumId : Int!
	var collectionId : Int!
	var contentUrl : String!
	var creationDate : String!
	var descriptionField : String!
	var fileId : Int!
	var image : String!
	var imageIcon : String!
	var imageNormal : String!
	var imageProfile : String!
	var listingId : Int!
	var modifiedDate : String!
	var photoId : Int!
	var title : String!
	var type : String!
	var userId : Int!
	var viewCount : Int!
    var img: UIImage!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		albumId = dictionary["album_id"] as? Int
		collectionId = dictionary["collection_id"] as? Int
		contentUrl = dictionary["content_url"] as? String
		creationDate = dictionary["creation_date"] as? String
		descriptionField = dictionary["description"] as? String
		fileId = dictionary["file_id"] as? Int
		image = dictionary["image"] as? String
		imageIcon = dictionary["image_icon"] as? String
		imageNormal = dictionary["image_normal"] as? String
		imageProfile = dictionary["image_profile"] as? String
		listingId = dictionary["listing_id"] as? Int
		modifiedDate = dictionary["modified_date"] as? String
		photoId = dictionary["photo_id"] as? Int
		title = dictionary["title"] as? String
		type = dictionary["type"] as? String
		userId = dictionary["user_id"] as? Int
		viewCount = dictionary["view_count"] as? Int
        img = dictionary["img"] as? UIImage
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if albumId != nil{
			dictionary["album_id"] = albumId
		}
		if collectionId != nil{
			dictionary["collection_id"] = collectionId
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
		if fileId != nil{
			dictionary["file_id"] = fileId
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
		if listingId != nil{
			dictionary["listing_id"] = listingId
		}
		if modifiedDate != nil{
			dictionary["modified_date"] = modifiedDate
		}
		if photoId != nil{
			dictionary["photo_id"] = photoId
		}
		if title != nil{
			dictionary["title"] = title
		}
		if type != nil{
			dictionary["type"] = type
		}
		if userId != nil{
			dictionary["user_id"] = userId
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
         albumId = aDecoder.decodeObject(forKey: "album_id") as? Int
         collectionId = aDecoder.decodeObject(forKey: "collection_id") as? Int
         contentUrl = aDecoder.decodeObject(forKey: "content_url") as? String
         creationDate = aDecoder.decodeObject(forKey: "creation_date") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         fileId = aDecoder.decodeObject(forKey: "file_id") as? Int
         image = aDecoder.decodeObject(forKey: "image") as? String
         imageIcon = aDecoder.decodeObject(forKey: "image_icon") as? String
         imageNormal = aDecoder.decodeObject(forKey: "image_normal") as? String
         imageProfile = aDecoder.decodeObject(forKey: "image_profile") as? String
         listingId = aDecoder.decodeObject(forKey: "listing_id") as? Int
         modifiedDate = aDecoder.decodeObject(forKey: "modified_date") as? String
         photoId = aDecoder.decodeObject(forKey: "photo_id") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int
         viewCount = aDecoder.decodeObject(forKey: "view_count") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if albumId != nil{
			aCoder.encode(albumId, forKey: "album_id")
		}
		if collectionId != nil{
			aCoder.encode(collectionId, forKey: "collection_id")
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
		if fileId != nil{
			aCoder.encode(fileId, forKey: "file_id")
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
		if listingId != nil{
			aCoder.encode(listingId, forKey: "listing_id")
		}
		if modifiedDate != nil{
			aCoder.encode(modifiedDate, forKey: "modified_date")
		}
		if photoId != nil{
			aCoder.encode(photoId, forKey: "photo_id")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if viewCount != nil{
			aCoder.encode(viewCount, forKey: "view_count")
		}

	}

}
