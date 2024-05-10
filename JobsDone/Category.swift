//
//	Category.swift
//
//	Create by musharraf on 9/5/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Category : NSObject, NSCoding{

	var categoryId : Int!
	var categoryName : String!
	var status : Bool!
	var thumbIcon : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		categoryId = dictionary["category_id"] as? Int
		categoryName = dictionary["category_name"] as? String
		status = dictionary["status"] as? Bool
		thumbIcon = dictionary["thumb_icon"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if categoryId != nil{
			dictionary["category_id"] = categoryId
		}
		if categoryName != nil{
			dictionary["category_name"] = categoryName
		}
		if status != nil{
			dictionary["status"] = status
		}
		if thumbIcon != nil{
			dictionary["thumb_icon"] = thumbIcon
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         categoryId = aDecoder.decodeObject(forKey: "category_id") as? Int
         categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
         status = aDecoder.decodeObject(forKey: "status") as? Bool
         thumbIcon = aDecoder.decodeObject(forKey: "thumb_icon") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if categoryId != nil{
			aCoder.encode(categoryId, forKey: "category_id")
		}
		if categoryName != nil{
			aCoder.encode(categoryName, forKey: "category_name")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if thumbIcon != nil{
			aCoder.encode(thumbIcon, forKey: "thumb_icon")
		}

	}

}