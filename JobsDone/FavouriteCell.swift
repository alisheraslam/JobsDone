//
//  FavouriteCell.swift
//  JobsDone
//
//  Created by musharraf on 07/03/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit


class FavouriteCell: UITableViewCell {
    
    
    @IBOutlet weak var userimage: WAImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var starImg: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var secondStarImg: UIButton!
    @IBOutlet weak var pencilImg: UIImageView!
    @IBOutlet weak var mxgImg: UIButton!
    @IBOutlet weak var skillImg: UIImageView!
    @IBOutlet weak var skillCount: UILabel!
    @IBOutlet weak var showSkillBtn: UIButton!
    @IBOutlet weak var pencilBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var btnStack: UIStackView!
    @IBOutlet weak var btnStackHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
