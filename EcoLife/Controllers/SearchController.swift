//
//  SearchController.swift
//  foursigma
//
//  Created by 姚逸晨 on 2/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    @IBOutlet weak var searchLocation: UIImageView!
    @IBOutlet weak var solarPanel: UIImageView!
    @IBOutlet weak var saveMoney: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.01)
        
        let searchLocationTap = UITapGestureRecognizer(target: self, action: #selector(SearchController.searchLocationTapDetected))
        let solarPanelTap = UITapGestureRecognizer(target: self, action: #selector(SearchController.solarPanelTapDetected))
        let saveMoneyTap = UITapGestureRecognizer(target: self, action: #selector(SearchController.saveMoneyTapDetected))
        
        searchLocation.isUserInteractionEnabled = true
        solarPanel.isUserInteractionEnabled = true
        saveMoney.isUserInteractionEnabled = true
        searchLocation.addGestureRecognizer(searchLocationTap)
        solarPanel.addGestureRecognizer(solarPanelTap)
        saveMoney.addGestureRecognizer(saveMoneyTap)

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
    
    // jump back to login function
    @objc func searchLocationTapDetected() {
        performSegue(withIdentifier: "searchLocations", sender: "")
    }
    
    // user sign up function
    @objc func solarPanelTapDetected() {
        performSegue(withIdentifier: "solarPanel", sender: "")
    }
    
    // user sign up function
    @objc func saveMoneyTapDetected() {
        performSegue(withIdentifier: "saveMoney", sender: "")
    }
    
}
