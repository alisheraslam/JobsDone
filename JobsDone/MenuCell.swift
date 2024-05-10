//
//  MenuCell.swift
//  JobsDone
//
//  Created by musharraf on 22/01/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var iconLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var imgCl: UICollectionView!
    
    var imgArr = [String]()
    var jobCount = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func LoadClView()
    {
        imgCl.delegate = self
        imgCl.dataSource = self
        imgCl.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return CGSize(width: 20, height: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier = "MenuItem"
        if indexPath.item == 3{
            identifier = "TextItem"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MenuItem
        if indexPath.item == 3{
            cell.contentView.backgroundColor = UIColor.darkGray
            cell.contentView.layer.cornerRadius = 10
            if jobCount > 0{
            cell.txt.text = "+\(jobCount - 3)"
            
            }
            return cell
        }
        cell.img.sd_setImage(with: URL(string: imgArr[indexPath.item]))
        cell.img.layer.cornerRadius = 10
        
        return cell
    }

}
