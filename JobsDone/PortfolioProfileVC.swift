//
//  PortfolioProfileVC.swift
//  JobsDone
//
//  Created by musharraf on 01/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import AACarousel

class PortfolioProfileVC: UIViewController,AACarouselDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userimage: WAImageView!
    @IBOutlet weak var starImg: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var postJob: UILabel!
    @IBOutlet weak var hired: UILabel!
    @IBOutlet weak var billed: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var portImg: UIImageView!
    @IBOutlet weak var appreBtn: WAButton!
    @IBOutlet weak var comentBtn: WAButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var carouselView: AACarousel!
    @IBOutlet weak var jobImgHeight: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var locationImg: UIImageView!
    var photos = [Photo]()
    var id: Int!
    var userId: Int!
    let guttCon = GutterMenuHandler()
    var guttermenu = [GutterMenuModel]()
    var navTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.starImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 20, height: 20))
        if self.userId == UserDefaults.standard.value(forKey: "id") as? Int
        {
            self.favBtn.isHidden = true
        }
//        self.title = "PORTFOLIO DETAIL"
        let menuBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "more"), style: .done, target: self, action: #selector(self.EditBtnClicked(_:)))
        if self.userId! == UserDefaults.standard.value(forKey: "id") as? Int{
            self.navigationItem.rightBarButtonItem = menuBtn
        }
        if Utilities.isGuest(){
            self.favBtn.isHidden = true
            self.sendBtn.isHidden = true
            self.appreBtn.isHidden = true
            self.comentBtn.isHidden = true
        }
        LoadProfile()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        LoadProfile()
    }
    @objc func EditBtnClicked(_ sender: UIBarButtonItem)
        {
            guttermenu.removeAll()
            if userId == UserDefaults.standard.value(forKey: "id") as? Int{
                let model2 = GutterMenuModel()
                model2.label = "Edit"
                model2.name = "edit"
                model2.urlParams["id"] = self.id as AnyObject
                model2.url = "/members/profile/editportfolio?portfolio_id=\(self.id!)"
                guttermenu.append(model2)
            let model4 = GutterMenuModel()
            model4.label = "Delete"
            model4.name = "delete"
            model4.urlParams["portfolio_id"] = self.id as AnyObject
            model4.url = "/members/profile/deleteportfolio?portfolio_id=\(self.id!)"
            guttermenu.append(model4)
            }
            
            guttCon.setGutterMenu(menu: guttermenu, con: self, index: 0, type: pluginType.portfolio, senderr: sender, view: self.view, btnTyp: "barBtn")
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - PROFILE btn
    @IBAction func ProfileBtnPressed(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = self.userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func LoadProfile()
    {
        var dic = Dictionary<String,AnyObject>()
        dic["portfolio_id"] = self.id as AnyObject
        dic["user_id"] = self.userId as AnyObject
        let method = "/members/profile/viewportfolio?"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code ==  200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    if let port = body!["response"] as? Dictionary<String,AnyObject>
                    {
                        let model = PortfolioModel.init(fromDictionary: port)
                        if model.isFavorite{
                           self.favBtn.tag = 1
                            self.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 30, height: 30)), for: .normal)
                        }else{
                            self.favBtn.tag = 0
                    self.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor.lightGray, size: CGSize(width: 30, height: 30)), for: .normal)
                        }
                        self.userimage.sd_setImage(with: URL(string: model.ownerImages.image))
                        self.name.text = model.ownerTitle
                        self.location.text = model.location
                        if self.location.text == ""{
                            self.locationImg.isHidden = true
                        }
                        if model.postedJobs != nil{
                            self.postJob.text = String(describing: model.postedJobs!)
                            
                        }
                        self.hired.text = String(describing: model.hiredJobs!)
                        if model.runningJobs != nil{
                            self.billed.text = String(describing: model.runningJobs!)
                        }
                        if model.avgRating != nil{
                        self.rating.text = String(describing: model.avgRating!)
                        }
                        if model.isLike{
                            self.sendBtn.setTitle("APPRECIATE PORTFOLIO", for: .normal)
                            self.sendBtn.isEnabled = false
                        }else{
                            
                        }
                        
                        self.reviews.text = "\(model.reviewCount!) Reviews"
                        self.appreBtn.setTitle("\(model.likeCount!) Appreciate", for: .normal)
                        self.comentBtn.setTitle("\(model.commentCount!) Comment", for: .normal)
                        self.photos = model.photosArr
                        if self.photos.count > 0{
                          self.titleLbl.text = self.photos[0].title ?? ""
                          self.detail.text = self.photos[0].descriptionField ?? ""
                        }else{
                            self.titleLbl.text = model.title ?? ""
                            self.detail.text = model.descriptionField ?? ""
                        }
                        self.setImage()
                    }
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            
        }
    }
    //MARK: - BUTTON IBACTIONS
    @IBAction func AppreciateListPressed(_ sender: UIButton)
    {
        let con = UIStoryboard.storyBoard(withName: .Portfolio).loadViewController(withIdentifier: .likeMembersViewController) as! LikeMembersViewController
        con.act_id = self.id
        self.navigationController?.pushViewController(con, animated: true)
    }
    @IBAction func CommentListPressed(_ sender: UIButton)
    {
        let cmmentVC = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .commentVC) as! CommentVC
        cmmentVC.act_id = self.id
        cmmentVC.commentScreenType = .feeds
        self.navigationController?.pushViewController(cmmentVC, animated: true)
    }
    
    @IBAction func AppreciateBtnPressed(_ sender: UIButton)
    {
        var dic = Dictionary<String,AnyObject>()
        dic["subject_id"]  = self.id as AnyObject
        dic["subject_type"] = "user_portfolio" as AnyObject
        let method = "like"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            let status = response["status_code"] as? Int
            if status == 200
            {
                self.sendBtn.setTitle("APPRECIATE PORTFOLIO", for: .normal)
                self.sendBtn.isEnabled = false
                Utilities.showAlertWithTitle(title: "", withMessage: "Item has been liked", withNavigation: self)
            }else {
                Utilities.showAlertWithTitle(title: "", withMessage: (response["message"] as? String)!, withNavigation: self)
            }
        }){ (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    //MARK: - ONCLICK FAVOURITE BUTTON
    @IBAction func FavBtnPressed(_ sender: UIButton)
    {
        
        var dic = Dictionary<String,AnyObject>()
        dic["user_id"]  = self.userId as AnyObject
        let method = "/members/favorite"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            let status = response["status_code"] as? Int
            if status == 204
            {
                if sender.tag == 0{
                   self.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 30, height: 30)), for: .normal)
                    sender.tag = 1
                }else{
                    self.favBtn.tag = 0
                    self.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor.lightGray, size: CGSize(width: 30, height: 30)), for: .normal)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    //MARK: - CAROUSEL SET IMAGES
    func setImage()
    {
        if self.photos.count == 0
        {
//            self.jobImgHeight.constant = 0
        }else
        {
            let screenSize = UIScreen.main.bounds
            let screenHeight = screenSize.height
//            self.jobImgHeight.constant = screenHeight / 3
            var pathArray = [String]()
            for pic in (self.photos){
                pathArray.append(pic.image)
            }
            let titleArray = [String]()
            carouselView.delegate = self
            carouselView.setCarouselData(paths: pathArray,  describedTitle: titleArray, isAutoScroll: true, timer: 5.0, defaultImage: "background")
            //optional methods
            carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
            carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
            carouselView.contentMode = .scaleAspectFit
            carouselView.layoutSubviews()
        }
    }
    //MARK: - CAROUSEL DELEGATES
    func downloadImages(_ url: String, _ index:Int) {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
//        imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
//            self.carouselView.images[index] = downloadImage
//        })
    }
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    
    func didSelectCarouselView(_ view: AACarousel, _ index: Int) {
        
    }
    func didChangeSliderImg(index: Int) {
        if self.photos.indices.contains(index){
            self.titleLbl.text = self.photos[index].title ?? ""
            self.detail.text = self.photos[index].descriptionField ?? ""
        }
    }

}
