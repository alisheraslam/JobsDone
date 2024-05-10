//
//  EmoCVCell.swift
//  JobsDone
//
//  Created by musharraf on 04/07/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class EmoCVCell: UICollectionViewCell {
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var emoImg: UIImageView!
    @IBOutlet weak var emoBtn: UIButton!
    func configCell(img: UIImage){
        photoImg.image = img
    }
    
}
