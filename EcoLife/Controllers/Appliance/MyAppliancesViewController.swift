//
//  MyAppliancesViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 5/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import Alamofire
import NVActivityIndicatorView
import EzPopup

class MyAppliancesViewController: UIViewController,addAppliance {
    
    static let cellID = "AJPaperExplainVCCellId"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var collectionView : UICollectionView!
    
    var Appliances = [Appliance]()
    var SearchResultAppliances = [Appliance]()
    
    var addApplianceType = ""
    var pickViewSelRow = 0
    var isSearchIng = false
    var ref: DatabaseReference!
    var recommendedApp: Appliance!
    
    var activityIndicator: NVActivityIndicatorView!
    
    var brandNameList = [String]()
    var colorList = [String]()
    var imageList = [String]()
    
    var averageEnergyConsumption = 0.0
    var averageStarRating = 0.0
    
    let allInfoButton: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.5)
        btn.setImage(UIImage(named: "all_appliances_info"), for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(allInfoAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Appliances"
        
        ref = Database.database().reference()
        
        // manage indicator
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        searchBar.isHidden = true
        activityIndicator.startAnimating()
        
        self.readData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let height: CGFloat = 50 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
    }
    
    func readData(){
        
        ref.child("appliance").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
        
                let value = child as! DataSnapshot
                
                let newBrand = "\(value.childSnapshot(forPath: "BrandName").value ?? "")"
                let brand = Brand(name: newBrand, isSelected: false)

                let newModel = "\(value.childSnapshot(forPath: "ModelName").value ?? "")"
                let model = Model(name: newModel, isSelected: false)

                let manufacturer = "\(value.childSnapshot(forPath: "Manufacturer").value ?? "")"
                let energyConsumption = "\(value.childSnapshot(forPath: "EnergyConsumption").value ?? "")"
                let rating = "\(value.childSnapshot(forPath: "Rating").value ?? "")"
                let type = "\(value.childSnapshot(forPath: "Type").value ?? "")"
                
                let size = "\(value.childSnapshot(forPath: "Size").value ?? "")"
                let ecoRating = "\(value.childSnapshot(forPath: "EcoLife Rating").value ?? "")"

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

                let newAppliance = Appliance(brand: brand, model: model, manufacturer: manufacturer, energyConsumption: energyConsumption, rating: rating, type: type, size: size, ecoRating: ecoRating, backColor: color, icon: UIImage(named: type) ?? UIImage())

                self.Appliances.append(newAppliance)
            }
            DispatchQueue.main.async {
                
                self.setUI()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func data() {
        if self.Appliances.count > 1 {
            
            for i in 0...self.Appliances.count - 2 {
                
                self.ref.child("appliance").child("\(i)").setValue([
                    "BrandName": self.Appliances[i].brand.name,
                    "ModelName": self.Appliances[i].model.name,
                    "EnergyConsumption": self.Appliances[i].energyConsumption,
                    "Rating": self.Appliances[i].rating,
                    "Manufacturer": self.Appliances[i].manufacturer,
                    "BackColor": self.Appliances[i].backColor,
                    "Type": self.Appliances[i].type,
                    "Size": self.Appliances[i].size,
                    "EcoLife Rating": self.Appliances[i].ecoRating
                    ])
            }
        }
    }
    
    func resetData() {
        ref.child("appliance").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.ref.child("appliance").removeValue()
            
            DispatchQueue.main.async {
                self.data()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        print(self.Appliances)
        
    }
    
    func popUpView(index: Int) {
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "appliance_info") as? ApplianceInfoViewController else { return }
        popupVC.height = 400
        popupVC.topCornerRadius = 35
        popupVC.presentDuration = 1.0
        popupVC.dismissDuration = 1.0
        popupVC.popupDelegate = self
        
        popupVC.appliance = Appliances[index]
        
        present(popupVC, animated: true, completion: nil)
        
    }
    
    @objc func allInfoAction() {
        
        if Appliances.count > 1 {
            performSegue(withIdentifier: "allAppInfo", sender: self)
//            guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "all_appliance_info") as? AllApplianceInfoViewController else { return }
//            popupVC.height = 600
//            popupVC.topCornerRadius = 35
//            popupVC.presentDuration = 1.0
//            popupVC.dismissDuration = 1.0
//            popupVC.popupDelegate = self
//
//            var expectInitAppliance = [Appliance]()
//            if Appliances.count == 2 {
//                expectInitAppliance.append(Appliances[0])
//            }
//            else if Appliances.count > 2 {
//                for i in 0...Appliances.count - 2 {
//                    expectInitAppliance.append(Appliances[i])
//                }
//            }
//
//            popupVC.appliance = expectInitAppliance
//
//            present(popupVC, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "No Appliances Available", message: "Please add an appliance first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
//    func readData(){
//
//        ref.child("appliance").child("0").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            let value = snapshot.value as? NSDictionary
//
//            let newBrand = "\(value!["BrandName"] ?? "")"
//            let brand = Brand(name: newBrand, isSelected: false)
//
//            let newModel = "\(value!["ModelName"] ?? "")"
//            let model = Model(name: newModel, isSelected: false)
//
//            let manufacturer = "\(value!["Manufacturer"] ?? "")"
//            let energyConsumption = "\(value!["EnergyConsumption"] ?? "")"
//            let rating = "\(value!["Rating"] ?? "")"
//            let type = "\(value!["Type"] ?? "")"
//
//            var color = ""
//
//            if type == "Computer Monitor" {
//                color = "#16A58C"
//            }
//            else if type == "Washing Machines" {
//                color = "#E38A08"
//            }
//            else if type == "Dryers" {
//                color = "#207DE2"
//            }
//            else if type == "Dishwashers" {
//                color = "#D3267E"
//            }
//            else if type == "Fridges and Freezers" {
//                color = "#4616BC"
//            }
//            else if type == "Televisions" {
//                color = "#8700B5"
//            }
//
//            let newAppliance = Appliance(brand: brand, model: model, manufacturer: manufacturer, energyConsumption: energyConsumption, rating: rating, type: type, backColor: color, icon: UIImage(named: type) ?? UIImage())
//
//            self.Appliances.append(newAppliance)
//
//            DispatchQueue.main.async {
//
//                self.setUI()
//            }
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    
    func setUI() {
        
        activityIndicator.stopAnimating()
        searchBar.isHidden = false
        
        let initBrand = Brand(name: "Pick Appliance", isSelected: false)
        let initModel = Model(name: "None", isSelected: false)
        let initAppliance =  Appliance.init(brand: initBrand, model: initModel, manufacturer: "None", energyConsumption: "0", rating: "0", type: "None", size: "0", ecoRating: "0", backColor: "#ffffff", icon: UIImage.init(named: "homework_add_icon") ?? UIImage())
        Appliances.append(initAppliance)
        
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = false
        searchBar.tintColor = .black
        
        for sv in searchBar.subviews {
            if sv.isKind(of: NSClassFromString("UIView")!) && sv.subviews.count>0 {
                sv.subviews.first!.removeFromSuperview()//去掉搜索框的灰色背景
            }
        }
        
        let searchField = searchBar.value(forKey: "searchField") as! UITextField
        searchField.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.3)
        searchField.clearButtonMode = .whileEditing
        
        searchField.font = UIFont(name: "Optima", size: 16)
        searchBar.tintColor = .black
        
        //快捷界面
        let itemW = NEWFITSCALEX(414/2.0)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: itemW, height: itemW / 2.0)
        // 最小行间距，默认是0
        layout.minimumLineSpacing = 0
        // 最小左右间距，默认是10
        layout.minimumInteritemSpacing = 0
        // 区域内间距，默认是 UIEdgeInsetsMake(0, 0, 0, 0)
        layout.sectionInset = UIEdgeInsets.init(top: NEWFITSCALEX(10), left: 0, bottom: 0, right: 0)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: navStatusBarH, width: ScreenW, height:ScreenH - navStatusBarH), collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.register(CustomCollCell.classForCoder(), forCellWithReuseIdentifier: MyAppliancesViewController.cellID)
        view.addSubview(collectionView)
        collectionView.reloadData()
        
        self.view.addSubview(allInfoButton)
        allInfoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55).isActive=true
        allInfoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive=true
        allInfoButton.widthAnchor.constraint(equalToConstant: 50).isActive=true
        allInfoButton.heightAnchor.constraint(equalTo: allInfoButton.widthAnchor).isActive=true
        
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    func addAppliance(app: Appliance) {
        self.Appliances.insert(app, at: Appliances.count - 1)
        self.collectionView.reloadData()
    }
    
}
extension MyAppliancesViewController :UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearchIng = true
        searchBar.showsCancelButton = true
        collectionView.reloadData()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchResultAppliances = [Appliance]()
        
        SearchResultAppliances = self.Appliances.filter(){
            $0.brand.name.lowercased().contains(searchText.lowercased())
        }
        
