//
//  FindProfessionalTVcell.swift
//  JobsDone
//
//  Created by musharraf on 18/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

protocol clViewDelegates {
    func didPressedUserSkillBtn(tag: Int)
}

class FindProfessionalTVcell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionViewTbl: UICollectionView!
    
    @IBOutlet weak var userimage: WAImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var starImg: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var mxgImg: UIButton!
    @IBOutlet weak var skillImg: UIImageView!
    @IBOutlet weak var skillCount: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var showSkillBtn: UIButton!
    
    var parent: UIViewController!
    var featuredArr = [User]()
    var searching = false
    let vc =  SkillVC(nibName: "SkillVC", bundle: nil)
    var delegate: clViewDelegates!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    func configCell(identifier  : String)
    {
        if identifier == "secondCell"
        {
            collectionViewTbl.delegate = self
            collectionViewTbl.dataSource = self
            DispatchQueue.main.async{
                self.collectionViewTbl.reloadData()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredArr.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let obj = self.featuredArr[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "professionalCell", for: indexPath as IndexPath) as! FindProfessionalCVC
        cell.onlineImg.image = cell.onlineImg.image?.withRenderingMode(.alwaysTemplate)
        if obj.isOnline{
            cell.onlineImg.tintColor = UIColor(hexString: "#29CD42")
        }else{
            cell.onlineImg.tintColor = UIColor(hexString: "#919191")
        }
        cell.cellView.dropShadow(color:UIColor.lightGray , opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
//        cell.profilePic.setImage(images[indexPath.item], for: .normal)
        cell.starsImg.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor(hexString: "#FF6B00"), size: CGSize(width: 20, height: 20))
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.profilePic.contentMode = .scaleAspectFill
        cell.userName.text = obj.displayname
        cell.profilePic.sd_setImage(with: URL(string: obj.image))
        cell.avgRating.text = "\(obj.avgRating!)"
        cell.businessName.text = obj.businessName!
        cell.backBtn.tag = indexPath.row
        cell.backBtn.addTarget(self, action: #selector(self.OnClickBack(_:)), for: .touchUpInside)
//        if searching{
        if obj.location != "<null>" && obj.location != nil{
            cell.distance.text = "\(obj.location!)"
        }else{
            cell.distance.text = ""
        }
        if obj.distance != nil{
            cell.distance.text = "\(cell.distance.text ?? ""). \(obj.distance!)Km away"
        }else{
            cell.distance.text = cell.distance.text
        }
        if obj.hourlyRate != nil{
            cell.hourlyRate.text = "$\(obj.hourlyRate!)"
        }
        // setting skill
        if obj.skills.count > 0{
            let url = obj.skills[0].thumbIcon
            cell.skillLbl.text = obj.skills[0].categoryName
            if url != ""{
                cell.skillImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                    // Perform your operations here.
                    cell.skillImg.image = cell.skillImg.image?.withRenderingMode(.alwaysTemplate)
                    cell.skillImg.tintColor = UIColor(hexString: "#FF6B00")
                }
            }else{
                cell.skillImg.image =  #imageLiteral(resourceName: "setting")
            }
            if (obj.skills.count) > 1{
                cell.skillLbl.text = "\(cell.skillLbl.text!) +\((obj.skills.count) - 1)"
            }else{
                cell.skillLbl.text = cell.skillLbl.text!
            }
        }
        cell.skillBtn.tag = indexPath.row
        cell.skillBtn.addTarget(self, action: #selector(self.ShowUserSkill(_:)), for: .touchUpInside)
//        }else{
//            cell.hourlyRate.text = ""
//            cell.distance.text = ""
//        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 180)
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let obj = self.featuredArr[indexPath.row]
        
            let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
            vc.id = obj.userId
        vc.featured = true
        parent.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func OnClickBack(_ sender: UIButton)
    {
        let obj = self.featuredArr[sender.tag]
        
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .mainProfileVC) as! MainProfileVC
        vc.id = obj.userId
        vc.featured = true
        parent.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - SHOW USER SKILLS
    @objc func ShowUserSkill(_ sender: UIButton)
    {
        let user = self.featuredArr[sender.tag]
        vc.skillArr = user.skills
        if user.skills.count > 0{
            let statVal: Double = 80
            let height = CGFloat((statVal * ceil((Double(user.skills.count) / 2))))
            let skillMid = (height + 40) * 0.5
            vc.view.frame = CGRect(x: 0, y: self.parent.view.frame.midY - (skillMid), width: (self.parent.view.frame.width ), height: height + 40)
            vc.skillCl.reloadData()
            vc.removeBtn.addTarget(self, action: #selector(self.Remove(_:)), for: .touchUpInside)
            self.parent.view.addSubview(vc.view)
            vc.view.center = self.parent.view.center
        }
    }
    @objc func Remove(_ sender: UIButton)
    {
        vc.view.removeFromSuperview()
    }

}
