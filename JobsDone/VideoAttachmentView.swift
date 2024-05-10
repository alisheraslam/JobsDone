//
//  VideoAttachmentView.swift
//  SchoolChain
//
//  Created by musharraf on 5/15/17.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit

class VideoAttachmentView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var chooseVideoBtn: UIButton!
    @IBOutlet weak var chooseTypeBtn: WAButton!
    @IBOutlet weak var videoUrl: WATextField!
    @IBOutlet weak var cancelBtn: WAButton!
    @IBOutlet weak var doneBtn: WAButton!
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    private func setupView() {
//        let view = viewFromNibForClass()
        let view: VideoAttachmentView = .fromNib()
//        view.frame = CGRect(x: 0, y: 0, width: 240, height: 120)
//        attachVideoAlertView.frame = CGRect(x: 0, y: 200, width: self.view.frame.width - 40, height: 180)
        view.frame = CGRect(x: 0, y: 200, width: view.frame.width - 30, height: 180)
        view.layer.cornerRadius = 8
        // Show the view.
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
//    private func viewFromNibForClass() -> UIView {
//        
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
//        
//        /* Usage for swift < 3.x
//         let bundle = NSBundle(forClass: self.dynamicType)
//         let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
//         let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//         */
//        
//        return view
//    }

}
extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
