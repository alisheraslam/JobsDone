//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

protocol CommentCellProtocolDelegate {
    
    func didPressedLikeButton(tag: Int)
    func didPressedLikeImg(tag: Int)
    func didPressedDeleteButton(tag: Int)
    func didPressedUserNameOrImageButton(tag: Int)

}

class CommentCell: UITableViewCell {

    @IBOutlet weak var pImg: WAImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesImgWidth: NSLayoutConstraint!
    @IBOutlet weak var likesImgLead: NSLayoutConstraint!
    @IBOutlet weak var cellBackView: WAView!
    var delegate: CommentCellProtocolDelegate?
    
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userNameButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeBtnClicked(_ sender: Any) {
        delegate?.didPressedLikeButton(tag: self.tag)
    }
    @IBAction func likeImgClicked(_ sender: Any) {
        delegate?.didPressedLikeImg(tag: self.tag)
    }

    @IBAction func deleteBtnClicked(_ sender: Any) {
        delegate?.didPressedDeleteButton(tag: self.tag)
    }
    
    func configCell(name: String, comment: String, time: String) {
        self.name.text = name
        self.userNameButton.setTitle(name, for: .normal)
        self.comment.text = comment
        self.time.text = time
    }
    @IBAction func userNameOrImageSelects(_ sender: Any) {
        
        delegate?.didPressedUserNameOrImageButton(tag: self.tag)
    }
    
}
