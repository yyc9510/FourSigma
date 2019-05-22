//
//  GrowVegetableViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 2/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import EzPopup

class GrowVegetableViewController: UIViewController {
    
    var vegetablePassData = ""
    var vegetableData = [["Basil", "30", "2", "4"], ["Beans", "130", "3", "4"], ["Beetroot", "180", "1", "6"], ["Broad Beans", "135", "1", "5"], ["Broccoli", "125", "1", "5"], ["Brussel Sprouts", "240", "1", "5"], ["Cabbage", "90", "2", "4"], ["Capsicum", "70", "3", "5"], ["Carrot", "360", "2", "3"], ["Cauliflower", "90", "2", "1.5"], ["Chilli", "130", "4", "5"], ["Chives", "45", "1", "1"], ["Corainder", "40", "2", "4"], ["Corn", "120", "1", "2"], ["Cucumber", "60", "1", "2"], ["Eggplant", "45", "2", "2"], ["Garlic", "110", "2", "2"], ["Kale", "90", "1", "4"], ["Leek", "150", "3", "3"], ["Lettuce", "35", "3", "4"], ["Mint", "100", "1", "4"], ["Onion", "330", "3", "2"], ["Oregano", "160", "1", "2"], ["Pak Choy", "45", "2", "1"], ["Parsley", "65", "3", "3"], ["Peas", "120", "1", "2"], ["Potatoes", "100", "1", "2"], ["Pumpkin", "150", "4", "2"], ["Radish", "45", "1", "1.5"], ["Rocket", "50", "4", "1"], ["Silverbeet", "65", "1", "6"], ["Snow Peas", "110", "1", "2"], ["Spinach", "40", "4", "3"], ["Spring Onion", "180", "2", "4"], ["Sunflower", "330", "1", "2"], ["Sweet Corn", "120", "1", "2"], ["Tomato", "130", "2", "2"], ["Zucchini", "65", "1", "2"]]
    var vegetableDetail = [String]()
    
    var scrollView = UIScrollView()
    var fertilizer = UISlider()
    var water = UISlider()
    
    var fertilizerData = 0.5
    var waterData = 0.5
    
    var imageView = UIImageView()
    var borderImageView = UIImageView()
    
    var progressView = UIProgressView()
    let start = UIButton()
    var progressBarTimer: Timer!
    
    var currentFertilizer = UILabel()
    var currentWater = UILabel()
    
