//
//  SolarSecondCalcViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 10/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import EzPopup
import SkyFloatingLabelTextField

class SolarSecondCalcViewController: UIViewController {
    
    var solarSize = ""
    
    var scrollView: UIScrollView!
    let customAlertVC = CustomAlertViewController.instantiate()
    
    var firstAnswer = SkyFloatingLabelTextField()
    var secondAnswer = SkyFloatingLabelTextField()
    var thirdAnswer = SkyFloatingLabelTextField()
    var fourthAnswer = SkyFloatingLabelTextField()
    var fifthAnswer = SkyFloatingLabelTextField()
    var sixthAnswer = SkyFloatingLabelTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 670)
        
        fourthAnswer.text = "0.7"
        fifthAnswer.text = "4.6"
        sixthAnswer.text = "0.12"
        
        initView()
    }
    
    func initView() {
        
        let title: UILabel = UILabel(frame: CGRect(x: 40, y: 30, width: 295, height: 52))
        title.center.x = self.view.center.x
        title.textAlignment = .center
        title.textColor = .black
        title.font = UIFont(name: "Optima", size: 22)
        title.text = "Step 2/3 Further Questions"
        
        let line: UILabel = UILabel(frame: CGRect(x: 16, y: 100, width: 343, height: 21))
        line.center.x = self.view.center.x
        line.textAlignment = .center
        line.textColor = .black
        line.font = UIFont(name: "Optima", size: 16)
        line.text = ".................................................................."
        
        let firstQuestion: UILabel = UILabel(frame: CGRect(x: 40, y: 142, width: 295, height: 52))
        firstQuestion.center.x = self.view.center.x
        firstQuestion.textAlignment = .left
        firstQuestion.textColor = .black
        firstQuestion.font = UIFont(name: "Optima", size: 18)
        firstQuestion.text = "1. What is the cost of your solar system ($)?"
        firstQuestion.numberOfLines = 2
        
        firstAnswer = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 210, width: 280, height: 42))
        firstAnswer.title = "System cost"
        firstAnswer.placeholder = "E.g. 10000"
        firstAnswer.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        firstAnswer.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        firstAnswer.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        
        firstAnswer.center.x = self.view.center.x
        firstAnswer.font = UIFont(name: "Optima", size: 20)
        firstAnswer.keyboardType = .decimalPad
        firstAnswer.toolbarPlaceholder = "E.g. 10000"
        firstAnswer.text = "10000"
        firstAnswer.errorColor = UIColor.red
        firstAnswer.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let firstHelpView: UIImageView = UIImageView(image: UIImage(named: "icons8-help-32.png"))
        firstHelpView.frame = CGRect(x: 322, y: 216, width: 30, height: 30)
        
        let firstHelpTap = UITapGestureRecognizer(target: self, action: #selector(SolarSecondCalcViewController.firstHelpTapped))
        firstHelpView.isUserInteractionEnabled = true
        firstHelpView.addGestureRecognizer(firstHelpTap)
        
        let secondQuestion: UILabel = UILabel(frame: CGRect(x: 40, y: 300, width: 295, height: 52))
        secondQuestion.center.x = self.view.center.x
        secondQuestion.textAlignment = .left
        secondQuestion.textColor = .black
        secondQuestion.font = UIFont(name: "Optima", size: 18)
        secondQuestion.text = "2. What is the cost of electricity per kW($)?"
        secondQuestion.numberOfLines = 2
        
        secondAnswer = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 368, width: 280, height: 42))
        secondAnswer.title = "Electricity cost"
        secondAnswer.placeholder = "E.g. 0.23"
        secondAnswer.text = "0.23"
        secondAnswer.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        secondAnswer.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        secondAnswer.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        
        secondAnswer.center.x = self.view.center.x
        secondAnswer.font = UIFont(name: "Optima", size: 20)
        secondAnswer.keyboardType = .decimalPad
        secondAnswer.toolbarPlaceholder = "E.g. 0.23"
        
        let secondHelpView: UIImageView = UIImageView(image: UIImage(named: "icons8-help-32.png"))
        secondHelpView.frame = CGRect(x: 322, y: 374, width: 30, height: 30)
        
        let secondHelpTap = UITapGestureRecognizer(target: self, action: #selector(SolarSecondCalcViewController.secondHelpTapped))
        secondHelpView.isUserInteractionEnabled = true
        secondHelpView.addGestureRecognizer(secondHelpTap)
        
        let thirdQuestion: UILabel = UILabel(frame: CGRect(x: 40, y: 458, width: 295, height: 52))
        thirdQuestion.center.x = self.view.center.x
        thirdQuestion.textAlignment = .left
        thirdQuestion.textColor = .black
        thirdQuestion.font = UIFont(name: "Optima", size: 18)
        thirdQuestion.text = "3. What is the average daily household energy usage (kW)?"
        thirdQuestion.numberOfLines = 2
        
        thirdAnswer = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 524, width: 280, height: 42))
        thirdAnswer.title = "Energy usage"
        thirdAnswer.placeholder = "E.g. 19"
        thirdAnswer.text = "19"
        thirdAnswer.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        thirdAnswer.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        thirdAnswer.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        
        thirdAnswer.center.x = self.view.center.x
        thirdAnswer.font = UIFont(name: "Optima", size: 20)
        thirdAnswer.keyboardType = .decimalPad
        thirdAnswer.toolbarPlaceholder = "E.g. 19"
        
        let thirdHelpView: UIImageView = UIImageView(image: UIImage(named: "icons8-help-32.png"))
        thirdHelpView.frame = CGRect(x: 322, y: 530, width: 30, height: 30)
        
        let thirdHelpTap = UITapGestureRecognizer(target: self, action: #selector(SolarSecondCalcViewController.secondHelpTapped))
        thirdHelpView.isUserInteractionEnabled = true
        thirdHelpView.addGestureRecognizer(thirdHelpTap)
        
//        let fourthQuestion: UILabel = UILabel(frame: CGRect(x: 40, y: 614, width: 295, height: 52))
//        fourthQuestion.center.x = self.view.center.x
//        fourthQuestion.textAlignment = .left
//        fourthQuestion.textColor = .black
//        fourthQuestion.font = UIFont(name: "Optima", size: 18)
//        fourthQuestion.text = "4. What is the self-consumption vs export?"
//        fourthQuestion.numberOfLines = 2
//
//        fourthAnswer = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 680, width: 295, height: 42))
//        fourthAnswer.title = "Self-consumption"
//        fourthAnswer.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
//        fourthAnswer.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
//        fourthAnswer.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
//
//        fourthAnswer.center.x = self.view.center.x
//        fourthAnswer.font = UIFont(name: "Optima", size: 20)
//        fourthAnswer.keyboardType = .decimalPad
//        fourthAnswer.toolbarPlaceholder = "E.g. 0.7 = 70% self-consumption"
//        fourthAnswer.errorColor = UIColor.red
//        fourthAnswer.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//
//        let fourthHelpView: UIImageView = UIImageView(image: UIImage(named: "icons8-help-32.png"))
//        fourthHelpView.frame = CGRect(x: 337, y: 686, width: 30, height: 30)
//
//        let fourthHelpTap = UITapGestureRecognizer(target: self, action: #selector(SolarSecondCalcViewController.fourthHelpTapped))
//        fourthHelpView.isUserInteractionEnabled = true
//        fourthHelpView.addGestureRecognizer(fourthHelpTap)
//
//        let fifthQuestion: UILabel = UILabel(frame: CGRect(x: 40, y: 770, width: 295, height: 52))
//        fifthQuestion.center.x = self.view.center.x
//        fifthQuestion.textAlignment = .left
//        fifthQuestion.textColor = .black
//        fifthQuestion.font = UIFont(name: "Optima", size: 18)
//        fifthQuestion.text = "5. What is the average daily sun hours (average is 4.6)?"
//        fifthQuestion.numberOfLines = 2
//
//        fifthAnswer = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 836, width: 295, height: 42))
//        fifthAnswer.title = "Sun hours"
//        fifthAnswer.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
//        fifthAnswer.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
//        fifthAnswer.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
//
//        fifthAnswer.center.x = self.view.center.x
//        fifthAnswer.font = UIFont(name: "Optima", size: 20)
//        fifthAnswer.keyboardType = .decimalPad
//        fifthAnswer.toolbarPlaceholder = "E.g. 4.6"
//
//        let fifthHelpView: UIImageView = UIImageView(image: UIImage(named: "icons8-help-32.png"))
//        fifthHelpView.frame = CGRect(x: 337, y: 842, width: 30, height: 30)
//
//        let fifthHelpTap = UITapGestureRecognizer(target: self, action: #selector(SolarSecondCalcViewController.fifthHelpTapped))
//        fifthHelpView.isUserInteractionEnabled = true
//        fifthHelpView.addGestureRecognizer(fifthHelpTap)
//
//        let sixthQuestion: UILabel = UILabel(frame: CGRect(x: 40, y: 926, width: 295, height: 52))
//        sixthQuestion.center.x = self.view.center.x
//        sixthQuestion.textAlignment = .left
//        sixthQuestion.textColor = .black
//        sixthQuestion.font = UIFont(name: "Optima", size: 18)
//        sixthQuestion.text = "6. What is the feed-in tariff ($)(average is 0.12)?"
//        sixthQuestion.numberOfLines = 2
//
//        sixthAnswer = SkyFloatingLabelTextField(frame: CGRect(x: 40, y: 992, width: 295, height: 42))
//        sixthAnswer.title = "Feed-in Tariff"
//        sixthAnswer.tintColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
//        sixthAnswer.selectedTitleColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
//        sixthAnswer.selectedLineColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
//
//        sixthAnswer.center.x = self.view.center.x
//        sixthAnswer.font = UIFont(name: "Optima", size: 20)
//        sixthAnswer.keyboardType = .decimalPad
//        sixthAnswer.toolbarPlaceholder = "E.g. 0.12"
//
//        let sixthHelpView: UIImageView = UIImageView(image: UIImage(named: "icons8-help-32.png"))
//        sixthHelpView.frame = CGRect(x: 337, y: 998, width: 30, height: 30)
//
//        let sixthHelpTap = UITapGestureRecognizer(target: self, action: #selector(SolarSecondCalcViewController.sixthHelpTapped))
//        sixthHelpView.isUserInteractionEnabled = true
//        sixthHelpView.addGestureRecognizer(sixthHelpTap)
        
        let nextButton: UIButton = UIButton(frame: CGRect(x: 108, y: 614, width: 158, height: 43))
        nextButton.center.x = self.view.center.x
        nextButton.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        nextButton.setTitle("Next Step", for: .normal)
        
        nextButton.addTarget(self, action: #selector(nextStepTapped), for: .touchUpInside)

        
        scrollView.addSubview(title)
        scrollView.addSubview(line)
        scrollView.addSubview(firstQuestion)
        scrollView.addSubview(firstAnswer)
        scrollView.addSubview(firstHelpView)
        scrollView.addSubview(secondQuestion)
        scrollView.addSubview(secondAnswer)
        scrollView.addSubview(secondHelpView)
        scrollView.addSubview(thirdQuestion)
        scrollView.addSubview(thirdAnswer)
        scrollView.addSubview(thirdHelpView)
//        scrollView.addSubview(fourthQuestion)
//        scrollView.addSubview(fourthAnswer)
//        scrollView.addSubview(fourthHelpView)
//        scrollView.addSubview(fifthQuestion)
//        scrollView.addSubview(fifthAnswer)
//        scrollView.addSubview(fifthHelpView)
//        scrollView.addSubview(sixthQuestion)
//        scrollView.addSubview(sixthAnswer)
//        scrollView.addSubview(sixthHelpView)
        scrollView.addSubview(nextButton)
        
        self.view.addSubview(scrollView)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
        if let text = firstAnswer.text {
            if let floatingLabelTextField = firstAnswer as? SkyFloatingLabelTextField{
                if((text as NSString).doubleValue > 50000 || (text as NSString).doubleValue < 0) || !text.matches("[0-9.]"){
                    floatingLabelTextField.errorMessage = "Wrong Value"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func firstHelpTapped() {
        
//        guard let customAlertVC = customAlertVC else { return }
//
//        customAlertVC.titleString = "Check the cost"
//        customAlertVC.messageString = "The cost of whole solar system."
//
//        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
//        popupVC.cornerRadius = 5
//        present(popupVC, animated: true, completion: nil)
        showPopupView(title: "Check the cost", message: "The cost of whole solar system.")
    }
    
    @objc func secondHelpTapped() {
        
//        guard let customAlertVC = customAlertVC else { return }
//
//        customAlertVC.titleString = "Check your bill"
//        customAlertVC.messageString = "The information is on your electricity bill."
//
//        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
//        popupVC.cornerRadius = 5
//        present(popupVC, animated: true, completion: nil)
        showPopupView(title: "Check your bill", message: "The information is on your electricity bill.")
    }
    
    @objc func fourthHelpTapped() {
        
//        guard let customAlertVC = customAlertVC else { return }
//
//        customAlertVC.titleString = "Self-consumption in decimal"
//        customAlertVC.messageString = "The value should be bigger than 0 and smaller than 1."
//
//        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
//        popupVC.cornerRadius = 5
//        present(popupVC, animated: true, completion: nil)
        showPopupView(title: "Self-consumption in decimal", message: "The value should be bigger than 0 and smaller than 1.")
    }
    
    @objc func fifthHelpTapped() {
        
//        guard let customAlertVC = customAlertVC else { return }
//
//        customAlertVC.titleString = "Average daily sun hours"
//        customAlertVC.messageString = "The suggestion answer is 4.6."
//
//        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
//        popupVC.cornerRadius = 5
//        present(popupVC, animated: true, completion: nil)
        showPopupView(title: "Average daily sun hours", message: "The suggestion answer is 4.6.")
    }
    
    @objc func sixthHelpTapped() {
        
//        guard let customAlertVC = customAlertVC else { return }
//
//        customAlertVC.titleString = "Feed-in Tariff"
//        customAlertVC.messageString = "The suggestion answer is 0.12."
//
//        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
//        popupVC.cornerRadius = 5
//        present(popupVC, animated: true, completion: nil)
        showPopupView(title: "Feed-in Tariff", message: "The suggestion answer is 0.12.")
    }
    
    @objc func nextStepTapped() {
        if firstAnswer.text != "" && secondAnswer.text != "" && thirdAnswer.text != "" && fourthAnswer.text != "" && fifthAnswer.text != "" && sixthAnswer.text != "" {
            let temp = (fourthAnswer.text! as NSString).doubleValue
            if temp < 1 && temp > 0 {
                performSegue(withIdentifier: "thirdStepSegue", sender: "")
            }
            else {
                let alert = UIAlertController(title: "Wrong value", message: "self-consumption vs export must be smaller 1 and bigger than 0", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Missing value(s)", message: "Empty value is not allowed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "thirdStepSegue") {
            let vc = segue.destination as! SolarCalcResultViewController
            vc.solarSize = self.solarSize
            vc.systemCost = (self.firstAnswer.text! as NSString).doubleValue
            vc.electricityCost = (self.secondAnswer.text! as NSString).doubleValue
            vc.dailyUsage = (self.thirdAnswer.text! as NSString).doubleValue
            vc.selfConsumption = 0.7
            vc.sunHours = 4.6
            vc.feedInTariff = 0.12
//            vc.selfConsumption = (self.fourthAnswer.text! as NSString).doubleValue
//            vc.sunHours = (self.fifthAnswer.text! as NSString).doubleValue
//            vc.feedInTariff = (self.sixthAnswer.text! as NSString).doubleValue
        }
    }
    
    func showPopupView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension String  {
    var isnumberordouble: Bool { return Int(self) != nil || Double(self) != nil }
}
