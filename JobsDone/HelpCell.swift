//
//  HelpCell.swift
//  JobsDone
//
//  Created by musharraf on 26/02/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

protocol helpCelldelegate {
    func didPressedQuestion(tag: Int)
}

class HelpCell: UITableViewCell {
    
    
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var ansLbl: UILabel!
    @IBOutlet weak var rightImg: UIImageView!
    var delegate: helpCelldelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didPressedQuestion(_ sender: UIButton) {
        delegate?.didPressedQuestion(tag: sender.tag)
    }

}
