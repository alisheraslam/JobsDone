//
//  MainProfileVC.swift
//  JobsDone
//
//  Created by musharraf on 17/05/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import ActiveLabel

class MainProfileVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MKMapViewDelegate {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userImg: WAImageView!
    @IBOutlet weak var starImg: UIImageView!
    @IBOutlet weak var skillLbl: UILabel!
    @IBOutlet weak var jobsLbl: UILabel!
    @IBOutlet weak var earnedLbl: UILabel!
    @IBOutlet weak var portLbl: UILabel!
    @IBOutlet weak var reviewsLbl: UILabel!
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var clView: UICollectionView!
    @IBOutlet weak var chatView: NSLayoutConstraint!
    @IBOutlet weak var skillViewHeight: NSLayoutConstraint!
    @IBOutlet weak var skillLblHeight: NSLayoutConstraint!
    @IBOutlet weak var inviteBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var skillView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var onlineImg: UIImageView!
    @IBOutlet weak var driveImg: UIImageView!
    @IBOutlet weak var walkImg: UIImageView!
    @IBOutlet weak var walkLbl: UILabel!
    @IBOutlet weak var driveLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var botmView: UIView!
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var detailHeading: UILabel!
    @IBOutlet weak var topMenu: UIStackView!
    @IBOutlet weak var viewMoreBtn: UIButton!
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    @IBOutlet weak var companylinkBtn: UIButton!
    @IBOutlet weak var hourlyRate: UILabel!
    @IBOutlet weak var crownImg: UIImageView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var jobsLblHeading: UILabel!
    @IBOutlet weak var hourlyHeading: UILabel!
    @IBOutlet weak var portfolioHeading: UILabel!
    @IBOutlet weak var headingView: UIView!
    
