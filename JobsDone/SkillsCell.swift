//
//  SkillsCell.swift
//  JobsDone
//
//  Created by musharraf on 28/02/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

protocol skillDelegate {
   func didPressedSkillBtn(tag: Int)
    
}

class SkillsCell: UICollectionViewCell {
    @IBOutlet weak var imgSkill: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cellView: WAView!
    //class is also assigned to search on hompage select category
    @IBOutlet weak var removeBtn: UIButton!
    var delegate: skillDelegate? = nil
    
    @IBAction func didPressedSkill(_ sender: UIButton) {
        delegate?.didPressedSkillBtn(tag:  sender.tag)
    }
}
