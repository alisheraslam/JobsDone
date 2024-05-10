//
//	Recipient.swift
//
//	Create by musharraf on 8/6/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Recipient : NSObject, NSCoding{

	var conversationId : Int!
	var inboxDeleted : Int!
	var inboxMessageId : AnyObject!
	var inboxRead : Int!
	var inboxUpdated : AnyObject!
	var inboxView : Int!
	var outboxDeleted : Int!
	var outboxMessageId : Int!
	var outboxUpdated : String!
	var userId : Int!
    var phone: String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		conversationId = dictionary["conversation_id"] as? Int
		inboxDeleted = dictionary["inbox_deleted"] as? Int
		inboxMessageId = dictionary["inbox_message_id"] as? AnyObject
		inboxRead = dictionary["inbox_read"] as? Int
		inboxUpdated = dictionary["inbox_updated"] as? AnyObject
		inboxView = dictionary["inbox_view"] as? Int
		outboxDeleted = dictionary["outbox_deleted"] as? Int
		outboxMessageId = dictionary["outbox_message_id"] as? Int
		outboxUpdated = dictionary["outbox_updated"] as? String
		userId = dictionary["user_id"] as? Int
        if let ph = dictionary["phone"] as? Int{
            phone = String(describing: ph)
        }else{
            if let ph = dictionary["phone"] as? String{
                phone = ph
            }
        }
        
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if conversationId != nil{
			dictionary["conversation_id"] = conversationId
		}
		if inboxDeleted != nil{
			dictionary["inbox_deleted"] = inboxDeleted
		}
		if inboxMessageId != nil{
			dictionary["inbox_message_id"] = inboxMessageId
		}
		if inboxRead != nil{
			dictionary["inbox_read"] = inboxRead
		}
		if inboxUpdated != nil{
			dictionary["inbox_updated"] = inboxUpdated
		}
		if inboxView != nil{
			dictionary["inbox_view"] = inboxView
		}
		if outboxDeleted != nil{
			dictionary["outbox_deleted"] = outboxDeleted
		}
		if outboxMessageId != nil{
			dictionary["outbox_message_id"] = outboxMessageId
		}
		if outboxUpdated != nil{
			dictionary["outbox_updated"] = outboxUpdated
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
         conversationId = aDecoder.decodeObject(forKey: "conversation_id") as? Int
         inboxDeleted = aDecoder.decodeObject(forKey: "inbox_deleted") as? Int
         inboxMessageId = aDecoder.decodeObject(forKey: "inbox_message_id") as? AnyObject
         inboxRead = aDecoder.decodeObject(forKey: "inbox_read") as? Int
         inboxUpdated = aDecoder.decodeObject(forKey: "inbox_updated") as? AnyObject
         inboxView = aDecoder.decodeObject(forKey: "inbox_view") as? Int
         outboxDeleted = aDecoder.decodeObject(forKey: "outbox_deleted") as? Int
         outboxMessageId = aDecoder.decodeObject(forKey: "outbox_message_id") as? Int
         outboxUpdated = aDecoder.decodeObject(forKey: "outbox_updated") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if conversationId != nil{
			aCoder.encode(conversationId, forKey: "conversation_id")
		}
		if inboxDeleted != nil{
			aCoder.encode(inboxDeleted, forKey: "inbox_deleted")
		}
		if inboxMessageId != nil{
			aCoder.encode(inboxMessageId, forKey: "inbox_message_id")
		}
		if inboxRead != nil{
			aCoder.encode(inboxRead, forKey: "inbox_read")
		}
		if inboxUpdated != nil{
			aCoder.encode(inboxUpdated, forKey: "inbox_updated")
		}
		if inboxView != nil{
			aCoder.encode(inboxView, forKey: "inbox_view")
		}
		if outboxDeleted != nil{
			aCoder.encode(outboxDeleted, forKey: "outbox_deleted")
		}
		if outboxMessageId != nil{
			aCoder.encode(outboxMessageId, forKey: "outbox_message_id")
		}
		if outboxUpdated != nil{
			aCoder.encode(outboxUpdated, forKey: "outbox_updated")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
