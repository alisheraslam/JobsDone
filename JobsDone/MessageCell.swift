//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

protocol MessageCellDelegate {
    func didPressedUserImageButton(tag: Int)
}

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: WAImageView!
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellBackView: WAView!
    
    let delegate: MessageCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func userImagePressed(_ sender: Any) {
        
        delegate?.didPressedUserImageButton(tag: (sender as AnyObject).tag)
    }

}
