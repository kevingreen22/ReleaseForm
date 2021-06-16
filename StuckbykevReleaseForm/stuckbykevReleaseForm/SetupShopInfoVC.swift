//
//  SetupShopInfoVC.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 5/22/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

class SetupShopInfoVC: UIViewController, UITextFieldDelegate {
    
    // **************************************
    // MARK: - Insatnce Variables
    // **************************************
    
    var textfieldCount = 0
    var name = ""
    var address = ""
    var phone = ""
    var website = ""
    var email = ""
    var artists = [String]()
    
    struct LabelText {
        static let name = "Enter Studio's Name"
        static let address = "Enter Studio's Address"
        static let phone = "Enter Studio's Phone Number"
        static let website = "Enter Studio's Website"
        static let email = "Enter Studio's Email"
        static let artists = "Enter Studio's Artist(s)"
    }
    
    
    
    // **************************************
    // MARK: - Outlets
    // **************************************
    
    @IBOutlet weak var verticalTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField! { didSet { textField.delegate = self } }
    @IBOutlet weak var textFieldColorBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var studioSetupAlreadyButton: UIButton!
    
    
    
    // **************************************
    // MARK: - Actions
    // **************************************
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        switch textfieldCount {
        case 1:
            label.text = LabelText.name
            textField.keyboardType = .default
            textField.text = name
        case 2:
            label.text = LabelText.address
            textField.keyboardType = .default
            textField.text = address
        case 3:
            label.text =  LabelText.phone
            textField.keyboardType = .numberPad
            textField.text = phone
        case 4:
            label.text =  LabelText.website
            textField.keyboardType = .default
            textField.text = website
        case 5:
            label.text =  LabelText.email
            textField.keyboardType = .emailAddress
            textField.text = email
        default:
            break
        }
        
        textfieldCount -= 1
        updateTextFieldUI()
        debugging()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        textfieldCount += 1
        switch textfieldCount {
        case 1:
            name = textField.text ?? ""
            label.text = LabelText.address
            textField.keyboardType = .default
            textField.text = address
        case 2:
            address = textField.text ?? ""
            label.text = LabelText.phone
            textField.keyboardType = .namePhonePad
            textField.text = phone
        case 3:
            phone = textField.text ?? ""
            label.text = LabelText.website
            textField.keyboardType = .default
            textField.text = website
        case 4:
            website = textField.text ?? ""
            label.text = LabelText.email
            textField.keyboardType = .emailAddress
            textField.text = email
        case 5:
            email = textField.text ?? ""
            label.text = LabelText.artists
            textField.keyboardType = .default
            textField.text = ""
        case 6:
            addArtistToList()
            fallthrough
        default:
            if completenessCheck() {
                saveShopInfoToModel()
                presentMainVC()
                self.dismiss(animated: false, completion: nil)
            } else {
                textfieldCount -= 1
                Alerts.myAlert(title: "Oops", message: "This basic information is required in order to use Release Forms", error: nil, actionsTitleAndStyle: nil, viewController: self, buttonHandler: nil)
            }
        }
        
