//
//  FindProfessionalCVC.swift
//  JobsDone
//
//  Created by musharraf on 17/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class FindProfessionalCVC: UICollectionViewCell {
    @IBOutlet weak var profilePic: WAImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var starsImg: UIImageView!
    @IBOutlet weak var avgRating: UILabel!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var onlineImg: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var hourlyRate: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var skillImg: UIImageView!
    @IBOutlet weak var skillLbl: UILabel!
    @IBOutlet weak var skillBtn: UIButton!
//    self.cellView.dropShadow(color: , opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
}
//extension UIView {
//
//    // OUTPUT 2
//    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = color.cgColor
//        self.layer.shadowOpacity = opacity
//        self.layer.shadowOffset = offSet
//        self.layer.shadowRadius = radius
//
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
//}

