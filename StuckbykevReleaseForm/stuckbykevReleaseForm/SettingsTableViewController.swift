//
//  SettingsTableViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 10/21/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import MessageUI
import UIKit
import Localize_Swift

protocol WriteSettingsInfoBack {
    func writeMasterPasscodeBack(passcode: String)
    func writeArtistPasscodeBack(passcode: String)
//    func writeArtistArraySetBack(artistDict: [String:UIImage])
//    func writeLegaleseArraySetBack(legalese: [String:Int])
//    func writeHealthClauseArraySetBack(healthClause: [String:Int])
//    func writeLogoBack(logo: UIImage)
//    func writeColorBack(color: UIColor)
    func setLocalize()
    func dismissKeyboard()
}

class SettingsTableViewController: UITableViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, WriteSettingsInfoBack {
    
    
    //***************************************************************
    // MARK: - Instance variables
    //***************************************************************
    
    let userDefaults = UserDefaults.standard
    var delegate: ReturnInfoDelegate?
//    let backgroundQueue = DispatchQueue(label: "com.stuckbykev.settings", qos: .background, target: nil)
    
    
    
    //***************************************************************
    // MARK: - Life Cycle
    //***************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** SettingsTableViewController ****")
//        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.popupDidDismis(true)
    }
    
    deinit { print("SettingsTableViewController DEINIT") }
    
    
    
    //***************************************************************
    // MARK: - WriteSettingsInfoBack Protocol Methods
    //***************************************************************
    
    func writeMasterPasscodeBack(passcode: String) {
        setMasterPasscodeButton!.setTitle("Master Passcode Set", for: UIControl.State())
//        Studio.masterPasscode = passcode
    }
    
    func writeArtistPasscodeBack(passcode: String) {
        setArtistPasscodeButton!.setTitle("Artist Passcode Set", for: UIControl.State())
//        Studio.artistPasscode = passcode
    }
    
//    func writeArtistArraySetBack(artistDict: [String:UIImage]) {
//        if artistDict.count > 0 {
//            for (key,image) in artistDict {
//                Studio.artistList.updateValue(image, forKey: key)
//            }
//        } else {
//            Studio.artistList = artistDict
//        }
//    }
    
//    func writeLegaleseArraySetBack(legalese: [String:Int]) {
//        Studio.legaleseDict = legalese
//    }
//
//    func writeHealthClauseArraySetBack(healthClause: [String:Int]) {
//        Studio.healthClausesDict = healthClause
//    }
    
//    func writeLogoBack(logo: UIImage) {
//        Studio.logo = logo
//    }
    
//    func writeColorBack(color: UIColor) {
//        Studio.backgroundColor = color
//    }
    
    func setLocalize() {
        Localize.setCurrentLanguage("English")
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
        self.resignFirstResponder()
    }
    
    
   
    
    
    //***************************************************************
    // MARK: - Outlets
    //***************************************************************
    
    @IBOutlet weak var studioNameTextField: UITextField! {
        didSet {
            studioNameTextField.delegate = self
            studioNameTextField.text = Studio.name
        }
    }
    
    @IBOutlet weak var studioAddressTextField: UITextField! {
        didSet {
            studioAddressTextField.delegate = self
            studioAddressTextField.text = Studio.address
        }
    }
    
    @IBOutlet weak var studioPhoneNumTextField: UITextField! {
        didSet {
            studioPhoneNumTextField.delegate = self
            studioPhoneNumTextField.text = Studio.phoneNumber
        }
    }
    
    @IBOutlet weak var studioWebsiteTextField: UITextField! {
        didSet {
            studioWebsiteTextField.delegate = self
            studioWebsiteTextField.text = Studio.website
        }
    }
    
    @IBOutlet weak var studioEmailTextField: UITextField! {
        didSet {
            studioEmailTextField.delegate = self
            studioEmailTextField.text = Studio.email
        }
    }
    
    @IBOutlet weak var addDeleteArtistButton: UIButton!
    @IBOutlet weak var setMasterPasscodeButton: UIButton!
    @IBOutlet weak var setArtistPasscodeButton: UIButton!
    @IBOutlet weak var under18TattoosSwitch: UISwitch! { didSet { under18TattoosSwitch.isOn = Studio.allowsUnder18Tattoos } }
    @IBOutlet weak var requireLotNumsSwitch: UISwitch! { didSet { requireLotNumsSwitch.isOn = Studio.lotNumsRequired } }
    
    
    
    //***************************************************************
    // MARK: - Actions
    //***************************************************************
    
    
    
