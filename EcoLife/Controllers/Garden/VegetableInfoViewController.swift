//
//  VegetableInfoViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 20/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import Charts

class VegetableInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var user = Auth.auth().currentUser
    var ref: DatabaseReference!
    var activityIndicator: NVActivityIndicatorView!
    let scrollView = UIScrollView()
    
    var vegetablePassData = ""
    let vegetable = ["Basil", "Beans", "Beetroot", "Broad Beans", "Broccoli", "Brussel Sprouts", "Cabbage", "Capsicum", "Carrot", "Cauliflower", "Chilli", "Chives", "Corainder", "Corn", "Cucumber", "Eggplant", "Garlic", "Kale", "Leek", "Lettuce", "Mint", "Onion", "Oregano", "Pak Choy", "Parsley", "Peas", "Potatoes", "Pumpkin", "Radish", "Rocket", "Silverbeet", "Snow Peas", "Spinach", "Spring Onion", "Sunflower", "Sweet Corn", "Tomato", "Zucchini"]
    var month = [String]()
    var sowingMonth = [String]()
    var harvest = ""
    var vegetableDescription = ""

    let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let sowingMonthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    // color line label setting
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    let tableView = UITableView()
    let allMonth = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    var monthColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
    var sowingMonthColor = UIColor.init(red: 252.0/255.0, green: 179.0/255.0, blue: 47.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 1.01)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.01)
        
        self.view.addSubview(scrollView)
        
        self.title = vegetablePassData
        self.view.backgroundColor = .white
        
        ref = Database.database().reference()
        
        self.prepareValue()
        
        // manage indicator
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func readData(vegetableIndex: String) {
        ref.child("vegetable").child(vegetableIndex).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get value
            let value = snapshot.value as? NSDictionary
            
            for (key, monthValue) in value! {
                if "\(monthValue)" == "1" {
                    self.month.append("\(key)")
                }
            }
            
            DispatchQueue.main.async {
                self.readVegetableData(vegetableIndex: vegetableIndex)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    
    }
    
    func readVegetableData(vegetableIndex: String) {
        ref.child("vegetableDetail").child(vegetableIndex).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get value
            let value = snapshot.value as? NSDictionary
            
            for (key, monthValue) in value! {
                if "\(monthValue)" == "1" {
                    self.sowingMonth.append("\(key)")
                }
                if "\(key)" == "Description" {
                    self.vegetableDescription = "\(monthValue)"
                }
            }
            
            self.harvest = "\(value!["Harvest"] ?? "No Data")"
            
            self.activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                self.monthCircle()
                self.setUP()
                self.setInitialView()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func readVegetableIndex(vegetable: String) -> String {
        let index = self.vegetable.firstIndex(of: vegetable)!
        return "\(index)"
    }
    
    func prepareValue() {
        let index = readVegetableIndex(vegetable: vegetablePassData)
        readData(vegetableIndex: index)
    }
    
    func monthCircle() {
        
        let monthCircleView = UIView()
        monthCircleView.frame = CGRect(x: 20, y: 110, width: 50, height: 50)
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 25, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        // Create a track layer
        let trackLayer = CAShapeLayer()
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 1
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = monthCircleView.center
        monthCircleView.layer.addSublayer(trackLayer)
        
        // Create an animation
        let percentage = Float(self.month.count) / 12.0
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = CGFloat(percentage)
        basicAnimation.duration = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        // Create a path layer
        let shapeLayer = CAShapeLayer()

        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0).cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = monthCircleView.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        shapeLayer.strokeEnd = 0
        shapeLayer.add(basicAnimation, forKey: "monthAnimation")
        monthCircleView.layer.addSublayer(shapeLayer)
        
        self.monthLabel.frame = monthCircleView.bounds
        self.monthLabel.center = monthCircleView.center
        monthLabel.text = "\(self.month.count)"
        monthCircleView.addSubview(monthLabel)
        //self.scrollView.addSubview(monthCircleView)
        
        // Second layer
        let sowingMonthCircleView = UIView()
        sowingMonthCircleView.frame = CGRect(x: 270, y: 110, width: 50, height: 50)
        
        let secondCircularPath = UIBezierPath(arcCenter: .zero, radius: 25, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        // Create a track layer
        let secondTrackLayer = CAShapeLayer()
        
        secondTrackLayer.path = secondCircularPath.cgPath
        secondTrackLayer.strokeColor = UIColor.lightGray.cgColor
        secondTrackLayer.lineWidth = 1
        secondTrackLayer.lineCap = CAShapeLayerLineCap.round
        secondTrackLayer.position = sowingMonthCircleView.center
        monthCircleView.layer.addSublayer(secondTrackLayer)
        
        // Create an animation
        let sowingPercentage = Float(self.sowingMonth.count) / 12.0
        let secondBasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        secondBasicAnimation.toValue = CGFloat(sowingPercentage)
        secondBasicAnimation.duration = 1
        secondBasicAnimation.fillMode = CAMediaTimingFillMode.forwards
        secondBasicAnimation.isRemovedOnCompletion = false
        
        // Create a path layer
        let secondShapeLayer = CAShapeLayer()
        
        secondShapeLayer.path = secondCircularPath.cgPath
        secondShapeLayer.strokeColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0).cgColor
        secondShapeLayer.fillColor = UIColor.white.cgColor
        secondShapeLayer.lineWidth = 3
        secondShapeLayer.lineCap = CAShapeLayerLineCap.round
        secondShapeLayer.position = sowingMonthCircleView.center
        secondShapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        secondShapeLayer.strokeEnd = 0
        secondShapeLayer.add(secondBasicAnimation, forKey: "monthAnimation")
        monthCircleView.layer.addSublayer(secondShapeLayer)
        
        self.sowingMonthLabel.frame = sowingMonthCircleView.bounds
        self.sowingMonthLabel.center = sowingMonthCircleView.center
        sowingMonthLabel.text = "\(self.sowingMonth.count)"
        
        monthCircleView.addSubview(sowingMonthLabel)
        self.scrollView.addSubview(monthCircleView)
    }
    
    func setInitialView() {
        
        // Vegetable image view
        let imageView = UIImageView()
        let image = UIImage(named: "\(self.title!).jpg")
        imageView.frame = CGRect(x: 20, y: 30, width: 200, height: 200)
        imageView.image = image
        imageView.maskCircle(anyImage: image!)
        imageView.center.x = self.view.center.x
        scrollView.addSubview(imageView)
        
        // Vegetable name
        let vegetableName = UILabel()
        vegetableName.text = "\(vegetablePassData)"
        vegetableName.textAlignment = .center
        vegetableName.font = UIFont.boldSystemFont(ofSize: 30)
        vegetableName.textColor = .black
        vegetableName.frame = CGRect(x: 20, y: 210, width: 200, height: 200)
        vegetableName.center.x = self.view.center.x
        scrollView.addSubview(vegetableName)
        
        // Line
        let line = UILabel()
        line.text = "......................................................................................................................................."
        line.textAlignment = .center
        line.textColor = .black
        line.center.x = self.view.center.x
        line.frame = CGRect(x: 20, y: 320, width: 330, height: 50)
        vegetableName.font = UIFont.boldSystemFont(ofSize: 20)
        scrollView.addSubview(line)
        
        // Description
        let descriptionLabel = UILabel()
        descriptionLabel.text = self.vegetableDescription
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        descriptionLabel.center.x = self.view.center.x
        descriptionLabel.frame = CGRect(x: 20, y: 310, width: scrollView.frame.width * 0.85, height: 200)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 5
        scrollView.addSubview(descriptionLabel)
        
        // Harvest
        let harvestLabel = UILabel()
        harvestLabel.text = "Harvest: \(self.harvest)"
        harvestLabel.textAlignment = .center
        harvestLabel.textColor = .black
        harvestLabel.center.x = self.view.center.x
        harvestLabel.frame = CGRect(x: 20, y: 370, width: scrollView.frame.width * 0.85, height: 200)
        harvestLabel.font = UIFont.systemFont(ofSize: 16)
        harvestLabel.numberOfLines = 1
        scrollView.addSubview(harvestLabel)
        
        // Month label
        let monthLabel = UILabel()
        monthLabel.textAlignment = .center
        monthLabel.text = "Months Growing"
        monthLabel.font = UIFont.systemFont(ofSize: 10)
        monthLabel.frame = CGRect(x: 13, y: 260, width: 100, height: 50)
        scrollView.addSubview(monthLabel)
        
        // Harvest month label
        let harvestMonthLabel = UILabel()
        harvestMonthLabel.textAlignment = .center
        harvestMonthLabel.text = "Months Sowing"
        harvestMonthLabel.font = UIFont.systemFont(ofSize: 10)
        harvestMonthLabel.frame = CGRect(x: 265, y: 260, width: 100, height: 50)
        scrollView.addSubview(harvestMonthLabel)
    }
    
    func setUP()  {
        tableView.frame = CGRect.init(x: 0, y: 490, width: screenW, height: 148)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isUserInteractionEnabled = false
        tableView.register(CustomCell.classForCoder(), forCellReuseIdentifier: "CustomCellID")
        scrollView.addSubview(tableView)
        
        let planLab = UILabel()
        planLab.frame = CGRect.init(x: 0, y: 0, width: 200, height: 50)
        planLab.textAlignment = NSTextAlignment.left
        planLab.text = "   Planning"
        planLab.textColor = UIColor.gray
        planLab.font = UIFont.systemFont(ofSize: 17)
        tableView.tableHeaderView = planLab
        
        let FootLab = UILabel()
        FootLab.frame = CGRect.init(x: 0, y: 0, width: screenW
            , height: 50)
        FootLab.textAlignment = NSTextAlignment.center
        FootLab.text = "Planning"
        FootLab.textColor = UIColor.black
        FootLab.font = UIFont.systemFont(ofSize: 17)
        
        let mutableAttributedStr =  NSMutableAttributedString.init(string: "Growing  Sowing")
        let range1 = NSRange.init(location: 0, length: 7)
        let range2 = NSRange.init(location: 9, length: 6)
        mutableAttributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: monthColor, range: range1)
        mutableAttributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: sowingMonthColor , range: range2)
        FootLab.attributedText = mutableAttributedStr
        tableView.tableFooterView = FootLab
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Month header
        let headView = UIView()
        let W  : CGFloat = screenW / 12.0
        let H : CGFloat = 30.0
        for i  in 0..<allMonth.count {
            let month = allMonth[i]
            let monthLab = UILabel()
            monthLab.frame = CGRect.init(x: W * CGFloat(i), y: 0, width: W, height: H)
            monthLab.textAlignment = NSTextAlignment.center
            monthLab.text = month
            monthLab.textColor = UIColor.black
            monthLab.font = UIFont.systemFont(ofSize: 13)
            headView.addSubview(monthLab)
        }
        return headView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 9
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellID", for: indexPath) as! CustomCell
        if indexPath.row == 0 {
            cell.monthArray = self.month
            cell.lineCorlor = self.monthColor
        }
        if indexPath.row == 1 {
            cell.monthArray = self.sowingMonth
            cell.lineCorlor = self.sowingMonthColor
        }
        return cell
    }
    
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