//        if self.pickViewSelRow == 0  {
//            SearchResultAppliances = self.Appliances.filter(){
//
//                $0.brand.name.lowercased().contains(searchText.lowercased())
//
//            }
//        }else if (self.pickViewSelRow == 1){
//            SearchResultAppliances = self.Appliances.filter(){
//                $0.model.name.lowercased().contains(searchText.lowercased())
//
//            }
//
//
//        } else{
//            SearchResultAppliances = self.Appliances.filter(){
//                $0.type.lowercased().contains(searchText.lowercased())
//
//            }
//        }
        
        if SearchResultAppliances.count != 0 {
            let appliance  = SearchResultAppliances.last
            if appliance?.brand.name == "Pick Appliance"{
                SearchResultAppliances.removeLast()
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearchIng = false
        searchBar.showsCancelButton = false
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchIng {
            return SearchResultAppliances.count
        }
        return Appliances.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyAppliancesViewController.cellID, for: indexPath) as! CustomCollCell
        
        let appliance : Appliance!
        
        if isSearchIng {
            
            appliance = SearchResultAppliances[indexPath.row]
            
            if Appliances.count > 1 {
                for i in 0...Appliances.count - 2 {
                    if Appliances[i].brand.name == appliance.brand.name {
                        print(i)
                        cell.operationBtn.tag = i
                    }
                }
            }

        }
        else {
            cell.operationBtn.tag = indexPath.row
            appliance = Appliances[indexPath.row]
        }
        
        let brand  = appliance.brand
        
        if indexPath.row % 2 == 0 {
            cell.containView.frame = CGRect.init(x: NEWFITSCALEX(20), y: NEWFITSCALEX(7), width: NEWFITSCALEX(177), height: NEWFITSCALEX(93.5))
        }
        else {
            cell.containView.frame = CGRect.init(x: NEWFITSCALEX(10), y: NEWFITSCALEX(7), width: NEWFITSCALEX(177), height: NEWFITSCALEX(93.5))
        }
        
//        if appliance.ecoRating == "High" {
//            cell.containView.backgroundColor = UIColor.colorWithHexString(color: appliance.backColor).withAlphaComponent(1.0)
//        }
//        else if appliance.ecoRating == "Medium" {
//            cell.containView.backgroundColor = UIColor.colorWithHexString(color: appliance.backColor).withAlphaComponent(0.6)
//        }
//        else {
//            cell.containView.backgroundColor = UIColor.colorWithHexString(color: appliance.backColor).withAlphaComponent(0.2)
//        }
        
        cell.containView.backgroundColor = UIColor.colorWithHexString(color: appliance.backColor).withAlphaComponent(1.0)
        cell.icon.image = appliance.icon
        cell.titleLab.text = brand.name
        cell.operationBtn.addTarget(self, action: #selector(operationAppliance(btn:)), for: UIControl.Event.touchUpInside)
        
        if indexPath.row == self.Appliances.count - 1 {
            cell.titleLab.textColor = UIColor.colorWithHexString(color: "#0065E9")
            cell.operationBtn.isHidden = true
            cell.containView.layer.borderWidth = NEWFITSCALEX(1.5)
            cell.containView.layer.borderColor = UIColor.colorWithHexString(color: "#0065E9").cgColor
            cell.icon.image = appliance.icon.maskWithColor(color: UIColor.colorWithHexString(color: "#0065E9"))
        }
        else{
            cell.titleLab.textColor = UIColor.white
            cell.operationBtn.isHidden = false
            cell.containView.layer.borderWidth = NEWFITSCALEX(0)
            cell.containView.layer.borderColor = cell.backgroundColor?.cgColor
            cell.icon.image = appliance.icon.maskWithColor(color: .white)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearchIng {
            return
        }
        if indexPath.row != self.Appliances.count - 1 {
            return
        }
        addAppliance()
    }
    
    @objc func addAppliance() {
        
        let alertController =  UIAlertController.init(title: "Select Appliance Type", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        
        let computerAction = UIAlertAction.init(title: "Computer Monitor", style: UIAlertAction.Style.default) { (action) in
            if action.title != "" {
                self.addApplianceType = action.title!
                self.performSegue(withIdentifier: "add_appliance", sender: "")
            }
        }
        
        let washingMachineAction = UIAlertAction.init(title: "Washing Machines", style: UIAlertAction.Style.default) { (action) in
            if action.title != "" {
                self.addApplianceType = action.title!
                self.performSegue(withIdentifier: "add_appliance", sender: "")
            }
        }
        
        let dryerAction = UIAlertAction.init(title: "Dryers", style: UIAlertAction.Style.default) { (action) in
            if action.title != "" {
                self.addApplianceType = action.title!
                self.performSegue(withIdentifier: "add_appliance", sender: "")
            }
        }
        
        let dishWasherAction = UIAlertAction.init(title: "Dishwashers", style: UIAlertAction.Style.default) { (action) in
            if action.title != "" {
                self.addApplianceType = action.title!
                self.performSegue(withIdentifier: "add_appliance", sender: "")
            }
        }
        
        let fridgeAction = UIAlertAction.init(title: "Fridges and Freezers", style: UIAlertAction.Style.default) { (action) in
            if action.title != "" {
                self.addApplianceType = action.title!
                self.performSegue(withIdentifier: "add_appliance", sender: "")
            }
        }
        
        let tvAction = UIAlertAction.init(title: "Televisions", style: UIAlertAction.Style.default) { (action) in
            if action.title != "" {
                self.addApplianceType = action.title!
                self.performSegue(withIdentifier: "add_appliance", sender: "")
            }
        }
        
        let canAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        
        alertController.addAction(computerAction)
        alertController.addAction(washingMachineAction)
        alertController.addAction(dryerAction)
        alertController.addAction(dishWasherAction)
        alertController.addAction(fridgeAction)
        alertController.addAction(tvAction)
        
        alertController.addAction(canAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    //点击三个点
    @objc func operationAppliance(btn : UIButton) -> () {
        
        let alertController =  UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let deleteAction = UIAlertAction.init(title: "Delete Appliance", style: UIAlertAction.Style.default) { (action) in
            
            self.Appliances.remove(at: btn.tag)
            self.resetData()
            self.collectionView.reloadData()
            
        }
        
        let checkAction = UIAlertAction.init(title: "Find More Information", style: UIAlertAction.Style.default) { (action) in
            
            self.popUpView(index: btn.tag)
        }
        
        let recommendationAction = UIAlertAction.init(title: "Recommendation", style: UIAlertAction.Style.default) { (action) in
            
            self.recommendedApp = self.Appliances[btn.tag]
            
            self.performSegue(withIdentifier: "recommendation", sender: self)
        }
        
        let canAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(checkAction)
        alertController.addAction(recommendationAction)
        alertController.addAction(canAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "add_appliance") {
            let vc = segue.destination as! AddApplianceViewController
            let type = addApplianceType
            
            vc.type = type
            
            var brands = [Brand]()
            var uniqueSize = [String]()
            var size = [[String]]()
            //var models = [[[Model]]]()
            var models = [[ExpandableSection]]()
            var info = [Appliance]()
            
            let url = Bundle.main.url(forResource: type, withExtension: "json")!
            do {
                let jsonData = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: jsonData) as! NSDictionary
                
                let dictionary = json[type] as! NSDictionary
                for allBrands in dictionary.allKeys {
                    
                    let modelValue = dictionary.value(forKey: allBrands as! String) as! NSDictionary
                    
                    var sizeInBrand = [String]()
                    
                    for allModels in modelValue.allKeys {
                        
                        let dataValue = modelValue.value(forKey: allModels as! String) as! NSDictionary
                        
                        let sizeTemp = dataValue["Size"] as! String
                        if !sizeInBrand.contains(sizeTemp) {
                            sizeInBrand.append(sizeTemp)
                        }
                        
                        if !uniqueSize.contains(sizeTemp) {
                            uniqueSize.append(sizeTemp)
                        }
                    }
                    
                    size.append(sizeInBrand)
                }
            }
            catch {
                print(error)
            }
            
            
            let urlTwo = Bundle.main.url(forResource: type, withExtension: "json")!
            do {
                let jsonData = try Data(contentsOf: urlTwo)
                let json = try JSONSerialization.jsonObject(with: jsonData) as! NSDictionary
                
                let dictionary = json[type] as! NSDictionary
                for allBrands in dictionary.allKeys {
                    
                    let newBrand = Brand(name: allBrands as! String, isSelected: false)
                    brands.append(newBrand)
                    
                    //var modelSection = [[Model]]()
                    var modelSection = [ExpandableSection]()
                    
                    for sizeType in uniqueSize {
                        
                        var modelSize = [Model]()
                        
                        let modelValue = dictionary.value(forKey: allBrands as! String) as! NSDictionary
                        
                        for allModels in modelValue.allKeys {
                            
                            let dataValue = modelValue.value(forKey: allModels as! String) as! NSDictionary
                            
                            let sizeTemp = dataValue["Size"] as! String
                            
                            if sizeTemp == sizeType {
                                modelSize.append(Model(name: allModels as! String, isSelected: false))
                            }
                        }
                        if modelSize.count > 0 {
                            modelSection.append(ExpandableSection(isExpanded: false, modelList: modelSize))
                        }
                    }
                    
                    let modelValue = dictionary.value(forKey: allBrands as! String) as! NSDictionary
                    
                    for allModels in modelValue.allKeys {
                        
                        let newModel = Model(name: allModels as! String, isSelected: false)
                        let dataValue = modelValue.value(forKey: allModels as! String) as! NSDictionary
                        
                        let sizeTemp = dataValue["Size"] as! String
                        let manufacturer = dataValue["Manufacturing Countries"] as! String
                        let energy = dataValue["Comparative Energy Consumption"] as! String
                        let rating = dataValue["Star Rating"] as! String
                        
                        let ecoRating = dataValue["EcoLife Rating"] as! String
                        
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
                        
                        let app = Appliance(brand: newBrand, model: newModel, manufacturer: manufacturer, energyConsumption: energy, rating: rating, type: type, size: sizeTemp, ecoRating: ecoRating, backColor: color, icon: UIImage(named: type)!)
                        
                        info.append(app)
                    }
                    
                    models.append(modelSection)
                }
            }
            catch {
                print(error)
            }
            
            brands[0].isSelected = true
            
            vc.data = info
            vc.brands = brands
            vc.models = models
            vc.size = size
            vc.delegate = self
        }
        else if segue.identifier == "recommendation" {
            let vc = segue.destination as! RecommendationViewController
            vc.selectedAppliance = recommendedApp
        }
        else if segue.identifier == "allAppInfo" {
            
            let vc = segue.destination as! AllApplianceInfoViewController
            
            var expectInitAppliance = [Appliance]()
            if Appliances.count == 2 {
                expectInitAppliance.append(Appliances[0])
            }
            else if Appliances.count > 2 {
                for i in 0...Appliances.count - 2 {
                    expectInitAppliance.append(Appliances[i])
                }
            }

            vc.appliance = expectInitAppliance
        }
    }
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}

extension MyAppliancesViewController: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}

