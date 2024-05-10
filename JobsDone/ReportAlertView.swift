// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan

import UIKit
import ActionSheetPicker_3_0

@objc protocol ReportAlertViewDelegate {
    
    func didPressedCancelButton()
    func didPressedReportButton()
    func didPressedReportTypeButton()
}


class ReportAlertView: UIView,UITextViewDelegate {

    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var descriptionTextView: WATextView!
    @IBOutlet weak var reportTypeButton: WAButton!
    var delegating : ReportAlertViewDelegate?

    var menu = GutterMenuModel()
    var con = UIViewController()
    var catString = "spam"
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
        descriptionTextView.delegate = self
        reportButton.isEnabled = false
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > 0{
            reportButton.isEnabled = true
        }else{
            reportButton.isEnabled = false
        }
    }
    
    private func instanceFromNib() -> UIView {
        //        return UINib(nibName: "VideoAttachAlertView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
        
    }
    @IBAction func reportTypeSelects(_ sender: Any) {
//        delegating?.didPressedReportTypeButton()
        let rows = ["spam","abuse","inappropriate","licensed","other"]
        ActionSheetStringPicker.init(title: "Select Type", rows: rows, initialSelection: 0, doneBlock: { (piker, index, value) in
            self.reportTypeButton.setTitle(rows[index], for: .normal)
        }, cancel: { (picker) in
            
        }, origin: reportTypeButton).show()
        

    }
    
    @IBAction func reportSelects(_ sender: Any) {

        let url = menu.url
        var urlParams = Dictionary<String,AnyObject>()
        urlParams["description"] = descriptionTextView.text as AnyObject
        urlParams["category"] = self.catString as AnyObject
        urlParams["type"] = menu.urlParams["type"]
        urlParams["id"] = menu.urlParams["id"]
//        urlParams = menu.urlParams
        self.removeFromSuperview()
        print("url is \(url) \n and parms are \(urlParams)" )
        Utilities.sharedInstance.showActivityIndicatory(uiView: (con.navigationController?.view)!)
        ALFWebService.sharedInstance.doPostData(parameters: urlParams, method: url, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.con.navigationController?.view)!)
            print(response)
                    self.delegating?.didPressedReportButton()
            let scode = response["status_code"] as! Int
            if scode == 200 {
                
            } else {
                
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: (self.con.navigationController?.view)!)
            print(response)
            
        }

        print(menu.urlParams)
    }
    @IBAction func cancelSelects(_ sender: Any) {
        delegating?.didPressedCancelButton()
    }


}
