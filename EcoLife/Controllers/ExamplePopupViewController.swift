//
//  ExamplePopupViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 15/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import EzPopup
import GooglePlaces

class ExamplePopupViewController: BottomPopupViewController {
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var placesClient: GMSPlacesClient!
    var placeId = ""
    
    let customAlertVC = CustomAlertViewController.instantiate()
    
    var postcode = "3145"
    var detailedAddress = "Caulfield East VIC 3145"
    var userLatitude = -37.877
    var userLongitude = 145.0449
    var condition = "ok"
    
    @IBAction func knowMoreButton(_ sender: Any) {
        if detailAddressLabel.text != "No Solar Data" {
            performSegue(withIdentifier: "chartSegue", sender: "")
        }
        else {
            guard let customAlertVC = customAlertVC else { return }
            
            customAlertVC.titleString = "No Availalbe Data"
            customAlertVC.messageString = "Currently available only for Victoria."
            
            let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
            popupVC.cornerRadius = 5
            present(popupVC, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailAddressLabel: UILabel!
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        print("postcode: \(postcode)")
        print("lat: \(userLatitude)")
        print("long: \(userLongitude)")
        print("address: \(detailedAddress)")
        
        placesClient = GMSPlacesClient.shared()
        
        if postcode.isnumberordouble && condition == "ok"{
            let conditionDouble = (postcode as NSString).doubleValue
            if conditionDouble >= 3000 && conditionDouble <= 4000 {
                detailAddressLabel.text = detailedAddress
            }
            else {
                detailAddressLabel.text = "No Solar Data"
                
            }
        }
        else {
            detailAddressLabel.text = "No Solar Data"
        }
        //self.imageView.isHidden = true
        //self.detailAddressLabel.frame = CGRect(x: 110, y: 92, width: 167, height: 78)
        getPlacePhoto()
    }
    
    func getPlacePhoto() {
        
        // Specify the place data types to return (in this case, just photos).
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))!
        
        placesClient?.fetchPlace(fromPlaceID: placeId,
                                 placeFields: fields,
                                 sessionToken: nil, callback: {
                                    (place: GMSPlace?, error: Error?) in
                                    if let error = error {
                                        print("An error occurred: \(error.localizedDescription)")
                                        return
                                    }
                                    if let place = place {
                                        // Get the metadata for the first photo in the place photo metadata list.
                                        if place.photos != nil && self.detailAddressLabel.text != "No Solar Data"{
                                            let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
                                            
                                            // Call loadPlacePhoto to display the bitmap and attribution.
                                            self.placesClient?.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                                                if let error = error {
                                                    // TODO: Handle the error.
                                                    print("Error loading photo metadata: \(error.localizedDescription)")
                                                    return
                                                } else {
                                                    // Display the first image and its attributions.
                                                    //self.imageView.isHidden = false
                                                    self.imageView?.image = photo;
                                                    self.detailAddressLabel.frame = CGRect(x: 212, y: 73, width: 151, height: 94)
                                                }
                                            })
                                        }
                                        else {
                                            self.imageView.image = UIImage(named: "no-image-available")
                                            //self.detailAddressLabel.frame = CGRect(x: 110, y: 92, width: 167, height: 78)
                                            //self.detailAddressLabel.textAlignment = .center
                                        }
                                    }
        })
        placeId = ""
    }
    // Bottom popup attribute methods
    // You can override the desired method to change appearance
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(300)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "chartSegue") {
            let vc = segue.destination as! DataResultViewController
            vc.postcode = self.postcode
            vc.userLatitude = self.userLatitude
            vc.userLongitude = self.userLongitude
            vc.detailedAddress = self.detailedAddress
        }
    }
}
