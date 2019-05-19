//
//  AllApplianceInfoViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 10/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Charts
import SkyFloatingLabelTextField

class AllApplianceInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var appliance = [Appliance]()
    var factorOneTextField = SkyFloatingLabelTextField()
    var tableView = UITableView()
    var chart = PieChartView()
    var button = UIButton()
    
    var pickerData = ["Average Star Rating", "Average EcoLife Rating", "Average Energy Consumption (kWh)", "Average Electricity Cost ($)"]
    var chartLabel = [String]()
    var numberOfValue = [Double]()
    var averageValue = String()
    var temp = [Double]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    var brandPieChartView: PieChartView!
    
    override func viewDidLoad() {
        
        self.title = "All Appliances Info"
        
        scrollView.contentSize = CGSize(width: 375, height: self.view.frame.height * 1.2)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "appInfoCell")
        
        createFactorOnePicker()
        createToolBar()
        setInitView()
        
        starRatingChart()
    }
    
    func setInitView() {
        
        factorOneTextField.frame = CGRect(x: 0, y: 30, width: self.view.frame.width * 0.8, height: 50)
        factorOneTextField.center.x = self.view.center.x
        factorOneTextField.text = "Average Star Rating"
        factorOneTextField.placeholder = "Please choose one factor"
        factorOneTextField.title = "Data Virtualization"
        factorOneTextField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        factorOneTextField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        factorOneTextField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        self.scrollView.addSubview(factorOneTextField)
        
        button.frame = CGRect(x: 0, y: 100, width: self.view.frame.width * 0.4, height: 50)
        button.center.x = self.view.center.x
        button.setTitle("Show Result", for: .normal)
        button.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(generatePieChart), for: .touchUpInside)
        self.scrollView.addSubview(button)
        
        tableView.frame = CGRect(x: 0, y: 500, width: self.view.frame.width, height: 300)
        self.scrollView.addSubview(tableView)
    }
    
    @objc func generatePieChart() {
        
        chartLabel.removeAll()
        numberOfValue.removeAll()
        temp.removeAll()
        averageValue = ""
        
        for sv in scrollView.subviews {
            if sv.isKind(of: PieChartView.self) {
                sv.removeFromSuperview()
            }
        }
        
        if factorOneTextField.text == "Average Star Rating" {
            starRatingChart()
        }
        else if factorOneTextField.text == "Average EcoLife Rating" {
            ecoRatingChart()
        }
        else if factorOneTextField.text == "Average Energy Consumption (kWh)" {
            energyChart()
        }
        else if factorOneTextField.text == "Average Electricity Cost ($)" {
            costChart()
        }
        tableView.reloadData()
    }
    
    func createFactorOnePicker() {
        let factorPicker = UIPickerView()
        factorPicker.delegate = self
        factorPicker.tag = 1
        factorOneTextField.inputView = factorPicker
        factorPicker.backgroundColor = .white
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AllApplianceInfoViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        factorOneTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func starRatingChart()  {
        
        chart.frame = CGRect(x: 0, y: 180, width: self.scrollView.frame.width, height: 300)
        chart.center.x = self.scrollView.center.x
        
        // Generate chart data entries
        
        for app in appliance {
            if chartLabel.count == 0 {
                chartLabel.append(app.type)
            }
            else if !chartLabel.contains(app.type) {
                chartLabel.append(app.type)
            }
        }
        
        for _ in chartLabel {
            numberOfValue.append(0.0)
            temp.append(0.0)
        }
        
        
        for i in 0...appliance.count - 1 {
            for n in 0...chartLabel.count - 1 {
                if appliance[i].type == chartLabel[n] {
                    numberOfValue[n] += Double(appliance[i].rating)!
                    temp[n] += 1
                }
            }
        }
        
        for i in 0...numberOfValue.count - 1 {
            numberOfValue[i] = numberOfValue[i] / temp[i]
        }
        
        var total = 0.0
        for i in 0...chartLabel.count - 1 {
            total += Double(numberOfValue[i])
        }
        
        averageValue = String(format: "%.1f", total / Double(chartLabel.count))
        
        let track = chartLabel
        let money = numberOfValue
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append(entry)
        }
        
        // Chart setup
        let set = PieChartDataSet(values: entries, label: "Average Star Rating")
        
        // This is custom extension method.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        set.valueFont = UIFont.systemFont(ofSize: 10)
        
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        
        // User interaction
        chart.isUserInteractionEnabled = true
        
        chart.holeRadiusPercent = 0.4
        chart.transparentCircleColor = UIColor.clear
        
        self.scrollView.addSubview(chart)
    }
    
    func ecoRatingChart()  {
        
        chart.frame = CGRect(x: 0, y: 180, width: self.scrollView.frame.width, height: 300)
        chart.center.x = self.scrollView.center.x
        
        // Generate chart data entries
        
        for app in appliance {
            if chartLabel.count == 0 {
                chartLabel.append(app.type)
            }
            else if !chartLabel.contains(app.type) {
                chartLabel.append(app.type)
            }
        }
        
        for _ in chartLabel {
            numberOfValue.append(0.0)
            temp.append(0.0)
        }
        
        
        for i in 0...appliance.count - 1 {
            for n in 0...chartLabel.count - 1 {
                if appliance[i].type == chartLabel[n] {
                    if appliance[i].ecoRating == "High" {
                        numberOfValue[n] += 1
                    }
                    else if appliance[i].ecoRating == "Medium" {
                        numberOfValue[n] += 2
                    }
                    else if appliance[i].ecoRating == "Low" {
                        numberOfValue[n] += 3
                    }
                    temp[n] += 1
                }
            }
        }
        
        for i in 0...numberOfValue.count - 1 {
            numberOfValue[i] = numberOfValue[i] / temp[i]
        }
        
        var total = 0.0
        for i in 0...chartLabel.count - 1 {
            total += Double(numberOfValue[i])
        }
        
        let ecoRatingTemp = Int(total / Double(chartLabel.count).rounded())
        if ecoRatingTemp == 3 {
            averageValue = "Low"
        }
        else if ecoRatingTemp == 2 {
            averageValue = "Medium"
        }
        else if ecoRatingTemp == 1 {
            averageValue = "High"
        }
        
        let track = chartLabel
        let money = numberOfValue
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append(entry)
        }
        
        // Chart setup
        let set = PieChartDataSet(values: entries, label: "Average EcoLife Rating (High = 1, Medium = 2, Low = 3)")
        
        // This is custom extension method.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        set.valueFont = UIFont.systemFont(ofSize: 10)
        
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        
        // User interaction
        chart.isUserInteractionEnabled = true

        chart.holeRadiusPercent = 0.4
        chart.transparentCircleColor = UIColor.clear
        
        self.scrollView.addSubview(chart)
    }
    
    func energyChart()  {
        
        chart.frame = CGRect(x: 0, y: 180, width: self.scrollView.frame.width, height: 300)
        chart.center.x = self.scrollView.center.x
        
        // Generate chart data entries
        
        for app in appliance {
            if chartLabel.count == 0 {
                chartLabel.append(app.type)
            }
            else if !chartLabel.contains(app.type) {
                chartLabel.append(app.type)
            }
        }
        
        for _ in chartLabel {
            numberOfValue.append(0.0)
            temp.append(0.0)
        }
        
        
        for i in 0...appliance.count - 1 {
            for n in 0...chartLabel.count - 1 {
                if appliance[i].type == chartLabel[n] {
                    numberOfValue[n] += Double(appliance[i].energyConsumption)!
                    temp[n] += 1
                }
            }
        }
        
        for i in 0...numberOfValue.count - 1 {
            numberOfValue[i] = numberOfValue[i] / temp[i]
        }
        
        var total = 0.0
        for i in 0...chartLabel.count - 1 {
            total += Double(numberOfValue[i])
        }
        
        averageValue = String(format: "%.1f", total / Double(chartLabel.count))
        
        let track = chartLabel
        let money = numberOfValue
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append(entry)
        }
        
        // Chart setup
        let set = PieChartDataSet(values: entries, label: "Average Energy Consumption (kWh)")
        
        // This is custom extension method.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        set.valueFont = UIFont.systemFont(ofSize: 10)
        
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        
        // User interaction
        chart.isUserInteractionEnabled = true
        
        chart.holeRadiusPercent = 0.4
        chart.transparentCircleColor = UIColor.clear
        
        self.scrollView.addSubview(chart)
    }
    
    func costChart()  {
        
        chart.frame = CGRect(x: 0, y: 180, width: self.scrollView.frame.width, height: 300)
        chart.center.x = self.scrollView.center.x
        
        // Generate chart data entries
        
        for app in appliance {
            if chartLabel.count == 0 {
                chartLabel.append(app.type)
            }
            else if !chartLabel.contains(app.type) {
                chartLabel.append(app.type)
            }
        }
        
        for _ in chartLabel {
            numberOfValue.append(0.0)
            temp.append(0.0)
        }
        
        
        for i in 0...appliance.count - 1 {
            for n in 0...chartLabel.count - 1 {
                if appliance[i].type == chartLabel[n] {
                    numberOfValue[n] += Double(appliance[i].energyConsumption)! / 3
                    temp[n] += 1
                }
            }
        }
        
        for i in 0...numberOfValue.count - 1 {
            numberOfValue[i] = numberOfValue[i] / temp[i]
        }
        
        var total = 0.0
        for i in 0...chartLabel.count - 1 {
            total += Double(numberOfValue[i])
        }
        
        averageValue = String(format: "%.1f", total / Double(chartLabel.count))
        
        let track = chartLabel
        let money = numberOfValue
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append(entry)
        }
        
        // Chart setup
        let set = PieChartDataSet(values: entries, label: "Average Electricity Cost ($)")
        
        // This is custom extension method.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        set.valueFont = UIFont.systemFont(ofSize: 10)
        
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        
        // User interaction
        chart.isUserInteractionEnabled = true

        chart.holeRadiusPercent = 0.4
        chart.transparentCircleColor = UIColor.clear
        
        self.scrollView.addSubview(chart)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartLabel.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appInfoCell", for: indexPath) as UITableViewCell
        cell.isUserInteractionEnabled = false
        for sv in cell.subviews {
            if sv.isKind(of: UILabel.self) {
                sv.removeFromSuperview()
            }
        }
        
        let labelOne = UILabel()
        labelOne.frame = CGRect(x: 20, y: 0, width: cell.frame.width, height: cell.frame.height)
        
        let labelTwo = UILabel()
        labelTwo.frame = CGRect(x: 190, y: 0, width: cell.frame.width, height: cell.frame.height)
        
        
        if indexPath.row == chartLabel.count {
            if factorOneTextField.text == "Average Star Rating" {
                
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal("Average Star Rating: ")
                    .bold(averageValue)
                
                labelOne.attributedText = formattedString
                
            }
            else if factorOneTextField.text == "Average EcoLife Rating" {
                
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal("Average EcoLife Rating: ")
                    .bold("\(averageValue)")
                
                labelOne.attributedText = formattedString
            }
            else if factorOneTextField.text == "Average Energy Consumption (kWh)" {
                
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal("Average Energy Consumption (kWh): ")
                    .bold(averageValue)
                
                labelOne.attributedText = formattedString
                
            }
            else if factorOneTextField.text == "Average Electricity Cost ($)" {
                
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal("Average Electricity Cost ($): ")
                    .bold(averageValue)
                
                labelOne.attributedText = formattedString
                
            }
            
        }
        else {
            if factorOneTextField.text == "Average Star Rating" {
                
                labelOne.text = "\(String(format: "%.0f", temp[indexPath.row])) \(chartLabel[indexPath.row])"
                labelOne.font = UIFont.systemFont(ofSize: 12)
                
                labelTwo.text = "Average Star Rating: \(String(format: "%.1f", numberOfValue[indexPath.row]))"
                labelTwo.font = UIFont.systemFont(ofSize: 12)
            }
            else if factorOneTextField.text == "Average EcoLife Rating" {
                
                labelOne.text = "\(String(format: "%.0f", temp[indexPath.row])) \(chartLabel[indexPath.row])"
                labelOne.font = UIFont.systemFont(ofSize: 12)
                
                let value = Int(numberOfValue[indexPath.row].rounded())
                var text = ""
                if  value == 3 {
                    text = "Low"
                }
                else if value == 2 {
                    text = "Medium"
                }
                else if value == 1 {
                    text = "High"
                }
                
                labelTwo.text = "Average EcoLife Rating: \(text)"
                labelTwo.font = UIFont.systemFont(ofSize: 12)
            }
            else if factorOneTextField.text == "Average Energy Consumption (kWh)" {
                labelOne.text = "\(String(format: "%.0f", temp[indexPath.row])) \(chartLabel[indexPath.row])"
                labelOne.font = UIFont.systemFont(ofSize: 12)
                
                labelTwo.text = "Average Consumption (kWh): \(String(format: "%.1f", numberOfValue[indexPath.row]))"
                labelTwo.font = UIFont.systemFont(ofSize: 10)
            }
            else if factorOneTextField.text == "Average Electricity Cost ($)" {
                
                labelOne.text = "\(String(format: "%.0f", temp[indexPath.row])) \(chartLabel[indexPath.row])"
                labelOne.font = UIFont.systemFont(ofSize: 12)
                
                labelTwo.text = "Average Cost ($): \(String(format: "%.1f", numberOfValue[indexPath.row]))"
                labelTwo.font = UIFont.systemFont(ofSize: 12)
            }
            
        }
        cell.addSubview(labelOne)
        cell.addSubview(labelTwo)
        
        return cell
    }
    
}

extension AllApplianceInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        factorOneTextField.text = pickerData[row]
    }
}


