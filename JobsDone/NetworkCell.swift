//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit



class NetworkCell: UITableViewCell {

    @IBOutlet weak var networkName: UILabel!
    @IBOutlet weak var joined_member: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    } 
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
