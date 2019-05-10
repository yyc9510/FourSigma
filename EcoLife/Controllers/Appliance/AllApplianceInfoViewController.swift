//
//  AllApplianceInfoViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 10/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Charts

class AllApplianceInfoViewController: BottomPopupViewController{
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var appliance = [Appliance]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    var brandPieChartView: PieChartView!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        scrollView.contentSize = CGSize(width: 375, height: self.view.frame.height * 1.2)
        
        setBrandPieChart()
        setManufacturerPieChart()
        setEnergyValue()
        setRatingValue()
        setCost()
    }
    
    func setBrandPieChart()  {
        
        let chart = PieChartView(frame: CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: 300))
        chart.center.x = self.scrollView.center.x
        
        // 2. generate chart data entries
        
        var brand = [String]()
        var numberOfBrand = [Double]()
        
        for app in appliance {
            if brand.count == 0 {
                brand.append(app.brand.name)
            }
            else if !brand.contains(app.brand.name) {
                brand.append(app.brand.name)
            }
        }
        
        for _ in brand {
            numberOfBrand.append(0.0)
        }
        
        
        for i in 0...appliance.count - 1 {
            for n in 0...brand.count - 1 {
                if appliance[i].brand.name == brand[n] {
                    numberOfBrand[n] += 1
                }
            }
        }
        
        
        let track = brand
        let money = numberOfBrand
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Brands")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = "Brand Pie Chart"
        chart.chartDescription = d
        //chart.centerText = "Pie Chart"
        chart.holeRadiusPercent = 0.4
        chart.transparentCircleColor = UIColor.clear
        self.scrollView.addSubview(chart)
        
    }
    
    func setManufacturerPieChart()  {
        
        let chart = PieChartView(frame: CGRect(x: 0, y: 320, width: self.scrollView.frame.width, height: 300))
        chart.center.x = self.scrollView.center.x
        
        // 2. generate chart data entries
        
        var manufacturer = [String]()
        var numberOfManufacturer = [Double]()
        
        for app in appliance {
            if manufacturer.count == 0 {
                manufacturer.append(app.manufacturer)
            }
            else if !manufacturer.contains(app.manufacturer) {
                manufacturer.append(app.manufacturer)
            }
        }
        
        for _ in manufacturer {
            numberOfManufacturer.append(0.0)
        }
        
        for i in 0...appliance.count - 1 {
            for n in 0...manufacturer.count - 1 {
                if appliance[i].manufacturer == manufacturer[n] {
                    numberOfManufacturer[n] += 1
                }
            }
        }
        
        let track = manufacturer
        let money = numberOfManufacturer
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Manufacturers")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = "Manufacturer Pie Chart"
        chart.chartDescription = d
        //chart.centerText = "Pie Chart"
        chart.holeRadiusPercent = 0.4
        chart.transparentCircleColor = UIColor.clear
        self.scrollView.addSubview(chart)
        
    }
    
    func setEnergyValue() {
        
        var averageEnergy = 0.0
        for app in appliance {
            averageEnergy += (app.energyConsumption as NSString).doubleValue
        }
        
        let doubleValue = averageEnergy / Double(appliance.count)
        let value = String(format: "%.01f", doubleValue)
        
        let averageEnergyLabel = UILabel()
        averageEnergyLabel.frame = CGRect(x: 0, y: 700, width: self.scrollView.frame.width, height: 70)
        averageEnergyLabel.center.x = self.scrollView.center.x
        averageEnergyLabel.textAlignment = .center
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Average Energy Consumption (kWh): ")
            .bold("\(value)")
        
        averageEnergyLabel.attributedText = formattedString
        
        self.scrollView.addSubview(averageEnergyLabel)
    }
    
    func setRatingValue() {
        
        var averageRating = 0.0
        for app in appliance {
            averageRating += (app.rating as NSString).doubleValue
        }
        
        let doubleValue = averageRating / Double(appliance.count)
        let value = String(format: "%.01f", doubleValue)
        
        let averageRatingLabel = UILabel()
        averageRatingLabel.frame = CGRect(x: 0, y: 650, width: self.scrollView.frame.width, height: 70)
        averageRatingLabel.center.x = self.scrollView.center.x
        averageRatingLabel.textAlignment = .center
        averageRatingLabel.numberOfLines = 2
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Average Star Rating: ")
            .bold("\(value)")
        
        averageRatingLabel.attributedText = formattedString
        
        self.scrollView.addSubview(averageRatingLabel)
    }
    
    func setCost() {
        
        var totalEnergy = 0.0
        for app in appliance {
            totalEnergy += (app.energyConsumption as NSString).doubleValue / 3
        }
        
        let value = String(format: "%.01f", totalEnergy)
        
        let averageCostLabel = UILabel()
        averageCostLabel.frame = CGRect(x: 0, y: 750, width: self.scrollView.frame.width, height: 70)
        averageCostLabel.center.x = self.scrollView.center.x
        averageCostLabel.textAlignment = .center
        averageCostLabel.numberOfLines = 2
        
        let formattedStringOne = NSMutableAttributedString()
        formattedStringOne
            .normal("Annually Estimated Total Cost ($): ")
            .bold("\(value)")
        
        averageCostLabel.attributedText = formattedStringOne
        
        self.scrollView.addSubview(averageCostLabel)
    }
    
}