//    @IBAction func restoreAppDefaults(_ sender: UIBarButtonItem) {
////        firstRestoreAppSettingsAlert()
//    }
    
    @IBAction func studioNameTextFieldAction(_ sender: UITextField) {
        if studioNameTextField.text != nil {
            Studio.name = sender.text ?? ""
        }
    }
    
    @IBAction func studioAddressTextFieldAction(_ sender: UITextField) {
        if studioAddressTextField.text != nil {
            Studio.address = sender.text ?? ""
        }
    }
    
    @IBAction func studioPhoneNumTextFieldAction(_ sender: UITextField) {
        if studioPhoneNumTextField.text != nil {
            Studio.phoneNumber = sender.text ?? ""
        }
    }
    
    @IBAction func studioWebsiteTextFieldAction(_ sender: UITextField) {
        if studioWebsiteTextField.text != nil {
            Studio.website = sender.text ?? ""
        }
    }
    
    @IBAction func studioEmailTextFieldAction(_ sender: UITextField) {
        if studioEmailTextField.text != nil {
            Studio.email = sender.text ?? ""
        }
    }
    
    @IBAction func addDeleteArtistButtonAction(_ sender: UIButton) { }
    
    @IBAction func setAppPasscodeButtonAction(_ sender: UIButton) { }
    
    @IBAction func under18TattoosSwitch(_ sender: UISwitch) {
        Studio.allowsUnder18Tattoos = sender.isOn
    }
    
    @IBAction func requireLotNumSwitch(_ sender: UISwitch) {
        Studio.lotNumsRequired = sender.isOn
    }
    
    @IBAction func unwindToSettingsVC(_ segue: UIStoryboardSegue) { }
    
