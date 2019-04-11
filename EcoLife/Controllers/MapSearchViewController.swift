//
//  MapSearchViewController.swift
//  foursigma
//
//  Created by 姚逸晨 on 2/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON
import IQKeyboardManagerSwift
import EzPopup

class MapSearchViewController: UIViewController, CLLocationManagerDelegate {
    
    let apiKey = "AIzaSyAuzAklWLxpNaZwEh8xXd1AXaHN3i62Fi0"
    let customAlertVC = CustomAlertViewController.instantiate()
    
    var userSearchResult: String
    var detailedAddress = ""
    //var resultButton: UIButton
    
    let locationManager = CLLocationManager()
    var userLatitude: CLLocationDegrees
    var userLongitude: CLLocationDegrees
    
    var mapView:GMSMapView?
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location"
        
        generateBarButtonItem()
        generateInitialMap()
        generateSearchBar()
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MapSearchViewController.self)
    
    }
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "google_location"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    @objc func btnMyLocationAction() {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.reloadMap()
        
    }
    
    @objc func helpTapped() {
        
        guard let customAlertVC = customAlertVC else { return }
        
        customAlertVC.titleString = "Availalbe Data"
        customAlertVC.messageString = "Currently available only for Victoria."
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.userLatitude = -37.8770
        self.userLongitude = 145.0449
        self.userSearchResult = "900 Dandenong Rd, Caulfield East VIC 3145, Australia"
        super.init(coder: aDecoder)!
    }
    
    func generateBarButtonItem() {
        
        let helpMe = UIImage(named: "icons8-help-32.png")
        let helpMeTwo = helpMe!.resizeImage(CGSize(width:25, height: 25))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: helpMeTwo, style: .plain, target: self, action: #selector(helpTapped))
    }
    
    func generateInitialMap() {
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: GMSCameraPosition.camera(withLatitude: -37.8770, longitude: 145.0449, zoom: 16))
        
        self.view.addSubview(mapView!)
        
        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive=true
        btnMyLocation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
    }
    
    func generateSearchBar() {
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = true
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func geocoding() {
        
        let address = self.userSearchResult.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .background, attributes: .concurrent)

        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&key=\(self.apiKey)").responseJSON(queue: queue, options: .allowFragments) {
            response in
            let responseStr = response.result.value
            if responseStr != nil {
                let jsonResponse = JSON(responseStr!)
                let jsonResult = jsonResponse["results"].array![0]
                let jsonGeometry = jsonResult["geometry"]
                let jsonLocation = jsonGeometry["location"]
                
                self.userLatitude = jsonLocation["lat"].doubleValue
                self.userLongitude = jsonLocation["lng"].doubleValue
                
                DispatchQueue.main.async {
                    self.reloadMap()
                }
            }
            else {
                self.addNoDataResult()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.userLatitude = locValue.latitude
        self.userLongitude = locValue.longitude
        self.getAddressFromLatLon(pdblLatitude: locValue.latitude, withLongitude: locValue.longitude)
    }
    
    func reloadMap() {
        
        mapView?.removeFromSuperview()
        
        self.view.subviews.forEach ({
            if $0 is UIButton {
                $0.removeFromSuperview()
            }
        })
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 16))
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
        
        marker.title = self.getAddress(input: self.userSearchResult)
        marker.snippet = "\(self.userLatitude), \(self.userLongitude)"
        marker.map = mapView
        self.view.addSubview(mapView!)
        self.view.sendSubviewToBack(mapView!)
        
        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive=true
        btnMyLocation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
        
        if self.userSearchResult != "fail" {
            let condition = getPostcode(input: self.userSearchResult)
            if condition.isnumberordouble {
                let conditionDouble = (condition as NSString).doubleValue
                if conditionDouble >= 3000 && conditionDouble <= 4000 {
                    self.addResult()
                }
            }
            else {
                self.addNoDataResult()
            }
        }
        else {
            self.addNoDataResult()
        }
    }
    
    func addResult() {
        
        let resultButton: UIButton = UIButton(frame: CGRect(x: self.view.frame.width * 0.33, y: self.view.frame.height * 0.835, width: self.view.frame.width * 0.55, height: self.view.frame.height * 0.06))
        resultButton.center.x = self.view.center.x
        resultButton.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 1.0)
        resultButton.setTitle("Show More About \(getPostcode(input: self.userSearchResult))", for: .normal)
        
        resultButton.addTarget(self, action: #selector(chartTapDetected), for: .touchUpInside)
        self.view.addSubview(resultButton)
    }
    
    func addNoDataResult() {
        
        let resultLabel: UILabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.33, y: self.view.frame.height * 0.835, width: self.view.frame.width * 0.55, height: self.view.frame.height * 0.06))
        resultLabel.center.x = self.view.center.x
        resultLabel.backgroundColor = UIColor(red: 35/255, green: 183/255, blue: 159/255, alpha: 0.5)
        resultLabel.text = "No Data in This Area"
        resultLabel.textColor = .white
        resultLabel.textAlignment = .center
        
        self.view.addSubview(resultLabel)
    }
    
    @objc func chartTapDetected() {
        performSegue(withIdentifier: "chartSegue", sender: "")
    }
    
    func getPostcode(input: String) -> String {
        let result = input.components(separatedBy: ",")
        let address = result[1]
        let postcode = address.components(separatedBy: " ")
        let final = postcode[postcode.endIndex - 1]
        return final
    }
    
    func getAddress(input: String) -> String {
        let result = input.components(separatedBy: ",")
        let address = result[0]
        return address
    }
    
    func getPlaceAddress(input: String) -> String {
        let result = input.components(separatedBy: ",")
        let address = result[1]
        return address
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double){
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        let lon: Double = pdblLongitude
        var addressString : String = ""
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    self.userSearchResult = "fail"
                }
                else {
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil && pm.postalCode != nil {
                            let locality = pm.locality! + " VIC "
                            let postalCode = pm.postalCode! + ", "
                            addressString = addressString + locality + postalCode
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country!
                        }
                        
                        print(addressString)
                        self.userSearchResult = addressString
                        self.detailedAddress = self.getPlaceAddress(input: addressString)
                    }
                }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "chartSegue") {
            let vc = segue.destination as! DataResultViewController
            vc.postcode = getPostcode(input: self.userSearchResult)
            vc.userLatitude = self.userLatitude
            vc.userLongitude = self.userLongitude
            vc.detailedAddress = self.detailedAddress
        }
    }
}

