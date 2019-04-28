//
//  GardenViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 19/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class GardenViewController: TabmanViewController {
    
    private var viewControllers: [(String, UITableViewController)] =
        [("Name", VegetableViewController()), ("Growing", VegetableGrowingViewController()), ("Sowing", VegetableSowingViewController())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Veggies"
        self.dataSource = self
        
        createBar()
    }
    
    func createBar() {
        
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        
        bar.buttons.customize { (bt) in
            bt.selectedTintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
            bt.tintColor = .lightGray
            bt.font = UIFont.systemFont(ofSize: 18)
            bt.selectedFont = UIFont.systemFont(ofSize: 18)
        }
        
        bar.indicator.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        bar.indicator.cornerStyle = .eliptical
        bar.indicator.overscrollBehavior = .compress
        bar.indicator.weight = .custom(value: 4)
        
        bar.layout.contentMode = .fit
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        addBar(bar, dataSource: self, at: .top)
    }
    
}

extension GardenViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: self.viewControllers[index].0)
    }

    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index].1
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for tabViewController: TabmanViewController, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }
}