//    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) { }
    
    
    
    //***************************************************************
    // MARK: - UITableViewDelegate
    //***************************************************************
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // feedback row
        if indexPath.section == 4 && indexPath.row == 0 {
            let mailComposeVC = configureMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeVC, animated: true, completion: nil)
            }
            
        // iTunes rate us row
        } else if indexPath.section == 4 && indexPath.row == 1 {
            
//            NEED TO ADD MY_APP_ID ON THE NEXT LINE ***************************************************
            let openAppStoreForRating = "itms-apps://itunes.apple.com/app/idYOUR_APP_ID_HERE?action=write-review&mt=8"
            if UIApplication.shared.canOpenURL(URL(string: openAppStoreForRating)!) {
                UIApplication.shared.open((URL(string: openAppStoreForRating))!, completionHandler: nil)
            } else {
                let appStoreErrorAlert = UIAlertController(title: "Cannot open AppStore" , message: "Please select our app from the AppStore and write a review for us. Thanks!!" , preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK" , style: .default, handler: nil)
                appStoreErrorAlert.addAction(ok)
                self.present(appStoreErrorAlert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    //***************************************************************
    // MARK: - MFMailComposeDelegate
    //***************************************************************
    
    func configureMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(appFeedbackEmails)
        mailComposeVC.setSubject("App Feedback")
        mailComposeVC.setMessageBody("Hi Team! \n\nI would like to share the following feedback.\n", isHTML: false)
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Cancelled Mail") // debugging
        case MFMailComposeResult.sent:
            print("Mail Sent") // debugging
        case MFMailComposeResult.saved:
            print("Draft Saved") // debugging
        case MFMailComposeResult.failed:
            print("Failed Mail") // debugging
        @unknown default:
            fatalError("Mail compose finished with unknown error.")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //***************************************************************
    // MARK: - Private Helper Methods
    //***************************************************************
    
    /// Shows the first confim alert for 'app restore defaults' and if accepted, shows the second confirmation alert.
//    fileprivate func firstRestoreAppSettingsAlert() {
//        let restoreAlert = UIAlertController(title: "Confirm Restore App Settings" , message: "Are you sure you want to completely restore the app settings to default? This will delete all app information. This will also delete any studio info and queue info stored in iCloud. This will NOT delete any client PDF's" , preferredStyle: UIAlertController.Style.alert)
//        let accept = UIAlertAction(title: "Accept" , style: .default, handler: { (ACTION) in
//            self.showSecondConfirmation()
//        })
//        let cancel = UIAlertAction(title: "Cancel" , style: .cancel, handler: nil)
//        restoreAlert.addAction(accept)
//        restoreAlert.addAction(cancel)
//        self.present(restoreAlert, animated: true, completion: nil)
//    }
    
//    /// Shows second confirm alert for 'app restore defaults' and if accepted, restores app defaults.
//    fileprivate func showSecondConfirmation() {
//        let confirmRestoreAlert = UIAlertController(title: "Are You Sure?" , message: "This will also reset the app passcodes and delete any clients in the queue." , preferredStyle: UIAlertController.Style.alert)
//        let accept = UIAlertAction(title: "Accept" , style: .default, handler: { (_) in
//
//            // Delete shopModel from iCloud
//            iCloud.deleteStudioModel(viewController: self, completion: { (error) in
//                if error == nil {
//                    self.userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//                    self.userDefaults.synchronize()
//                    Localize.setCurrentLanguage("English")
//
//                    // Clear the current studio model singleton
//                    Studio = StudioModel()
//
//                    self.confirmResetAppSettingsToDefault()
//                }
//            })
//        })
//        let cancel = UIAlertAction(title: "Cancel" , style: .cancel, handler: nil)
//        confirmRestoreAlert.addAction(accept)
//        confirmRestoreAlert.addAction(cancel)
//        self.present(confirmRestoreAlert, animated: true, completion: nil)
//    }
//
//    /// Confirms app restored to defaults
//    fileprivate func confirmResetAppSettingsToDefault() {
//        let confirmAlert = UIAlertController(title: "App Reset" , message: "The app settings have been restored." , preferredStyle: UIAlertController.Style.alert)
//        let accept = UIAlertAction(title: "Ok" , style: .default, handler: { (ACTION) in
//            self.tableView.reloadData()
//        })
//        confirmAlert.addAction(accept)
//        self.present(confirmAlert, animated: true, completion: nil)
//    }
    
    
    
    //***************************************************************
    // MARK: - UITextField Delegate
    //***************************************************************
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case studioNameTextField:
            studioAddressTextField.becomeFirstResponder()
        case studioAddressTextField:
            studioPhoneNumTextField.becomeFirstResponder()
        case studioPhoneNumTextField:
            studioWebsiteTextField.becomeFirstResponder()
        case studioWebsiteTextField:
            studioEmailTextField.becomeFirstResponder()
        case studioEmailTextField:
            studioEmailTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    
    
    //***************************************************************
    // MARK: - Navigation
    //***************************************************************
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let mainVC = segue.destination as? MainViewController {
//            StudioModel.storeStudioIntoUserDefaults()
//            backgroundQueue.async {
//                iCloud.uploadStudioModel(studioModel: Studio, viewController: mainVC, completion: nil)
//            }
//
//            mainVC.view.layoutIfNeeded()
//
//        } else
            if segue.identifier == SegueIDs.EditLegaleseSegue {
            guard let editLegaleseVC = (segue.destination as? LegaleseViewController) else { return }
            editLegaleseVC.delegate = self
        } else if segue.identifier == SegueIDs.AddDeleteArtistSegue {
            guard let addArtistVC = segue.destination as? AddDeleteArtistViewController else { return }
            addArtistVC.delegate = self
        } else if segue.identifier == SegueIDs.EditHealthClauseSegue {
            guard let healthClauseVC = segue.destination as? HealthClauseEditorViewController else { return }
            healthClauseVC.delegate = self
        } else if segue.identifier == SegueIDs.SetMasterPasscodeSegue {
            guard let setPasscodeVC = (segue.destination as? SetPasscodeViewController) else  { return }
            setPasscodeVC.delegate = self
            setPasscodeVC.isMaster = true
        } else if segue.identifier == SegueIDs.SetArtistPasscodeSegue {
            guard let setPasscodeVC = (segue.destination as? SetPasscodeViewController) else { return }
            setPasscodeVC.delegate = self
            setPasscodeVC.isArtist = true
        } else if segue.identifier == SegueIDs.SetStudioLogoSegue {
            guard let logoVC = segue.destination as? LogoViewController else { return }
            logoVC.delegate = self
        } else if segue.identifier == SegueIDs.SetBackgroundColorSegue {
            guard let backgroundColorVC = segue.destination as? BackgroundViewController else { return }
            backgroundColorVC.writeBackDelegate = self
            backgroundColorVC.delegate = delegate
        }
    }
    
    
   
}

