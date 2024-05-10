//
//	LocationParam.swift
//
//	Create by musharraf on 5/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class LocationParam : NSObject, NSCoding{

	var address : String!
	var city : String!
	var country : String!
	var formattedAddress : String!
	var latitude : Float!
	var listingId : Int!
	var location : String!
	var locationId : Int!
	var longitude : Float!
	var state : String!
	var zipcode : String!
	var zoom : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		address = dictionary["address"] as? String
		city = dictionary["city"] as? String
		country = dictionary["country"] as? String
		formattedAddress = dictionary["formatted_address"] as? String
		latitude = dictionary["latitude"] as? Float
		listingId = dictionary["listing_id"] as? Int
		location = dictionary["location"] as? String
		locationId = dictionary["location_id"] as? Int
		longitude = dictionary["longitude"] as? Float
		state = dictionary["state"] as? String
		zipcode = dictionary["zipcode"] as? String
		zoom = dictionary["zoom"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if address != nil{
			dictionary["address"] = address
		}
		if city != nil{
			dictionary["city"] = city
		}
		if country != nil{
			dictionary["country"] = country
		}
		if formattedAddress != nil{
			dictionary["formatted_address"] = formattedAddress
		}
		if latitude != nil{
			dictionary["latitude"] = latitude
		}
		if listingId != nil{
			dictionary["listing_id"] = listingId
		}
		if location != nil{
			dictionary["location"] = location
		}
		if locationId != nil{
			dictionary["location_id"] = locationId
		}
		if longitude != nil{
			dictionary["longitude"] = longitude
		}
		if state != nil{
			dictionary["state"] = state
		}
		if zipcode != nil{
			dictionary["zipcode"] = zipcode
		}
		if zoom != nil{
			dictionary["zoom"] = zoom
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         address = aDecoder.decodeObject(forKey: "address") as? String
         city = aDecoder.decodeObject(forKey: "city") as? String
         country = aDecoder.decodeObject(forKey: "country") as? String
         formattedAddress = aDecoder.decodeObject(forKey: "formatted_address") as? String
         latitude = aDecoder.decodeObject(forKey: "latitude") as? Float
         listingId = aDecoder.decodeObject(forKey: "listing_id") as? Int
         location = aDecoder.decodeObject(forKey: "location") as? String
         locationId = aDecoder.decodeObject(forKey: "location_id") as? Int
         longitude = aDecoder.decodeObject(forKey: "longitude") as? Float
         state = aDecoder.decodeObject(forKey: "state") as? String
         zipcode = aDecoder.decodeObject(forKey: "zipcode") as? String
         zoom = aDecoder.decodeObject(forKey: "zoom") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if address != nil{
			aCoder.encode(address, forKey: "address")
		}
		if city != nil{
			aCoder.encode(city, forKey: "city")
		}
		if country != nil{
			aCoder.encode(country, forKey: "country")
		}
		if formattedAddress != nil{
			aCoder.encode(formattedAddress, forKey: "formatted_address")
		}
		if latitude != nil{
			aCoder.encode(latitude, forKey: "latitude")
		}
		if listingId != nil{
			aCoder.encode(listingId, forKey: "listing_id")
		}
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if locationId != nil{
			aCoder.encode(locationId, forKey: "location_id")
		}
		if longitude != nil{
			aCoder.encode(longitude, forKey: "longitude")
		}
		if state != nil{
			aCoder.encode(state, forKey: "state")
		}
		if zipcode != nil{
			aCoder.encode(zipcode, forKey: "zipcode")
		}
		if zoom != nil{
			aCoder.encode(zoom, forKey: "zoom")
		}

	}

}