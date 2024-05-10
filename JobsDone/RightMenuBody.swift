//
//	Body.swift
//
//	Create by musharraf on 10/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct RightMenuBody{

	var enableModules : [String]!
//	var languages : DashLanguage!
	var location : Int!
	var menus : [Menu]!
	var restapilocation : Restapilocation!
	var sdiosappMode : Int!
	var sdiosappSharedSecretKey : String!
	var seaolocation : AnyObject!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		enableModules = dictionary["enable_modules"] as? [String]
//		if let languagesData = dictionary["languages"] as? [String:Any]{
//				languages = DashLanguage(fromDictionary: languagesData)
//			}
		location = dictionary["location"] as? Int
		menus = [Menu]()
		if let menusArray = dictionary["menus"] as? [[String:Any]]{
			for dic in menusArray{
				let value = Menu(fromDictionary: dic)
				menus.append(value)
			}
		}
		if let restapilocationData = dictionary["restapilocation"] as? [String:Any]{
				restapilocation = Restapilocation(fromDictionary: restapilocationData)
			}
		sdiosappMode = dictionary["sdiosappMode"] as? Int
		sdiosappSharedSecretKey = dictionary["sdiosappSharedSecretKey"] as? String
		seaolocation = dictionary["seaolocation"] as? AnyObject
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if enableModules != nil{
			dictionary["enable_modules"] = enableModules
		}
//		if languages != nil{
//			dictionary["languages"] = languages.toDictionary()
//		}
		if location != nil{
			dictionary["location"] = location
		}
		if menus != nil{
			var dictionaryElements = [[String:Any]]()
			for menusElement in menus {
				dictionaryElements.append(menusElement.toDictionary())
			}
			dictionary["menus"] = dictionaryElements
		}
		if restapilocation != nil{
			dictionary["restapilocation"] = restapilocation.toDictionary()
		}
		if sdiosappMode != nil{
			dictionary["sdiosappMode"] = sdiosappMode
		}
		if sdiosappSharedSecretKey != nil{
			dictionary["sdiosappSharedSecretKey"] = sdiosappSharedSecretKey
		}
		if seaolocation != nil{
			dictionary["seaolocation"] = seaolocation
		}
		return dictionary
	}

}
