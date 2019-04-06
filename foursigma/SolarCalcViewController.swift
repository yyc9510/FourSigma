//
//  SolarCalcViewController.swift
//  foursigma
//
//  Created by 姚逸晨 on 5/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class SolarCalcViewController: UIViewController {

    
    @IBOutlet weak var dailyConsumption: UITextField!
    @IBOutlet weak var bill: UITextField!
    
    @IBAction func dailyConsumptionButton(_ sender: Any) {
        if (dailyConsumption.text != "") {
            if (dailyConsumption.text!.isnumberordouble) {
                let daily = Double(dailyConsumption.text!)
                let num = calc(userInput: daily!)
                if (num > 0) {
                    let alert = UIAlertController(title: "Congratulation", message: "You will need \(num) solar panel(s)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Sorry...", message: "Please enter correct value!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else {
                let alert = UIAlertController(title: "Sorry...", message: "Please enter correct value!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Sorry...", message: "Please enter value!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func bullButton(_ sender: Any) {
        if (bill.text != "") {
            if (bill.text!.isnumberordouble) {
                let billNum = Double(bill.text!)
                let num = calcSystem(userInput: billNum!)
                if (num > 0) {
                    //let system = self.calcSystem(userInput: Double(num))
                    let alert = UIAlertController(title: "Congratulation", message: "You will need \(num) solar panel(s)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Sorry...", message: "Please enter correct value!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else {
                let alert = UIAlertController(title: "Sorry...", message: "Please enter correct value!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Sorry...", message: "Please enter value!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func calc(userInput: Double) -> Int {
        let kwSystem = userInput / 4.5
        let result = kwSystem / 250 * 1000
        return Int(result)
    }
    
    func calcSystem(userInput: Double) -> Int {
        let kwhDaily = userInput * 10 / 30
        let kwSystem = kwhDaily / 4.5
        let result = kwSystem / 250 * 1000
        return Int(result)
    }
    
}

extension String  {
    var isnumberordouble: Bool { return Int(self) != nil || Double(self) != nil }
}
