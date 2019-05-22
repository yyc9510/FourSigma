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
    var type = ""
    
    var sectionName = [String]()
    
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
        
        if type == "Fridges and Freezers" {
            sectionName = ["Brand Name", "Model Number", "Volume (L)", "Manufacturing Countries", "Comparative Energy Consumption (kWh)", "Star Rating", "Yearly Cost of Electricity ($)", "EcoLife Rating"]
        }
        else if type == "Washing Machines" || type == "Dryers" {
            sectionName = ["Brand Name", "Model Number", "Capacity (kg)", "Manufacturing Countries", "Comparative Energy Consumption (kWh)", "Star Rating", "Yearly Cost of Electricity ($)", "EcoLife Rating"]
        }
        else if type == "Dishwashers" {
            sectionName = ["Brand Name", "Model Number", "Capacity (Number of dishes)", "Manufacturing Countries", "Comparative Energy Consumption (kWh)", "Star Rating", "Yearly Cost of Electricity ($)", "EcoLife Rating"]
        }
        else {
            sectionName = ["Brand Name", "Model Number", "Screen Size & Type", "Manufacturing Countries", "Comparative Energy Consumption (kWh)", "Star Rating", "Yearly Cost of Electricity ($)", "EcoLife Rating"]
        }
        
        let firstAppliance = data[0]
        let secondAppliance = data[1]
        
        let brand = [firstAppliance.brand.name, secondAppliance.brand.name]
        let brandRow = [brand]
        
        let model = [firstAppliance.model.name, secondAppliance.model.name]
        let modelRow = [model]
        
        let size = [firstAppliance.size, secondAppliance.size]
        let sizeRow = [size]
        
        let manufacturer = [firstAppliance.manufacturer, secondAppliance.manufacturer]
        let manufacturerRow = [manufacturer]
        
        let energyConsumption = [firstAppliance.energyConsumption, secondAppliance.energyConsumption]
        let energyConsumptionRow = [energyConsumption]
        
        let rating = [firstAppliance.rating, secondAppliance.rating]
        let ratingRow = [rating]
        
        let ecoRating = [firstAppliance.ecoRating, secondAppliance.ecoRating]
        let ecoRatingRow = [ecoRating]
        
        let cost = [firstAppliance.energyConsumption, secondAppliance.energyConsumption]
        let costRow = [cost]
        
        twoAppliancesValues.append(brandRow)
        twoAppliancesValues.append(modelRow)
        twoAppliancesValues.append(sizeRow)
        twoAppliancesValues.append(manufacturerRow)
        twoAppliancesValues.append(energyConsumptionRow)
        twoAppliancesValues.append(ratingRow)
        twoAppliancesValues.append(costRow)
        twoAppliancesValues.append(ecoRatingRow)
    }
    
    
    func initView() {
        
        self.view.addSubview(comparisonView)
        comparisonView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        comparisonView.addSubview(comparisonTableView)
        comparisonTableView.frame = comparisonView.frame
        comparisonTableView.separatorStyle = .none
        
        self.view.addSubview(goBackButton)
        //goBackButton.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 0.5)
        //goBackButton.backgroundColor = .gray
        goBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive=true
        goBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
        goBackButton.widthAnchor.constraint(equalToConstant: 50).isActive=true
        goBackButton.heightAnchor.constraint(equalTo: goBackButton.widthAnchor).isActive=true
        
        self.view.addSubview(screenshotButton)
        //screenshotButton.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 0.5)
        //screenshotButton.backgroundColor = .gray
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
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        btn.setImage(UIImage(named: "go_back"), for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
        btn.imageView?.tintColor=UIColor.lightGray.withAlphaComponent(0.5)
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let screenshotButton: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        btn.setImage(UIImage(named: "screenshot"), for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
        btn.imageView?.tintColor=UIColor.lightGray.withAlphaComponent(0.5)
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
        return sectionName.count
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
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comparisonCell", for: indexPath) as UITableViewCell
        
        cell.isUserInteractionEnabled = false
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
        
        if indexPath.section == 6 {
            
            let first = String(format: "%.01f", firstValue / 3)
            let second = String(format: "%.01f", secondValue / 3)
            
            labelOne.text = "\(first)"
            labelTwo.text = "\(second)"
        }
        if firstValue > secondValue && indexPath.section == 4 {
            labelOne.textColor = badColor
            labelTwo.textColor = goodColor
        }
        else if firstValue < secondValue && indexPath.section == 4 {
            labelOne.textColor = goodColor
            labelTwo.textColor = badColor
        }
        
        if firstValue > secondValue && indexPath.section == 5 {
            labelOne.textColor = goodColor
            labelTwo.textColor = badColor
        }
        else if firstValue < secondValue && indexPath.section == 5 {
            labelOne.textColor = badColor
            labelTwo.textColor = goodColor
        }
        
        if firstValue > secondValue && indexPath.section == 6 {
            labelOne.textColor = badColor
            labelTwo.textColor = goodColor
        }
        else if firstValue < secondValue && indexPath.section == 6 {
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
