//
//  CustomTabBarController.swift
//  foursigma
//
//  Created by 姚逸晨 on 2/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import RevealingSplashView

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "logo")!, iconInitialSize: CGSize(width: 333, height: 129), backgroundColor: UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0))
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.startAnimation() {
            
        }

        let numbersOfTabs = CGFloat((tabBar.items?.count)!)
        let tabBarSize = CGSize(width: tabBar.frame.width / numbersOfTabs, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1), size: tabBarSize)
    }
    
    

}

// when the user press the tab bar item, the UIImage will change color
extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
