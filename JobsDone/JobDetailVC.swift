//
//  JobDetailVC.swift
//  JobsDone
//
//  Created by musharraf on 05/03/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import AACarousel
import Kingfisher
import MapKit

class JobDetailVC: UIViewController,AACarouselDelegate,MKMapViewDelegate {
   
    
    func didChangeSliderImg(index: Int) {
        print(index)
    }
    
    
    
    func didSelectCarouselView(_ view: AACarousel, _ index: Int) {
        
    }
    
    var jobId: Int!
    var job: JobsModel!
    var ownerId: Int!
    @IBOutlet weak var img: WAImageView!
    @IBOutlet weak var skillImg: UIImageView!
    @IBOutlet weak var skillCount: UILabel!
    @IBOutlet weak var userFavourite: UIButton!
    @IBOutlet weak var reviewImg: UIImageView!
    @IBOutlet weak var jobFavourite: UIButton!
    @IBOutlet weak var carouselView: AACarousel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var jobPosted: UILabel!
    @IBOutlet weak var hired: UILabel!
    @IBOutlet weak var billed: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var jobReviews: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobDetail: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var jobType: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var jobTeam: UILabel!
    @IBOutlet weak var applied: UILabel!
    @IBOutlet weak var avgBid: UILabel!
    @IBOutlet weak var invited: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var jobImgHeight: NSLayoutConstraint!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var applyBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var inviteBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewView: UIStackView!
    @IBOutlet weak var inviteBtn: UIStackView!
    @IBOutlet weak var clientReview: UILabel!
    @IBOutlet weak var contractReview: UILabel!
    @IBOutlet weak var calendarImg: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    var dic = Dictionary<String,AnyObject>()
    let guttCon = GutterMenuHandler()
    var guttermenu = [GutterMenuModel]()
    var method = ""
    var userImg = ""
    var circleOverlay: MKCircle!
    var circleRenderer: MKCircleRenderer!
    var indexPath: IndexPath!
    var jobSkillArr = [Category]()
    
