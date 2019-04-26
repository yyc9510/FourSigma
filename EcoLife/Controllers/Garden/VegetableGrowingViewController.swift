//
//  VegetableGrowingViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 25/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit

class VegetableGrowingViewController: UITableViewController {
    
    let vegetable = ["Basil", "Beans", "Beetroot", "Broad Beans", "Broccoli", "Brussel Sprouts", "Cabbage", "Capsicum", "Carrot", "Cauliflower", "Chilli", "Chives", "Corainder", "Corn", "Cucumber", "Eggplant", "Garlic", "Kale", "Leek", "Lettuce", "Mint", "Onion", "Oregano", "Pak Choy", "Parsley", "Peas", "Potatoes", "Pumpkin", "Radish", "Rocket", "Silverbeet", "Snow Peas", "Spinach", "Spring Onion", "Sunflower", "Sweet Corn", "Tomato", "Zucchini"]
    
    let labelSection = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var twoDimensionalArray = [
        
        // January
        ExpandableNames(isExpanded: true, names: ["Basil", "Beans", "Beetroot", "Brussel Sprouts", "Cabbage", "Carrot", "Chives", "Cucumber", "Eggplant", "Leek", "Lettuce", "Mint", "Oregano", "Parsley", "Radish", "Silverbeet", "Sunflower", "Sweet Corn", "Zucchini"]),
        
        // February
        ExpandableNames(isExpanded: true, names: ["Basil", "Beans", "Beetroot", "Cabbage", "Carrot", "Chives", "Cucumber", "Leek", "Lettuce", "Mint", "Oregano", "Pak Choy", "Parsley", "Radish", "Silverbeet", "Spinach"]),
        
        // March
        ExpandableNames(isExpanded: true, names: ["Broccoli", "Cabbage", "Carrot", "Cauliflower", "Chives", "Garlic", "Leek", "Lettuce", "Mint", "Oregano", "Pak Choy", "Parsley", "Peas", "Radish", "Rocket", "Silverbeet", "Spinach"]),
        
        // April
        ExpandableNames(isExpanded: true, names: ["Broad Beans", "Broccoli", "Cabbage", "Carrot", "Cauliflower", "Chives", "Garlic", "Leek", "Lettuce", "Mint", "Onion", "Oregano", "Pak Choy", "Parsley", "Peas", "Radish", "Rocket", "Silverbeet", "Snow Peas", "Spinach"]),
        
        // May
        ExpandableNames(isExpanded: true, names: ["Broad Beans", "Broccoli", "Cabbage", "Cauliflower", "Chives", "Garlic", "Kale", "Lettuce", "Onion", "Oregano", "Pak Choy", "Parsley", "Peas", "Radish", "Rocket", "Snow Peas", "Spinach"]),
        
        // June
        ExpandableNames(isExpanded: true, names: ["Broad Beans", "Broccoli", "Cabbage", "Cauliflower", "Kale", "Lettuce", "Onion", "Peas", "Radish", "Snow Peas", "Spinach"]),
        
        // July
        ExpandableNames(isExpanded: true, names: ["Broad Beans", "Kale", "Lettuce", "Onion", "Peas", "Radish", "Snow Peas"]),
        
        // August
        ExpandableNames(isExpanded: true, names: ["Beetroot", "Carrot", "Corainder", "Kale", "Leek", "Lettuce", "Mint", "Onion", "Peas", "Potatoes", "Radish", "Rocket", "Silverbeet", "Snow Peas", "Spring Onion", "Sunflower", "Sweet Corn"]),
        
        // September
        ExpandableNames(isExpanded: true, names: ["Beans", "Beetroot", "Carrot", "Chives", "Corainder", "Kale", "Leek", "Lettuce", "Mint", "Oregano", "Parsley", "Peas", "Potatoes", "Pumpkin", "Radish", "Rocket", "Silverbeet", "Snow Peas", "Spring Onion", "Sunflower", "Sweet Corn", "Zucchini"]),
        
        // October
        ExpandableNames(isExpanded: true, names: ["Basil", "Beans", "Beetroot", "Broccoli", "Cabbage", "Capsicum", "Carrot", "Chilli", "Chives", "Corainder", "Cucumber", "Eggplant", "Leek", "Lettuce", "Mint", "Oregano", "Parsley", "Potatoes", "Pumpkin", "Radish", "Rocket", "Silverbeet", "Spring Onion", "Sunflower", "Sweet Corn", "Tomato", "Zucchini"]),
        
        // November
        ExpandableNames(isExpanded: true, names: ["Basil", "Beans", "Beetroot", "Broccoli", "Cabbage", "Capsicum", "Carrot", "Chilli", "Chives", "Corainder", "Corn", "Cucumber", "Eggplant", "Leek", "Lettuce", "Mint", "Oregano", "Parsley", "Pumpkin", "Radish", "Rocket", "Silverbeet", "Spring Onion", "Sunflower", "Sweet Corn", "Tomato", "Zucchini"]),
        
        // December
        ExpandableNames(isExpanded: true, names: ["Basil", "Beans", "Beetroot", "Brussel Sprouts", "Cabbage", "Capsicum", "Carrot", "Chilli", "Chives", "Corn", "Cucumber", "Eggplant", "Leek", "Lettuce", "Mint", "Oregano", "Parsley", "Pumpkin", "Radish", "Silverbeet", "Sunflower", "Sweet Corn", "Tomato", "Zucchini"])
    ]
    
    var month = [String]()
    var vegetablePassData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionIndexColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "vegetableCell")
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vegetableCell", for: indexPath)
        
        let name = twoDimensionalArray[indexPath.section].names[indexPath.row]
        
        cell.textLabel?.text = name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        let label = UILabel()
        label.text = self.labelSection[section]
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.frame = CGRect(x: 20, y: 10, width: 100, height: 15)
        
        let button = UIButton(type: .system)
        button.tag = section
        if twoDimensionalArray[section].isExpanded {
            let origImage = UIImage(named: "collapse")
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            button.setImage(tintedImage, for: .normal)
            button.tintColor = .black
        }
        else {
            let origImage = UIImage(named: "expand")
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            button.setImage(tintedImage, for: .normal)
            button.tintColor = .black
        }
        
        button.frame = CGRect(x: 330, y: 10, width: 20, height: 15)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(button)
        
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        return view
    }
    
    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        
        for row in twoDimensionalArray[section].names.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = twoDimensionalArray[section].isExpanded
        twoDimensionalArray[section].isExpanded = !isExpanded
        
        if isExpanded {
            
            let origImage = UIImage(named: "expand");
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            button.setImage(tintedImage, for: .normal)
            button.tintColor = .black
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        else {
            
            let origImage = UIImage(named: "collapse");
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            button.setImage(tintedImage, for: .normal)
            button.tintColor = .black
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !twoDimensionalArray[section].isExpanded {
            return 0
        }
        
        return twoDimensionalArray[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vegetablePassData = twoDimensionalArray[indexPath.section].names[indexPath.row]
        
        let vc = VegetableInfoViewController()
        vc.vegetablePassData = vegetablePassData
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
