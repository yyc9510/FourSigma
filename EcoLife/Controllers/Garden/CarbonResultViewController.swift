//
//  CarbonResultViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 1/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class CarbonResultViewController: UITableViewController {
    
    var type = ""
    
    var landfill = 0
    var compost = 0
    
    var landfillCarbon = 0.0
    var compostCarbon = 0.0
    var netCarbon = 0.0
    
    var weeklyPassenger = 0.0
    var kilometer = 0.0
    var weeklyHomes = 0.0
    var smartphone = 0.0
    
    var goodData = [NSMutableAttributedString]()
    var badData = [NSMutableAttributedString]()
    
    override func viewWillAppear(_ animated: Bool) {
        calculation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Result"

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func calculation() {
        
        landfillCarbon = Double(landfill) * 0.003417161
        compostCarbon = Double(compost) * -0.000424389
        netCarbon = landfillCarbon + compostCarbon
        
        weeklyPassenger = landfillCarbon * 0.212
        kilometer = landfillCarbon * 3934.846
        weeklyHomes = landfillCarbon * 0.12
        smartphone = landfillCarbon * 255025
        
        if landfillCarbon + compostCarbon > 0 {
            type = "bad"
            
            let formattedStringOne = NSMutableAttributedString()
            let formattedStringTwo = NSMutableAttributedString()
            let formattedStringThree = NSMutableAttributedString()
            let formattedStringFour = NSMutableAttributedString()
            let formattedStringFive = NSMutableAttributedString()
            let formattedStringSix = NSMutableAttributedString()
            let formattedStringSeven = NSMutableAttributedString()
            
            
            formattedStringOne
                .normal("Carbon Emission generated from landfilled waste: ")
                .bold("\(String(format: "%.3f", landfillCarbon))")
                .normal(" tonnes")
            formattedStringTwo
                .normal("Carbon Emission offset from composted waste: ")
                .bold("\(String(format: "%.3f", abs(compostCarbon)))")
                .normal(" tonnes")
            formattedStringThree
                .normal("Net Carbon Emissions in Metric Tonnes of CO2 Equivalent: ")
                .bold("\(String(format: "%.3f", abs(landfillCarbon + compostCarbon)))")
                .normal(" tonnes")
            formattedStringFour
                .normal("Passenger vehicles driven per year: ")
                .bold("\(String(format: "%.1f", weeklyPassenger * 52))")
            formattedStringFive
                .normal("Kilometres driven by an average passenger vehicle: ")
                .bold("\(String(format: "%.1f", kilometer))")
            formattedStringSix
                .normal("Number of homes energy use for one year: ")
                .bold("\(String(format: "%.1f", weeklyHomes * 52))")
            formattedStringSeven
                .normal("Number of smartphones charged: ")
                .bold("\(String(format: "%.1f", smartphone))")
            
            badData.append(formattedStringOne)
            badData.append(formattedStringTwo)
            badData.append(formattedStringThree)
            badData.append(formattedStringFour)
            badData.append(formattedStringFive)
            badData.append(formattedStringSix)
            badData.append(formattedStringSeven)
            
        }
        else {
            type = "good"
            
            let formattedStringOne = NSMutableAttributedString()
            let formattedStringTwo = NSMutableAttributedString()
            let formattedStringThree = NSMutableAttributedString()
            
            formattedStringOne
                .normal("Carbon Emission generated from landfilled waste: ")
                .bold("\(String(format: "%.3f", landfillCarbon))")
                .normal(" tonnes")
            formattedStringTwo
                .normal("Carbon Emission offset from composted waste: ")
                .bold("\(String(format: "%.3f", abs(compostCarbon)))")
                .normal(" tonnes")
            formattedStringThree
                .normal("Net Carbon Emissions in Metric Tonnes of CO2 Equivalent: ")
                .bold("0.0")
                .normal(" tonnes")
            
            goodData.append(formattedStringOne)
            goodData.append(formattedStringTwo)
            goodData.append(formattedStringThree)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "good" {
            return goodData.count
        }
        else {
            return badData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "compostResultCell", for: indexPath) as! CarbonTableViewCell
        cell.isUserInteractionEnabled = false
        
        if type == "good" {
            cell.label.attributedText = goodData[indexPath.row]
            
        }
        else if type == "bad" {
            cell.label.attributedText = badData[indexPath.row]
        }
        
        cell.carbonImageView.image = UIImage(named: "carbon\(indexPath.row)")
        cell.carbonImageView.maskCircle(anyImage: UIImage(named: "carbon\(indexPath.row)")!)
        cell.carbonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
