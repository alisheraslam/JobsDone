//
//  PortfolioVC.swift
//  JobsDone
//
//  Created by musharraf on 22/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class PortfolioVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var heading: UILabel!
    var portArr = [PortfolioModel]()
    var totalItemCount = 0
    var userId = ""
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=10
    var lastIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        clView.delegate = self
        clView.dataSource = self
        if Utilities.isGuest(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-button"), style: .done, target: self, action: #selector(self.OnclickAdd(_:)))
        }
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
        if Int(self.userId) == UserDefaults.standard.value(forKey: "id") as? Int{
            heading.text = "MY PORTFOLIO"
        }
        LoadPortfolio()
    //Do any additional setup after loading the view.
    }
    @objc func OnclickAdd(_ sender: UIBarButtonItem)
    {
        let vc = UIStoryboard.storyBoard(withName: .Portfolio).loadViewController(withIdentifier: .createPortfolioVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = self.portArr.count - 3
        if indexPath.row == lastElement {
            if portArr.count < totalItemCount{
                if !isDataLoading{
                    UIView.setAnimationsEnabled(false)
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    if self.portArr.count > 0 {
                        self.lastIndex = self.portArr.count - 1
                    }
                    self.clView.setContentOffset(clView.contentOffset, animated: false)
                    self.LoadPortfolio()
                    
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portArr.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width / 2 - 20
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return CGSize(width: width, height: width)
        
        // your code here
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let objModel = portArr[indexPath.item]
        //get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortCell", for: indexPath as IndexPath) as! SkillsCell
        
        cell.imgSkill.sd_setImage(with: URL(string: objModel.image))
      
        cell.name.text = objModel.title!
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.portArr[indexPath.row]
        let vc = UIStoryboard.storyBoard(withName: .Portfolio).loadViewController(withIdentifier: .portfolioProfileVC) as! PortfolioProfileVC
        vc.id = obj.portfolioId
        vc.userId = obj.userId
        if obj.title != ""{
            vc.title = obj.title
        }else{
            vc.title = "PORTFOLIO DETAIL"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func LoadPortfolio()
    {
        var method = "/members/profile/portfolio"
        var params = Dictionary<String,AnyObject>()
        params["user_id"] = self.userId as AnyObject
        params["page"] = pageNo as AnyObject
        params["limit"] = limit as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    self.totalItemCount = body!["totalItemCount"] as! Int
                    if let skillArr   = body!["response"] as? [Dictionary<String,AnyObject>]
                    {
                        for skill in skillArr
                        {
                            let objModel = PortfolioModel.init(fromDictionary: skill)
                            self.portArr.append(objModel)
                        }
                    }
                    self.countLbl.text = "\(self.portArr.count)"
                    if self.isDataLoading{
                        var indexPathsArray = [NSIndexPath]()
                        for index in self.lastIndex..<self.portArr.count - 1{
                            let indexPath = NSIndexPath(row: index, section: 0)
                            indexPathsArray.append(indexPath)
                            self.isDataLoading = false
                        }
                        UIView.setAnimationsEnabled(false)
                        self.clView.performBatchUpdates({
                            self.clView.insertItems(at: indexPathsArray as [IndexPath])
                        }, completion: { (response) in
                            
                        })
                        UIView.setAnimationsEnabled(true)
                    }else{
                        self.clView.reloadData()
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
