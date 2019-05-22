//
//  SolarCalcViewController.swift
//  foursigma
//
//  Created by 姚逸晨 on 5/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import EzPopup
import SkyFloatingLabelTextField

class SolarCalcViewController: UIViewController {

    let peoplePickerData = ["1-2", "2-3", "3-4", "4+"]
    let solarPickerData = ["2kW", "3kW", "4kW", "5kW"]
    
    let customAlertVC = CustomAlertViewController.instantiate()
    
    var peopleTextField = SkyFloatingLabelTextField()
    var solarTextField = SkyFloatingLabelTextField()
    
    var dropDownImageViewOne = UIImageView()
    var dropDownImageViewTwo = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func firstStepButton(_ sender: Any) {
        if peopleTextField.text != "" && solarTextField.text != "" {
            performSegue(withIdentifier: "secondStepSegue", sender: "")
        }
        else {
            let alert = UIAlertController(title: "Missing value(s)", message: "Empty value is not allowed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 570)
        
        generateBarButtonItem()
        setUpLabel()
        createPeoplePicker()
        createSolarPicker()
        createToolBar()
    }
    
    func generateBarButtonItem() {
        
        let helpMe = UIImage(named: "icons8-help-32.png")
        let helpMeTwo = helpMe!.resizeImage(CGSize(width:25, height: 25))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: helpMeTwo, style: .plain, target: self, action: #selector(helpTapped))
    }
    
    func setUpLabel() {
        
        dropDownImageViewOne.frame = CGRect(x: 305, y: 228, width: 20, height: 20)
        dropDownImageViewOne.image = UIImage(named: "expand")
        dropDownImageViewTwo.frame = CGRect(x: 305, y: 408, width: 20, height: 20)
        dropDownImageViewTwo.image = UIImage(named: "expand")
        
        peopleTextField = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 213, width: 295, height: 45))
        solarTextField = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 393, width: 295, height: 45))
    
        peopleTextField.placeholder = "E.g. 3-4"
        peopleTextField.text = "1-2"
        peopleTextField.title = "Family Size"
        peopleTextField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        peopleTextField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        peopleTextField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        
        self.scrollView.addSubview(peopleTextField)
    
        solarTextField.placeholder = "E.g. 4kW"
        solarTextField.text = "3kW"
        solarTextField.title = "Solar Panel Size"
        solarTextField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        solarTextField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        solarTextField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
    
        self.scrollView.addSubview(solarTextField)
        self.scrollView.addSubview(dropDownImageViewOne)
        self.scrollView.addSubview(dropDownImageViewTwo)
    }
    
    func createPeoplePicker() {
        let peoplePicker = UIPickerView()
        peoplePicker.delegate = self
        peoplePicker.tag = 1
        peopleTextField.inputView = peoplePicker
        peoplePicker.backgroundColor = .white
    }
    
    @objc func helpTapped() {
        
        guard let customAlertVC = customAlertVC else { return }
        
        customAlertVC.titleString = "Solar Panel Size"
        customAlertVC.messageString = "We provide suggestion for solar panel size based on the number of people living in a household"
        //"1-2 person households: 2kW solar panel.\n2-3 person households: 3kW solar panel.\n3-4 person households: 4kW solar panel.\n4+ person households: 5kW solar panel."
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    func createSolarPicker() {
        let solarPicker = UIPickerView()
        solarPicker.delegate = self
        solarPicker.tag = 2
        solarTextField.inputView = solarPicker
        solarPicker.backgroundColor = .white
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SolarCalcViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        peopleTextField.inputAccessoryView = toolBar
        solarTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "secondStepSegue") {
            let vc = segue.destination as! SolarSecondCalcViewController
            vc.solarSize = self.solarTextField.text!
        }
    }
    
}

extension SolarCalcViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return peoplePickerData.count
        }
        else {
            return solarPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(peoplePickerData[row])"
        }
        else {
            return "\(solarPickerData[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            peopleTextField.text = peoplePickerData[row]
            if solarTextField.text == "" {
                solarTextField.text = solarPickerData[row]
            }
        }
        else {
            solarTextField.text = solarPickerData[row]
        }
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}