    //MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle(titel: "JOB DETAILS")
        img.sd_setImage(with: URL(string: userImg))
        self.inviteBtnHeight.constant = 0
        self.applyBtnHeight.constant = 0
        self.reviewViewHeight.constant = 0
        self.reviewView.isHidden = true
        let imgSt = #imageLiteral(resourceName: "star")
        let statustintedImage = imgSt.withRenderingMode(.alwaysTemplate)
        self.reviewImg.image = statustintedImage
        self.self.reviewImg.tintColor = UIColor(hexString: "#FF6B00")
        let menuBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "more"), style: .done, target: self, action: #selector(self.EditBtnClicked(_:)))
        if self.ownerId! == UserDefaults.standard.value(forKey: "id") as? Int{
        self.navigationItem.rightBarButtonItem = menuBtn
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hexString: "#FF6B00")
        }
        
        ////////
        self.calendarImg.image = self.calendarImg.image?.withRenderingMode(.alwaysTemplate)
        self.calendarImg.tintColor = UIColor(hexString: "#FF6B00")
        if Utilities.isGuest(){
            self.userFavourite.isHidden = true
            self.jobFavourite.isHidden = true
            self.applyBtnHeight.constant = 0
            self.inviteBtnHeight.constant = 0
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.loadJobDetail()
    }
    //MARK: - SET GUTTER MENU
    @objc func EditBtnClicked(_ sender: UIBarButtonItem)
    {
        guttermenu.removeAll()
        if self.job.appliedCount > 0{
        let model = GutterMenuModel()
        model.label = "View Applicants"
        model.name = "view_applicants"
        model.urlParams["id"] = self.jobId as AnyObject
        guttermenu.append(model)
        }
        let model1 = GutterMenuModel()
        model1.label = "View Invites"
        model1.name = "view_invites"
        model1.urlParams["id"] = self.jobId as AnyObject
        model1.urlParams["invite_id"] = self.job.inviteId! as AnyObject
        guttermenu.append(model1)
        if self.job.canEdit{
            let model2 = GutterMenuModel()
            model2.label = "Edit Job"
            model2.name = "edit"
            model2.urlParams["id"] = self.jobId as AnyObject
            guttermenu.append(model2)
            
        }
        if self.job!.jobStatus == "Closed"{
        let model3 = GutterMenuModel()
        model3.label = "Open Job"
        model3.name = "open"
        model3.urlParams["id"] = self.jobId as AnyObject
        model3.url =  "/jobs/close/?id=\(self.jobId!)"
        guttermenu.append(model3)
        }else{
            let model3 = GutterMenuModel()
            model3.label = "Close Job"
            model3.name = "close"
            model3.urlParams["id"] = self.jobId as AnyObject
            model3.url =  "/jobs/close/?id=\(self.jobId!)"
            guttermenu.append(model3)
        }
        if self.job.canEdit{
            let model4 = GutterMenuModel()
            model4.label = "Delete Job"
            model4.name = "delete"
            model4.urlParams["id"] = self.jobId as AnyObject
            model4.url = "/jobs/delete/?id=\(self.jobId!)"
            guttermenu.append(model4)
        }
        
         guttCon.setGutterMenu(menu: guttermenu, con: self, index: self.indexPath.row, type: pluginType.jobs, senderr: sender, view: self.view, btnTyp: "barBtn")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - SHOW USER SKILLS
    @IBAction func ShowUserSkill(_ sender: UIButton)
    {
        let job = self.job!
        vc.skillArr = job.categories
        if job.categories.count > 0{
            let statVal: Double = 80
            let height = CGFloat((statVal * ceil((Double(job.categories.count) / 2))))
            let skillMid = (height + 40) * 0.5
            vc.view.frame = CGRect(x: 0, y: self.view.frame.midY - (skillMid), width: (self.view.frame.width ), height: height + 40)
            vc.skillCl.reloadData()
            vc.removeBtn.addTarget(self, action: #selector(self.Remove(_:)), for: .touchUpInside)
            self.view.addSubview(vc.view)
            vc.view.center = self.view.center
        }
    }
    @objc func Remove(_ sender: UIButton)
    {
        vc.view.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - LOAD JOB DETAIL
    func loadJobDetail()
    {
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        var params = Dictionary<String,AnyObject>()
        params["id"] = jobId as AnyObject
        ALFWebService.sharedInstance.doGetData(parameters: params, method: "/jobs/view", success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    if let jobs   = body!["response"] as? Dictionary<String,AnyObject>
                    {
                        self.job = JobsModel.init(fromDictionary: jobs)
                        let id = self.job?.ownerId
                        if id == UserDefaults.standard.value(forKey: "id") as? Int
                        {
                            self.userFavourite.isHidden = true
                            self.jobFavourite.isHidden = true
                        }else
                        {
                            if (self.job?.isFavorite)!
                            {
                                let img = #imageLiteral(resourceName: "star")
                                let statustintedImage = img.withRenderingMode(.alwaysTemplate)
                                self.self.jobFavourite.setImage(statustintedImage, for: .normal)
                                self.self.jobFavourite.tintColor = UIColor(hexString: "#FF6B00")
                                
                            }else{
                                let img = #imageLiteral(resourceName: "star")
                                let statustintedImage = img.withRenderingMode(.alwaysTemplate)
                                
                                self.jobFavourite.setImage(statustintedImage, for: .normal)
                                self.self.jobFavourite.tintColor = UIColor.lightGray
                            }
                            if (self.job?.userFavorite)!
                            {
                                let img = #imageLiteral(resourceName: "star")
                                let statustintedImage = img.withRenderingMode(.alwaysTemplate)
                                self.userFavourite.setImage(statustintedImage, for: .normal)
                            
                                self.userFavourite.tintColor = UIColor(hexString: "#FF6B00")
                            }else{
                                let img = #imageLiteral(resourceName: "star")
                                let statustintedImage = img.withRenderingMode(.alwaysTemplate)
                                self.userFavourite.setImage(statustintedImage, for: .normal)
                                self.userFavourite.tintColor = UIColor.lightGray
                            }
                        }
                        if self.job.image != ""{
                        self.img.sd_setImage(with: URL(string: self.job.image))
                        }
                        self.jobPosted.text = String(describing: self.job!.postedJobs!)
                        self.hired.text = String(describing: self.job!.hiredJobs!)
                        if self.job.runningJobs != nil {
                            self.billed.text = "\(self.job!.runningJobs!)"
                        }
                        if self.job!.avgRating != nil{
                        self.reviews.text = String(describing: self.job!.avgRating!)
                        }
                        self.jobReviews.text = "\( self.job!.reviewCount!) Reviews"
                        self.price.text = "$\(self.job!.price!)"
                        self.applied.text = String(describing: self.job!.appliedCount!)
                        if self.job!.interviewCount != nil{
                        self.avgBid.text = String(describing: self.job!.interviewCount!)
                        }
                        self.invited.text = String(describing: self.job!.inviteCount!)
                        self.status.text = self.job!.jobStatus
                        self.userName.text = self.job?.ownerTitle
                        if self.job?.location != nil{
                            if self.job!.canApply{
                            self.location.text = self.job.location ?? ""
                            }else {
                               self.location.text = self.job?.location
                            }
                        }else
                        {
                            if self.job.location != nil{
                            self.location.text = self.job?.location ?? ""
                            }
                        }
                        self.jobTitle.text = self.job?.title
                        self.jobDetail.text = self.job?.body
                        self.jobType.text = self.job?.jobTypeLabel
                        let dur = self.job?.duration!
                        let durLbl = self.job?.jobDurationLabel!
                        self.duration.text = "\(String(describing: dur!)) \(String(describing: durLbl!))"
                        self.setImage()
                        if self.job!.hiredId != 0{
                            if self.job!.hiredId == UserDefaults.standard.value(forKey: "id") as? Int{
                                if self.job!.locationParams != nil{
                                self.ShowLocationOnMap(dest: self.job!.locationParams)
                                }
                                self.bottomView.isHidden = true
                                
                            }
                        }else{
                        self.SetMapView()
                        }
                        //-----------------
                        if UserDefaults.standard.value(forKey: "id") as? Int == self.job!.ownerId{
                            if self.job!.canEnd{
                                self.applyBtn.setTitle("END JOB", for: .normal)
                                self.applyBtnHeight.constant = 50
                                self.applyBtn.isEnabled = true
                                self.applyBtn.isHidden = false
                            }
                        }else{
                            if self.job!.canEnd && self.job.isHired{
                                self.inviteBtnHeight.constant = 0
                                self.inviteBtn.isHidden = true
                                self.applyBtnHeight.constant = 50
                                self.applyBtn.isHidden = false
                                self.applyBtn.setTitle("END JOB", for: .normal)
                                
                                
                            }
                        }
                        
                        if self.job.jobStatus == "Completed"{
                            self.applyBtn.isHidden = true
                            self.applyBtnHeight.constant = 0
                            self.inviteBtnHeight.constant = 0
                            self.inviteBtn.isHidden = true
                        }
                        if self.job.jobStatus == "Hired"{
                            self.inviteBtnHeight.constant = 0
                            self.inviteBtn.isHidden = true
                            if self.job.canEnd{
                                self.applyBtnHeight.constant = 50
                                self.applyBtn.setTitle("END JOB", for: .normal)
                                self.applyBtn.isEnabled = true
                            }
                        }
                        
                        
                        if self.job.inviteId != 0{
                            if self.job.inviteStatus == "pending"{
                                if !self.job.isHired{
                                    self.applyBtnHeight.constant = 0
                                    self.applyBtn.isHidden = true
                                    self.inviteBtnHeight.constant = 50
                                    self.inviteBtn.isHidden = false
                                }else
                                {
                                    self.applyBtnHeight.constant = 50
                                    self.applyBtn.isHidden = false
                                    self.inviteBtnHeight.constant = 0
                                    self.inviteBtn.isHidden = true
                                }
                                
                            }else if self.job.inviteStatus == "accepted" && !self.job.isHired{
                                self.inviteBtnHeight.constant = 0
                                self.inviteBtn.isHidden = true
                                self.applyBtnHeight.constant = 50
                                self.applyBtn.isHidden = false
                                self.applyBtn.setTitle("ACCEPTED AND CHAT NOW", for: .normal)
                            }else if self.job.inviteStatus == "declined"{
                                self.applyBtn.isHidden = false
                                self.applyBtnHeight.constant = 50
                                self.inviteBtnHeight.constant = 0
                                self.inviteBtn.isHidden = true
                                self.applyBtn.setTitle("DECLINED", for: .normal)
                                self.applyBtn.isEnabled = false
                            }
//                            else{
//                                self.inviteBtnHeight.constant = 0
//                                self.inviteBtn.isHidden = true
//                                self.applyBtnHeight.constant = 50
//                                self.applyBtn.setTitle(self.job.inviteStatus.uppercased(), for: .normal)
//                                self.applyBtn.isEnabled = false
//                            }
                        }
                        if UserDefaults.standard.value(forKey: "id") as? Int == self.job!.ownerId{
                            self.inviteBtnHeight.constant = 0
                            self.inviteBtn.isHidden = true
                        }
                        if self.job.canFeedback && !self.job.canEnd{
                            self.applyBtn.setTitle("END JOB", for: .normal)
                            self.applyBtn.isEnabled = true
                            self.inviteBtnHeight.constant = 0
                            self.inviteBtn.isHidden = true
                        }
//                        if !self.job.canFeedback && !self.job.canEnd{
//                            self.inviteBtnHeight.constant = 0
//                            self.inviteBtn.isHidden = true
//                        }
                        if self.job.canApply{
                            if self.job.inviteId == 0 && UserDefaults.standard.value(forKey: "id") as? Int != self.job!.ownerId{
                           self.applyBtn.setTitle("APPLY NOW", for: .normal)
                            self.applyBtn.isHidden = false
                            self.applyBtnHeight.constant = 50
                            }
                        }
                        if let id = UserDefaults.standard.value(forKey: "level_id") as? Int{
                            if id == 7 || id == 8{
                                self.applyBtnHeight.constant = 0
                                self.applyBtn.isHidden = true
                            }
                        }
                        if self.job!.categories.count > 0{
                            self.skill.text = self.job?.categories[0].categoryName
                            let url = self.job?.categories[0].thumbIcon
                            if url != ""{
                            let dat = NSData(contentsOf: URL(string: url!)!)
                            let img = UIImage(data: dat! as Data)
                            let statustintedImage = img?.withRenderingMode(.alwaysTemplate)
                            self.skillImg.image = statustintedImage
                            self.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                            }
                            if (self.job?.categories.count)! > 1{
                                self.skillCount.text = "+\((self.job?.categories.count)! - 1)"
                            }
                            
                        }
                        if self.job!.endDate != nil{
                        let dat = Utilities.dateFromString(self.job!.endDate)
                        let datStr = Utilities.stringFromDateWithFormat(dat as Date, format: "MMM dd yyyy")
                       self.jobTeam.text = datStr
                        }
                       let usr = String(format: "%.1f", self.job.ownerFeedback!)
                        if usr != "0.0"{
                       self.clientReview.text = usr
                        }else{
                           self.clientReview.text = "0"
                        }
                        let own = String(format: "%.1f", self.job.userFeedback!)
                        if own != "0.0"{
                       self.contractReview.text = own
                        }else{
                            self.contractReview.text = "0"
                        }
                        if self.clientReview.text! == "0"{
                            self.reviewView.arrangedSubviews[0].isUserInteractionEnabled = false
                        }
                        if self.contractReview.text! == "0"{
                            self.reviewView.arrangedSubviews[1].isUserInteractionEnabled = false
                        }
                        if self.contractReview.text! == "0" && self.clientReview.text! == "0"{
                            self.reviewViewHeight.constant = 0
                        }else{
                            self.reviewView.isHidden = false
                            self.reviewViewHeight.constant = 60
                        }
                        if self.job.jobDurationLabel! == ""{
                            self.duration.text = "Not Applicable"
                        }else{
                            self.duration.text = "\(self.job.jobDurationLabel! ?? "Not Applicable")"
                        }
                        if Utilities.isGuest(){
                            self.userFavourite.isHidden = true
                            self.jobFavourite.isHidden = true
                            self.applyBtnHeight.constant = 0
                            self.inviteBtnHeight.constant = 0
                        }
                    }
                    
                }else if status_code == 401{
                    self.navigationController?.popViewController(animated: true)
                    Utilities.showAlertWithTitle(title: "Your skills don't match the job skills", withMessage: "", withNavigation: self)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    func setImage()
    {
        if self.job?.photos.count == 0
        {
            self.jobImgHeight.constant = 0
        }else
        {
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            self.jobImgHeight.constant = screenHeight / 3
             var pathArray = [String]()
            for pic in (self.job?.photos)!{
                pathArray.append(pic.image)
            }
            var titleArray = [String]()
//            titleArray = ["picture 1","picture 2","picture 3","picture 4","picture 5"]
            carouselView.delegate = self
            carouselView.setCarouselData(paths: pathArray,  describedTitle: titleArray, isAutoScroll: true, timer: 5.0, defaultImage: "background")
            //optional methods
            carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
            carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
            carouselView.layoutSubviews()
        }
    }
    func downloadImages(_ url: String, _ index:Int) {
        
        let imageView = UIImageView()
//        imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
//            self.carouselView.images[index] = downloadImage
//        })
    }
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    //MARK: - SET MAP
    func SetMapView()
    {
        if self.job.locationParams != nil{
            mapView.mapType = MKMapType.standard
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.job.locationParams.latitude),longitude: CLLocationDegrees(self.job.locationParams.longitude))
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = self.job.locationParams.location
            annotation.subtitle = self.job.locationParams.formattedAddress
            //        annotation.
//            mapView.addAnnotation(annotation)
            
            let circlLoc = CLLocation(latitude:  CLLocationDegrees(self.job.locationParams.latitude), longitude:
                 CLLocationDegrees(self.job.locationParams.longitude))
            
            addRadiusCircle(location: circlLoc)
            
        }
        
    }
    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        let cord =  CLLocationCoordinate2DMake(CLLocationDegrees(self.job.locationParams.latitude), CLLocationDegrees(self.job.locationParams.longitude))
        let circle = MKCircle.init(center: cord, radius: 1000 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            var circle = MKCircleRenderer(overlay: overlay)
            return circle
        }
    }

    @IBAction func onclickUserFav(_ sender: Any)
    {
        dic["user_id"] = self.job?.ownerId as AnyObject
            method = "/members/favorite"
        postFavourite(method: method)
    }
    @IBAction func onclickJobFav(_ sender: Any)
    {
        dic["id"] = self.job?.listingId as AnyObject
            method = "/jobs/favorite"
        postFavourite(method: method)
    }
    
    func postFavourite(method: String)
    {
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: self.dic, method: method, success: { (response) in
            
            print(response)
            let status = response["status_code"] as? Int
            if status == 204
            {
                self.loadJobDetail()
                Utilities.showAlertWithTitle(title: "Success", withMessage: "Success", withNavigation: self)
                return
            }else
            {
                
                Utilities.showAlertWithTitle(title: "Alert", withMessage: response["message"] as! String, withNavigation: self)
                return
            }
            
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    @IBAction func ApplyForJob(_ sender: UIButton)
    {
        if sender.titleLabel?.text == "END JOB" || sender.titleLabel?.text == "GIVE FEEDBACK"
        {
             let con = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .addFeedbackVC) as! AddFeedbackVC
            con.dic["listing_id"] = self.job.listingId as AnyObject
            con.dic["hire_id"] = self.job.hireId as AnyObject
            con.image = self.job.image
            con.nametxt = self.job.ownerTitle
            con.userId = self.job.ownerId
            self.navigationController?.pushViewController(con, animated: true)
        }else if sender.titleLabel?.text == "ACCEPTED AND CHAT NOW"{
            let user = UsersModel()
            user.id = String(describing: self.job!.ownerId)
            user.label = self.job!.ownerTitle
            let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .composeMessageVC) as! ComposeMessageVC
            vc.selectedUsers.append(user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
        let con = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .applyJobVC) as! ApplyJobVC
        con.id = self.jobId
        con.name = self.userName.text!
        con.img = self.userImg
        self.navigationController?.pushViewController(con, animated: true)
        }
        
    }
    @IBAction func AcceptJob(_ sender: UIButton)
    {
        var params = Dictionary<String,AnyObject>()
        params["status"] = "accepted" as AnyObject
        params["id"] = self.job.inviteId! as AnyObject
        PerformInvitationAction(params: params)
    }
    @IBAction func DeclineJob(_ sender: UIButton)
    {
        var params = Dictionary<String,AnyObject>()
        params["status"] = "declined" as AnyObject
        params["id"] = self.job.inviteId! as AnyObject
        PerformInvitationAction(params: params)
    }
    
    func PerformInvitationAction(params: Dictionary<String,AnyObject>)
    {
        let url = "/jobs/invitestatus"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: params, method: url, success: { (response) in
            print(response)
            let status = response["status_code"] as? Int
            if status == 204
            {
               self.inviteBtnHeight.constant = 0
                self.applyBtnHeight.constant = 50
                self.applyBtn.isHidden = false
                self.applyBtn.isEnabled = false
                if params["status"] as! String == "accepted"
                {
                    self.applyBtn.isEnabled = true
                    self.applyBtn.setTitle("ACCEPTED AND CHAT NOW", for: .normal)
                }else{
                    self.applyBtn.setTitle("Declined", for: .normal)
                }
            }else
            {
                
//                Utilities.showAlertWithTitle(title: "Alert", withMessage: response["message"] as! String, withNavigation: self)
//                return
            }
            
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    @IBAction func ReviewPressed(_ sender: UIButton)
    {
        let con = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .feedbackDetail) as! FeedbackDetail
        con.dic["id"] = self.job.listingId as AnyObject
        if sender.titleLabel?.text == "Client's Review"
        {
            
            if self.job.ownerFeedback! > 0.0{
                con.dic["owner"] = "1" as AnyObject
                self.navigationController?.pushViewController(con, animated: true)
            }
        }else if sender.titleLabel?.text == "Contractor's Review"{
            if self.job.userFeedback! > 0.0{
                 con.dic["owner"] = "0" as AnyObject
                self.navigationController?.pushViewController(con, animated: true)
            }
        }
    }
    //Mark: - SHOW LOCATION ON MAP
    func ShowLocationOnMap(dest: LocationParam)
    {
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(dest.latitude),longitude: CLLocationDegrees(dest.longitude))
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = dest.formattedAddress
        self.mapView.addAnnotation(annotation)
    }
    
    //MARK: - PROFILE btn
    @IBAction func ProfileBtnPressed(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = self.ownerId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ReviewListPress(_ sender: UIButton)
    {
        let con = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .feedbackVC)
        self.navigationController?.pushViewController(con, animated: true)
    }
    
}
