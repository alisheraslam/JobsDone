//
//  AllMessageCell.swift
//  JobsDone
//
//  Created by musharraf on 19/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class AllMessageCell: UITableViewCell {
    @IBOutlet weak var userimage: WAImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var videochatBtn: UIButton!
    @IBOutlet weak var rubbishBtn: UIButton!
    @IBOutlet weak var userBtn: UIButton!
     @IBOutlet weak var hireBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
