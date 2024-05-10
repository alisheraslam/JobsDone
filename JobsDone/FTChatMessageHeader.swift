//
//  FTChatMessageHeader.swift
//  FTChatMessage
//
//  Created by liufengting on 16/2/28.
//  Copyright © 2016年 liufengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

protocol FTChatMessageHeaderDelegate {
    func ft_chatMessageHeaderDidTappedOnIcon(_ messageSenderModel : FTChatMessageUserModel)
}

class FTChatMessageHeader: UILabel {
    
//    var iconButton : UIButton!
    var iconButton : UIImageView!
    var messageSenderModel : FTChatMessageUserModel!
    var headerViewDelegate : FTChatMessageHeaderDelegate?

    lazy var messageSenderNameLabel: UILabel! = {
        let label = UILabel(frame: CGRect.zero)
        label.font = FTDefaultTimeLabelFont
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        return label
    }()


    
    convenience init(frame: CGRect, senderModel: FTChatMessageUserModel ) {
        self.init(frame : frame)

        
        messageSenderModel = senderModel;
        self.setupHeader( senderModel, isSender: senderModel.isUserSelf)
    }
    
    
    
    fileprivate func setupHeader(_ user : FTChatMessageUserModel, isSender: Bool){
        self.backgroundColor = UIColor.clear
        
        let iconRect = isSender ? CGRect(x: self.frame.width-FTDefaultMargin-FTDefaultIconSize, y: FTDefaultMargin, width: FTDefaultIconSize, height: FTDefaultIconSize) : CGRect(x: FTDefaultMargin, y: FTDefaultMargin, width: FTDefaultIconSize, height: FTDefaultIconSize)
//        iconButton = UIButton(frame: iconRect)
        iconButton = UIImageView(frame: iconRect)
        iconButton.backgroundColor = isSender ? FTDefaultOutgoingColor : FTDefaultIncomingColor
        iconButton.layer.cornerRadius = FTDefaultIconSize/2;
        iconButton.clipsToBounds = true
        iconButton.contentMode = .scaleAspectFill
        iconButton.isUserInteractionEnabled = true
//        iconButton.addTarget(self, action: #selector(self.iconTapped), for: UIControlEvents.touchUpInside)
        print(user.senderIconUrl)
        
        self.addSubview(iconButton)
        iconButton.sd_setImage(with: URL(string:user.senderIconUrl))
        if (user.senderIconUrl != nil) {
//            iconButton.kf.setBackgroundImage(with: URL(string : user.senderIconUrl!), for: .normal, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        
        var nameLabelRect = CGRect( x: 0, y: -5 , width: FTScreenWidth - (FTDefaultMargin*2 + FTDefaultIconSize), height: FTDefaultSectionHeight)
        var nameLabelTextAlignment : NSTextAlignment = .right
        
        if isSender == false {
            nameLabelRect.origin.x = FTDefaultMargin + FTDefaultIconSize + FTDefaultMargin
            nameLabelTextAlignment =  .left
        }
        
        messageSenderNameLabel.frame = nameLabelRect
        messageSenderNameLabel.text = user.senderName
        messageSenderNameLabel.textAlignment = nameLabelTextAlignment
        self.addSubview(messageSenderNameLabel)

        
        
    }


    
    
    @objc func iconTapped() {
        if (headerViewDelegate != nil) {
            headerViewDelegate?.ft_chatMessageHeaderDidTappedOnIcon(messageSenderModel)
        }
    }
    
    
    
}
