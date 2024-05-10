//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

protocol memberCellDelegate{
    func didPressedConnectionButton(sender: UIButton)
}

class MemberCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: WAImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var addRemoveImage: UIImageView!
    
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var cellBackView: WAView!
    
    @IBOutlet weak var addConnectionButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    var delegate: memberCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addconnectionSelects(_ sender: UIButton) {
         delegate?.didPressedConnectionButton(sender: sender)
    }
    
    
}
