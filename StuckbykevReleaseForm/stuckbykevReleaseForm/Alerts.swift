//
//  Alerts.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 3/19/18.
//  Copyright © 2018 Kevin Green. All rights reserved.
//

import Foundation
import UIKit
//import SCLAlertView

class Alerts {
    
    
    
    // MARK: - Standard alerts
    
    /// A standard alert with a dismis button. Optionaly can add multiple custom actions. (If custom actions are used, then the default "Dismis" action is not used.)
    /// The use of completion handlers for the actions is always nil and not configurable. If you need a handler after an action is triggered you should create an alert from scratch.
    ///
    /// - Parameters:
    ///   - title: An optional title message to display in the alert.
    ///   - message: An optional message to display in the alert.
    ///   - error: The error as an Error.
    ///   - actionsTitleAndStyle: An optional dictionary of alert actions. Key is the action title, and the value is the action's style.
    ///   - view: The view presenting the alert.
    static func myAlert(title: String?,
                        message: String?,
                        error: Error?,
                        actionsTitleAndStyle actions: [String : UIAlertAction.Style]?,
                        viewController view: UIViewController, buttonHandler: ((_ button: String?) -> Void)?)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title ?? "", message: "\(String(describing: message ?? "")) \(error?.localizedDescription ?? "")", preferredStyle: .alert)
            
            if let actions = actions {
                for (title, style) in actions {
                    let action = UIAlertAction(title: title, style: style, handler: { (_) in
                        buttonHandler?(title)
                    })
                    alert.addAction(action)
                }
            } else {
                let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: { (_) in
                    buttonHandler?("Dismiss")
                })
                alert.addAction(dismiss)
            }
            
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /// Shows the iCloud not signed in error alert.
    ///
    /// - Parameter view: The view thats presenting the alert.
    static func iCloudSignedInError(viewController view: UIViewController) {
        let alert = UIAlertController(title: "iCloud not available", message: "iCloud not signed in. Make sure your signed in to your iCloud account in settings.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: .default, handler: { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(ok)
        alert.addAction(settings)
        DispatchQueue.main.async { view.present(alert, animated: true, completion: nil) }
    }
    
    
   
    
    
    
    
    
    
    // MARK: - SCL Alerts
    
    /// Shows the Pregnant or nursing alert.
    ///
    /// - Parameters:
    ///   - view: The view thats presenting the alert.
    ///   - healthClauseView: The HealthClauseView object that contains the check box.
    ///   - identifier: The segue identifier to segue to. Optional
    static func pregnantAlert(viewController view: HealthTabVC, cell: HealthClauseCollectionCell, segueTo identifier: String?) {
        let pregnantAlert = SCLAlertView(appearance: alertAppearance)
        pregnantAlert.addButton("OK".localized()) {
            cell.checkBoxImageView.image = nil
        }
        pregnantAlert.addButton("Cancel Form".localized()) {
            guard let segue = identifier else { return }
            view.performSegue(withIdentifier: segue, sender: view)
        }
        pregnantAlert.showWarning("Unable To Tattoo/Pierce".localized(), subTitle: "Unfortunately it is not permitted to a tattoo/piering while pregnant/nursing for safety reasons.".localized())
    }
   
    
    /// Shows wrong birthdate Alert.
    ///
    /// - Parameter view: The view thats presenting the alert.
    static func wrongBirthdateAlert(viewController view: UIViewController) {
        let wrongBirthdateAlert = SCLAlertView(appearance: alertAppearance)
        wrongBirthdateAlert.addButton("OK".localized()) {}
        wrongBirthdateAlert.showWarning("Wrong Birthdate".localized(), subTitle: "The birthdate you entered does not match the birthdate for the name chosen.".localized())
    }
    
    /// Shows get birthdate list error Alert.
    ///
    /// - Parameters:
    ///   - error: The error.
    ///   - view: The view thats presenting the alert.
    static func getBirthdateListfailed(error: Error?, viewController view: UIViewController) {
        print("iCloud get birthdate list error: \(String(describing: error))") // debugging
        let getListFailedAlert = SCLAlertView(appearance: alertAppearance)
        getListFailedAlert.addButton("Dismiss".localized()) {}
        getListFailedAlert.showError("Please try again or start a new form.", subTitle: "There was an error downloading client list for searchbar:\n\(error?.localizedDescription ?? "No error description")\n")
    }
    
    
    /// Shows the camera connection error alert.
    ///
    /// - Parameters:
    ///   - error: The error.
    ///   - view: The view thats presenting the alert.
    static func cameraConnectionError(error: Error?, viewController view: UIViewController) {
        print("Camera connection error") // debugging
        let cameraConnectError = SCLAlertView(appearance: alertAppearance)
        cameraConnectError.addButton("OK".localized()) {}
        cameraConnectError.showWarning("Oops".localized(), subTitle: "Something went wrong connectiong to your camera. Plese check your settings and try again.\n\(error?.localizedDescription ?? "No error description")".localized())
    }
    
    /// Shows the incomplete ID's alert.
    ///
    /// - Parameter view: The view thats presenting the alert.
//    static func incompleteIDsAlert(viewController view: UIViewController) {
//        let incompleteAlert = SCLAlertView(appearance: alertAppearance)
//        incompleteAlert.addButton("OK".localized()) {}
//        incompleteAlert.showInfo("No ID Photo Taken".localized(), subTitle: "You must take a picture of your ID(s) before you can continue.".localized())
//    }
    
    /// Shows the cancel form alert.
    ///
    /// - Parameter view: The view thats presenting the alert.
    static func cancelFormAlert(viewController view: UIViewController) {
        let alertView = SCLAlertView(appearance: alertAppearance)
        alertView.addButton("Yes".localized()) {
            view.performSegue(withIdentifier: "Unwind To Main VC", sender: view)
        }
        alertView.addButton("No".localized()) {}
        alertView.showInfo("Cancel Form".localized(), subTitle: "Are you sure you want to cancel this form?".localized())
    }
    
    /// Shows the incomplete form alert.
    ///
    /// - Parameter view: The view thats presenting the alert.
    static func incompleteFormAlert(viewController view: SignatureTabVC, missingList: String) {
        let incompleteForm = SCLAlertView(appearance: alertAppearance)
        incompleteForm.addButton("OK".localized()) {}
        incompleteForm.showError("Oops".localized(), subTitle: "You must complete all information before saving your form:".localized() + "\n\(missingList)")
    }
    
    /// Shows the Confirmation alert.
    ///
    /// - Parameters:
    ///   - view: The view thats presenting the alert.
    ///   - segueIdentifier: he identifier of the segue to be presented.
    ///   - sender: The sender as Any?
    static func confirmationAlert(viewController view: UIViewController, segueIdentifier: String, sender: Any?) {
        let alertView = SCLAlertView(appearance: alertAppearance)
        alertView.addButton("Confirm".localized()) {
            view.performSegue(withIdentifier: segueIdentifier, sender: sender)
        }
        alertView.addButton("Make Changes".localized()) {}
        alertView.showInfo("Confirmation".localized(), subTitle: "By selecting accept, you acknowlege all information provided is true and correct".localized())
    }
    
   
    
}

