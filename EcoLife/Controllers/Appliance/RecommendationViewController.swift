//
//  RecommendationViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 13/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RecommendationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var type = ""
    var selectedAppliance: Appliance!
    var tableView = UITableView()
    var factorOneTextField = SkyFloatingLabelTextField()
    var factorTwoTextField = SkyFloatingLabelTextField()
    var button = UIButton()
    
    var factorPickerData = ["Energy Consumption", "Star Rating", "EcoLife Rating"]
    var factorTwoPickerData = [String]()
    
    var allApplianceList = [Appliance]()
    var recommendationList = [Appliance]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Recommendation"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "recommendationCell")
        
        createFactorOnePicker()
        createFactorTwoPicker()
        createToolBar()
        
        initValue()
        sortAppliance(factorOne: factorPickerData[0], factorTwo: factorTwoPickerData[0])
        initView()
    }
    
    func initValue() {
        
        self.type = selectedAppliance.type
        
        let url = Bundle.main.url(forResource: type, withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! NSDictionary
            
            let dictionary = json[type] as! NSDictionary
            for allBrands in dictionary.allKeys {
                
                let newBrand = Brand(name: allBrands as! String, isSelected: false)
                
                let modelValue = dictionary.value(forKey: allBrands as! String) as! NSDictionary
                
                for allModels in modelValue.allKeys {
                    
                    let newModel = Model(name: allModels as! String, isSelected: false)
                    let dataValue = modelValue.value(forKey: allModels as! String) as! NSDictionary
                    
                    let sizeTemp = dataValue["Size"] as! String
                    let manufacturer = dataValue["Manufacturing Countries"] as! String
                    let energy = dataValue["Comparative Energy Consumption"] as! String
                    let rating = dataValue["Star Rating"] as! String
                    
                    let ecoRating = dataValue["EcoLife Rating"] as! String
                    
                    var color = ""
                    
                    if type == "Computer Monitor" {
                        color = "#16A58C"
                    }
                    else if type == "Washing Machines" {
                        color = "#E38A08"
                    }
                    else if type == "Dryers" {
                        color = "#207DE2"
                    }
                    else if type == "Dishwashers" {
                        color = "#D3267E"
                    }
                    else if type == "Fridges and Freezers" {
                        color = "#4616BC"
                    }
                    else if type == "Televisions" {
                        color = "#8700B5"
                    }
                    
                    let app = Appliance(brand: newBrand, model: newModel, manufacturer: manufacturer, energyConsumption: energy, rating: rating, type: type, size: sizeTemp, ecoRating: ecoRating, backColor: color, icon: UIImage(named: type)!)
                    
                    allApplianceList.append(app)
                }
            }
        }
        catch {
            print(error)
        }
        
        for app in allApplianceList {
            if !factorTwoPickerData.contains(app.brand.name) {
                factorTwoPickerData.append(app.brand.name)
            }
        }
        
        factorTwoPickerData.sort(by: { $0 < $1})
        
    }
    
    func sortAppliance(factorOne: String, factorTwo: String) {
        recommendationList.removeAll()
        var sortedAppliance = [Appliance]()
        
        for app in allApplianceList {
            if app.brand.name == factorTwo {
                sortedAppliance.append(app)
            }
        }
        
        if factorOne == "Energy Consumption" {
            
            sortedAppliance = sortedAppliance.sorted(by: { $0.energyConsumption < $1.energyConsumption })
            if sortedAppliance.count >= 5 {
                recommendationList.append(sortedAppliance[0])
                recommendationList.append(sortedAppliance[1])
                recommendationList.append(sortedAppliance[2])
                recommendationList.append(sortedAppliance[3])
                recommendationList.append(sortedAppliance[4])
            }
            else {
                recommendationList = sortedAppliance
            }
        }
        else if factorOne == "Star Rating" {
            sortedAppliance = sortedAppliance.sorted(by: { $0.rating > $1.rating })
            if sortedAppliance.count >= 5 {
                recommendationList.append(sortedAppliance[0])
                recommendationList.append(sortedAppliance[1])
                recommendationList.append(sortedAppliance[2])
                recommendationList.append(sortedAppliance[3])
                recommendationList.append(sortedAppliance[4])
            }
            else {
                recommendationList = sortedAppliance
            }
        }
        else if factorOne == "EcoLife Rating" {
            sortedAppliance = sortedAppliance.sorted(by: { $0.rating > $1.rating })
            
            var sortedApp = [Appliance]()
            for app in sortedAppliance {
                if app.ecoRating == "Low" {
                    sortedApp.append(app)
                }
            }
            if sortedApp.count == 0 {
                for app in sortedAppliance {
                    if app.ecoRating == "Medium" {
                        sortedApp.append(app)
                    }
                }
            }
            else if sortedApp.count == 0 {
                for app in sortedAppliance {
                    if app.ecoRating == "High" {
                        sortedApp.append(app)
                    }
                }
            }
            
            if sortedApp.count >= 5 {
                recommendationList.append(sortedApp[0])
                recommendationList.append(sortedApp[1])
                recommendationList.append(sortedApp[2])
                recommendationList.append(sortedApp[3])
                recommendationList.append(sortedApp[4])
            }
            else {
                recommendationList = sortedApp
            }
            
        }
        
    }
    
    func initView() {
        factorOneTextField.frame = CGRect(x: 0, y: 20, width: self.view.frame.width * 0.7, height: 50)
        factorOneTextField.center.x = self.view.center.x
        factorOneTextField.text = "Energy Consumption"
        factorOneTextField.placeholder = "Please choose one factor"
        factorOneTextField.title = "Filter"
        factorOneTextField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        factorOneTextField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        factorOneTextField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        self.view.addSubview(factorOneTextField)
        
        factorTwoTextField.frame = CGRect(x: 0, y: 90, width: self.view.frame.width * 0.7, height: 50)
        factorTwoTextField.center.x = self.view.center.x
        factorTwoTextField.text = factorTwoPickerData[0]
        factorTwoTextField.placeholder = "Please choose one brand"
        factorTwoTextField.title = "Brand Name"
        factorTwoTextField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        factorTwoTextField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        factorTwoTextField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        self.view.addSubview(factorTwoTextField)
        
        button.frame = CGRect(x: 0, y: 170, width: self.view.frame.width * 0.4, height: 50)
        button.center.x = self.view.center.x
        button.setTitle("Find", for: .normal)
        button.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(resetData), for: .touchUpInside)
        self.view.addSubview(button)
        
        tableView.frame = CGRect(x: 0, y: 250, width: self.view.frame.width, height: self.view.frame.height - 370)
        //tableView.separatorStyle = .none
        self.view.addSubview(tableView)
    }
    
    @objc func resetData() {
        sortAppliance(factorOne: factorOneTextField.text!, factorTwo: factorTwoTextField.text!)
        tableView.reloadData()
    }
    
    func createFactorOnePicker() {
        let factorPicker = UIPickerView()
        factorPicker.delegate = self
        factorPicker.tag = 1
        factorOneTextField.inputView = factorPicker
        factorPicker.backgroundColor = .white
    }
    
    func createFactorTwoPicker() {
        let factorPicker = UIPickerView()
        factorPicker.delegate = self
        factorPicker.tag = 2
        factorTwoTextField.inputView = factorPicker
        factorPicker.backgroundColor = .white
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RecommendationViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        factorOneTextField.inputAccessoryView = toolBar
        factorTwoTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendationCell", for: indexPath) as UITableViewCell
        
        for sv in cell.subviews {
            if sv.isKind(of: UILabel.self) || sv.isKind(of: UIImageView.self) {
                sv.removeFromSuperview()
            }
        }
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        imageView.image = UIImage(named: "rank\(indexPath.row)")
        
        let label = UILabel()
        label.frame = CGRect(x: 70, y: 0, width: cell.frame.width - 70, height: cell.frame.height / 2)
        label.text = "\(recommendationList[indexPath.row].model.name)"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        let labelTwo = UILabel()
        labelTwo.frame = CGRect(x: 70, y: cell.frame.height / 2, width: cell.frame.width - 70, height: cell.frame.height / 4)
        labelTwo.text = "Energy Consumption: \(recommendationList[indexPath.row].energyConsumption)"
        labelTwo.font = UIFont.systemFont(ofSize: 10)
        
        let labelThree = UILabel()
        labelThree.frame = CGRect(x: 70, y: cell.frame.height * 3 / 4, width: cell.frame.width - 70, height: cell.frame.height / 4)
        labelThree.text = "Star Rating: \(recommendationList[indexPath.row].rating)     EcoLife Rating: \(recommendationList[indexPath.row].ecoRating)"
        labelThree.font = UIFont.systemFont(ofSize: 10)
        
        cell.addSubview(imageView)
        cell.addSubview(label)
        cell.addSubview(labelTwo)
        cell.addSubview(labelThree)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension RecommendationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return factorPickerData.count
        }
        else {
            return factorTwoPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return factorPickerData[row]
        }
        else {
            return factorTwoPickerData[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            factorOneTextField.text = factorPickerData[row]
        }
        else {
            factorTwoTextField.text = factorTwoPickerData[row]
        }
    }
}
