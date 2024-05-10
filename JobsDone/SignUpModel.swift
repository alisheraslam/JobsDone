//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class SignUpModel: NSObject {
    var type = ""
    var name = ""
    var label = ""
    var multiOptions = Dictionary<String, AnyObject>()
    var value: AnyObject?
    var descrip = ""
    var hasValidator: Bool?
    
    var fieldOptions = [Dictionary<String, AnyObject>]()
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if !(dictionary["label"] is NSNull) &&  dictionary["label"] != nil{
            
            label = (dictionary["label"] as? String)!
        }
        
        if !(dictionary["name"] is NSNull) &&  dictionary["name"] != nil{
            
            name = (dictionary["name"] as? String)!
        }
        
        if !(dictionary["value"] is NSNull) &&  dictionary["value"] != nil{
            
            value = dictionary["value"]
        }
        
        if !(dictionary["type"] is NSNull) &&  dictionary["type"] != nil{
            
            type = (dictionary["type"] as? String)!
        }
        if !(dictionary["description"] is NSNull) &&  dictionary["description"] != nil{
            
            descrip = (dictionary["description"] as? String)!
        }
        if !(dictionary["hasValidator"] is NSNull) &&  dictionary["hasValidator"] != nil{
            
            hasValidator = dictionary["hasValidator"] as? Bool
        }
        
        if !(dictionary["multiOptions"] is NSNull) &&  dictionary["multiOptions"] != nil{
            print(dictionary["multiOptions"]!)
            multiOptions = (dictionary["multiOptions"])! as! Dictionary<String, AnyObject>
            
        }
        if !(dictionary["fieldOptions"] is NSNull) &&  dictionary["fieldOptions"] != nil{
            
            fieldOptions = dictionary["fieldOptions"] as! [Dictionary<String, AnyObject>]
        }
    }

}

