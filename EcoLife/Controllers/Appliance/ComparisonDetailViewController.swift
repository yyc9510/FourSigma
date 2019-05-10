//
//  ComparisonDetailViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 3/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import EzPopup

class ComparisonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    var type = ""
    
    var brands = [Brand]()
    var models = [[Model]]()
    var data = [Appliance]()
    
    var brandSelection = [Int]()
    var allSelection = [[Int]]()
    
    var filtered: [Model] = []
    
    var searchActive : Bool = false
    
    var selectedAppliances = [Model]()
    var selectedBrand = [Brand]()
    
    var brandTableView = UITableView()
    var modelTableView = UITableView()
    var searchController = UISearchController(searchResultsController: nil)
    var bottomView = UIView()
    var selection = UILabel()
    var checkResult = UIButton()
    
    let customAlertVC = CustomAlertViewController.instantiate()
    let customAlertVCTwo = CustomAlertViewController.instantiate()
   
    var numberOfSelection = 0
    var brandReference = 0
    
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "Pick Appliance"
        
        brandTableView.delegate = self
        brandTableView.dataSource = self
        brandTableView.tag = 1
        
        modelTableView.delegate = self
        modelTableView.dataSource = self
        modelTableView.tag = 2
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.searchController.searchBar.isTranslucent = false
        self.searchController.searchBar.placeholder = "Search"
        
        navigationItem.titleView = searchController.searchBar
        
        brandTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        modelTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    
    func initView() {
        
        for _ in 0...self.brands.count - 1 {
            self.brandSelection.append(0)
        }
        
        brandTableView.frame = CGRect(x: 0, y: 10, width: self.view.frame.width * 0.4, height: self.view.frame.height * 0.75)
        brandTableView.layer.addBorder(edge: .right, color: UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.7), thickness: 1)
        brandTableView.separatorStyle = .none
        
        modelTableView.frame = CGRect(x: self.view.frame.width * 0.4, y: 10, width: self.view.frame.width * 0.6, height: self.view.frame.height * 0.75)
        modelTableView.tableFooterView = UIView()
        
        bottomView.frame = CGRect(x: 0, y: self.view.frame.height * 0.75 + 10, width: self.view.frame.width, height: self.view.frame.height * 0.25 - 10 - (self.tabBarController?.tabBar.frame.size.height)!)
        bottomView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.7)
        
        selection.frame = CGRect(x: 5, y: 0, width: self.view.frame.width * 0.6, height: bottomView.frame.height / 2.5)
        selection.textAlignment = .center
        selection.font = UIFont(name: "Optima", size: 14)
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("You have selected ")
            .bold("0")
            .normal(" appliance(s)")
        
        self.selection.attributedText = formattedString
        
        checkResult.frame = CGRect(x: self.view.frame.width * 0.6, y: 0, width: self.view.frame.width * 0.4, height: bottomView.frame.height / 2.5)
        checkResult.setTitle("Check Result", for: .normal)
        checkResult.titleLabel?.textAlignment = .center
        checkResult.titleLabel?.font = UIFont(name: "Optima", size: 15)
        checkResult.setTitleColor(.black, for: .normal)
        checkResult.isUserInteractionEnabled = false
        checkResult.addTarget(self, action: #selector(goResult), for: .touchUpInside)
        
        bottomView.addSubview(selection)
        bottomView.addSubview(checkResult)
        self.view.addSubview(brandTableView)
        self.view.addSubview(modelTableView)
        self.view.addSubview(bottomView)
        
        brandTableView.reloadData()
        modelTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            
            return brands.count
        }
        else if tableView.tag == 2 {
            if searchActive {
                return filtered.count
            }
            else
            {
                return models[brandReference].count
            }
            
        }
        else {
            return 0
        }
    }
    
    func popUpFailure() {
        guard let customAlertVC = customAlertVC else { return }
        
        customAlertVC.titleString = "Selections are out of range"
        customAlertVC.messageString = "You can only select two appliances"
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    func popUpLoadDataFailure() {
        guard let customAlertVC = customAlertVCTwo else { return }
        
        customAlertVC.titleString = "Error"
        customAlertVC.messageString = "Data loading failure"
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        cell.contentView.backgroundColor = .white
        
        if tableView.tag == 1 {
            
            if brands[indexPath.row].isSelected{
                let imageView = UIImageView(frame: CGRect(x: 0, y: cell.frame.height * 1 / 4, width: 3, height: cell.frame.height / 2))
                let image = UIImage(color: UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0), size: CGSize(width: 3, height: cell.frame.height / 2))
                imageView.image = image
                cell.addSubview(imageView)

                cell.textLabel?.textColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
            }
            else if !brands[indexPath.row].isSelected{
                for view in cell.subviews {
                    if let imageView = view as? UIImageView {
                        imageView.removeFromSuperview()
                    }
                }
                cell.textLabel?.textColor = .black
            }
            
            cell.textLabel?.text = brands[indexPath.row].name
            cell.textLabel?.font = UIFont(name: "Optima", size: 13)
            if brandSelection[indexPath.row] == 1 {
                cell.contentView.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 0.3)
                cell.textLabel?.textColor = .white
            }
            else if brandSelection[indexPath.row] == 2 {
                cell.contentView.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 0.6)
                cell.textLabel?.textColor = .white
            }
        }
        else if tableView.tag == 2 {
            
            if !searchActive {
                cell.textLabel?.font = UIFont(name: "Optima", size: 16)
                cell.textLabel?.text = models[brandReference][indexPath.row].name
            }
            else {
                cell.textLabel?.font = UIFont(name: "Optima", size: 16)
                cell.textLabel?.text = filtered[indexPath.row].name
            }
            
//            if models[brandReference][indexPath.row].isSelected {
//                cell.contentView.backgroundColor = .lightGray
//            }
            for selectedModel in selectedAppliances {
                if cell.textLabel?.text == selectedModel.name {
                    cell.contentView.backgroundColor = .lightGray
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        if tableView.tag == 1 {
            
            for i in 0...brands.count - 1 {
                brands[i].isSelected = false
            }
            brands[indexPath.row].isSelected = true
            
            brandReference = indexPath.row
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: cell.frame.height * 1 / 4, width: 3, height: cell.frame.height / 2))
            let image = UIImage(color: UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0), size: CGSize(width: 3, height: cell.frame.height / 2))
            imageView.image = image
            cell.addSubview(imageView)
            
            cell.textLabel?.textColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
            
            if searchActive {
                searchController.isActive = false
                searchActive = false
            }
        }
            
        else if tableView.tag == 2 {
            
            let modelName = cell.textLabel?.text
            var selectedModelIndex = 0
            for i in 0...models[brandReference].count - 1 {
                if models[brandReference][i].name == modelName {
                    selectedModelIndex = i
                }
            }
            
            models[brandReference][selectedModelIndex].isSelected = !models[brandReference][selectedModelIndex].isSelected
            
            if models[brandReference][selectedModelIndex].isSelected {
                numberOfSelection += 1
                brandSelection[brandReference] += 1
                
                selectedBrand.append(brands[brandReference])
                selectedAppliances.append(models[brandReference][selectedModelIndex])
                allSelection.append([brandReference,selectedModelIndex])
            }
            else {
                numberOfSelection -= 1
                brandSelection[brandReference] -= 1
                checkResult.setTitleColor(.black, for: .normal)
                checkResult.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.7)
                checkResult.isUserInteractionEnabled = false
                checkResult.removeTarget(self, action: #selector(goResult), for: .touchUpInside)
                
                removeSelectedApplianceBrand(brand: brands[brandReference])
                removeSelectedAppliance(model: models[brandReference][selectedModelIndex])
                removeSelectedApplianceInfo(brandIndex: brandReference, modelIndex: selectedModelIndex)
            }
            
            if numberOfSelection > 2 {
                popUpFailure()
                numberOfSelection -= 1
                brandSelection[brandReference] -= 1
                models[brandReference][selectedModelIndex].isSelected = !models[brandReference][selectedModelIndex].isSelected
                removeSelectedAppliance(model: models[brandReference][selectedModelIndex])
                removeSelectedApplianceBrand(brand: brands[brandReference])
                removeSelectedApplianceInfo(brandIndex: brandReference, modelIndex: selectedModelIndex)
            }
            
            if numberOfSelection == 2 {
                checkResult.setTitleColor(.white, for: .normal)
                checkResult.backgroundColor = .orange
                checkResult.isUserInteractionEnabled = true
                checkResult.addTarget(self, action: #selector(goResult), for: .touchUpInside)
            }
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("You have selected ")
                .bold("\(numberOfSelection)")
                .normal(" appliance(s)")
            
            self.selection.attributedText = formattedString

//            models[brandReference][indexPath.row].isSelected = !models[brandReference][indexPath.row].isSelected
//
//            if models[brandReference][indexPath.row].isSelected {
//                numberOfSelection += 1
//                brandSelection[brandReference] += 1
//
//                selectedAppliances.append(models[brandReference][indexPath.row])
//                selectedBrand.append(brands[brandReference])
//                allSelection.append([brandReference,indexPath.row])
//
//            }
//            else {
//                numberOfSelection -= 1
//                brandSelection[brandReference] -= 1
//                checkResult.setTitleColor(.black, for: .normal)
//                checkResult.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.7)
//                checkResult.isUserInteractionEnabled = false
//                checkResult.removeTarget(self, action: #selector(goResult), for: .touchUpInside)
//                removeSelectedAppliance(model: models[brandReference][indexPath.row])
//                removeSelectedApplianceBrand(brand: brands[brandReference])
//                removeSelectedApplianceInfo(brandIndex: brandReference, modelIndex: indexPath.row)
//            }
//
//            if numberOfSelection > 2 {
//                popUpFailure()
//                numberOfSelection -= 1
//                brandSelection[brandReference] -= 1
//                models[brandReference][indexPath.row].isSelected = !models[brandReference][indexPath.row].isSelected
//                removeSelectedAppliance(model: models[brandReference][indexPath.row])
//                removeSelectedApplianceBrand(brand: brands[brandReference])
//                removeSelectedApplianceInfo(brandIndex: brandReference, modelIndex: indexPath.row)
//            }
//
//            if numberOfSelection == 2 {
//                checkResult.setTitleColor(.white, for: .normal)
//                checkResult.backgroundColor = .orange
//                checkResult.isUserInteractionEnabled = true
//                checkResult.addTarget(self, action: #selector(goResult), for: .touchUpInside)
//            }
//
//            let formattedString = NSMutableAttributedString()
//            formattedString
//                .normal("You have selected ")
//                .bold("\(numberOfSelection)")
//                .normal(" appliance(s)")
//
//            self.selection.attributedText = formattedString
//
        }
        brandTableView.reloadData()
        modelTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        if tableView.tag == 1 {
            
            for view in cell.subviews {
                if let imageView = view as? UIImageView {
                    imageView.removeFromSuperview()
                }
            }
            cell.textLabel?.textColor = .black
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchString = searchController.searchBar.text
        
        filtered.removeAll()
        
        filtered = models[brandReference].filter({ (item) -> Bool in
            let countryText: NSString = item.name as NSString
            
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        self.modelTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        self.modelTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.modelTableView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            self.modelTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    @objc func goResult() {
        
        performSegue(withIdentifier: "comparisonResult", sender: "")
    }
    
    func removeSelectedAppliance(model: Model) {
        selectedAppliances.removeAll{$0.name == model.name}
    }
    
    func removeSelectedApplianceBrand(brand: Brand) {
        selectedBrand.removeAll{$0.name == brand.name}
    }
    
    func removeSelectedApplianceInfo(brandIndex: Int, modelIndex: Int) {
        print("first: \(allSelection)")
        
        if allSelection.count == 2 {
            
            if allSelection[0] == [brandIndex, modelIndex] {
                allSelection = [allSelection[1]]
            }
            else if allSelection[1] == [brandIndex, modelIndex] {
                allSelection = [allSelection[0]]
            }
            
        } else if allSelection.count == 1 {
            allSelection = [[Int]]()
        }
        print("second: \(allSelection)")
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "comparisonResult") {
            let vc = segue.destination as! ComparisonResultViewController
            
            var passData = [Appliance]()
            
            for app in data {
                for i in selectedAppliances {
                    if app.model.name == i.name {
                        passData.append(app)
                    }
                }
            }
            
            vc.data = passData
            
        }
    }
    
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
