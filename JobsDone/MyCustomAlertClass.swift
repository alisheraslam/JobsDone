//
//  MyCustomAlertClass.swift
//  SocialNet
//
//  Created by musharraf on 13/12/2017.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit

@IBDesignable
class MyCustomAlertClass: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
