//
//  CarbonViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 1/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import EzPopup
import SkyFloatingLabelTextField

class CarbonViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var landfillTextField = SkyFloatingLabelTextField()
    var compostTextField = SkyFloatingLabelTextField()
    let customAlertVC = CustomAlertViewController.instantiate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Carbon Emission"
        initView()
    }
    
    func initView() {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 700)
        
        let firstQuestion: UILabel = UILabel(frame: CGRect(x: 40, y: 80, width: 295, height: 52))
        firstQuestion.center.x = self.view.center.x
        firstQuestion.textAlignment = .left
        firstQuestion.textColor = .black
        firstQuestion.font = UIFont(name: "Optima", size: 18)
        firstQuestion.text = "1. What is the quantity of landfilled waste per week (in kg)?"
        firstQuestion.numberOfLines = 2
        
        landfillTextField = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 148, width: 295, height: 42))
        landfillTextField.title = "Positive integer"
        landfillTextField.placeholder = "E.g. 10"
        landfillTextField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        landfillTextField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        landfillTextField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        
        landfillTextField.center.x = self.view.center.x
        landfillTextField.font = UIFont(name: "Optima", size: 20)
        landfillTextField.keyboardType = .decimalPad
        landfillTextField.toolbarPlaceholder = "E.g. 10"
        landfillTextField.errorColor = UIColor.red
        landfillTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let secondQuestion: UILabel = UILabel(frame: CGRect(x: 40, y: 260, width: 295, height: 52))
        secondQuestion.center.x = self.view.center.x
        secondQuestion.textAlignment = .left
        secondQuestion.textColor = .black
        secondQuestion.font = UIFont(name: "Optima", size: 18)
        secondQuestion.text = "2. What is the quantity of composted waste per week (in kg)?"
        secondQuestion.numberOfLines = 2
        
        compostTextField = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 328, width: 295, height: 42))
        compostTextField.title = "Positive integer"
        compostTextField.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        compostTextField.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        compostTextField.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        
        compostTextField.center.x = self.view.center.x
        compostTextField.font = UIFont(name: "Optima", size: 20)
        compostTextField.keyboardType = .decimalPad
        compostTextField.placeholder = "E.g. 10"
        compostTextField.toolbarPlaceholder = "E.g. 10"
        compostTextField.errorColor = UIColor.red
        compostTextField.addTarget(self, action: #selector(textFieldDidChangeTwo(_:)), for: .editingChanged)
        
        let checkResult = UIButton(frame: CGRect(x: 40, y: 460, width: 150, height: 40))
        checkResult.setTitle("Check Result", for: .normal)
        checkResult.titleLabel?.font = UIFont(name: "Optima", size: 16)
        checkResult.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        checkResult.titleLabel?.textAlignment = .center
        checkResult.titleLabel?.textColor = .white
        checkResult.center.x = self.view.center.x
        checkResult.addTarget(self, action: #selector(check), for: .touchUpInside)
        
        self.scrollView.addSubview(firstQuestion)
        self.scrollView.addSubview(landfillTextField)
        self.scrollView.addSubview(secondQuestion)
        self.scrollView.addSubview(compostTextField)
        self.scrollView.addSubview(checkResult)
        self.view.addSubview(scrollView)
    }
    
    @objc func check() {
        let landfillInput = landfillTextField.text
        let compostInput = compostTextField.text
        if  landfillInput != "" &&  compostInput != "" {
            if !(landfillInput! as NSString).contains(".") && !(compostInput! as NSString).contains(".") && (landfillInput! as NSString).integerValue <= 100 && (compostInput! as NSString).integerValue <= 100 && (landfillInput! as NSString).integerValue > 0 && (compostInput! as NSString).integerValue > 0{
                performSegue(withIdentifier: "carbonResult", sender: "")
                
            }
            else {
                popUp()
            }
        }
        else {
           popUp()
        }
    }
    
    func popUp() {
        guard let customAlertVC = customAlertVC else { return }
        
        customAlertVC.titleString = "Wrong Value"
        customAlertVC.messageString = "Please check the input"
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
        if let text = landfillTextField.text {
            if let floatingLabelTextField = landfillTextField as? SkyFloatingLabelTextField{
                if((text as NSString).contains(".") || (text as NSString).integerValue <= 0 || (text as NSString).integerValue > 100) {
                    floatingLabelTextField.errorMessage = "Wrong Value"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func textFieldDidChangeTwo(_ textfield: UITextField) {
        
        if let text = compostTextField.text {
            if let floatingLabelTextField = compostTextField as? SkyFloatingLabelTextField{
                if((text as NSString).contains(".") || (text as NSString).integerValue <= 0 || (text as NSString).integerValue > 100) {
                    floatingLabelTextField.errorMessage = "Wrong Value"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "carbonResult") {
            let vc = segue.destination as! CarbonResultViewController
            vc.landfill = (self.landfillTextField.text! as NSString).integerValue 
            vc.compost = (self.compostTextField.text! as NSString).integerValue 
        }
    }
}
