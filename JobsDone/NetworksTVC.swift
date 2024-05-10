////
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

enum ListType{
    case availableNetworks
    case myNetworks
   
}

class NetworksTVC: UITableViewController {

    @IBOutlet var networkTblView: UITableView!
    
    
    var listType : ListType = .availableNetworks
    
    var networkTitle: String?
    var joind_members: Int?
    var availableNetworkArr = [Dictionary<String,AnyObject>]()
    var joinedNetworksArr = [Dictionary<String,AnyObject>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        getNetworkActivities()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNetworkActivities(){
        let dic = [:] as Dictionary<String, AnyObject>
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: "members/settings/network", success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let scode = response["status_code"] as? Int {
                if scode == 200 {
                    
                    if let body = response["body"] as? Dictionary<String,AnyObject> {
                        
                        if let availNet = body["availableNetworks"] as? [Dictionary<String,AnyObject>] {
                            self.availableNetworkArr = availNet
                        }
                        if let joinNet = body["joinedNetworks"] as? [Dictionary<String,AnyObject>] {
                            self.joinedNetworksArr = joinNet
                        }
                        
                    }
                    self.networkTblView.reloadData()
                } else if scode == 401 {
                    Utilities.showAlertWithTitle(title: "Sorry", withMessage: "You do not have access to this resource.", withNavigation: self)
                }
            }

        }) { (response) in
            print(response)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listType == .availableNetworks {
            if availableNetworkArr.isEmpty {
                return 1
            }
                return availableNetworkArr.count
        } else {
            if joinedNetworksArr.isEmpty {
                return 1
            }
                return joinedNetworksArr.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var return_val: UITableViewCell?
        if listType == .availableNetworks {
            if availableNetworkArr.isEmpty {
                let identifier = "Cell"
                var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
                if cell == nil {
                    tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
                }
                cell.cellLabel.text = "No Data"
                return_val = cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NetworkCell
                print(joinedNetworksArr.count)
                let j = self.availableNetworkArr[indexPath.row]
                print(j)
                self.networkTitle = j["title"] as? String
                self.joind_members = j["member_count"] as? Int
                cell.networkName.text = networkTitle
                if joind_members == 1 {
                    cell.joined_member.text = "(" + String(describing: self.joind_members!) + " member.)"
                } else {
                    cell.joined_member.text = "(" + String(describing: self.joind_members!) + " members.)"
                }
                return_val = cell
            } 
            return return_val!
        }else{
            if !(joinedNetworksArr.isEmpty) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NetworkCell
                print(joinedNetworksArr.count)
                let j = self.joinedNetworksArr[indexPath.row]
                print(j)
                self.networkTitle = j["title"] as? String
                self.joind_members = j["member_count"] as? Int
                cell.networkName.text = networkTitle
                if joind_members == 1 {
                    cell.joined_member.text = "(" + String(describing: self.joind_members!) + " member.)"
                } else {
                    cell.joined_member.text = "(" + String(describing: self.joind_members!) + " members.)"
                }
                return_val = cell
            } else {
                let identifier = "Cell"
                var cell: NoActivityCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
                if cell == nil {
                    tableView.register(UINib(nibName: "NoActivityCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoActivityCell
                }
                cell.cellLabel.text = "No Data"
                return_val = cell
            }
            return return_val!
        }
    }

}
