//
//	RootClass.swift
//
//	Create by musharraf on 10/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct RighMenuModel{

	var body : RightMenuBody!
	var statusCode : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let bodyData = dictionary["body"] as? [String:Any]{
				body = RightMenuBody(fromDictionary: bodyData)
			}
		statusCode = dictionary["status_code"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if body != nil{
			dictionary["body"] = body.toDictionary()
		}
		if statusCode != nil{
			dictionary["status_code"] = statusCode
		}
		return dictionary
	}

}
