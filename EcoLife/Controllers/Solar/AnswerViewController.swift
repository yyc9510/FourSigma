//
//  AnswerViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 11/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionImage: UIImageView!
    
    var questionName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Related Information"
        self.questionLabel.text = questionName
        setDifferentAnswers()
        setDifferentImage()
    }
    
    func setDifferentAnswers() {
        
        if questionName == "Rebates" {
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("Eligible households can claim a rebate up to ")
                .bold("$2,225")
                .normal(" on the cost of a solar PV. A loan schema will be initiated for solar PV from ")
                .bold("July 2019")
                .normal(".")
            
            self.answerLabel.attributedText = formattedString
            //self.answerLabel.text = "Eligible households can claim a rebate up to $2,225 on the cost of a solar PV. A loan schema will be initiated for solar PV from July 2019."
        }
        else if questionName == "Consuming and Production" {
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("The electricity consuming and production is in ")
                .bold("three")
                .normal(" phases. The ")
                .bold("first")
                .normal(" phase is that electricity imported when solar panels not working i.e. night time. The ")
                .bold("second")
                .normal(" phase is that electricity generated from solar panels is consumed. The ")
                .bold("final")
                .normal(" phase is that excess electricity will be exported to the rid and get Feed-in Tariff.")
            
            self.answerLabel.attributedText = formattedString
            //self.answerLabel.text = "The electricity consuming and production is in three phases. The first phase is that electricity imported when solar panels not working i.e. night time. The second phase is that electricity generated from solar panels is consumed. The final phase is that excess electricity will be exported to the rid and get Feed-in Tariff."
        }
        else if questionName == "Feed-in Tariff" {
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("A Feed-in Tariff is the rate at which consumers are credited when ")
                .bold("they export excess electricity generation from their small-scale solar generators")
                .normal(".")
            
            self.answerLabel.attributedText = formattedString
            //self.answerLabel.text = "A Feed-in Tariff is the rate at which consumers are credited when they export excess electricity generation from their small-scale solar generators."
        }
        else if questionName == "Time Block for Feed-in Tariff" {
            self.answerLabel.text = "The following image shows the time block for Feed-in Tariff"
        }
    }
    
    func setDifferentImage() {
        
        if questionName == "Consuming and Production" {
            self.questionImage.image = UIImage(named: "consuming_image")
        }
        else if questionName == "Time Block for Feed-in Tariff" {
            self.questionImage.image = UIImage(named: "time_block_table")
        }
    }

}
