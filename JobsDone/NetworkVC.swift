//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

class NetworkVC: UIViewController {

    @IBOutlet weak var availableNetworksBtn: UIButton!
    @IBOutlet weak var myNetworksBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
  
    @IBOutlet weak var underLine1: UIView!
    @IBOutlet weak var underLine2: UIView!
    
    var availableNetworkVC: NetworksTVC!
    var myNetworkVC: NetworksTVC!
    var viewControllers: [UIViewController]!
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        availableNetworkVC = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .networksTVC) as! NetworksTVC
        availableNetworkVC.listType = .availableNetworks
        
        myNetworkVC = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .networksTVC) as! NetworksTVC
        myNetworkVC.listType = .myNetworks
        
        viewControllers = [availableNetworkVC, myNetworkVC]
        
        underLine1.backgroundColor = UIColor(hexString: "#0080FF")
        underLine2.backgroundColor = .clear
        
        self.navigationItem.title = "Networks"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func availableNetworksBtnClicked(_ sender: UIButton?) {
        underLine1.backgroundColor = UIColor(hexString: "#0080FF")
        underLine2.backgroundColor = .clear
        
        let previousIndex = selectedIndex
        selectedIndex = (sender as AnyObject).tag
        
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)

    }
    @IBAction func myNetworksBtnClicked(_ sender: UIButton) {
        underLine1.backgroundColor = .clear
        underLine2.backgroundColor = UIColor(hexString: "#0080FF")
        
        let previousIndex = selectedIndex
        selectedIndex = (sender as AnyObject).tag
        
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
    }
}
