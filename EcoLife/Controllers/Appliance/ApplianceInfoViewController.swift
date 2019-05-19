//
//  ApplianceInfoViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 8/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class ApplianceInfoViewController: BottomPopupViewController, UITableViewDelegate, UITableViewDataSource {
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var appliance: Appliance!
    var data = [String]()
    var tableViewLabel = [String]()
    
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func button(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var showView: UIView!
    
    var infoTableView = UITableView()
    var closeButton = UIButton()
    
    override func viewDidLoad() {
        
        setData()
        
        brand.text = appliance.brand.name
        imageView.image = UIImage(named: "\(appliance.type)_1")
        
        infoTableView.frame = CGRect(x: 0, y: 0, width: showView.frame.width, height: showView.frame.height)
        infoTableView.separatorStyle = .singleLine
        infoTableView.isScrollEnabled = false
        self.showView.addSubview(infoTableView)
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "applianceInfoCell")
    }
    
    func setData() {
        
        if appliance.type == "Fridges and Freezers" {
            tableViewLabel = ["Appliance Type", "Brand Name", "Model Number", "Volume (L)", "Manufacturing Countries", "Energy Consumption (kWh)", "Star Rating", "Yearly Cost of Electricity ($)", "EcoLife Rating"]
        }
        else if appliance.type == "Washing Machines" || appliance.type == "Dryers" {
            tableViewLabel = ["Appliance Type", "Brand Name", "Model Number", "Capacity (kg)", "Manufacturing Countries", "Energy Consumption (kWh)", "Star Rating", "Yearly Cost of Electricity ($)", "EcoLife Rating"]
        }
        else if appliance.type == "Dishwashers" {
            tableViewLabel = ["Appliance Type", "Brand Name", "Model Number", "Capacity (Number of dishes)", "Manufacturing Countries", "Energy Consumption (kWh)", "Star Rating", "Yearly Cost of Electricity ($)", "EcoLife Rating"]
        }
        else {
            tableViewLabel = ["Appliance Type", "Brand Name", "Model Number", "Screen Size & Type", "Manufacturing Countries", "Energy Consumption (kWh)", "Star Rating", "Yearly Cost of Electricity ($)", "EcoLife Rating"]
        }
        
        data.append(appliance.type)
        data.append(appliance.brand.name)
        data.append(appliance.model.name)
        data.append(appliance.size)
        data.append(appliance.manufacturer)
        data.append(appliance.energyConsumption)
        data.append(appliance.rating)
        data.append(appliance.energyConsumption)
        data.append(appliance.ecoRating)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "applianceInfoCell", for: indexPath)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: 20)
        label.numberOfLines = 2
        label.center.x = view.center.x
        label.textAlignment = .center
        
        if indexPath.row != 7 {
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("\(tableViewLabel[indexPath.row]):")
                .bold(" \(data[indexPath.row])")
    
            label.attributedText = formattedString
            
            //cell.textLabel?.text = "\(tableViewLabel[indexPath.row]): \(data[indexPath.row])"
        }
        else if indexPath.row == 7 {
            
            let value = (data[indexPath.row] as NSString).doubleValue / 3
            let strValue = String(format: "%.1f", value)
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("\(tableViewLabel[indexPath.row]):")
                .bold(" \(strValue)")
            
            label.attributedText = formattedString
        }
        
        cell.addSubview(label)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}

