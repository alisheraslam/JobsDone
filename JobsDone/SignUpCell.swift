//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

protocol memberSeachCellDelegate {
    
    
    func didPressedSubmitButton(index: Int, section: Int, sender: Any)
    func didPressedDateButton(index: Int, section: Int, sender: WAButton)
    func didPressedmultiOptButton(index: Int, section: Int, sender: Any)
    func didChangeTextField(index: Int, section: Int, text: String)
    func didChangeTextView(index: Int, section: Int, text: String)
    func didSelectICheckBtn(index: Int, section: Int, sender: Any)
    
}


protocol SignUpCellDelegate {
    
    func didPressedFileButton(index: Int, section: Int, sender: Any)
    func didPressedSubmitButton(index: Int, section: Int, sender: Any)
    func didPressedDateButton(index: Int, section: Int, sender: WAButton)
    func didPressedmultiOptButton(index: Int, section: Int, sender: Any)
    func didChangeTextField(index: Int, section: Int, text: String)
    func didChangeTextView(index: Int, section: Int, text: String)
    func didSelectImageBtn(index: Int, section: Int, sender: Any)
    func didSelectICheckBtn(index: Int, section: Int, sender: Any)
    func didPressedLocationButton(index: Int, section: Int, sender: Any)
}

class SignUpCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var txtField: UITextField? = nil
    @IBOutlet weak var multiTxtField: UITextField? = nil
    @IBOutlet weak var passTxtField: UITextField? = nil
    @IBOutlet weak var txtView: WATextView? = nil
//    @IBOutlet weak var img_view: UIImageView!
     @IBOutlet weak var img_lbl: UILabel!
    @IBOutlet weak var select_lbl: UILabel!
    @IBOutlet weak var radio_lbl: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var dateBtn: WAButton!

    @IBOutlet weak var multiOptBtn: WAButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var heading_lbl: UILabel!
    @IBOutlet weak var locBtn: WAButton!
    @IBOutlet weak var chooseImageBtn: WAButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var policyBtn: UIButton!
    @IBOutlet weak var agreeTermBtn: UIButton!
    
    @IBOutlet fileprivate weak var collectView: UICollectionView!
    
    var section : Int!
    
    var delegate: SignUpCellDelegate?
    var delegateForMember: memberSeachCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtField?.delegate = self
        txtView?.delegate = self
        multiTxtField?.delegate = self
//        phoneNumberTextField.delegate = self
        txtField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        multiTxtField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                 for: UIControl.Event.editingChanged)
        phoneNumberTextField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                        for: UIControl.Event.editingChanged)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Configure the view for the selected state
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.didChangeTextView(index: textView.tag, section: section, text: textView.text)
        delegateForMember?.didChangeTextView(index: textView.tag, section: section, text: textView.text)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.didChangeTextField(index: textField.tag, section: section, text: textField.text!)
        delegateForMember?.didChangeTextView(index: textField.tag, section: section, text: textField.text!)
    }

    @IBAction func selectFileClicked(_ sender: Any) {
        delegate?.didPressedFileButton(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    
    @IBAction func selectBtnClicked(_ sender: Any) {
        
        delegate?.didSelectICheckBtn(index: (sender as AnyObject).tag, section: section, sender: sender)
        delegateForMember?.didSelectICheckBtn(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    
    @IBAction func radioBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        delegate?.didPressedSubmitButton(index: (sender as AnyObject).tag, section: section, sender: sender)
        delegateForMember?.didPressedSubmitButton(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    
    @IBAction func dateBtnClicked(_ sender: WAButton) {
        delegate?.didPressedDateButton(index: sender.tag, section: section, sender: sender)
        delegateForMember?.didPressedDateButton(index: sender.tag, section: section, sender: sender)
    }

    @IBAction func multiOptBtnClicked(_ sender: Any) {
        delegate?.didPressedmultiOptButton(index: (sender as AnyObject).tag, section: section, sender: sender)
        delegateForMember?.didPressedmultiOptButton(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    
    @IBAction func chooseImageBtnClicked(_ sender: Any) {
        delegate?.didSelectImageBtn(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    @IBAction func locBtnClicked(_ sender: WAButton) {
        delegate?.didPressedLocationButton(index: sender.tag, section: section, sender: sender)
        
    }
}
