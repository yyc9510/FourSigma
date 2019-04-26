//
//  SolarCollectionViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 12/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class SolarCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchControllerDelegate{
    
    let solarCollection = [UIImage(named: "knowyourarea.png"), UIImage(named: "roicalculator.png"), UIImage(named: "solarpedia")]
    let segueLocation = ["knowyourarea", "roicalculator", "solarpedia"]

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return solarCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SolarCollectionViewCell
        
        cell.image.image = solarCollection[indexPath.row]
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
