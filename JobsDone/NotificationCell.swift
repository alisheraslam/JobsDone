//
//  NotificationCell.swift
//  JobsDone
//
//  Created by musharraf on 23/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var userimage: WAImageView!
    @IBOutlet weak var ratingImg: UIImageView!
    @IBOutlet weak var skillImg: UIImageView!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var goToProfile: UIButton!
    @IBOutlet weak var skillShowBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse(){
        // SET SWITCH STATE OFF HERE
    }

}
