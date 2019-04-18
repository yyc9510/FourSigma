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
    
    let locationManager = CLLocationManager()
    var userLatitude: CLLocationDegrees
    var userLongitude: CLLocationDegrees
    var placeId = ""
    
    var mapView:GMSMapView?
    var placesClient: GMSPlacesClient!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Know Your Area"
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        placesClient = GMSPlacesClient.shared()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        generateBarButtonItem()
        generateInitialMap()
        generateSearchBar()
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MapSearchViewController.self)
        
        let filter = GMSAutocompleteFilter()
        filter.country = "AU"
        resultsViewController!.autocompleteFilter = filter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(UIImage(named: "google-location.png"), for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let goBackButton: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(UIImage(named: "go_back.png"), for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    @objc func btnMyLocationAction() {
    
        self.reloadMap()
    }
    
    @objc func goBack() {
        
        self.navigationController?.popViewController(animated: true)
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
        //self.placeId = "ChIJwQo-s4xp1moRCnq_1koT-WM"
        super.init(coder: aDecoder)!
    }
    
    func popUpView(condition: String) {
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
        popupVC.height = 300
        popupVC.topCornerRadius = 35
        popupVC.presentDuration = 1.0
        popupVC.dismissDuration = 1.0
        popupVC.popupDelegate = self
        
        getAddressFromLatLon(pdblLatitude: self.userLatitude, withLongitude: self.userLongitude)
        
        popupVC.userLatitude = self.userLatitude
        popupVC.userLongitude = self.userLongitude
        popupVC.placeId = self.placeId
        popupVC.postcode = getPostcode(input: self.userSearchResult)
        if self.detailedAddress == "" {
            popupVC.detailedAddress = "Caulfield East VIC 3145"
        }
        else {
            popupVC.detailedAddress = self.detailedAddress
        }
        popupVC.condition = condition
        
        present(popupVC, animated: true, completion: nil)
        self.placeId = ""
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
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive=true
        btnMyLocation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
        
        self.view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive=true
        goBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        goBackButton.widthAnchor.constraint(equalToConstant: 50).isActive=true
        goBackButton.heightAnchor.constraint(equalTo: goBackButton.widthAnchor).isActive=true
    }
    
    func generateSearchBar() {
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 25, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
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
                self.popUpView(condition: "fail")
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.userLatitude = locValue.latitude
        self.userLongitude = locValue.longitude
        self.getAddressFromLatLon(pdblLatitude: locValue.latitude, withLongitude: locValue.longitude)
        print("lat2: \(self.userLatitude)")
        print("long2: \(self.userLongitude)")
        
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
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive=true
        btnMyLocation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
        
        self.view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive=true
        goBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        goBackButton.widthAnchor.constraint(equalToConstant: 50).isActive=true
        goBackButton.heightAnchor.constraint(equalTo: goBackButton.widthAnchor).isActive=true
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        placesClient?.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
            (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList {
                    let place = likelihood.place
                    print("Current Place name \(String(describing: place.name)) at likelihood \(likelihood.likelihood)")
                    print("Current PlaceID \(String(describing: place.placeID))")
                    self.placeId = place.placeID ?? ""

                }
            }
        })
        
        if self.userSearchResult != "fail" {
            popUpView(condition: "ok")
        }
        else {
            popUpView(condition: "fail")
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
        if result.count >= 2 {
            let address = result[result.count - 2]
            let postcode = address.components(separatedBy: " ")
            let final = postcode[postcode.endIndex - 1]
                return final
            
        }
        else {
            return ""
        }
    }
    
    func getAddress(input: String) -> String {
        let result = input.components(separatedBy: ",")
        let address = result[0]
        return address
    }
    
    func getPlaceAddress(input: String) -> String {
        let result = input.components(separatedBy: ",")
        let address = result[result.count - 2]
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
        self.placeId = place.placeID ?? ""
        print("placeId: \(placeId)")
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

extension MapSearchViewController: BottomPopupDelegate {
    
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


