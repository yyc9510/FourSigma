//
//  SolarInfoViewController.swift
//  foursigma
//
//  Created by 姚逸晨 on 6/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import EzPopup

class SolarInfoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating
 {
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let questionName = ["Rebates", "Consuming and Production", "Feed-in Tariff", "Time Block for Feed-in Tariff"]
    
    let questionImage = [UIImage(named: "Rebates"), UIImage(named: "Consuming and Production"), UIImage(named: "Feed-in Tariff"), UIImage(named: "Time Block for Feed-in Tariff")]
    
    let searchController = UISearchController(searchResultsController: nil)
    let customAlertVC = CustomAlertViewController.instantiate()
    var searchActive : Bool = false
    
    var filtered:[String] = []
    var filteredImage:[UIImage] = []
    var questionNameForSegue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateBarButtonItem()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.frame.size.width = self.view.frame.size.width
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.searchController.searchBar.isTranslucent = false
        self.searchController.searchBar.placeholder = "Search..."
        
        self.searchView.addSubview(self.searchController.searchBar)
    }
    
    func generateBarButtonItem() {
        
        let helpMe = UIImage(named: "icons8-help-32.png")
        let helpMeTwo = helpMe!.resizeImage(CGSize(width:25, height: 25))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: helpMeTwo, style: .plain, target: self, action: #selector(helpTapped))
    }
    
    @objc func helpTapped() {
        
        guard let customAlertVC = customAlertVC else { return }
        
        customAlertVC.titleString = "Looking for information?"
        customAlertVC.messageString = "Try to use the search bar to find solutions."
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchActive {
            return filtered.count
        }
        else
        {
            return questionName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if !searchActive {
            cell.questionImage.image = questionImage[indexPath.row]
            cell.questionName.text = questionName[indexPath.row]
        }
        else {
            cell.questionImage.image = filteredImage[indexPath.row]
            cell.questionName.text = filtered[indexPath.row]
        }
        
        // This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if searchActive {
            questionNameForSegue = filtered[indexPath.row]
        }
        else {
            questionNameForSegue = questionName[indexPath.row]
        }
        
        performSegue(withIdentifier: "answerSegue", sender: "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchString = searchController.searchBar.text
        
        filtered.removeAll()
        filteredImage.removeAll()
        
        filtered = questionName.filter({ (item) -> Bool in
            let countryText: NSString = item as NSString
            
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        if filtered.isEmpty {
            
        }
        else{
            for i in 0...filtered.count - 1 {
                filteredImage.append(UIImage(named: filtered[i])!)
                }
        }
        
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.collectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            self.collectionView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "answerSegue") {
            let vc = segue.destination as! AnswerViewController
            vc.questionName = self.questionNameForSegue
        }
    }
}
