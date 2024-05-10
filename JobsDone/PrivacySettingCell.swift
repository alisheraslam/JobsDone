//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit


protocol PrivacyCellDelegate {
    
    func didPressedRadioButton(index: Int, section: Int)
    func didPressedCheckButton(index: Int, section: Int)
}   

class PrivacySettingCell: UITableViewCell {

    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    
    var section : Int!
    var delegate: PrivacyCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func radioButtonSelects(_ sender: Any) {
//        delegate?.didPressedRadioButton(index: radioButton.tag, section: section)
    }
    @IBAction func checkBoxSelects(_ sender: Any) {
//        delegate?.didPressedCheckButton(index: checkBoxButton.tag, section: section)
    }
    
}
