//
//  SkillPopCell.swift
//  JobsDone
//
//  Created by musharraf on 31/08/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class SkillPopCell: UICollectionViewCell {
    @IBOutlet weak var imgSkill: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cellView: WAView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let width = UIScreen.main.bounds.size.width
        widthConstraint.constant = width / 2 - 15
    }

}
