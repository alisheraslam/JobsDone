
//
//  FeedbackDetail.swift
//  JobsDone
//
//  Created by musharraf on 05/06/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
import Cosmos

class FeedbackDetail: UIViewController {
    @IBOutlet weak var img: WAImageView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reviewImg: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var jobPosted: UILabel!
    @IBOutlet weak var hired: UILabel!
    @IBOutlet weak var billed: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var skillView: CosmosView!
    @IBOutlet weak var availView: CosmosView!
    @IBOutlet weak var coopView: CosmosView!
    @IBOutlet weak var finishView: CosmosView!
    @IBOutlet weak var deadView: CosmosView!
    @IBOutlet weak var avgLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var reviewByLbl: UILabel!
    @IBOutlet weak var jobFavourite: UIButton!
    @IBOutlet weak var skillLbl: UILabel!
    @IBOutlet weak var availLbl: UILabel!
    @IBOutlet weak var proLbl: UILabel!
    @IBOutlet weak var finishLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    var feedback: FeedbackModel!
    var userId: Int!
    var dic =  Dictionary<String,AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "REVIEW DETAIL"
        let imgSt = #imageLiteral(resourceName: "star")
        let statustintedImage = imgSt.withRenderingMode(.alwaysTemplate)
        self.reviewImg.image = statustintedImage
        self.reviewImg.tintColor = UIColor(hexString: "#FF6B00")
        self.skillView.isUserInteractionEnabled = false
        self.availView.isUserInteractionEnabled = false
        self.coopView.isUserInteractionEnabled = false
        self.finishView.isUserInteractionEnabled = false
        self.deadView.isUserInteractionEnabled = false
        LoadDetail()
        if Utilities.isGuest(){
            self.jobFavourite.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - USER DETAIL
    
    func LoadDetail()
    {
        let method = "/jobs/feedbackdetail"
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doGetData(parameters: self.dic, method: method, success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            if let status_code = response["status_code"] as? Int{
                if status_code ==  200{
                    let body = response["body"] as? Dictionary<String,AnyObject>
                    if let port = body!["response"] as? Dictionary<String,AnyObject>
                    {
                        let model = FeedbackModel.init(fromDictionary: port)
                        self.feedback = model
                        self.skillView.rating = Double(model.avgRating)
                        self.availView.rating = Double(model.availability)
                        self.coopView.rating = Double(model.cooperative)
                        self.finishView.rating = Double(model.finishing)
                        self.deadView.rating = Double(model.deadline)
                        self.avgLbl.text = "\(model.avgRating!)"
                        self.detailLbl.text = "\(model.comments!)"
                        self.name.text = model.ownerTitle
                        self.heading.text = "FOR \(model.ownerTitle!)"
                        self.location.text = model.location ?? ""
                        self.jobPosted.text = "\(model.postedJobs!)"
                        self.hired.text = "\(model.hiredJobs!)"
                        if model.totalBilled != nil{
                        self.billed.text = String(describing: model.runningJobs!)
                        }
                        self.rating.text = "\(model.userRating!)"
                        self.reviews.text = "\(model.reviewCount!) Reviews"
                        self.img.sd_setImage(with: URL(string: model.image))
                        self.reviewByLbl.text = model.feedbackBy!
                        self.skillLbl.text = String(describing: model.skills!)
                        self.availLbl.text = String(describing: model.availability!)
                        self.proLbl.text = String(describing: model.cooperative!)
                        self.finishLbl.text = String(describing: model.finishing!)
                        self.timeLbl.text = String(describing: model.deadline!)
                    }
                }
            }
        }){ (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
            
        }

    }
    
    @IBAction func PostFavourite()
    {
        var param = Dictionary<String,AnyObject>()
        param["user_id"] = self.feedback.feedbackTo as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostData(parameters: param, method: "/members/favorite", success: { (response) in
            
            print(response)
            let status = response["status_code"] as? Int
            if status == 204
            {
                self.feedback.isFavorite = !(self.feedback.isFavorite)
                if (self.feedback.isFavorite)!
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
            }
            
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
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