    var skillArr = [SkillModel]()
    var skillsCount = 0
    var id :Int!
    var isFav = false
    var img = ""
    var rating = ""
    var reviews = ""
    var name = ""
    var url: URL!
    var userPhone: String!
    var website = ""
    var webUrl = ""
    var featured = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clView.delegate = self
        clView.dataSource = self
        chatView.constant = 0
        editProfileBtn.isHidden = true
        userImg.contentMode = .scaleAspectFill
        distanceView.backgroundColor = UIColor.clear
        let editImg = #imageLiteral(resourceName: "pencil")
        let penc = editImg.withRenderingMode(.alwaysTemplate)
        editProfileBtn.setImage(penc, for: .normal)
        editProfileBtn.tintColor = UIColor(hexString: "#FF6B00")
        let crImg = #imageLiteral(resourceName: "crown")
        let crown = crImg.withRenderingMode(.alwaysTemplate)
        crownImg.image = crown
        if featured{
            crownImg.tintColor = UIColor(hexString: "#FF6B00")
        }else{
            crownImg.tintColor = UIColor.lightGray
        }
        self.starImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 25, height: 25))
        if id! != UserDefaults.standard.value(forKey: "id") as? Int{
            chatView.constant = 30
            favBtn.isHidden = false
            editProfileBtn.isHidden = true
            editProfileBtn.isUserInteractionEnabled = false
        }else{
            if let level =  UserDefaults.standard.value(forKey: "level_id") as? Int {
                if level != 8 && level != 7{
                    
                }else{
                    self.mapHeight.constant = 0
                    self.mapView.isHidden = true
                }
            }
            
            topMenu.isHidden = true
            inviteBtnHeight.constant = 0
            submitBtn.isHidden = true
            favBtn.isHidden = true
            skillViewHeight.constant = 60
            skillLblHeight.constant = 30
            editProfileBtn.isHidden = false
        }
        
       let img = #imageLiteral(resourceName: "back_white")
        let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(self.PopSelf(_:)))
        self.navigationItem.leftBarButtonItem = btn
        self.mapView.delegate = self
        mapView.isZoomEnabled = true
        self.driveImg.image = UIImage.fontAwesomeIcon(name: .car, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 15, height: 15))
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        clView.collectionViewLayout = layout
        if Utilities.isGuest(){
            inviteBtnHeight.constant = 0
            submitBtn.isHidden = true
            favBtn.isHidden = true
            topMenu.isHidden = true
        }
        LoadProfile()
        // Do any additional setup after loading the view.
    }
    @objc func PopSelf(_ sener: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GoToEditProfile(_ sender: UIButton)
    {
         let vc = UIStoryboard.storyBoard(withName: .Setting ).loadViewController(withIdentifier: .settingRGTab) as! SettingRGTab
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //website link
    @IBAction func WebSiteLinkPressed(_ sender: UIButton) {
        
        let con = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .privacyVC) as! PrivacyPolicyController
        con.pageTypes = .website
        con.url = self.webUrl
        con.navTitle(titel: self.website)
        if (website != ""  && website != nil) && (webUrl != nil && webUrl != ""){
        self.navigationController?.pushViewController(con, animated: true)
        }else{
             Utilities.showAlertWithTitle(title: "Business Website not is not Available", withMessage: "", withNavigation: self)
        }
    }
    //MARK: - MAKE CALL

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:-  COLLECITONVIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skillArr.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let str = skillArr[indexPath.row].category_name
        var w = str.width(withConstraintedHeight: 60, font: UIFont.systemFont(ofSize: 15.0))
        w = w + 60
        return CGSize(width: w , height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clView.dequeueReusableCell(withReuseIdentifier: "mainSkillsCell", for: indexPath) as! SkillsCell
        let obj = skillArr[indexPath.row]
        cell.imgSkill.sd_setImage(with: URL(string: obj.thumb_icon), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
            // Perform your operations here.
            cell.imgSkill.image = cell.imgSkill.image?.withRenderingMode(.alwaysTemplate)
            cell.imgSkill.tintColor = UIColor(hexString: "#FF6B00")
        }
        cell.name.text = obj.category_name
        cell.cellView.layer.cornerRadius = 15
        cell.cellView.dropShadow(color:UIColor.lightGray, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
        return cell
    }
    
    //MARK:- LOAD PROFILE
    func LoadProfile()
    {
        let method = "user/profile/\(id!)"
        let params = Dictionary<String,AnyObject>()
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: params, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            if let status_code = response["status_code"] as? Int{
                if status_code == 200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                   
                    if let responseObj   = body!["response"] as? Dictionary<String,AnyObject>
                    {
                        if let nameStr = responseObj["displayname"] as? String
                        {
                            self.nameLbl.text = nameStr
                            
                        }
                        if let levelId = responseObj["level_id"] as? Int{
                            if levelId == 7 || levelId == 8{
                                self.jobsLblHeading.text = "Posted Jobs"
                                self.hourlyHeading.text = "Total Billed"
                                self.portfolioHeading.text = "Hired Jobs"
                                self.skillLblHeight.constant = 0
                                self.skillViewHeight.constant = 0
                                self.skillView.isHidden = true
                                self.headingView.backgroundColor = UIColor.clear
                                if let posted = responseObj["posted_jobs"] as? Int{
                                    self.jobsLbl.text = "\(posted)"
                                }
                                if let spent = responseObj["total_billed"] as? Int{
                                    self.hourlyRate.text = "$\(spent)"
                                }
                                if let hiring = responseObj["hired_jobs"] as? Int{
                                    self.portLbl.text = "\(hiring)"
                                }
                            }else{
                                if let rate = responseObj["hourly_rate"] as? Float{
                                    self.hourlyRate.text = "$\(Int(rate))"
                                }
                                if let jobCount = responseObj["job_count"] as? Int
                                {
                                    self.jobsLbl.text = "\(jobCount)"
                                }
                                if let port = responseObj["portfolio_count"] as? Int
                                {
                                    if port == 0{
                                        self.firstStackView.arrangedSubviews[2].isHidden = true
                                        self.stackView.arrangedSubviews[2].isHidden = true
                                    }else{
                                        self.portLbl.text = "\(port)"
                                    }
                                }
                            }
                        }
                        
                        
                        if let level_id = responseObj["level_id"] as? Int{
                            if level_id == 7{
                                self.mapView.isHidden = true
                            }
                        }
                        if let phone = responseObj["phone"] as? Int{
                            
                            
                            let s = self.formattedNumber(number: String(describing: phone))
                            self.userPhone = s
                            self.numberLbl.text = String(describing: s)
                            
                        }else if let phone = responseObj["phone"] as? String{
                            let numWithoutdot = phone.replacingOccurrences(of: ".", with: "")
                            let s = self.formattedNumber(number: String(describing: numWithoutdot))
                            self.userPhone = s
                            self.numberLbl.text = String(describing: s)
                            self.companylinkBtn.isHidden = true
                        }
                        if let username = responseObj["businessname"] as? String{
                            if self.numberLbl.text == ""{
                                self.numberLbl.text = "\(username)"
                                self.companylinkBtn.isHidden = false
                            }else{
                                if username != ""{
                                    let name = "<u>\(username)</u>"
                                    let atStr = "\(self.numberLbl.text!) . \(name)"
                            self.numberLbl.attributedText = Utilities.stringFromHtml(string: atStr)
                                    self.companylinkBtn.isHidden = false
                                }
                            }
                        }
                        
                        if let website = responseObj["website"] as? String{
                            self.website = website
                        }
                        if let webUrl = responseObj["website_url"] as? String{
                           self.webUrl = webUrl
                        }
                        
                        if let review = responseObj["review_count"] as? String
                        {
                            self.reviewsLbl.text = review
                            self.reviews = review
                        }
                        if let google = responseObj["google_rating"] as? Int
                        {
                            if google == 0{
                            self.firstStackView.arrangedSubviews[5].isHidden = true
                                self.stackView.arrangedSubviews[5].isHidden = true
            
                            }else{
                            self.ratingLbl.text = String(describing: google)
                            }
                        }
                        self.firstStackView.arrangedSubviews[1].isHidden = true
                        self.stackView.arrangedSubviews[1].isHidden = true
                        if let fav = responseObj["is_favorite"] as? Bool
                        {
                            if fav || self.id == UserDefaults.standard.value(forKey: "id") as? Int {
                        self.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 25, height: 25)), for: .normal)
                            }
                        }
                        if let about = responseObj["description"] as? String
                        {
                            let atrSt = Utilities.stringFromHtml(string: about)
                            let str = atrSt?.string.replacingOccurrences(of: "<[^>]+\n>", with: "", options: .regularExpression, range: nil)
                            self.detailLbl.text = str?.replacingOccurrences(of: "\n", with: "")
                            let lines = self.detailLbl.numberOfVisibleLines
                            if lines > 3{
                                self.viewMoreBtn.isHidden = false
                                self.detailLbl.numberOfLines = 3
                            }else{
                                self.viewMoreBtn.isHidden = true
                            }
                            if self.detailLbl.text == ""{
                                self.botmView.backgroundColor = UIColor.clear
                                self.detailHeading.text = ""
                            }
                        }else{
                            self.botmView.backgroundColor = UIColor.clear
                            self.detailHeading.text = ""
                            self.viewMoreBtn.isHidden = true
                        }
                        if let img = responseObj["image"] as? String
                        {
                            self.url = URL(string: img)
                            self.userImg.sd_setImage(with: URL(string: img))
                            self.img = img
                        }

                        if let skills = responseObj["skills"] as? [Dictionary<String,AnyObject>]{
                            for skill in skills
                            {
                                let objModel = SkillModel.init(skill)
                                self.skillArr.append(objModel)
                            }
                        }
                        if let avg = responseObj["avg_rating"] as? Float{
                            self.reviewsLbl.text = String(describing: avg)
                        }
                        if let avg = responseObj["review_count"] as? Int{
                            self.reviewsCount.text = "\(avg) Reviews"
                        }
                        if let isOnline = responseObj["is_online"] as? Bool{
                            self.onlineImg.image = self.onlineImg.image?.withRenderingMode(.alwaysTemplate)
                            if isOnline || Utilities.isSelfUser(userID: self.id){
                                self.onlineImg.tintColor = UIColor(hexString: "#29CD42")
                            }else{
                                self.onlineImg.tintColor = UIColor(hexString: "#919191")
                            }
                        }
                        if let loc = responseObj["locationParams"] as? Dictionary<String,AnyObject>{
                            let dest = LocationParam.init(fromDictionary: loc)
                            self.locationLbl.text = dest.city
                            if let decode =  UserDefaults.standard.object(forKey: "locationParams") as? Data{
                                let myLocation = NSKeyedUnarchiver.unarchiveObject(with: decode) as! LocationParam
                            let start = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(myLocation.latitude), longitude: CLLocationDegrees(myLocation.longitude))
                            let end = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(dest.latitude), longitude: CLLocationDegrees(dest.longitude))
                            if self.id != UserDefaults.standard.value(forKey: "id") as? Int{
                            self.showRouteOnMap(pickupCoordinate: start, destinationCoordinate: end)
                            }else{
                                
//                                if UserDefaults.standard.object(forKey: "level_id") as? Int == 7{
                                    self.ShowLocationOnMap(dest: dest)
//                                }
                            }
                            }else{
//                                if UserDefaults.standard.object(forKey: "level_id") as? Int == 7{
                                    self.ShowLocationOnMap(dest: dest)
                                    self.walkImg.isHidden = true
                                    self.driveImg.isHidden = true
//                                }
                            }
                        }else{
                            self.walkImg.isHidden = true
                            self.driveImg.isHidden = true
                            
                        }
                         self.skillsCount = self.skillArr.count
                        self.skillLbl.text = "\(self.skillsCount)"
                    }
                    if self.mapView.isHidden{
                        self.mapHeight.constant = 20
                    }
                    self.clView.reloadData()
                }else{
                    let mxg = response["message"] as? String
                    let refreshAlert = UIAlertController(title: "", message: mxg, preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                    }))
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
        }
    }
    
    @IBAction func ShowMore(_ sender: UIButton)
    {
        if self.detailLbl.numberOfVisibleLines > 3{
            self.detailLbl.numberOfLines = 3
            self.viewMoreBtn.setTitle("View More", for: .normal)
        }else{
            self.detailLbl.numberOfLines = 0
            self.viewMoreBtn.setTitle("View less", for: .normal)
        }
    }
    
    @IBAction func ReviewList(_ sender: UIButton)
    {
        let con = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .feedbackVC) as! FeedbackVC
        con.user_id = String(describing: self.id!)
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    @IBAction func JobBtnPressed(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .MyJob).loadViewController(withIdentifier: .jobHistoryVC) as! JobHistoryVC
        vc.userId = self.id
        vc.reviews = self.reviewsCount.text!
        vc.rating = self.self.reviewsLbl.text!
        vc.img = self.img
        vc.name = self.nameLbl.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func EarnJobBtnPressed(_ sender: UIButton)
    {
        
    }
    //MARK: - CALL BTN PRESSED
    @IBAction func AudioCallBtnPressed(_ sender: UIButton)
    {
        if userPhone != ""{
            userPhone.makeAColl()
        }
    }
    
    @IBAction func ChatBtnPressed(_ sender: UIButton)
    {
        let user = UsersModel()
        user.id = String(describing: self.id!)
        user.label = self.nameLbl!.text!
        let vc = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .composeMessageVC) as! ComposeMessageVC
        vc.selectedUsers.append(user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func PortfolioBtnPressed(_ sender: UIButton)
    {
        
        let vc = UIStoryboard.storyBoard(withName: .Portfolio).loadViewController(withIdentifier: .portfolioVC) as! PortfolioVC
        vc.userId = "\(self.id!)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func FavBtnPressed(_ sender: UIButton)
    {
        var dic = Dictionary<String,AnyObject>()
        dic["user_id"]  = self.id as AnyObject
        let method = "/members/favorite"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: dic, method: method, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
            let status = response["status_code"] as? Int
            if status == 204
            {
                self.isFav = !(self.isFav)
                if self.isFav || self.id == UserDefaults.standard.value(forKey: "id") as? Int {
                    self.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 25, height: 25)), for: .normal)
                }else{
                    self.favBtn.setImage(UIImage.fontAwesomeIcon(name: .star, textColor: UIColor.lightGray, size: CGSize(width: 25, height: 25)), for: .normal)
                }
            }

        }) { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            print(response)
        }
    }
    
    
    //MARK: - ONCLICK INVITETOJOB
    @IBAction func InviteToJobPressed(_ sender: UIButton)
    {
        let vc = UIStoryboard.storyBoard(withName: .Menu).loadViewController(withIdentifier: .sendInvitationVC) as! SendInvitationVC
        vc.user_id = self.id
        vc.image = self.img
        vc.ratingLbl = self.ratingLbl.text!
        vc.reviewsLbl = "\(self.reviewsLbl.text!) Reviews"
        vc.nameLbl = self.nameLbl.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - showRouteOnMap
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            //MARK: - DRIVE TIME AND WALKING TIME
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceAnnotation.coordinate.latitude),\(sourceAnnotation.coordinate.longitude)&destination=\(destinationAnnotation.coordinate.latitude),\(destinationAnnotation.coordinate.longitude)&sensor=false&mode=driving&project=jobsdone-1520334615196"
            URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    print(json)
                    var posts = json["routes"] as? [Dictionary<String,AnyObject>] ?? []
                    if posts.count > 0{
                   let post = posts[0] as? Dictionary<String,AnyObject>
                    if let legs = post!["legs"] as? [Dictionary<String,AnyObject>]{
                        let leg = legs[0] as? Dictionary<String,AnyObject>
                        if let time = leg!["duration"] as? Dictionary<String,AnyObject>{
                            self.driveLbl.text = time["text"] as? String
                        }
                        if let dist = leg!["distance"] as? Dictionary<String,AnyObject>{
                            self.locationLbl.text = "\(self.locationLbl.text!) . \(dist["text"] as! String) away"
                            self.distanceView.backgroundColor = UIColor.white
                        }
                        
                    }
                    }
                    print(posts)
                } catch let error as NSError {
                    print(error)
                }
            }).resume()
            let urlwalk = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceAnnotation.coordinate.latitude),\(sourceAnnotation.coordinate.longitude)&destination=\(destinationAnnotation.coordinate.latitude),\(destinationAnnotation.coordinate.longitude)&sensor=false&mode=walking&project=jobsdone-1520334615196"
            URLSession.shared.dataTask(with: URL(string: urlwalk)!, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    print(json)
                    var posts = json["routes"] as? [Dictionary<String,AnyObject>] ?? []
                    if posts.count > 0{
                    let post = posts[0] as? Dictionary<String,AnyObject>
                    if let legs = post!["legs"] as? [Dictionary<String,AnyObject>]{
                        let leg = legs[0] as? Dictionary<String,AnyObject>
                        if let time = leg!["duration"] as? Dictionary<String,AnyObject>{
                            self.walkLbl.text = time["text"] as? String
                        }
                        
                    }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }).resume()
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    //Mark: - SHOW LOCATION ON MAP
    func ShowLocationOnMap(dest: LocationParam)
    {
        self.walkImg.isHidden = true
        self.driveImg.isHidden = true
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(dest.latitude),longitude: CLLocationDegrees(dest.longitude))
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = dest.location
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(hexString: "#FF6B00")
        renderer.lineWidth = 5.0
        return renderer
    }
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            if annotation.isEqual(mapView.annotations[0]){
                if mapView.annotations.count == 1{
                    if let data = try? Data(contentsOf: self.url!)
                    {
                        let img: UIImage = UIImage(data: data)!
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                        imageView.image = img
                        imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
                        imageView.layer.masksToBounds = true
                        annotationView.addSubview(imageView)
                    }
                }else{
                return nil
                }
            }else{
                if let data = try? Data(contentsOf: self.url!)
                {
                    let img: UIImage = UIImage(data: data)!
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                    imageView.image = img
                    imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
                    imageView.layer.masksToBounds = true
                    annotationView.addSubview(imageView)
//                    annotationView.image = img
                }
            }
        }
        return annotationView
    }
    private func formattedNumber(number: String) -> String {
        var cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var mask = ""
        if number.count == 10{
            mask = "+1.XXX.XXX.XXXX"
        }else{
        mask = "+X.XXX.XXX.XXXX"
        }
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    

}
extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
}

}
extension String {
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeAColl() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}

