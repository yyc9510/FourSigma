//
//  ComparisonViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 2/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ComparisonViewController: UIViewController {

    let comparisonPickerData = ["Computer Monitor", "Washing Machines", "Fridges and Freezers", "Televisions", "Dryers", "Dishwashers"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Comparison"
        
        createDataSourcePicker()
        createToolBar()
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    let comparisonType: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Appliances Types"
        textField.title = "Appliances Types"
        textField.text = "Computer Monitor"
        textField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        textField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        textField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints=false
        return textField
    }()
    
    let btnGetStarted: UIButton = {
        let btn=UIButton()
        btn.setTitle("Get Started", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.orange
        btn.layer.cornerRadius=5
        btn.layer.masksToBounds=true
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnGetStartedAction), for: .touchUpInside)
        return btn
    }()
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text="Appliances Comparison"
        lbl.textColor=UIColor.darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 30)
        lbl.numberOfLines=2
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let subTitle: UILabel = {
        let lbl=UILabel()
        lbl.text="Comparing the manufacturers, energy consumption and star ratings"
        lbl.textColor=UIColor.darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.numberOfLines=2
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    @objc func btnGetStartedAction() {
        performSegue(withIdentifier: "comparisonDetail", sender: "")
    }
    
    func createDataSourcePicker() {
        let dataSourcePicker = UIPickerView()
        dataSourcePicker.delegate = self
        comparisonType.inputView = dataSourcePicker
        dataSourcePicker.backgroundColor = .white
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CompostQuizViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        comparisonType.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func initView() {
        
        self.view.addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive=true
        lblTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblTitle.widthAnchor.constraint(equalToConstant: 350).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 60).isActive=true
        
        
        self.view.addSubview(subTitle)
        subTitle.heightAnchor.constraint(equalToConstant: 50).isActive=true
        subTitle.widthAnchor.constraint(equalToConstant: 250).isActive=true
        subTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        subTitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(comparisonType)
        comparisonType.topAnchor.constraint(equalTo: subTitle.topAnchor, constant: 150).isActive=true
        comparisonType.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        comparisonType.widthAnchor.constraint(equalToConstant: 250).isActive=true
        comparisonType.heightAnchor.constraint(equalToConstant: 60).isActive=true
        
        self.view.addSubview(btnGetStarted)
        btnGetStarted.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnGetStarted.widthAnchor.constraint(equalToConstant: 150).isActive=true
        btnGetStarted.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        btnGetStarted.topAnchor.constraint(equalTo: comparisonType.bottomAnchor, constant: 100).isActive=true
        
    }
    
    
}

extension ComparisonViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return comparisonPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(comparisonPickerData[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        comparisonType.text = comparisonPickerData[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "comparisonDetail") {
            let vc = segue.destination as! ComparisonDetailViewController
            let type = comparisonType.text!
            
            vc.type = type
            
            var brands = [Brand]()
            var models = [[Model]]()
            var info = [Appliance]()
            
            let url = Bundle.main.url(forResource: type, withExtension: "json")!
            do {
                let jsonData = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: jsonData) as! NSDictionary
                
                let dictionary = json[type] as! NSDictionary
                for allBrands in dictionary.allKeys {
                    let newBrand = Brand(name: allBrands as! String, isSelected: false)
                    brands.append(newBrand)
                    
                    var modelInBrand = [Model]()
                    //var dataInBrand = [Info]()
                    let modelValue = dictionary.value(forKey: allBrands as! String) as! NSDictionary
                    
                    for allModels in modelValue.allKeys {
                        let newModel = Model(name: allModels as! String, isSelected: false)
                        modelInBrand.append(newModel)
                
                        let dataValue = modelValue.value(forKey: allModels as! String) as! NSDictionary
                        
                        let manufacturer = dataValue["Manufacturing Countries"] as! String
                        let energy = dataValue["Comparative Energy Consumption"] as! String
                        let rating = dataValue["Star Rating"] as! String
                        
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
                        
                        let app = Appliance(brand: newBrand, model: newModel, manufacturer: manufacturer, energyConsumption: energy, rating: rating, type: type, backColor: color, icon: UIImage(named: type)!)

                        info.append(app)
                    }
                    models.append(modelInBrand)
                }
                
                brands[0].isSelected = true
                
                vc.brands = brands
                vc.models = models
                vc.data = info
            }
            catch {
                print(error)
            }

        }
    }
}
