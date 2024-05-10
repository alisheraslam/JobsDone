//
//  HomeTVCell.swift
//  JobsDone
//
//  Created by musharraf on 18/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class HomeTVCell: UITableViewCell {
    @IBOutlet weak var userimage: WAImageView!
    @IBOutlet weak var starImg: UIImageView!
    @IBOutlet weak var skillImg: UIImageView!
    @IBOutlet weak var selfImg: UIImageView!
    @IBOutlet weak var skillCount: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var jobTypeLbl: UILabel!
    @IBOutlet weak var jobDurationLbl: UILabel!
    @IBOutlet weak var jobDurationType: UILabel!
    @IBOutlet weak var jobLocation: UILabel!
    @IBOutlet weak var jobStatus: UILabel!
    @IBOutlet weak var jobDate: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var showSkillBtn: UIButton!
    @IBOutlet weak var skillLbl: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var headerTxt: UILabel!
    @IBOutlet weak var countTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
