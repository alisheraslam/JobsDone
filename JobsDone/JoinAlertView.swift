// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan

import UIKit

class JoinAlertView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegate : GutterMenuProtocol? = nil
    
   
    var menu = GutterMenuModel()
    var con = UIViewController()
    var blurrView = UIView()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        let view = instanceFromNib()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
        
        
    }
    
    
       private func instanceFromNib() -> UIView {
        //        return UINib(nibName: "VideoAttachAlertView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    @IBAction func cancelButtonSelects(_ sender: Any) {
        self.removeFromSuperview()
        blurrView.removeFromSuperview()
    }
    
        
    
    
    @IBAction func selectButtons(_ sender: WAButton) {
        
        self.removeFromSuperview()
        blurrView.removeFromSuperview()
        
        
        let url = menu.url
        var urlParams = Dictionary<String,AnyObject>()
        urlParams["rsvp"] = sender.tag as AnyObject
        
        urlParams.update(other: menu.urlParams)
        
        
        print("url is \(url) \n and parms are \(urlParams)" )
        Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
        ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.con.navigationController?.view)!)
            print(response)
            let scode = response["status_code"] as! Int
            if scode == 200 {
                if let body = response["body"] as? Dictionary<String,AnyObject>{
                    if let gut = body["response"] as? Dictionary<String,AnyObject>{
                        if let guts = gut["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                            var arr = [GutterMenuModel]()
                            for men in guts{
                                let gutmod = GutterMenuModel.init(men)
                                arr.append(gutmod)
                                
                            }
                            
                            self.delegate?.leaveOrJoinDoneWithMenu!(gutMenu: arr, index: 0)
                        }
                    }
                    
                    
                    if let guts = body["gutterMenu"] as? [Dictionary<String,AnyObject>]{
                        var arr = [GutterMenuModel]()
                        for men in guts{
                            let gutmod = GutterMenuModel.init(men)
                            arr.append(gutmod)
                            
                        }
                        
                        self.delegate?.leaveOrJoinDoneWithMenu!(gutMenu: arr, index: 0)
                    }
                }
            } else {
                
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.con.navigationController?.view)!)
            print(response)
            
        }
        
        print(menu.urlParams)

        
        
    }
    
    


}
