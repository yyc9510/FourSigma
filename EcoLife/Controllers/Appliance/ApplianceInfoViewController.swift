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
    let tableViewLabel = ["Appliance Type", "Brand Name", "Model Name", "Manufacturer", "Energy Consumption (kWh)", "Star Rating", "Cost of Electricity ($)"]
    
    @IBAction func button(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var showView: UIView!
    
    var infoTableView = UITableView()
    var closeButton = UIButton()
    
    override func viewDidLoad() {
        
        setData()
        
        infoTableView.frame = CGRect(x: 0, y: 0, width: showView.frame.width, height: showView.frame.height)
        infoTableView.separatorStyle = .singleLine
        self.showView.addSubview(infoTableView)
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "applianceInfoCell")
    }
    
    func setData() {
        data.append(appliance.type)
        data.append(appliance.brand.name)
        data.append(appliance.model.name)
        data.append(appliance.manufacturer)
        data.append(appliance.energyConsumption)
        data.append(appliance.rating)
        data.append(appliance.energyConsumption)
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
        
        if indexPath.row != 6 {
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("\(tableViewLabel[indexPath.row]):")
                .bold(" \(data[indexPath.row])")
    
            label.attributedText = formattedString
            
            //cell.textLabel?.text = "\(tableViewLabel[indexPath.row]): \(data[indexPath.row])"
        }
        else if indexPath.row == 6 {
            
            let value = (data[indexPath.row] as NSString).doubleValue * 3.0
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("\(tableViewLabel[indexPath.row]):")
                .bold(" \(value)")
            
            label.attributedText = formattedString
        }
        
        cell.addSubview(label)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

