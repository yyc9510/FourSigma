//
//  ComparisonResultViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 4/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import EzPopup

class ComparisonResultViewController: UIViewController, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var data = [Appliance]()
    var twoAppliancesValues = [[[String]]]()
    let sectionName = ["Brand Name", "Model Number", "Manufacturing Countries", "Comparative Energy Consumption (kWh)", "Star Rating", "Yearly Cost of Electricity ($)"]
    
    let goodColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
    let badColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0)
    
    var comparisonTableView = UITableView()
    var comparisonView = UIView()
    let customAlertVCOne = CustomAlertViewController.instantiate()
    let customAlertVCTwo = CustomAlertViewController.instantiate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpValue()
        comparisonTableView.delegate = self
        comparisonTableView.dataSource = self
        comparisonTableView.register(UITableViewCell.self, forCellReuseIdentifier: "comparisonCell")
        
        navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        initView()
    }
    
    func setUpValue() {
        let firstAppliance = data[0]
        let secondAppliance = data[1]
        
        let brand = [firstAppliance.brand.name, secondAppliance.brand.name]
        let brandRow = [brand]
        
        let model = [firstAppliance.model.name, secondAppliance.model.name]
        let modelRow = [model]
        
        let manufacturer = [firstAppliance.manufacturer, secondAppliance.manufacturer]
        let manufacturerRow = [manufacturer]
        
        let energyConsumption = [firstAppliance.energyConsumption, secondAppliance.energyConsumption]
        let energyConsumptionRow = [energyConsumption]
        
        let rating = [firstAppliance.rating, secondAppliance.rating]
        let ratingRow = [rating]
        
        let cost = [firstAppliance.energyConsumption, secondAppliance.energyConsumption]
        let costRow = [cost]
        
        twoAppliancesValues.append(brandRow)
        twoAppliancesValues.append(modelRow)
        twoAppliancesValues.append(manufacturerRow)
        twoAppliancesValues.append(energyConsumptionRow)
        twoAppliancesValues.append(ratingRow)
        twoAppliancesValues.append(costRow)
    }
    
    
    func initView() {
        
        self.view.addSubview(comparisonView)
        comparisonView.frame = CGRect(x: 0, y:  50, width: view.frame.width, height: view.frame.height - 50)
        
        comparisonView.addSubview(comparisonTableView)
        comparisonTableView.frame = comparisonView.frame
        comparisonTableView.separatorStyle = .none
        
        self.view.addSubview(goBackButton)
        goBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive=true
        goBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
        goBackButton.widthAnchor.constraint(equalToConstant: 50).isActive=true
        goBackButton.heightAnchor.constraint(equalTo: goBackButton.widthAnchor).isActive=true
        
        self.view.addSubview(screenshotButton)
        screenshotButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive=true
        screenshotButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive=true
        screenshotButton.widthAnchor.constraint(equalToConstant: 50).isActive=true
        screenshotButton.heightAnchor.constraint(equalTo: screenshotButton.widthAnchor).isActive=true
        
    }
    
    func popUpSuccess() {
        guard let customAlertVC = customAlertVCOne else { return }
        
        customAlertVC.titleString = "Saved"
        customAlertVC.messageString = "The screenshot has been saved to your photo library"
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    func popUpFailure() {
        guard let customAlertVC = customAlertVCTwo else { return }
        
        customAlertVC.titleString = "Error"
        customAlertVC.messageString = "Something is wrong"
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    let goBackButton: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(UIImage(named: "go_back"), for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let screenshotButton: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(UIImage(named: "screenshot"), for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(screenshot), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    
    
    @objc func goBack() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func screenshot() {
        let screenshot = comparisonView.takeScreenshot()
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            popUpFailure()
            print(error)
        } else {
            popUpSuccess()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = "\(sectionName[section])"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 15)
        label.center.x = view.center.x
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comparisonCell", for: indexPath) as UITableViewCell
        
        
        let labelOne = UILabel()
        labelOne.frame = CGRect(x: view.frame.width / 8, y: 0, width: view.frame.width / 4, height: cell.frame.height)
        labelOne.text = twoAppliancesValues[indexPath.section][indexPath.row][0]
        labelOne.numberOfLines = 2
        labelOne.font = UIFont.systemFont(ofSize: 14)
        
        let labelTwo = UILabel()
        labelTwo.frame = CGRect(x: view.frame.width * 5 / 8, y: 0, width: view.frame.width / 4, height: cell.frame.height)
        labelTwo.text = twoAppliancesValues[indexPath.section][indexPath.row][1]
        labelTwo.numberOfLines = 2
        labelTwo.font = UIFont.systemFont(ofSize: 14)
        
    
        let firstValue = (labelOne.text! as NSString).doubleValue
        let secondValue = (labelTwo.text! as NSString).doubleValue
        
        if indexPath.section == 5 {
            labelOne.text = "\(firstValue / 3.0)"
            labelTwo.text = "\(secondValue / 3.0)"
        }
        if firstValue > secondValue && indexPath.section == 3{
            labelOne.textColor = badColor
            labelTwo.textColor = goodColor
        }
        else if firstValue < secondValue && indexPath.section == 3 {
            labelOne.textColor = goodColor
            labelTwo.textColor = badColor
        }
        
        if firstValue > secondValue && indexPath.section == 4 {
            labelOne.textColor = goodColor
            labelTwo.textColor = badColor
        }
        else if firstValue < secondValue && indexPath.section == 4 {
            labelOne.textColor = badColor
            labelTwo.textColor = goodColor
        }
        
        if firstValue > secondValue && indexPath.section == 5 {
            labelOne.textColor = badColor
            labelTwo.textColor = goodColor
        }
        else if firstValue < secondValue && indexPath.section == 5 {
            labelOne.textColor = goodColor
            labelTwo.textColor = badColor
        }
        
        for subview in cell.contentView.subviews {
            
            subview.removeFromSuperview()
            
        }
        cell.contentView.addSubview(labelOne)
        cell.contentView.addSubview(labelTwo)
        
        return cell
    }
    
    

}

extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
