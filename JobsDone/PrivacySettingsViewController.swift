//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit

enum screenTypes{
    
    case Privacy
    case Notifications
} 

class PrivacySettingsViewController: UITableViewController,PrivacyCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var saveChangesCell: UITableViewCell!
    @IBOutlet var saveBtn: UIButton!
    let picker = UIImagePickerController()
    
    var sType = screenTypes.Privacy
    
    var dataArray = [PrivacySettingModel]()
    var formValues = Dictionary<String,AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.backgroundColor = UIColor(hexString: "#FF6A00")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.estimatedRowHeight = 38
        self.tableView.rowHeight = UITableView.automaticDimension
        
        if self.sType == .Notifications || self.sType == .Privacy{
            
            let bar = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveChangesSelect(_:)))
            bar.tintColor = UIColor(netHex: 0xB3CCCA)
            self.navigationItem.rightBarButtonItem = bar
        }
        loadPrivacyData()
    }
     
    func loadPrivacyData(){
        
        var method = "members/settings/privacy"
        
        if self.sType == .Notifications{
            
            method = "members/settings/notifications"
        }else if self.sType == .Privacy{
            method = "members/settings/privacy"
        }
        
        
        
        var dic = Dictionary<String,AnyObject>()
        dic["type"] = "ios" as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            
            if let body = response["body"] as? Dictionary<String,AnyObject>{
                if let form = body["form"] as? [Dictionary<String,AnyObject>]{
                    
                    for obj in form{
                    
                        let objModel = PrivacySettingModel.init(obj)
                        self.dataArray.append(objModel)
                        
                    }
                    let mod = PrivacySettingModel.init()
                    mod.type = "Submit"
                    self.dataArray.append(mod)
                }
                
                if let formValues = body["formValues"] as? Dictionary<String,AnyObject>{
                    
                    for obj in self.dataArray{
                        let keys = Array(formValues.keys)
                        _ = Array(formValues.values)
                        if !keys.contains(obj.name) && obj.type == "MultiCheckbox"{
                            
                            self.formValues[obj.name] = [String]() as AnyObject
                        }else{
//                            let ind = keys.index(of: obj.name)
                            self.formValues[obj.name] = formValues[obj.name]
                        }
//                        for (k,v) in formValues{
//                            
//                            if obj.name == k{
//                                
//                                self.formValues[k] = v
//                            }
//                        }
                    }
                    
                    print(self.formValues)
                }

                self.tableView.reloadData()
            }
            
//            for menu in self.menus{
//                
//                if !(menu["name"] is NSNull){
//                    self.nams.append((menu["name"] as? String)!)
//                }
//            }
//            print(self.nams)
            
        }) { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let objModel = dataArray[section]
        
        if objModel.type == "Checkbox"{
            
            return " "
        }else if objModel.type == "MultiCheckbox"{
            
            return objModel.label
        }else if objModel.type == "Radio"{
            return objModel.label
        }else if objModel.type == "Submit"{
            
//            return objModel.label
        }

        return objModel.label
    }
    
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        let objModel = dataArray[section]
        
        if objModel.type == "Checkbox"{
            
            return "\n"
        }else if objModel.type == "MultiCheckbox"{
            if self.sType == .Privacy{
                return "\(objModel.descriptions) \n"
            }else{
                return ""
            }
            
        }else if objModel.type == "Radio"{
            return "\(objModel.descriptions) \n"
        }else if objModel.type == "Submit"{
            
            return "\(objModel.descriptions) \n"
        }
        
        return objModel.descriptions
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let objModel = dataArray[section]
        
        if objModel.type == "Checkbox"{
            return 1
        }else if objModel.type == "MultiCheckbox"{
            return objModel.multiOptions.count
        }else if objModel.type == "Radio"{
            return objModel.multiOptions.count
        }else if objModel.type == "Submit"{
            
            return 1
        }
        
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifier = "radio"
        let objModel = dataArray[indexPath.section]
        
        if objModel.type == "Checkbox"{
            
            identifier = "check"
        }else if objModel.type == "MultiCheckbox"{
            
            identifier = "check"
        }else if objModel.type == "Radio"{
            identifier = "radio"
        }else if objModel.type == "Submit"{
            return saveChangesCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PrivacySettingCell

        // Configure the cell...
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.section = indexPath.section
        
        //For Single CheckBox Handling
        if objModel.type == "Checkbox"{
            cell.checkBoxButton.tintColor = UIColor(hexString: "#FF6A00")
            for (k,v) in self.formValues{
                if objModel.name == k{
                    if v as! Int == 1{
                        
                        cell.checkBoxButton.setFAIcon(icon: .FACheckSquare, forState: .normal)
                    }else{
                        cell.checkBoxButton.setFAIcon(icon: .FASquareO, forState: .normal)
                    }
                    
                }
            }
        cell.contentLabel.text = objModel.label
        cell.checkBoxButton.tag = indexPath.row
            
            
        //For Multiple CheckBox Handling
        }else if objModel.type == "MultiCheckbox"{
            cell.checkBoxButton.tintColor = UIColor(hexString: "#FF6A00")
            let values = Array(objModel.multiOptions.values)
            let keys = Array(objModel.multiOptions.keys)
            cell.contentLabel.text = values[indexPath.row]
            
            for (k,v) in self.formValues{
                if objModel.name == k{
                    
                    if let val = v as? [String]{
                            
                            if val.contains(keys[indexPath.row]){
                                cell.checkBoxButton.setFAIcon(icon: .FACheckSquare, forState: .normal)
                            }else{
                                
                                cell.checkBoxButton.setFAIcon(icon: .FASquareO, forState: .normal)
                            }
                        
                    }
                }
            }
            cell.checkBoxButton.tag = indexPath.row
            
        //For Radio Button Handling
        }else if objModel.type == "Radio"{
            let values = Array(objModel.multiOptions.values)
            let keys = Array(objModel.multiOptions.keys)
            
            cell.contentLabel.text = values[indexPath.row]
            
            for (k,v) in self.formValues{
                if objModel.name == k{
                    if v as! String == keys[indexPath.row]{
                        cell.radioButton.setFAIcon(icon: FAType.FACircle, forState: .normal)
                    }else{
                        cell.radioButton.setFAIcon(icon: FAType.FACircleThin, forState: .normal)
                    }
            }
        }
        cell.radioButton.tag = indexPath.row
        }else if objModel.type == "Submit"{
            return saveChangesCell
        }


        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objModel = dataArray[indexPath.section]
        
        if objModel.type == "Checkbox"{
            
            for (k,v) in self.formValues{
                if objModel.name == k{
                    if v as! Int == 1{
                        
                        self.formValues[k] = 0 as AnyObject
                        
                    }else{
                        
                        self.formValues[k] = 1 as AnyObject
                    }
                    
                }
            }
            let path = NSIndexPath(item: indexPath.row, section: indexPath.section)
            self.tableView.reloadRows(at: [path as IndexPath], with: .none)
            print(self.formValues)
        }else if objModel.type == "MultiCheckbox"{
            
//            let values = Array(objModel.multiOptions.values)
            let keys = Array(objModel.multiOptions.keys)

            for (k,v) in self.formValues{
                if objModel.name == k{
                    
                    if var val = v as? [String]{
                        
                        if val.contains(keys[indexPath.row]){
                          let ins = val.index(of: keys[indexPath.row])
                            val.remove(at: ins!)
                        }else{
                            val.append(keys[indexPath.row])
                        }
                        self.formValues[k] = val as AnyObject
                    }
                 
                   
                    
                }
            }
            let path = NSIndexPath(item: indexPath.row, section: indexPath.section)
            self.tableView.reloadRows(at: [path as IndexPath], with: .none)
            print(self.formValues)
            
        }else if objModel.type == "Radio"{
         
//            let values = Array(objModel.multiOptions.values)
            let keys = Array(objModel.multiOptions.keys)
            
            for (k,_) in self.formValues{
                if objModel.name == k{
                    
//                    if v as! String == keys[indexPath.row]{
//                    }else{
//                     
                        self.formValues[k] = keys[indexPath.row] as AnyObject
                    let indices: IndexSet = [indexPath.section]
                    self.tableView.reloadSections(indices, with: .none)
                    print(self.formValues)
//                    }
                }

        }
        }
        
        
    }
    
    func didPressedCheckButton(index: Int, section: Int) {
     
        let objModel = dataArray[section]
        
        if objModel.type == "Checkbox"{
            
            for (k,v) in self.formValues{
                if objModel.name == k{
                    if v as! Int == 1{
                        
                        self.formValues[k] = 0 as AnyObject
                        
                    }else{
        
                        self.formValues[k] = 1 as AnyObject
                    }
                    
                }
            }
            let path = NSIndexPath(item: index, section: section)
            self.tableView.reloadRows(at: [path as IndexPath], with: .none)
            print(self.formValues)
            
        }else if objModel.type == "MultiCheckbox"{
            
        }
        
    }
    
    func didPressedRadioButton(index: Int, section: Int) {
        
        let objModel = dataArray[section]
        
        if objModel.type == "Radio"{
         
        }
    }
   
    @IBAction func saveChangesSelect(_ sender: Any) {
        
        if self.sType == .Privacy{
            let method = "members/settings/privacy"
            Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: self.formValues, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
                print(response)
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
                print(response)
            }

        }else{
            
            let method = "members/settings/notifications"
            
            var dic = Dictionary<String,AnyObject>()
            
            for (_,v) in self.formValues{
                
               if let val = v as? [String]{
                    
                for str in val{
                    dic[str] = 1 as AnyObject
                }
                }
            }
            
            print(dic)
            
            Utilities.sharedInstance.showActivityIndicatory(uiView: (self.navigationController?.view)!)
            ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
                print(response)
            }) { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: (self.navigationController?.view)!)
                print(response)
            }

            
        }
        
    }

}
