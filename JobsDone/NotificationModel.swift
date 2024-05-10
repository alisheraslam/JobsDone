//
//  NotificationModel.swift
//  JobsDone
//
//  Created by musharraf on 08/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class NotificationModel: NSObject, NSCoding{
    
    var actionTypeBody : String!
    var date : String!
    var feedTitle : String!
    var mitigated : Int!
    var module : String!
    var notificationId : Int!
    var notifyTimestamp : String!
    var object : Object!
    var objectId : Int!
    var objectType : String!

    var read : Int!
    var show : Int!
    var subject : Subject!
    var subjectId : Int!
    var subjectType : String!
    var type : String!
    var url : String!
    var userId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        actionTypeBody = dictionary["action_type_body"] as? String
       
        date = dictionary["date"] as? String
        feedTitle = dictionary["feed_title"] as? String
        mitigated = dictionary["mitigated"] as? Int
        module = dictionary["module"] as? String
        notificationId = dictionary["notification_id"] as? Int
        notifyTimestamp = dictionary["notify_timestamp"] as? String
        if let objectData = dictionary["object"] as? [String:Any]{
            object = Object(fromDictionary: objectData)
        }
        objectId = dictionary["object_id"] as? Int
        objectType = dictionary["object_type"] as? String
        
        read = dictionary["read"] as? Int
        show = dictionary["show"] as? Int
        if let subjectData = dictionary["subject"] as? [String:Any]{
            subject = Subject(fromDictionary: subjectData)
        }
        subjectId = dictionary["subject_id"] as? Int
        subjectType = dictionary["subject_type"] as? String
        type = dictionary["type"] as? String
        url = dictionary["url"] as? String
        userId = dictionary["user_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if actionTypeBody != nil{
            dictionary["action_type_body"] = actionTypeBody
        }
        
        if date != nil{
            dictionary["date"] = date
        }
        if feedTitle != nil{
            dictionary["feed_title"] = feedTitle
        }
        if mitigated != nil{
            dictionary["mitigated"] = mitigated
        }
        if module != nil{
            dictionary["module"] = module
        }
        if notificationId != nil{
            dictionary["notification_id"] = notificationId
        }
        if notifyTimestamp != nil{
            dictionary["notify_timestamp"] = notifyTimestamp
        }
        if object != nil{
            dictionary["object"] = object.toDictionary()
        }
        if objectId != nil{
            dictionary["object_id"] = objectId
        }
        if objectType != nil{
            dictionary["object_type"] = objectType
        }
        
        if read != nil{
            dictionary["read"] = read
        }
        if show != nil{
            dictionary["show"] = show
        }
        if subject != nil{
            dictionary["subject"] = subject.toDictionary()
        }
        if subjectId != nil{
            dictionary["subject_id"] = subjectId
        }
        if subjectType != nil{
            dictionary["subject_type"] = subjectType
        }
        if type != nil{
            dictionary["type"] = type
        }
        if url != nil{
            dictionary["url"] = url
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
        actionTypeBody = aDecoder.decodeObject(forKey: "action_type_body") as? String
        
        date = aDecoder.decodeObject(forKey: "date") as? String
        feedTitle = aDecoder.decodeObject(forKey: "feed_title") as? String
        mitigated = aDecoder.decodeObject(forKey: "mitigated") as? Int
        module = aDecoder.decodeObject(forKey: "module") as? String
        notificationId = aDecoder.decodeObject(forKey: "notification_id") as? Int
        notifyTimestamp = aDecoder.decodeObject(forKey: "notify_timestamp") as? String
        object = aDecoder.decodeObject(forKey: "object") as? Object
        objectId = aDecoder.decodeObject(forKey: "object_id") as? Int
        objectType = aDecoder.decodeObject(forKey: "object_type") as? String
        
        read = aDecoder.decodeObject(forKey: "read") as? Int
        show = aDecoder.decodeObject(forKey: "show") as? Int
        subject = aDecoder.decodeObject(forKey: "subject") as? Subject
        subjectId = aDecoder.decodeObject(forKey: "subject_id") as? Int
        subjectType = aDecoder.decodeObject(forKey: "subject_type") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if actionTypeBody != nil{
            aCoder.encode(actionTypeBody, forKey: "action_type_body")
        }
        
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if feedTitle != nil{
            aCoder.encode(feedTitle, forKey: "feed_title")
        }
        if mitigated != nil{
            aCoder.encode(mitigated, forKey: "mitigated")
        }
        if module != nil{
            aCoder.encode(module, forKey: "module")
        }
        if notificationId != nil{
            aCoder.encode(notificationId, forKey: "notification_id")
        }
        if notifyTimestamp != nil{
            aCoder.encode(notifyTimestamp, forKey: "notify_timestamp")
        }
        if object != nil{
            aCoder.encode(object, forKey: "object")
        }
        if objectId != nil{
            aCoder.encode(objectId, forKey: "object_id")
        }
        if objectType != nil{
            aCoder.encode(objectType, forKey: "object_type")
        }
        
        if read != nil{
            aCoder.encode(read, forKey: "read")
        }
        if show != nil{
            aCoder.encode(show, forKey: "show")
        }
        if subject != nil{
            aCoder.encode(subject, forKey: "subject")
        }
        if subjectId != nil{
            aCoder.encode(subjectId, forKey: "subject_id")
        }
        if subjectType != nil{
            aCoder.encode(subjectType, forKey: "subject_type")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        
    }
    
}
