//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

protocol SuggestionCollectionCellDelegate{
    func didPressedCrossButton(sender: UIButton, tag: Int)
}


class SuggestionCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var crosBtn: UIButton!
    
    var delegate: SuggestionCollectionCellDelegate?
    
    @IBAction func cross(_ sender: UIButton) {
        delegate?.didPressedCrossButton(sender: sender, tag: self.tag)
    }
    
    
    
}
