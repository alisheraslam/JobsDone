//
//  WAView.swift
//  Iptikar PromotionS
//
//  Created by Waqas Ali on 12/25/15.
//  Copyright © 2015 Waqas Ali. All rights reserved.
//

import UIKit

@IBDesignable class WAView: UIView {

    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    
    @IBInspectable var backgroundColors: UIColor = UIColor.clear {
        didSet {
            self.layer.backgroundColor = backgroundColors.cgColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
            if borderWidth != 0 {
                borderWidth = 1
            }
        }
    }
    
   func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func getWAViewBounds() -> CGRect {
        return self.bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

extension UInt32 {
    init?(hexString: String) {
        let scanner = Scanner(string: hexString)
        var hexInt = UInt32.min
        let success = scanner.scanHexInt32(&hexInt)
        if success {
            self = hexInt
        } else {
            return nil
        }
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.resignFirstResponder()
        self.view.endEditing(true)
    }
}

