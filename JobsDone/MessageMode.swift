//
//  MessageMode.swift
//  JobsDone
//
//  Created by musharraf on 08/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class MessageMode:NSObject, NSCoding{
    
    var message : Message!
    var recipient : Recipient!
    var sender : Sender!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let messageData = dictionary["message"] as? [String:Any]{
            message = Message(fromDictionary: messageData)
        }
        if let recipientData = dictionary["recipient"] as? [String:Any]{
            recipient = Recipient(fromDictionary: recipientData)
        }
        if let senderData = dictionary["sender"] as? [String:Any]{
            sender = Sender(fromDictionary: senderData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if message != nil{
            dictionary["message"] = message.toDictionary()
        }
        if recipient != nil{
            dictionary["recipient"] = recipient.toDictionary()
        }
        if sender != nil{
            dictionary["sender"] = sender.toDictionary()
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        message = aDecoder.decodeObject(forKey: "message") as? Message
        recipient = aDecoder.decodeObject(forKey: "recipient") as? Recipient
        sender = aDecoder.decodeObject(forKey: "sender") as? Sender
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if recipient != nil{
            aCoder.encode(recipient, forKey: "recipient")
        }
        if sender != nil{
            aCoder.encode(sender, forKey: "sender")
        }
        
    }
    
}

