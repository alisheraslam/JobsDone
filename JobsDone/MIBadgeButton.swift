//
//  MIBadgeButton.swift
//  SchoolChain
//
//  Created by musharraf on 29/08/2017.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit

class MIBadgeButton: UIButton {
    var badgeValue : String! = "" {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override init(frame :CGRect)  {
        // Initialize the UIView
        super.init(frame : frame)
        
        self.awakeFromNib()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.awakeFromNib()
    }
    
    
    override func awakeFromNib()
    {
        self.drawBadgeLayer()
    }
    
    var badgeLayer :CAShapeLayer!
    func drawBadgeLayer() {
        
        if self.badgeLayer != nil {
            self.badgeLayer.removeFromSuperlayer()
        }
        
        // Omit layer if text is nil
        if self.badgeValue == nil || self.badgeValue.count == 0 {
            return
        }
        
        //! Initial label text layer
        let labelText = CATextLayer()
        labelText.contentsScale = UIScreen.main.scale
        labelText.string = self.badgeValue.uppercased()
        labelText.fontSize = 9.0
        labelText.font = UIFont.systemFont(ofSize: 9)
        labelText.alignmentMode = CATextLayerAlignmentMode.center
        labelText.foregroundColor = UIColor.white.cgColor
        let labelString = self.badgeValue.uppercased() as String?
        let labelFont = UIFont.systemFont(ofSize: 9) as UIFont?
        let attributes = [NSAttributedString.Key.font : labelFont]
        let w = self.frame.size.width
        let h = CGFloat(10.0)  // fixed height
        let labelWidth = min(w * 12.0, 12.0)    // Starting point
        let rect = labelString!.boundingRect(with: CGSize(width: labelWidth, height: h), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let textWidth = round(rect.width * UIScreen.main.scale)
        labelText.frame = CGRect(x: 0, y: 0, width: textWidth, height: h)
        
        //! Initialize outline, set frame and color
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        let frame : CGRect = labelText.frame
        let cornerRadius = CGFloat(6.0)
        let borderInset = CGFloat(-1.0)
        let aPath = UIBezierPath(roundedRect: frame.insetBy(dx: borderInset, dy: borderInset), cornerRadius: cornerRadius)
        
        shapeLayer.path = aPath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 0.5
        
        shapeLayer.insertSublayer(labelText, at: 0)
        
        shapeLayer.frame = shapeLayer.frame.offsetBy(dx: w*0.7, dy: 0.0)
        
        self.layer.insertSublayer(shapeLayer, at: 999)
        self.layer.masksToBounds = false
        self.badgeLayer = shapeLayer
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawBadgeLayer()
        self.setNeedsDisplay()
    }
}
