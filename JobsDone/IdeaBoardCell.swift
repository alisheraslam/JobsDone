//
//  IdeaBoardCell.swift
//  JobsDone
//
//  Created by musharraf on 19/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class IdeaBoardCell: UITableViewCell {
    @IBOutlet weak var userimage: WAImageView!
    @IBOutlet weak var starImg: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var workImg: UIImageView!
    @IBOutlet weak var skillImg: UIImageView!
    @IBOutlet weak var skillCount: UILabel!
    @IBOutlet weak var heightImg: NSLayoutConstraint!
    @IBOutlet weak var showSkillBtn: UIButton!
    @IBOutlet weak var userProfileBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
