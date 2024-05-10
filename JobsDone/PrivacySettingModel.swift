//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class PrivacySettingModel: NSObject {
    
    var label = ""
    var name = ""
    var descriptions = ""
    var type = ""
    var multiOptions = [String:String]()
    
        
    
    
      convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        if !(dictionary["label"] is NSNull) &&  dictionary["label"] != nil{
            
            label = (dictionary["label"] as? String)!
        }
        
        if !(dictionary["name"] is NSNull) &&  dictionary["name"] != nil{
            
            name = (dictionary["name"] as? String)!
        }
        
        if !(dictionary["description"] is NSNull) &&  dictionary["description"] != nil{
            
            descriptions = (dictionary["description"] as? String)!
        }
        
        if !(dictionary["type"] is NSNull) &&  dictionary["type"] != nil{
            
            type = (dictionary["type"] as? String)!
        }
        
        if !(dictionary["multiOptions"] is NSNull) &&  dictionary["multiOptions"] != nil{
            
            multiOptions = (dictionary["multiOptions"] as? [String:String])!
        }
    }
}
