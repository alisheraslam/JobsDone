 //
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import RichEditorView

protocol CreateFormCellDelegate {
    
    func didPressedFileButton(index: Int, section: Int, sender: Any)
    func didPressedSubmitButton(index: Int, section: Int, sender: Any)
    func didPressedDateButton(index: Int, section: Int, sender: WAButton)
    func didPressedmultiOptButton(index: Int, section: Int, sender: Any)
    func didChangeTextField(index: Int, section: Int, text: String)
    func didChangeTextView(index: Int, section: Int, text: String)
    func didChangeEditorView(index: Int, section: Int, text: String)
    func didSelectImageBtn(index: Int, section: Int, sender: Any)
    func didPressedEditorBtn(index: Int, section: Int, sender: Any)
    
 
}

class CreateFormCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var txtField: UITextField? = nil
    @IBOutlet weak var multiTxtField: UITextField? = nil
    @IBOutlet weak var txtView: WATextView? = nil
    @IBOutlet weak var img_view: UIImageView!
    @IBOutlet weak var dispImg: UIImageView!
     @IBOutlet weak var img_lbl: UILabel!
    @IBOutlet weak var select_lbl: UILabel!
    @IBOutlet weak var radio_lbl: UILabel!
    @IBOutlet weak var htmlEditorView: RichEditorView?
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var dateBtn: WAButton!

    @IBOutlet weak var multiOptBtn: WAButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var heading_lbl: UILabel!
    
    @IBOutlet weak var chooseImageBtn: WAButton!
    @IBOutlet weak var disImgHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var collectView: UICollectionView!
    
    var section : Int!
    var indexForEditor: Int!
    var delegate: CreateFormCellDelegate?
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtField?.delegate = self
        txtView?.delegate = self
        multiTxtField?.delegate = self
//        htmlEditorBtn?.isHidden = true
        txtField?.addTarget(self, action: #selector(CreateFormCell.textFieldDidChange(_:)),
                            for: .editingChanged)
        multiTxtField?.addTarget(self, action: #selector(CreateFormCell.textFieldDidChange(_:)),
                           for: .editingChanged)
        self.htmlEditorView?.delegate = self
        
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
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        delegate?.didChangeTextField(index: textField.tag, section: section, text: textField.text!)
//        return true
//    }
    
    func validateEditor(createForm: CreateFormModel,formType: pluginType,detail: String)
    {
//       if (self.reuseIdentifier == "textAreaCell")
//       {
//        print(createForm.name)
//        if (formType == .classified || formType == .blogs )
//        {
//            htmlEditorBtn?.isHidden = false
//            if detail != ""
//            {
//                htmlEditorBtn?.setTitle(detail, for: .normal)
//            }
//        }
//
//        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.didChangeTextView(index: textView.tag, section: section, text: textView.text)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.didChangeTextField(index: textField.tag, section: section, text: textField.text!)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//    }
    @IBAction func selectFileClicked(_ sender: Any) {
        delegate?.didPressedFileButton(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    
    @IBAction func selectBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func radioBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        delegate?.didPressedSubmitButton(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    
    @IBAction func dateBtnClicked(_ sender: WAButton) {
        delegate?.didPressedDateButton(index: sender.tag, section: section, sender: sender)
    }

    @IBAction func multiOptBtnClicked(_ sender: Any) {
        delegate?.didPressedmultiOptButton(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    
    @IBAction func chooseImageBtnClicked(_ sender: Any) {
        delegate?.didSelectImageBtn(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    
    @IBAction func onClickTextBtn(_ sender: Any) {
        delegate?.didPressedEditorBtn(index: (sender as AnyObject).tag, section: section, sender: sender)
    }
    
}
extension CreateFormCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectView.delegate = dataSourceDelegate
        collectView.dataSource = dataSourceDelegate
        collectView.tag = row
//        collectView.setContentOffset(collectView.contentOffset, animated:false)
        collectView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectView.contentOffset.x = newValue }
        get { return collectView.contentOffset.x }
    }
    
}

extension String{
    func convertHtml() -> NSAttributedString{
//        guard let data = data(using: .utf8) else { return NSAttributedString() }
//        do{
//            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
//        }catch{
//            return NSAttributedString()
//        }
        return NSAttributedString()
    }
}
 extension CreateFormCell: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        print(content)
        //        totalTxt = content
        
        delegate?.didChangeEditorView(index: indexForEditor, section: section, text: content)
    }
    
 }

