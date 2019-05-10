//
//  ApplianceCollectionViewController.swift
//  EcoLife
//
//  Created by 姚逸晨 on 2/5/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import LocalAuthentication
import EzPopup

class ApplianceCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchControllerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let applianceCollection = [UIImage(named: "comparison"),UIImage(named: "my_appliances")]
    let segueLocation = ["comparison", "my_appliances"]
    let customAlertVC = CustomAlertViewController.instantiate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    func popUpFailure() {
        guard let customAlertVC = customAlertVC else { return }
        
        customAlertVC.titleString = "Permission Denied"
        customAlertVC.messageString = "Face ID / Touch ID authentication is required"
        
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applianceCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "applianceCell", for: indexPath) as! ApplianceCollectionCell
        
        cell.image.image = applianceCollection[indexPath.row]
        cell.image.layer.cornerRadius = 10
        
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
        cell.layer.cornerRadius = 10.0
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != 1 {
            let segueIdentifier = segueLocation[indexPath.row]
            performSegue(withIdentifier: segueIdentifier, sender: "")
        }
        else {
            authenticationWithTouchID(indexPath: indexPath)
        }
    }
    
    func authenticationWithTouchID(indexPath: IndexPath) {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    DispatchQueue.main.async {
                        let segueIdentifier = self.segueLocation[indexPath.row]
                        self.performSegue(withIdentifier: segueIdentifier, sender: "")
                    }
                    
                    
                } else {
                    
                    self.popUpFailure()
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            self.popUpFailure()
            guard let error = authError else {
                
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
            
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            //self.navigationController?.popToRootViewController(animated: true)
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}

