//
//	City.swift
//
//	Create by musharraf on 13/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class City : NSObject, NSCoding{

	var location : String!
	var locationId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		location = dictionary["location"] as? String
		locationId = dictionary["location_id"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if location != nil{
			dictionary["location"] = location
		}
		if locationId != nil{
			dictionary["location_id"] = locationId
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         location = aDecoder.decodeObject(forKey: "location") as? String
         locationId = aDecoder.decodeObject(forKey: "location_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if locationId != nil{
			aCoder.encode(locationId, forKey: "location_id")
		}

	}

}