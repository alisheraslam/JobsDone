//
//	Menu.swift
//
//	Create by musharraf on 10/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Menu{

	var canCreate : CanCreate!
	var defaultField : Int!
	var headerLabel : String!
	var icon : String!
	var label : String!
	var module : String!
	var name : String!
	var type : String!
	var url : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let canCreateData = dictionary["canCreate"] as? [String:Any]{
				canCreate = CanCreate(fromDictionary: canCreateData)
			}
		defaultField = dictionary["default"] as? Int
		headerLabel = dictionary["headerLabel"] as? String
		icon = dictionary["icon"] as? String
		label = dictionary["label"] as? String
		module = dictionary["module"] as? String
		name = dictionary["name"] as? String
		type = dictionary["type"] as? String
		url = dictionary["url"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if canCreate != nil{
			dictionary["canCreate"] = canCreate.toDictionary()
		}
		if defaultField != nil{
			dictionary["default"] = defaultField
		}
		if headerLabel != nil{
			dictionary["headerLabel"] = headerLabel
		}
		if icon != nil{
			dictionary["icon"] = icon
		}
		if label != nil{
			dictionary["label"] = label
		}
		if module != nil{
			dictionary["module"] = module
		}
		if name != nil{
			dictionary["name"] = name
		}
		if type != nil{
			dictionary["type"] = type
		}
		if url != nil{
			dictionary["url"] = url
		}
		return dictionary
	}

}