    var isRunning = false
    let customAlertVC = CustomAlertViewController.instantiate()
    let customAlertVCTwo = CustomAlertViewController.instantiate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0.0
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 600)
        
        self.title = "Grow \(vegetablePassData)"
        self.view.backgroundColor = .white
        
        insertData()
        print(vegetableDetail)
        setUpView()
        setUpSlider()
        self.view.addSubview(scrollView)
    }
    
    func insertData() {
        for i in vegetableData {
            if i[0] == vegetablePassData {
                vegetableDetail.append(i[1])
                vegetableDetail.append(i[2])
                vegetableDetail.append(i[3])
            }
        }
    }
    
    func setUpSlider() {
        
        let fertilizerLabel = UILabel(frame: CGRect(x: 20, y: 250, width: 200, height: 30))
        fertilizerLabel.textAlignment = .center
        fertilizerLabel.font = UIFont(name: "Optima", size: 16)
        fertilizerLabel.center.x = self.view.center.x
        fertilizerLabel.numberOfLines = 1
        fertilizerLabel.text = "Times of fertilizing per week"
        scrollView.addSubview(fertilizerLabel)
        
        fertilizer = UISlider(frame: CGRect(x: 0, y: 300, width: 300, height: 50))
        fertilizer.center.x = self.view.center.x
        fertilizer.minimumValue = 0
        fertilizer.maximumValue = 1
        fertilizer.value = 0.5
        fertilizer.minimumValueImage = UIImage(named: "minus")
        fertilizer.maximumValueImage = UIImage(named: "add")
        fertilizer.addTarget(self, action: #selector(fertilizerDidChange(_:)), for: .valueChanged)
        self.scrollView.addSubview(fertilizer)
        
        let fertilizerStart = UILabel(frame: CGRect(x: 20, y: 280, width: 30, height: 30))
        fertilizerStart.textAlignment = .center
        fertilizerStart.font = UIFont(name: "Optima", size: 14)
        fertilizerStart.numberOfLines = 1
        fertilizerStart.text = "0"
        scrollView.addSubview(fertilizerStart)
        
        let fertilizerEnd = UILabel(frame: CGRect(x: 320, y: 280, width: 30, height: 30))
        fertilizerEnd.textAlignment = .center
        fertilizerEnd.font = UIFont(name: "Optima", size: 14)
        fertilizerEnd.numberOfLines = 1
        fertilizerEnd.text = "\(vegetableDetail[2])"
        scrollView.addSubview(fertilizerEnd)
        
        currentFertilizer.frame =  CGRect(x: 155, y: 280, width: 60, height: 30)
        currentFertilizer.textAlignment = .center
        currentFertilizer.font = UIFont(name: "Optima", size: 16)
        currentFertilizer.numberOfLines = 1
        currentFertilizer.text = "\(Double(vegetableDetail[2])! * fertilizerData)"
        scrollView.addSubview(currentFertilizer)
        
        let waterLabel = UILabel(frame: CGRect(x: 20, y: 370, width: 200, height: 30))
        waterLabel.textAlignment = .center
        waterLabel.font = UIFont(name: "Optima", size: 16)
        waterLabel.center.x = self.view.center.x
        waterLabel.numberOfLines = 1
        waterLabel.text = "Times of watering per week"
        scrollView.addSubview(waterLabel)
        
        water = UISlider(frame: CGRect(x: 0, y: 430, width: 300, height: 50))
        water.center.x = self.view.center.x
        water.minimumValue = 0
        water.maximumValue = 1
        water.value = 0.5
        water.minimumValueImage = UIImage(named: "minus")
        water.maximumValueImage = UIImage(named: "add")
        water.addTarget(self, action: #selector(waterDidChange(_:)), for: .valueChanged)
        self.scrollView.addSubview(water)
        
        let waterStart = UILabel(frame: CGRect(x: 20, y: 410, width: 30, height: 30))
        waterStart.textAlignment = .center
        waterStart.font = UIFont(name: "Optima", size: 14)
        waterStart.numberOfLines = 1
        waterStart.text = "0"
        scrollView.addSubview(waterStart)
        
        let waterEnd = UILabel(frame: CGRect(x: 320, y: 410, width: 30, height: 30))
        waterEnd.textAlignment = .center
        waterEnd.font = UIFont(name: "Optima", size: 14)
        waterEnd.numberOfLines = 1
        waterEnd.text = "\(vegetableDetail[1])"
        scrollView.addSubview(waterEnd)
        
        currentWater.frame =  CGRect(x: 155, y: 410, width: 60, height: 30)
        currentWater.textAlignment = .center
        currentWater.font = UIFont(name: "Optima", size: 16)
        currentWater.numberOfLines = 1
        currentWater.text = "\(Double(vegetableDetail[1])! * waterData)"
        scrollView.addSubview(currentWater)

    }
    
    func setUpView() {
        
        borderImageView.frame = CGRect(x: 30, y: 30, width: 200, height: 200)
        let borderImage = UIImage(color: .white, size: CGSize(width: 200, height: 200))
        borderImageView.image = borderImage
        borderImageView.maskCircle(anyImage: borderImage!)
        borderImageView.center.x = self.view.center.x
        borderImageView.layer.borderWidth = 5
        borderImageView.layer.borderColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0).cgColor
        scrollView.addSubview(borderImageView)
        
        let image = UIImage(named: "\(vegetablePassData).jpg")
        imageView.frame = CGRect(x: 30, y: 105, width: 50, height: 50)
        imageView.image = image
        imageView.maskCircle(anyImage: image!)
        imageView.center.x = self.view.center.x
        scrollView.addSubview(imageView)
        
        progressView.frame = CGRect(x: 20, y: 10, width: self.view.frame.width * 0.9, height: 50)
        progressView.center.x = self.view.center.x
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 10
        progressView.subviews[1].clipsToBounds = true
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        scrollView.addSubview(progressView)
        
        let progressStart = UILabel(frame: CGRect(x: 10, y: 15, width: 30, height: 30))
        progressStart.textAlignment = .center
        progressStart.font = UIFont(name: "Optima", size: 14)
        progressStart.numberOfLines = 1
        progressStart.text = "0"
        scrollView.addSubview(progressStart)
        
        let progressEnd = UILabel(frame: CGRect(x: 300, y: 15, width: 60, height: 30))
        progressEnd.textAlignment = .center
        progressEnd.font = UIFont(name: "Optima", size: 14)
        progressEnd.numberOfLines = 1
        progressEnd.text = "\(vegetableDetail[0]) days"
        scrollView.addSubview(progressEnd)
        
        start.frame = CGRect(x: 40, y: 495, width: 150, height: 40)
        start.layer.cornerRadius=5
        start.layer.masksToBounds=true
        start.translatesAutoresizingMaskIntoConstraints=false
        start.setTitle("Start", for: .normal)
        start.titleLabel?.font = UIFont(name: "Optima", size: 16)
        start.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        start.titleLabel?.textAlignment = .center
        start.titleLabel?.textColor = .white
        start.center.x = self.view.center.x
        start.addTarget(self, action: #selector(go), for: .touchUpInside)
        scrollView.addSubview(start)
    }
    
    @objc func go() {
        if(isRunning){
            progressBarTimer.invalidate()
            start.setTitle("Start", for: .normal)
        }
        else{
            start.setTitle("Stop", for: .normal)
            progressView.progress = 0.0
            self.progressBarTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GrowVegetableViewController.updateProgressView), userInfo: nil, repeats: true)
            
            progressView.progressTintColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0)
            progressView.progressViewStyle = .default
            
            let absWaterData = (1 - abs(waterData - 0.5)) * 2
            let absFertilizerData = (1 - abs(fertilizerData - 0.5)) * 2
            let data = absWaterData + absFertilizerData
            
            UIView.animate(withDuration: 5.5, animations: {() -> Void in
                self.imageView.transform = CGAffineTransform(scaleX: CGFloat(data), y: CGFloat(data))
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 2.0, animations: {() -> Void in
                    self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    if data <= 4 && data >= 3.5 {
                        self.popUpSuccess()
                    }
                    else {
                        self.popUpFailure()
                    }
                })
            })
            
        }
        isRunning = !isRunning
    }
    
    func popUpSuccess() {
        guard let customAlertVC = customAlertVC else { return }
        
        customAlertVC.titleString = "Congratulations!"
        customAlertVC.messageString = "You can harvest \(vegetablePassData) now"
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    func popUpFailure() {
        guard let customAlertVC = customAlertVCTwo else { return }
        
        customAlertVC.titleString = "Oops!"
        customAlertVC.messageString = "\(vegetablePassData) stops growing"
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    @objc func updateProgressView(){
        progressView.progress += 0.1
        progressView.setProgress(progressView.progress, animated: true)
        if(progressView.progress == 1.0)
        {
            progressBarTimer.invalidate()
            isRunning = false
            start.setTitle("Start", for: .normal)
        }
    }
    
    @objc func fertilizerDidChange(_ sender: UISlider) {
        self.fertilizerData = Double(round(100 * sender.value) / 100)
        let currentData = Double(vegetableDetail[2])! * fertilizerData
        currentFertilizer.text = "\(round(100 * currentData) / 100)"
    }
    
    @objc func waterDidChange(_ sender: UISlider) {
        self.waterData = Double(round(100 * sender.value) / 100)
        let currentData = Double(vegetableDetail[1])! * waterData
        currentWater.text = "\(round(100 * currentData) / 100)"
    }

}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
