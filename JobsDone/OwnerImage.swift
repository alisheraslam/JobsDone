//
//	OwnerImage.swift
//
//	Create by musharraf on 22/5/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class OwnerImage : NSObject, NSCoding{

	var contentUrl : String!
	var image : String!
	var imageIcon : String!
	var imageNormal : String!
	var imageProfile : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		contentUrl = dictionary["content_url"] as? String
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
		if contentUrl != nil{
			dictionary["content_url"] = contentUrl
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
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         contentUrl = aDecoder.decodeObject(forKey: "content_url") as? String
         image = aDecoder.decodeObject(forKey: "image") as? String
         imageIcon = aDecoder.decodeObject(forKey: "image_icon") as? String
         imageNormal = aDecoder.decodeObject(forKey: "image_normal") as? String
         imageProfile = aDecoder.decodeObject(forKey: "image_profile") as? String

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

	}

}