//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import ActiveLabel
import Cupcake

@objc public protocol ChatCellDelegate {
    
    @objc optional func didPressedPlayOrImage(tag:Int)
    @objc optional func didPressedLink(tag:Int)
}

class ChatCell: UITableViewCell{
    
    
    var delegate : ChatCellDelegate?

    @IBOutlet weak var userImage: WAImageView!
    @IBOutlet weak var msgLabel: ActiveLabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageImage: WAImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var playIconImage: UIImageView!
    @IBOutlet weak var linkLabel: ActiveLabel!
    @IBOutlet weak var backImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(message:ChatDataModel){
        userImage.sd_setImage(with: URL(string:message.image_icon))
        let strssss = message.body
        let strs = strssss.convertHtml()
        let attStr2 = AttStr(strs)
        msgLabel.attributedText = attStr2
//        msgLabel.str(attStr2)
        let date = Utilities.dateFromString(message.date)
        let time = Utilities.timeAgoSinceDate(date: date, numericDates: true)
        dateLabel.text = time
        msgLabel.textColor = UIColor.white
        msgLabel.font = UIFont.systemFont(ofSize: 18)
        if message.attachment_type == "album_photo" || message.attachment_type == "video"{
            
            if message.messageImg == nil {
                messageImage.sd_setImage(with: URL(string:message.image))
            } else {
                messageImage.image = message.messageImg
            }
            
            if message.attachment_type == "video"{
                self.playIconImage.isHidden = false
            }else{
                self.playIconImage.isHidden = true
            }
        }
        if message.attachment_type == "core_link"{
            linkLabel.enabledTypes = [.url]
            linkLabel.text = message.uri
            linkLabel.handleURLTap({ (url) in
                
                
                self.handleTap(url: url)
            })
        }
        
        if message.attachment_type == "music_playlist_song"{
            self.musicNameLabel.text = message.title
        }

    }
    
    func handleTap(url:URL){
        print(url)
        delegate?.didPressedLink!(tag: self.tag)
        
//        UIApplication.shared.openURL(url)
    }
    @IBAction func playOrShowImageButton(_ sender: Any) {
        
        delegate?.didPressedPlayOrImage!(tag: self.tag)
    }
    
}

