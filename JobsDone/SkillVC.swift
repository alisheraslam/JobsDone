//
//  SkillVC.swift
//  JobsDone
//
//  Created by musharraf on 08/09/2018.
//  Copyright © 2018 Stars Developer. All rights reserved.
//

import UIKit
private let reuseIdentifier = "SkillPopCell"
class SkillVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var skillCl: UICollectionView!
    @IBOutlet weak var removeBtn: UIButton!
    
    var skillArr = [Category]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SkillPopCell", bundle: nil)
        skillCl?.register(nib, forCellWithReuseIdentifier: "SkillPopCell")
        if let flowlayout = skillCl?.collectionViewLayout as? UICollectionViewFlowLayout{
            flowlayout.estimatedItemSize = CGSize(width: 1, height: 1)
            flowlayout.minimumLineSpacing = 0
            flowlayout.minimumInteritemSpacing = 0
        }
        self.view.layer.borderWidth = 5
        self.view.layer.borderColor = UIColor(hexString: "#FF6B00").cgColor
        self.view.layer.cornerRadius = 5
        removeBtn.addTarget(self, action: #selector(self.Remove(_:)), for: .touchUpInside)
        skillCl.delegate = self
        skillCl.dataSource = self
        skillCl.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skillArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillPopCell", for: indexPath) as! SkillPopCell
        var obj : Category!
        cell.cellView.layer.cornerRadius = 15
        cell.cellView.dropShadow(color:UIColor.lightGray, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
        obj = skillArr[indexPath.row]
        let url =  obj.thumbIcon
        if url != ""{
            cell.imgSkill.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "setting"), options: []) { (image, error, imageCacheType, imageUrl) in
                // Perform your operations here.
                cell.imgSkill.image = cell.imgSkill.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgSkill.tintColor = UIColor(hexString: "#FF6B00")
                
            }
        }
        cell.name.text = obj.categoryName
        return cell
    }
    
    @IBAction func Remove(_ sender: UIButton)
    {
        self.view.removeFromSuperview()
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
