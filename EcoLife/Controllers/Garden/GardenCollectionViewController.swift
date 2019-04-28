//
//  GardenCollectionViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 18/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class GardenCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchControllerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let gardenCollection = [UIImage(named: "grow_fruit_collection"), UIImage(named: "compost_quiz")]
    let segueLocation = ["grow_fruit_collection", "compost_quiz"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gardenCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gardenCell", for: indexPath) as! GardenCollectionViewCell
        
        cell.image.image = gardenCollection[indexPath.row]
        cell.image.layer.cornerRadius = 10
        
        // This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 10.0
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let segueIdentifier = segueLocation[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: "")
    }
}
