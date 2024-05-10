//
//	Message.swift
//
//	Create by musharraf on 8/6/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Message : NSObject, NSCoding{

	var attachmentId : Int!
	var attachmentType : String!
	var body : String!
	var conversationId : Int!
	var date : String!
	var messageId : Int!
	var recipientsCount : Int!
	var title : String!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		attachmentId = dictionary["attachment_id"] as? Int
		attachmentType = dictionary["attachment_type"] as? String
		body = dictionary["body"] as? String
		conversationId = dictionary["conversation_id"] as? Int
		date = dictionary["date"] as? String
		messageId = dictionary["message_id"] as? Int
		recipientsCount = dictionary["recipients_count"] as? Int
		title = dictionary["title"] as? String
		userId = dictionary["user_id"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if attachmentId != nil{
			dictionary["attachment_id"] = attachmentId
		}
		if attachmentType != nil{
			dictionary["attachment_type"] = attachmentType
		}
		if body != nil{
			dictionary["body"] = body
		}
		if conversationId != nil{
			dictionary["conversation_id"] = conversationId
		}
		if date != nil{
			dictionary["date"] = date
		}
		if messageId != nil{
			dictionary["message_id"] = messageId
		}
		if recipientsCount != nil{
			dictionary["recipients_count"] = recipientsCount
		}
		if title != nil{
			dictionary["title"] = title
		}
		if userId != nil{
			dictionary["user_id"] = userId
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         attachmentId = aDecoder.decodeObject(forKey: "attachment_id") as? Int
         attachmentType = aDecoder.decodeObject(forKey: "attachment_type") as? String
         body = aDecoder.decodeObject(forKey: "body") as? String
         conversationId = aDecoder.decodeObject(forKey: "conversation_id") as? Int
         date = aDecoder.decodeObject(forKey: "date") as? String
         messageId = aDecoder.decodeObject(forKey: "message_id") as? Int
         recipientsCount = aDecoder.decodeObject(forKey: "recipients_count") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if attachmentId != nil{
			aCoder.encode(attachmentId, forKey: "attachment_id")
		}
		if attachmentType != nil{
			aCoder.encode(attachmentType, forKey: "attachment_type")
		}
		if body != nil{
			aCoder.encode(body, forKey: "body")
		}
		if conversationId != nil{
			aCoder.encode(conversationId, forKey: "conversation_id")
		}
		if date != nil{
			aCoder.encode(date, forKey: "date")
		}
		if messageId != nil{
			aCoder.encode(messageId, forKey: "message_id")
		}
		if recipientsCount != nil{
			aCoder.encode(recipientsCount, forKey: "recipients_count")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}