extension MapSearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        // Do something with the selected place.
        print("Place name: \(place.name ?? "no place name")")
        print("Place address: \(place.formattedAddress ?? "no place address")")
        print("Place attributions: \(String(describing: place.attributions))")

        self.userSearchResult = place.formattedAddress ?? "no result"
        if self.userSearchResult.contains(",") {
            self.detailedAddress = self.getPlaceAddress(input: place.formattedAddress!)
        }
        else {
            self.userSearchResult = "fail"
        }
        
        DispatchQueue.main.async {
            self.geocoding()
        }
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension UIImage {
    func resizeImage(_ newSize: CGSize) -> UIImage? {
        func isSameSize(_ newSize: CGSize) -> Bool {
            return size == newSize
        }
        
        func scaleImage(_ newSize: CGSize) -> UIImage? {
            func getScaledRect(_ newSize: CGSize) -> CGRect {
                let ratio   = max(newSize.width / size.width, newSize.height / size.height)
                let width   = size.width * ratio
                let height  = size.height * ratio
                return CGRect(x: 0, y: 0, width: width, height: height)
            }
            
            func _scaleImage(_ scaledRect: CGRect) -> UIImage? {
                UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
                draw(in: scaledRect)
                let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
                return image
            }
            return _scaleImage(getScaledRect(newSize))
        }
        
        return isSameSize(newSize) ? self : scaleImage(newSize)!
    }
}

