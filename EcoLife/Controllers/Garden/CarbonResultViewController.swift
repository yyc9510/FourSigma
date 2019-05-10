//
//  CarbonResultViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 1/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class CarbonResultViewController: UIViewController {
    
    var landfill = 0
    var compost = 0
    
    var landfillCarbon = 0.0
    var compostCarbon = 0.0
    
    var netCarbon = 0.0
    
    var weeklyPassenger = 0.0
    var kilometer = 0.0
    
    var weeklyHomes = 0.0
    var smartphone = 0.0
    
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Result"
        
        calculation()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        if landfillCarbon + compostCarbon > 0 {
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 2200)
            initView()
        }
        else {
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
            initSecondView()
        }

    }
    
    func calculation() {
        landfillCarbon = Double(landfill) * 0.003417161
        compostCarbon = Double(compost) * -0.000424389
        netCarbon = landfillCarbon + compostCarbon
        
        weeklyPassenger = landfillCarbon * 0.212
        kilometer = landfillCarbon * 3934.846
        
        weeklyHomes = landfillCarbon * 0.12
        smartphone = landfillCarbon * 255025
    }
    
    func initView() {
        
        let resultLabel = UILabel(frame: CGRect(x: 30, y: 30, width: 300, height: 70))
        resultLabel.center.x = self.view.center.x
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont(name: "Optima", size: 20)
        resultLabel.numberOfLines = 2
        resultLabel.text = "Oops! Something is not good"
        resultLabel.textColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0)
        scrollView.addSubview(resultLabel)
        
        // 1
        let landfillImageView = UIImageView()
        let landfillImage = UIImage(named: "landfill_waste")
        landfillImageView.frame = CGRect(x: 30, y: 120, width: 150, height: 150)
        landfillImageView.image = landfillImage
        landfillImageView.maskCircle(anyImage: landfillImage!)
        landfillImageView.center.x = self.view.center.x
        scrollView.addSubview(landfillImageView)
        
        let landfillCarbonLabel = UILabel(frame: CGRect(x: 30, y: 300, width: 300, height: 70))
        landfillCarbonLabel.center.x = self.view.center.x
        landfillCarbonLabel.textAlignment = .center
        landfillCarbonLabel.font = UIFont(name: "Optima", size: 18)
        landfillCarbonLabel.numberOfLines = 3
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Carbon Emission generated from landfilled waste: ")
            .bold("\(Double(String(format: "%.4f", landfillCarbon))!)")
            .normal(" tonnes")
        
        landfillCarbonLabel.attributedText = formattedString
        scrollView.addSubview(landfillCarbonLabel)
        
        // Line
        let lineOne = UILabel()
        lineOne.text = "......................................................................................................................................."
        lineOne.textAlignment = .center
        lineOne.textColor = .black
        lineOne.center.x = self.view.center.x
        lineOne.frame = CGRect(x: 20, y: 360, width: 330, height: 50)
        scrollView.addSubview(lineOne)
        
        // 2
        let compostImageView = UIImageView()
        let compostImage = UIImage(named: "compost_waste")
        compostImageView.frame = CGRect(x: 30, y: 430, width: 150, height: 150)
        compostImageView.image = compostImage
        compostImageView.maskCircle(anyImage: compostImage!)
        compostImageView.center.x = self.view.center.x
        scrollView.addSubview(compostImageView)
        
        let compostCarbonLabel = UILabel(frame: CGRect(x: 30, y: 600, width: 300, height: 70))
        compostCarbonLabel.center.x = self.view.center.x
        compostCarbonLabel.textAlignment = .center
        compostCarbonLabel.font = UIFont(name: "Optima", size: 18)
        compostCarbonLabel.numberOfLines = 3
        
        let formattedStringTwo = NSMutableAttributedString()
        formattedStringTwo
            .normal("Carbon Emission offset from composted waste: ")
            .bold("\(Double(String(format: "%.4f", compostCarbon))!)")
            .normal(" tonnes")
        
        compostCarbonLabel.attributedText = formattedStringTwo
        scrollView.addSubview(compostCarbonLabel)
        
        let lineTwo = UILabel()
        lineTwo.text = "......................................................................................................................................."
        lineTwo.textAlignment = .center
        lineTwo.textColor = .black
        lineTwo.center.x = self.view.center.x
        lineTwo.frame = CGRect(x: 20, y: 660, width: 330, height: 50)
        scrollView.addSubview(lineTwo)
        
        // 3
        let netCarbonImageView = UIImageView()
        let netCarbonImage = UIImage(named: "netCarbon")
        netCarbonImageView.frame = CGRect(x: 30, y: 730, width: 150, height: 150)
        netCarbonImageView.image = netCarbonImage
        netCarbonImageView.maskCircle(anyImage: netCarbonImage!)
        netCarbonImageView.center.x = self.view.center.x
        scrollView.addSubview(netCarbonImageView)
        
        let netCarbonLabel = UILabel(frame: CGRect(x: 30, y: 900, width: 300, height: 70))
        netCarbonLabel.center.x = self.view.center.x
        netCarbonLabel.textAlignment = .center
        netCarbonLabel.font = UIFont(name: "Optima", size: 18)
        netCarbonLabel.numberOfLines = 3
        
        let formattedStringSeven = NSMutableAttributedString()
        formattedStringSeven
            .normal("Net Carbon Emissions in Metric Tonnes of CO2 Equivalent: ")
            .bold("\(Double(String(format: "%.4f", landfillCarbon + compostCarbon))!)")
            .normal(" tonnes")
        
        netCarbonLabel.attributedText = formattedStringSeven
        scrollView.addSubview(netCarbonLabel)
        
        let lineSeven = UILabel()
        lineSeven.text = "......................................................................................................................................."
        lineSeven.textAlignment = .center
        lineSeven.textColor = .black
        lineSeven.center.x = self.view.center.x
        lineSeven.frame = CGRect(x: 20, y: 960, width: 330, height: 50)
        scrollView.addSubview(lineSeven)
        
        // 4
        let passengerImageView = UIImageView()
        let passengerImage = UIImage(named: "passenger")
        passengerImageView.frame = CGRect(x: 30, y: 1030, width: 150, height: 150)
        passengerImageView.image = passengerImage
        passengerImageView.maskCircle(anyImage: passengerImage!)
        passengerImageView.center.x = self.view.center.x
        scrollView.addSubview(passengerImageView)
        
        let passengerLabel = UILabel(frame: CGRect(x: 30, y: 1200, width: 300, height: 70))
        passengerLabel.center.x = self.view.center.x
        passengerLabel.textAlignment = .center
        passengerLabel.font = UIFont(name: "Optima", size: 18)
        passengerLabel.numberOfLines = 3
        
        let formattedStringThree = NSMutableAttributedString()
        formattedStringThree
            .normal("Passenger vehicles driven per year: ")
            .bold("\(Double(String(format: "%.4f", weeklyPassenger * 52))!)")
        
        passengerLabel.attributedText = formattedStringThree
        scrollView.addSubview(passengerLabel)
        
        let lineThree = UILabel()
        lineThree.text = "......................................................................................................................................."
        lineThree.textAlignment = .center
        lineThree.textColor = .black
        lineThree.center.x = self.view.center.x
        lineThree.frame = CGRect(x: 20, y: 1260, width: 330, height: 50)
        scrollView.addSubview(lineThree)
        
        // 5
        let kiloImageView = UIImageView()
        let kiloImage = UIImage(named: "kilometer")
        kiloImageView.frame = CGRect(x: 30, y: 1330, width: 150, height: 150)
        kiloImageView.image = kiloImage
        kiloImageView.maskCircle(anyImage: kiloImage!)
        kiloImageView.center.x = self.view.center.x
        scrollView.addSubview(kiloImageView)
        
        let kiloLabel = UILabel(frame: CGRect(x: 30, y: 1500, width: 300, height: 70))
        kiloLabel.center.x = self.view.center.x
        kiloLabel.textAlignment = .center
        kiloLabel.font = UIFont(name: "Optima", size: 18)
        kiloLabel.numberOfLines = 3
        
        let formattedStringFour = NSMutableAttributedString()
        formattedStringFour
            .normal("Kilometres driven by an average passenger vehicle: ")
            .bold("\(Double(String(format: "%.4f", kilometer))!)")
        
        kiloLabel.attributedText = formattedStringFour
        scrollView.addSubview(kiloLabel)
        
        let lineFour = UILabel()
        lineFour.text = "......................................................................................................................................."
        lineFour.textAlignment = .center
        lineFour.textColor = .black
        lineFour.center.x = self.view.center.x
        lineFour.frame = CGRect(x: 20, y: 1560, width: 330, height: 50)
        scrollView.addSubview(lineFour)
        
        // 6
        let homeImageView = UIImageView()
        let homeImage = UIImage(named: "home_energy")
        homeImageView.frame = CGRect(x: 30, y: 1630, width: 150, height: 150)
        homeImageView.image = homeImage
        homeImageView.maskCircle(anyImage: homeImage!)
        homeImageView.center.x = self.view.center.x
        scrollView.addSubview(homeImageView)
        
        let homeLabel = UILabel(frame: CGRect(x: 30, y: 1800, width: 300, height: 70))
        homeLabel.center.x = self.view.center.x
        homeLabel.textAlignment = .center
        homeLabel.font = UIFont(name: "Optima", size: 18)
        homeLabel.numberOfLines = 3
        
        let formattedStringFive = NSMutableAttributedString()
        formattedStringFive
            .normal("Number of homes energy use for one year: ")
            .bold("\(Double(String(format: "%.4f", weeklyHomes * 52))!)")
        
        homeLabel.attributedText = formattedStringFive
        scrollView.addSubview(homeLabel)
        
        let lineFive = UILabel()
        lineFive.text = "......................................................................................................................................."
        lineFive.textAlignment = .center
        lineFive.textColor = .black
        lineFive.center.x = self.view.center.x
        lineFive.frame = CGRect(x: 20, y: 1860, width: 330, height: 50)
        scrollView.addSubview(lineFive)
        
        // 7
        let smartphoneImageView = UIImageView()
        let smartphoneImage = UIImage(named: "smartphone")
        smartphoneImageView.frame = CGRect(x: 30, y: 1930, width: 150, height: 150)
        smartphoneImageView.image = smartphoneImage
        smartphoneImageView.maskCircle(anyImage: smartphoneImage!)
        smartphoneImageView.center.x = self.view.center.x
        scrollView.addSubview(smartphoneImageView)
        
        let smartphoneLabel = UILabel(frame: CGRect(x: 30, y: 2100, width: 300, height: 70))
        smartphoneLabel.center.x = self.view.center.x
        smartphoneLabel.textAlignment = .center
        smartphoneLabel.font = UIFont(name: "Optima", size: 18)
        smartphoneLabel.numberOfLines = 3
        
        let formattedStringSix = NSMutableAttributedString()
        formattedStringSix
            .normal("Number of smartphones charged: ")
            .bold("\(Double(String(format: "%.4f", smartphone))!)")
        
        smartphoneLabel.attributedText = formattedStringSix
        scrollView.addSubview(smartphoneLabel)
        
        self.view.addSubview(scrollView)
    }
    
    func initSecondView() {
        
        let resultLabel = UILabel(frame: CGRect(x: 30, y: 30, width: 300, height: 70))
        resultLabel.center.x = self.view.center.x
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont(name: "Optima", size: 20)
        resultLabel.numberOfLines = 2
        resultLabel.text = "Congratulations! You did a good job for protecting the environment"
        resultLabel.textColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        scrollView.addSubview(resultLabel)
        
        let landfillImageView = UIImageView()
        let landfillImage = UIImage(named: "landfill_waste")
        landfillImageView.frame = CGRect(x: 30, y: 120, width: 150, height: 150)
        landfillImageView.image = landfillImage
        landfillImageView.maskCircle(anyImage: landfillImage!)
        landfillImageView.center.x = self.view.center.x
        scrollView.addSubview(landfillImageView)
        
        let landfillCarbonLabel = UILabel(frame: CGRect(x: 30, y: 300, width: 300, height: 70))
        landfillCarbonLabel.center.x = self.view.center.x
        landfillCarbonLabel.textAlignment = .center
        landfillCarbonLabel.font = UIFont(name: "Optima", size: 18)
        landfillCarbonLabel.numberOfLines = 3
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Carbon Emission generated from landfilled waste: ")
            .bold("\(Double(String(format: "%.4f", landfillCarbon))!)")
            .normal(" tonnes")
        
        landfillCarbonLabel.attributedText = formattedString
        scrollView.addSubview(landfillCarbonLabel)
        
        // Line
        let lineOne = UILabel()
        lineOne.text = "......................................................................................................................................."
        lineOne.textAlignment = .center
        lineOne.textColor = .black
        lineOne.center.x = self.view.center.x
        lineOne.frame = CGRect(x: 20, y: 360, width: 330, height: 50)
        scrollView.addSubview(lineOne)
        
        let compostImageView = UIImageView()
        let compostImage = UIImage(named: "compost_waste")
        compostImageView.frame = CGRect(x: 30, y: 430, width: 150, height: 150)
        compostImageView.image = compostImage
        compostImageView.maskCircle(anyImage: compostImage!)
        compostImageView.center.x = self.view.center.x
        scrollView.addSubview(compostImageView)
        
        let compostCarbonLabel = UILabel(frame: CGRect(x: 30, y: 600, width: 300, height: 70))
        compostCarbonLabel.center.x = self.view.center.x
        compostCarbonLabel.textAlignment = .center
        compostCarbonLabel.font = UIFont(name: "Optima", size: 18)
        compostCarbonLabel.numberOfLines = 3
        
        let formattedStringTwo = NSMutableAttributedString()
        formattedStringTwo
            .normal("Carbon Emission offset from composted waste: ")
            .bold("\(Double(String(format: "%.4f", compostCarbon))!)")
            .normal(" tonnes")
        
        compostCarbonLabel.attributedText = formattedStringTwo
        scrollView.addSubview(compostCarbonLabel)
        
        let lineTwo = UILabel()
        lineTwo.text = "......................................................................................................................................."
        lineTwo.textAlignment = .center
        lineTwo.textColor = .black
        lineTwo.center.x = self.view.center.x
        lineTwo.frame = CGRect(x: 20, y: 660, width: 330, height: 50)
        scrollView.addSubview(lineTwo)
        
        let netCarbonImageView = UIImageView()
        let netCarbonImage = UIImage(named: "netCarbon")
        netCarbonImageView.frame = CGRect(x: 30, y: 730, width: 150, height: 150)
        netCarbonImageView.image = netCarbonImage
        netCarbonImageView.maskCircle(anyImage: netCarbonImage!)
        netCarbonImageView.center.x = self.view.center.x
        scrollView.addSubview(netCarbonImageView)
        
        let netCarbonLabel = UILabel(frame: CGRect(x: 30, y: 900, width: 300, height: 70))
        netCarbonLabel.center.x = self.view.center.x
        netCarbonLabel.textAlignment = .center
        netCarbonLabel.font = UIFont(name: "Optima", size: 18)
        netCarbonLabel.numberOfLines = 3
        
        let formattedStringThree = NSMutableAttributedString()
        formattedStringThree
            .normal("Net Carbon Emissions in Metric Tonnes of CO2 Equivalent: ")
            .bold("0")
            .normal(" tonnes")
        
        netCarbonLabel.attributedText = formattedStringThree
        scrollView.addSubview(netCarbonLabel)
        
        self.view.addSubview(scrollView)
    }
    
}
