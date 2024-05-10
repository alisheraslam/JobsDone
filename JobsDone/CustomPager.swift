//
//  CustomPager.swift
//  JobsDone
//
//  Created by musharraf on 07/08/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class CustomPager: UIPageControl {
    let activeImage:UIImage = #imageLiteral(resourceName: "selected")
    let inactiveImage:UIImage = #imageLiteral(resourceName: "selected")
    var type = "membership"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     */
    
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    func updateDots() {
        var i = 0
        for view in self.subviews {
            if let imageView = self.imageForSubview(view) {
                if i == self.currentPage {
                    imageView.image = self.activeImage
                    imageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
                } else {
                    if type == "membership"{
                    imageView.image = self.inactiveImage
                    }else{
                        imageView.image = #imageLiteral(resourceName: "onlineDot")
                    }
                    imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                }
                i = i + 1
            } else {
                var dotImage = self.inactiveImage
                if i == self.currentPage {
                    dotImage = self.activeImage
                    
                }
                view.clipsToBounds = false
                view.addSubview(UIImageView(image:dotImage))
                i = i + 1
            }
        }
    }
    
    fileprivate func imageForSubview(_ view:UIView) -> UIImageView? {
        var dot:UIImageView?
        
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        
        return dot
    }

    

}
