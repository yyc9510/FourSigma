//
//  SolarCalcResultViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 10/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SolarCalcResultViewController: UIViewController {
    
    var solarSize = ""
    var systemCost = 0.0
    var electricityCost = 0.0
    var dailyUsage = 0.0
    var selfConsumption = 0.0
    var sunHours = 0.0
    var feedInTariff = 0.0
    
    var averageDailyProduction = 0.0
    var dailySelfComsumption = 0.0
    var dailySolarExport = 0.0
    
    var totalDailySaving = 0.0
    var totalAnnualSaving = 0.0
    var totalQuarterSaving = 0.0
    var totalMonthlySaving = 0.0
    
    var numOfYearsPayoff = 0.0
    var annualROI = 0.0
    
    @IBOutlet weak var payOffLabel: UILabel!
    @IBOutlet weak var roiLabel: UILabel!
    @IBOutlet weak var dailyProductionLabel: UILabel!
    var savingTypeTextField = SkyFloatingLabelTextField()
    var dropDownImageViewOne = UIImageView()
    @IBOutlet weak var savingResultLabel: UILabel!
    
    let savingPickerData = ["Daily", "Monthly", "Quarterly", "Annually"]
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 570)
        
        dropDownImageViewOne.frame = CGRect(x: 339, y: 395, width: 20, height: 20)
        dropDownImageViewOne.image = UIImage(named: "expand")
        
        savingTypeTextField = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 385, width: 339, height: 40))
        
        savingTypeTextField.placeholder = "E.g. Daily"
        savingTypeTextField.title = "Time Period of Saving"
        savingTypeTextField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        savingTypeTextField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        savingTypeTextField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        
        self.scrollView.addSubview(savingTypeTextField)
        self.scrollView.addSubview(dropDownImageViewOne)
        createSolarPicker()
        createToolBar()
        
        self.savingTypeTextField.text = "Annually"
        setResult()
    }
    
    func setResult() {
        // Cell D2 - Average daily system Production (kWh)
        averageDailyProduction = (solarSize as NSString).doubleValue * sunHours
        
        // Cell E2 - Daily self-consumption (kWh)
        dailySelfComsumption = averageDailyProduction * selfConsumption
        
        // Cell F2 - Daily solar export (kWh)
        dailySolarExport = averageDailyProduction - dailySelfComsumption
        
        // Cell J2 - Total daily savings ($)
        totalDailySaving = (dailySolarExport * feedInTariff) + (dailySelfComsumption * electricityCost)
        
        // Cell F8 - Annual Savings ($)
        totalAnnualSaving = totalDailySaving * 365
        
        // Cell J4 - Total quartley savings ($)
        totalQuarterSaving = totalAnnualSaving / 4
        
        totalMonthlySaving = totalAnnualSaving / 12
        
        // Cell D8 - Number of years to pay off
        numOfYearsPayoff = systemCost / totalAnnualSaving
        
        // Cell E7 - Annual ROI (%)
        annualROI = (systemCost / numOfYearsPayoff) / systemCost
        
        let numOfYearsPayoffFormatted = Double(String(format: "%.1f", numOfYearsPayoff))!
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("It will take ")
            .bold("\(numOfYearsPayoffFormatted)")
            .normal(" years to pay off")
        
        self.payOffLabel.attributedText = formattedString
        
        let roiFormatted = Double(String(format: "%.1f", annualROI))!
        let formattedStringTwo = NSMutableAttributedString()
        formattedStringTwo
            .normal("Return on investment: ")
            .bold("\(roiFormatted * 100) %")
        
        self.roiLabel.attributedText = formattedStringTwo
        
        let formattedStringThree = NSMutableAttributedString()
        formattedStringThree
            .normal("Average daily system production: ")
            .bold("\(Int(averageDailyProduction)) kWh")
        
        self.dailyProductionLabel.attributedText = formattedStringThree
        
        let doubleFormatted = Double(String(format: "%.1f", totalAnnualSaving))!
        self.savingResultLabel.text = "You will save $ \(doubleFormatted) Annually"
    }
    
    @objc func handleUpdate() {
        
    }
    
    func changeSavingResult(input: String) {
        if input == "Daily" {
            let doubleFormatted = Double(String(format: "%.2f", totalDailySaving))!
            self.savingResultLabel.text = "You will save $ \(doubleFormatted) \(input)"
        }
        else if input == "Monthly" {
            let doubleFormatted = Double(String(format: "%.2f", totalMonthlySaving))!
            self.savingResultLabel.text = "You will save $ \(doubleFormatted) \(input)"
        }
        else if input == "Quarterly" {
            let doubleFormatted = Double(String(format: "%.2f", totalQuarterSaving))!
            self.savingResultLabel.text = "You will save $ \(doubleFormatted) \(input)"
        }
        else if input == "Annually" {
            let doubleFormatted = Double(String(format: "%.2f", totalAnnualSaving))!
            self.savingResultLabel.text = "You will save $ \(doubleFormatted) \(input)"
        }
    }
    
    func createSolarPicker() {
        let savingPicker = UIPickerView()
        savingPicker.delegate = self
        savingTypeTextField.inputView = savingPicker
        savingPicker.backgroundColor = .white
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SolarCalcResultViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        savingTypeTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SolarCalcResultViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return savingPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(savingPickerData[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        savingTypeTextField.text = savingPickerData[row]
        changeSavingResult(input: savingPickerData[row])
    }
}