        updateTextFieldUI()
        debugging()
    }
    
    @IBAction func studioSetupAlreadyTapped(_ sender: UIButton) {
        Alerts.myAlert(title: "Already Setup Studio?", message: "If you have already setup your studio, either on another device or deleted the app previously, tap \"Studio Setup Already\"", error: nil, actionsTitleAndStyle: ["Studio Setup Already" : UIAlertAction.Style.default, "Cancel" : UIAlertAction.Style.destructive], viewController: self, buttonHandler: { (buttonTitle) in
            switch buttonTitle {
            case "Studio Setup Already": self.presentMainVC()
            case "Cancel": break
            default: break
            }
        })
    }
    
    
    
    // **************************************
    // MARK: - Life Cycle
    // **************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** SetupShopInfoVC ****")
        
        shouldBackButtonBeEnabled()
        label.text = LabelText.name
        textField.becomeFirstResponder()
        setupUIFromOrientation()
    }
    
    deinit { print("SetupShopInfoVC DEINIT") }
    
    
    
    // **************************************
    // MARK: - Orientation Delegate
    // **************************************
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupUIFromOrientation()
    }
    
    
    
    // **************************************
    // MARK: - Private Helper Methods
    // **************************************
    
    fileprivate func setupUIFromOrientation() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            print("Orientation landscape")
            verticalTextFieldConstraint.constant = 183
        case .portrait, .portraitUpsideDown:
            print("Orientation portrait")
            verticalTextFieldConstraint.constant = 366
        case .unknown:
            print("Orientation unknown")
            verticalTextFieldConstraint.constant = 366
        case .faceUp, .faceDown:
            print("Orientation landscape")
            verticalTextFieldConstraint.constant = 183
        default:
            print("Orientation drfault")
            verticalTextFieldConstraint.constant = 366
        }
    }
    
    
    fileprivate func presentMainVC() {
        guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifiers.MainVC) as? MainViewController else { return }
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = mainVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    fileprivate func updateTextFieldUI() {
        if textField.text!.count > 1 {
            animateTextFieldColorBar(true)
        } else { animateTextFieldColorBar(false) }
        
        shouldBackButtonBeEnabled()
        shouldNextButtonBeEnabled()
        textField.becomeFirstResponder()
    }
    
    /// Alows the backButton to be enabled only if textfieldCount > 0
    fileprivate func shouldBackButtonBeEnabled() {
        if textfieldCount == 0 {
            backButton.isEnabled = false
        } else { backButton.isEnabled = true }
    }
    
    fileprivate func shouldNextButtonBeEnabled() {
        if label.text == LabelText.artists && artists.count == 0 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    /// Checks that all the required fields are properly set.
    ///
    /// - Returns: True if all fields are properly set, false otherwies.
    fileprivate func completenessCheck() -> Bool {
        if name.length > 0 && address.length > 0 && phone.length > 0 && website.length > 0 && email.length > 0 && artists.count > 0 {
            view.endEditing(true)
            return true
        } else {
            shouldNextButtonBeEnabled()
            return false
        }
    }
    
    /// Saves the required fields to the StudioModel. Then sets the user default for apps first launch to true.
    fileprivate func saveShopInfoToModel() {
        Studio.name = name
        Studio.address = address
        Studio.phoneNumber = phone
        Studio.website = website
        Studio.email = email
        for artist in artists {
            let img = UIImage(named: "default artist photo")
            Studio.artistList.updateValue(img!, forKey: artist)
        }
        
        // set userDefaults for app launched for first time
        UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
        
        // Upload Studio Model to iCloud
        iCloud.uploadStudioModel(studioModel: Studio, viewController: self, completion: nil)
    }
    
    /// Animates the text field's underline color to green or red.
    ///
    /// - Parameter editing: Animates to green if true, red if false.
    fileprivate func animateTextFieldColorBar(_ editing: Bool) {
        if editing {
            UIView.animate(withDuration: 1.5, animations: {
                self.textFieldColorBar.backgroundColor = UIColor.green
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.textFieldColorBar.backgroundColor = UIColor.red
            }, completion: nil)
        }
    }
    
    /// Adds the artist name to the list of artists.
    fileprivate func addArtistToList() {
        textField.keyboardType = .default
        if textField.text != "" {
            artists.append(textField.text!)
            textField.text = ""
            animateTextFieldColorBar(false)
            shouldNextButtonBeEnabled()
        }
    }
    
    /// Debugging. Prints to the console various pieces of information pertaining to this class.
    fileprivate func debugging() {
        print("debugging info: \(textfieldCount), \(name), \(address), \(phone), \(email), \(website), \(artists)")
    }
    
    
    
    // **************************************
    // MARK: - UITextfieldDelegate
    // **************************************
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if label.text == LabelText.artists {
            addArtistToList()
        } else {
            nextButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0 {
            animateTextFieldColorBar(true)
        } else if range.location == 0 {
            animateTextFieldColorBar(false)
        }
        return true
    }
    

}

