// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan

import UIKit
import ActionSheetPicker_3_0


@objc protocol VideoAttachAlertViewDelegate {
    
    func didPressedCancelButton()
    func didPressedDoneButton(attachedView:VideoAttachAlertView)
    func didPressedChooseVideoButton()
    func didPressedChooseTypeButton()
    
}

class VideoAttachAlertView: UIView {
    
    var delegating : VideoAttachAlertViewDelegate?
    var videoType = Int()
    var chooseTypeSet = Bool()
    
    @IBAction func chooseButtonSelects(_ sender: Any) {
        self.urlTextField.resignFirstResponder()
        let rows = ["Youtube","Vimeo"]
        let videoType = [1,2]
        ActionSheetStringPicker.init(title: "Select Type", rows: rows, initialSelection: 0, doneBlock: { (piker, index, value) in
            self.chooseTypeButton.setTitle(rows[index], for: .normal)
            print(self.chooseTypeSet)
            print(self.videoType)
            self.chooseTypeSet = true
            self.videoType = videoType[index]
        }, cancel: { (picker) in
            
        }, origin: chooseTypeButton).show()
    }
    @IBOutlet weak var chooseTypeButton: WAButton!
    
    @IBOutlet weak var urlTextField: WATextField!
    
    @IBAction func cancelButtonSelects(_ sender: Any) {
                delegating?.didPressedCancelButton()
    }
    @IBOutlet weak var cancelButton: WAButton!
    
    @IBAction func doneSelects(_ sender: Any) {
    
        delegating?.didPressedDoneButton(attachedView: self)
    }
    @IBOutlet weak var doneButton: WAButton!
    
    
    @IBAction func chooseVideoSelects(_ sender: Any) {
    }
    @IBOutlet weak var chooseVideoButton: UIButton!
//    @IBOutlet weak var chooseVideoButton: UIButton!
//    @IBOutlet weak var chooseTypeButton: WAButton!
//    @IBOutlet weak var doneButton: WAButton!
//    @IBOutlet weak var cancelButton: WAButton!
//    @IBOutlet weak var urlTextField: WATextField!
//    @IBAction func chooseButtonSelects(_ sender: Any) {
//        delegating?.didPressedChooseTypeButton()
//    }
//    @IBAction func cancelButtonSelects(_ sender: Any) {
//        print(delegating as Any)
//        delegating?.didPressedCancelButton()
//    }
//    @IBAction func doneSelects(_ sender: Any) {
//        delegating?.didPressedDoneButton()
//    }
//    @IBAction func chooseVideoSelects(_ sender: Any) {
//        delegating?.didPressedChooseVideoButton()
//    }
    
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

}
