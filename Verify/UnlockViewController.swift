//
//  UnlockViewController.swift
//  Verify
//
//  Created by Razvan  Julian on 12/01/2018.
//

import UIKit
import LocalAuthentication

class UnlockViewController: UIViewController {

    @IBOutlet var unlockBiometricLabel: UILabel!
    @IBOutlet var unlockImageView: UIImageView!
    @IBOutlet var unlockButton: UIButton!
    
    
    
    
    @IBAction func unlock(_ sender: Any) {
        
        authenticationWithTouchID()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        unlockButton.layer.cornerRadius = 10
        
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        
        let localAuthenticationContext = LAContext()
        
        var authError: NSError?
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
        
            if #available(iOS 11.0, *) {
                if localAuthenticationContext.biometryType == .faceID {
                    
                    unlockImageView.image = UIImage(named: "faceID")
                    unlockBiometricLabel.text = "You can turn off Face ID in the security section of the settings."
                    
                } else if localAuthenticationContext.biometryType == .touchID {
                    
                    unlockImageView.image = UIImage(named: "touchID")
                    unlockBiometricLabel.text = "You can turn off Touch ID in the security section of the settings."
                    
                        }
                
                    } else {
                
                    // Fallback on earlier versions
                    unlockImageView.image = UIImage(named: "Image")
                    unlockBiometricLabel.text = "You can turn off passcode in the security section of the settings."
                
                }
            
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UnlockViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    //TODO: User authenticated successfully, take appropriate action
                    DispatchQueue.main.async {
                        
                        self.performSegue(withIdentifier: "showToDo", sender: nil)

                    }
                    
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
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
            if #available(iOS 9.0, *) {
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
            } else {
                // Fallback on earlier versions
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        if #available(iOS 9.0, *) {
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
                message = "The user did cancel"
                
            case LAError.userFallback.rawValue:
                message = "The user chose to use the fallback"
                
            default:
                message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
            }
        } else {
            // Fallback on earlier versions
        }
        
        return message
    }
}
