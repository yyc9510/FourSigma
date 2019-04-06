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

class MapSearchViewController: UIViewController, CLLocationManagerDelegate {
    
    let apiKey = "AIzaSyAuzAklWLxpNaZwEh8xXd1AXaHN3i62Fi0"
    
    var userSearchResult: String
    var chartImage: UIImageView?
    var label: UILabel?
    
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
    
    @objc func addTapped() {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.refreshMap()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.userLatitude = -37.8770
        self.userLongitude = 145.0449
        self.userSearchResult = "You are here"
        super.init(coder: aDecoder)!
    }
    
    func generateBarButtonItem() {
        
        let locateMe = UIImage(named: "locateMe.png")
        let locateMeTwo = locateMe!.resizeImage(CGSize(width:25, height: 25))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: locateMeTwo, style: .plain, target: self, action: #selector(addTapped))
    }
    
    func generateInitialMap() {
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: GMSCameraPosition.camera(withLatitude: -37.8770, longitude: 145.0449, zoom: 16))
        
        self.view.addSubview(mapView!)
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.userLatitude = locValue.latitude
        self.userLongitude = locValue.longitude
    }
    
    func reloadMap() {
        
        reloadImageLabel()
        mapView?.removeFromSuperview()
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.7), camera: GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 16))
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
        marker.title = self.getAddress(input: self.userSearchResult)
        marker.snippet = "\(self.userLatitude), \(self.userLongitude)"
        marker.map = mapView
        self.view.addSubview(mapView!)
        self.view.sendSubviewToBack(mapView!)
        self.addResult()
    }
    
    func refreshMap() {
        
        reloadImageLabel()
        mapView?.removeFromSuperview()
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 16))
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
        marker.title = "\(self.userSearchResult)"
        marker.snippet = "\(self.userLatitude), \(self.userLongitude)"
        marker.map = mapView
        self.view.addSubview(mapView!)
        self.view.sendSubviewToBack(mapView!)
    }
    
    func addResult() {
        
        
        let image: UIImage = UIImage(named: "icons8-increase-100.png")!
        chartImage = UIImageView(frame: CGRect(x: self.view.frame.width * 0.15, y: self.view.frame.height * 0.72, width: self.view.frame.width * 0.2, height: self.view.frame.height * 0.15))
        chartImage?.image = image
        self.view.addSubview(chartImage!)
        
        let chartTap = UITapGestureRecognizer(target: self, action: #selector(MapSearchViewController.chartTapDetected))
        
        chartImage!.isUserInteractionEnabled = true
        chartImage!.addGestureRecognizer(chartTap)
        
        self.label = UILabel(frame: CGRect(x: self.view.frame.width * 0.5, y: self.view.frame.height * 0.7, width: self.view.frame.width * 0.35, height: self.view.frame.height * 0.2))
        self.label!.lineBreakMode = .byWordWrapping
        self.label!.numberOfLines = 2
        self.label!.text = "Click the Icon to Know More"
        self.view.addSubview(self.label!)
        
    }
    
    func reloadImageLabel() {
        self.chartImage?.removeFromSuperview()
        self.label?.removeFromSuperview()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "chartSegue") {
            let vc = segue.destination as! DataResultViewController
            vc.postcode = getPostcode(input: self.userSearchResult)
            vc.userLatitude = self.userLatitude
            vc.userLongitude = self.userLongitude
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
