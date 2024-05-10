//
//  LocationModel.swift
//  JobsDone
//
//  Created by musharraf on 12/07/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class LocationModel: NSObject {
    
    var cities : [City]!
    var location : String!
    var locationId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cities = [City]()
        if let citiesArray = dictionary["cities"] as? [[String:Any]]{
            for dic in citiesArray{
                let value = City(fromDictionary: dic)
                cities.append(value)
            }
        }
        location = dictionary["location"] as? String
        locationId = dictionary["location_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cities != nil{
            var dictionaryElements = [[String:Any]]()
            for citiesElement in cities {
                dictionaryElements.append(citiesElement.toDictionary())
            }
            dictionary["cities"] = dictionaryElements
        }
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
        cities = aDecoder.decodeObject(forKey :"cities") as? [City]
        location = aDecoder.decodeObject(forKey: "location") as? String
        locationId = aDecoder.decodeObject(forKey: "location_id") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if cities != nil{
            aCoder.encode(cities, forKey: "cities")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if locationId != nil{
            aCoder.encode(locationId, forKey: "location_id")
        }
        
    }

}
