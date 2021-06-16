//
//  MainViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/31/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import CloudKit
import Localize_Swift
import SCLAlertView

protocol ReturnInfoDelegate {
    func writeBirthdateBack(_ birthdate: String)
    func writeLanguageBack(_ languageChosen: String)
    func popupDidDismis(_ didDismis: Bool)
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, ReturnInfoDelegate {
    
    //***************************************************************
    // MARK: - Instance variables
    //***************************************************************
    
    let cellReuseID = "Search Cell"
    var searchActive = false
    var namesDatesList = [String : String]()
    var recordIDsForNamesDatesListIndex = [String : CKRecord.ID]()
    var name = String()
    var birthdateForAuth = String()
    var zip = String()
    var filtered = [String]()
    let backgroundQueue = DispatchQueue(label: "com.stuckbykev.main", qos: .userInitiated, target: nil)
//    let exclamationImageView = UIImageView(image: UIImage(named: "exclamation_mark.png"))
//    let queueNumberImageView = UIImageView(image: UIImage(named: "queue_number.png"))
//    var portraitConstraints = [NSLayoutConstraint]()
//    var landscapeConstraints = [NSLayoutConstraint]()
//    var shopInfo = [String:String]()
    
    
    
    //***************************************************************
    // MARK: - Outlets
    //***************************************************************
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var settingsButton: UIBarButtonItem! {
        didSet {
            DispatchQueue.main.async {
                let icon = UIImage(named: "settings gear")
                let point = CGPoint(x: 0, y: 0)
                let iconSize = CGRect(origin: point, size: icon!.size)
                let customButton = SpringButton(frame: iconSize)
                customButton.setBackgroundImage(icon, for: .normal)
                self.settingsButton.customView = customButton
                customButton.addTarget(self, action: #selector(MainViewController.tappedLeftBarButton(button:)), for: .touchUpInside)
            }
        }
    }
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var helpButton: SpringButton!
    @IBOutlet weak var languageButton: SpringButton!
    @IBOutlet weak var welcomeLabel: UILabel! {
        didSet {
            welcomeLabel.layer.cornerRadius = 10
//            welcomeLabel.setDropShadowOnLabel() // <-- NOT WORKING
        }
    }
    @IBOutlet weak var searchTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var logoImageView: UIImageView! {  didSet { logoImageView.image = Studio.logo } }
    @IBOutlet weak var startButton: SpringButton! {
        didSet {
            startButton.titleLabel?.numberOfLines = 1
            startButton.titleLabel?.adjustsFontSizeToFitWidth = true
            startButton.titleLabel?.baselineAdjustment = .alignCenters
            startButton.titleLabel?.lineBreakMode = .byClipping
            startButton.layer.cornerRadius = startButton.bounds.width / 2
            startButton.setDropShadowOnButton()
        }
    }
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var queueButton: UIBarButtonItem!
    @IBOutlet weak var searchTableViewBlurView: UIVisualEffectView!
    @IBOutlet weak var searchTableView: UITableView!
    
    
    
    //***************************************************************
    // MARK: - Actions
    //***************************************************************
    
    @IBAction func queueButtonAction(_ sender: UIBarButtonItem) {
        print("Queue button tapped")  // debugging
        blurView.isHidden = false
        if let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifiers.PasscodeVC) as? PasscodeToQueueOrSettings {
            passwordVC.delegate = self
            passwordVC.isArtist = true
            passwordVC.segueIdentifier = SegueIDs.PasscodeToQueueSegue
            passwordVC.modalPresentationStyle = .popover
            self.view.endEditing(true)
            present(passwordVC, animated: true, completion: nil)
            let popoverController = passwordVC.popoverPresentationController
            popoverController!.sourceView = self.view
            popoverController!.sourceView = self.view.viewWithTag(2)
            popoverController!.permittedArrowDirections = .up
        }
    }
    
    @IBAction func startButtonAction(_ sender: SpringButton) {
        print("Start button tapped")  // debugging
        Animate.pop(for: sender, loop: false) {
            self.searchBar.resignFirstResponder()
            self.blurView.isHidden = false
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIBarButtonItem) {
        print("Settings button tapped")  // debugging
        settingsButton.removeBadge()
    }
    
    @objc func tappedLeftBarButton(button: SpringButton) {
        print("Left bar button selector method triggered")  // debugging
        Animate.animateSettingsButton(settingsButton: button)
        blurView.isHidden = false
        if let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifiers.PasscodeVC) as? PasscodeToQueueOrSettings {
            passwordVC.delegate = self
            passwordVC.isMaster = true
            passwordVC.segueIdentifier = SegueIDs.PasscodeToSettingsSegue
            passwordVC.modalPresentationStyle = .popover
            self.view.endEditing(true)
            present(passwordVC, animated: true, completion: nil)
            let popoverController = passwordVC.popoverPresentationController
            popoverController!.sourceView = self.view
            popoverController!.sourceView = self.view.viewWithTag(2)
            popoverController!.permittedArrowDirections = .up
        }
    }
    
    var currentlyVisible: Bool = false
    @IBAction func helpButtonAction(_ sender: SpringButton) {
        print("Help button tapped")  // debugging
        Animate.pop(for: sender, loop: false, completion: { })
        let helpView = HelpView()
        if !currentlyVisible {
            helpView.frame.origin = CGPoint(x: sender.frame.maxX + 5, y: sender.frame.minY - sender.frame.height * 2)
            helpView.label.text = "Long press to show the help tutorial".localized()
            view.bringSubviewToFront(helpView)
            self.view.addSubview(helpView)
            currentlyVisible = true
        } else {
            delay(delay: 3.0) {
                helpView.removeFromSuperview()
                self.currentlyVisible = false
            }
        }
        delay(delay: 3.0) {
            helpView.removeFromSuperview()
            self.currentlyVisible = false
        }
    }
    
    @IBAction func longPressOnHelpButton(_ sender: UILongPressGestureRecognizer) {
        print("Long press gesture triggered")
        if sender.state == .began {
            showHelpTutorial(viewController: self)
        }
    }
    
    @IBAction func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        print("Tap gesture triggered")
        if isLanguageMenuOpen == true {
            dismissLanguagePopover()
        }
        if blurView.isHidden == false {
            blurView.isHidden = true
//            Animate.heartBeat(for: startButton as Any)
        }
    }
 
    var isLanguageMenuOpen: Bool = false
    @IBAction func languageButtonAction(_ sender: SpringButton) {
        print("Language button tapped")
        Animate.languageButton(for: sender)
    }
    
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {
        print("Unwind segue to main triggered")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.blurView.isHidden = true
        if segue.destination == self {
            viewWillAppear(true)
        }
    }
    
    
    
    //***************************************************************
    // MARK: - Life Cycle
    //***************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** MainViewController ****")
        
        // This Ensures the language will always be English when the app starts. However it does NOT change the language of the device.
        Localize.setCurrentLanguage("en")
        
        /// Adds an observer for LCLLanguageChangeNotification on viewWillAppear. This is posted whenever a language changes and allows the viewcontroller to make the necessary UI updated.
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSettingsBadge), name: .studioDataChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateQueueBadge), name: .queueDataChanged, object: nil)
        
        Animate.glareStar(for: helpButton)
        Animate.glareStar(for: languageButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blurView.isHidden = true
        iCloud.retrieveQueueFromCloud(viewController: self, completion: nil)
        iCloud.retrieveStudioModelFromCloud(viewController: self, completion: { (error) in
            if error != nil, let studio = getStudioModelFromUserDefaults() {
                Studio = studio
            }
        })
        updateQueueBadge()
        updateSettingsBadge()
        setLanguageButtonImage()
        setupViewFromOrientation()
        setText()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit { print("MainViewController DEINIT") }
    
    
    
    // **************************************
    // MARK: - Orientation Delegate
    // **************************************
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupViewFromOrientation()
    }
    
    
    
    //***************************************************************
    // MARK: - Private Helper Methods
    //***************************************************************
    
    /// Sets the language of the text to the currently chosen language. In app only, not system-wide.
    @objc fileprivate func setText() {
        startButton.titleLabel?.text = "Start".localized()
        welcomeLabel.text = "Welcome To Your Digital Release Form!".localized()
        searchBar.placeholder = "Been here before? Search for yourself to auto-fill your info.".localized()
        infoTextLabel.text = "This app is your new digital tattoo/piercing release form. It replaces the paper release form you would normally fill out today. Law requires a new form for each session, but paper is wasteful and not secure.  It saves trees, reduces printer ink, eliminates bulky cabinets, encrypts your data, and helps you quickly auto-fill your infomation. Everybody wins! Including the environment!".localized()
    }
    
    fileprivate func setupViewFromOrientation() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
             infoTextLabel.isHidden = true
        case .portrait, .portraitUpsideDown:
            infoTextLabel.isHidden = false
        case .unknown:
            infoTextLabel.isHidden = true
        case .faceUp, .faceDown:
            infoTextLabel.isHidden = true
        default:
            infoTextLabel.isHidden = true
        }
    }
    
    fileprivate func updateUI() {
        navigationBar.topItem?.title = Studio.name
        self.view.backgroundColor = Studio.backgroundColor
        self.logoImageView.image = Studio.logo
//        if startButton.isEnabled { Animate.heartBeat(for: startButton as Any) }
    }
    
    @objc private func updateSettingsBadge() {
        DispatchQueue.main.async {
            if Studio.isStudioModelComplete {
                self.updateUI()
                self.startButton.isEnabled = true
                self.settingsButton.removeBadge()
            } else {
                self.startButton.isEnabled = false
                self.settingsButton.setBadge(text: "!", andFontSize: 16)
                Animate.heartBeat(for: self.settingsButton.getBadgeLayer())
            }
        }
    }
    
    @objc private func updateQueueBadge() {
        DispatchQueue.main.async {
            self.queueButton.tintColor = UIColor.black
            self.queueButton.setBadge(text: String(Queue.count), withOffsetFromTopRight: CGPoint(x: -55, y: 0), andColor: UIColor.badgeGreenColor(), andFilled: true, andFontSize: 16)
        }
    }
    
    @objc func dismissLanguagePopover() {
        print("X button tapped in language tvc")
        let baseView = UIView()
        UIView.animate(withDuration: 0.1, animations: {
            baseView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }) { (complete) in
            UIView.animate(withDuration: 0.2, animations: {
                baseView.transform = CGAffineTransform(scaleX: 1, y: 0.2)
                baseView.alpha = 0.0
            }, completion: { (complete) in
                baseView.transform = .identity
                baseView.removeFromSuperview()
                for view in baseView.subviews{
                    view.removeFromSuperview()
                }
            })
        }
    }
    
    /// Shows the Under Age alert popup
//    fileprivate func showUnder18TattooAlert() {
//        let wrongBirthdateAlert = SCLAlertView(appearance: alertAppearance)
//        wrongBirthdateAlert.addButton("OK".localized()) {
//            self.tattooPiercing18AlertView.isHidden = true
//            self.blurView.isHidden = true
//        }
//        wrongBirthdateAlert.showWarning("Under Age".localized(), subTitle: "We're sorry, you must be 18 or older to get a tattoo.".localized())
//    }
    
    /// Sets the language button image to the currently set language flag image.
    /// The language code. i.e. "de", "en", "es-MX", "fr", "it", "ja", "ru", "zh-Hans"
    fileprivate func setLanguageButtonImage() {
        print("Current language: \(Localize.currentLanguage())") // debugging
        var imageName = "langButton_"
        imageName += Localize.currentLanguage()
        languageButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    /// Gets a record ID from the recordIDsForNamesDatesListIndex dictionary containing all the record ID's for the searched/filtered client models.
    ///
    /// - Parameter index: The dictionary index pertaining to the specificly chosen client.
    /// - Returns: The recordID of that client model.
    fileprivate func getRecordIDFor(key: String) -> CKRecord.ID? {
        guard let recordID = recordIDsForNamesDatesListIndex[key] else { return nil }
        return recordID
    }
    
    
    
    //***************************************************************
    // MARK: - Protocol methods
    //***************************************************************
    
    /// Validates a birthdate value with a returning client's birthdate for auto-fill purposes.
    ///
    /// - Parameter value: The birthdate as a string value.
    func writeBirthdateBack(_ birthdate: String) {
        // check 'value' against birthdate string (birthdateForAuth) of client
        let key = self.name + " " + self.zip
        if birthdate == self.namesDatesList[key] {
            print("Birthday value: \(String(describing: self.namesDatesList[key]))") // debugging
            guard let recordID = self.getRecordIDFor(key: key) else { return }
            
            // Retrieve Client model from iCloud
            iCloud.downloadClientFromiCloud(with: recordID, viewController: self, completion: { (error) in
                if error == nil {
                    Client.returningClient = true
                    
                    DispatchQueue.main.async {
                        // Show tattooPiercing18AlertView
                        self.searchBar.resignFirstResponder()
                        self.blurView.isHidden = false
                    }
                }
            })
        } else {
            DispatchQueue.main.async {
                Alerts.wrongBirthdateAlert(viewController: self)
                self.blurView.isHidden = true
            }
        }
    }
    
    /// Updates the UI with the chosen language info and images.
    ///
    /// - Parameter languageChosen: The currently chosen language string.
    func writeLanguageBack(_ languageChosen: String) {
        Localize.setCurrentLanguage(languageChosen)
        setText()
        setLanguageButtonImage()
        print("Language changed: \(languageChosen)") // debugging
    }
    
    /// Updates the UI when a popup is dismised.
    ///
    /// - Parameter didDismis: True if the popup was dismised, false otherwise.
    func popupDidDismis(_ didDismis: Bool) {
        if didDismis {
            blurView.isHidden = true
        }
    }
    
    
    
    //***************************************************************
    // MARK: - UISearchBarDelegate
    //***************************************************************
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        backgroundQueue.async {
            guard isiCloudSignedin() else { Alerts.iCloudSignedInError(viewController: self); return }
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: iCloud.RecordTypes.client, predicate: predicate)
            
            publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (queryResults, error) in
                if let results = queryResults {
                    for record in results {
                        let name = record.object(forKey: "name") as! String
                        let zip = record.object(forKey: "zip") as! String
                        let birthdateForAuth = record.object(forKey: "birth") as! String
                        let recordID = record.recordID
                        
                        let key = name + " " + zip.trimmingCharacters(in: .whitespaces)
                        self.namesDatesList.updateValue(birthdateForAuth, forKey: key)
//                        let index = self.namesDatesList.index(forKey: key)
                        self.recordIDsForNamesDatesListIndex.updateValue(recordID, forKey: key)
                    }
                } else if let error = error {
                    Alerts.myAlert(title: "Error", message: "There was an error downloading client list for search:\n \(error)", error: error, actionsTitleAndStyle: nil, viewController: self, buttonHandler: nil)
                }
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = namesDatesList.keys.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        print("Searchbar namesList: \(namesDatesList)") // debugging
        (filtered.count == 0) ? (searchActive = false) : (searchActive = true)
        searchTableView.reloadData()
        
        // These next two lines dynamicaly adjust the Search TableView's height
        super.updateViewConstraints()
        self.searchTableViewHeightConstraint?.constant = self.searchTableView.contentSize.height
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        self.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.resignFirstResponder()
    }
    
    
    
    //***************************************************************
    // MARK: - UITableViewDataSource
    //***************************************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID) as UITableViewCell?
        if searchActive {
            searchTableView.isHidden = false
            searchTableViewBlurView.isHidden = false
            cell?.textLabel?.text = filtered[indexPath.row]
        } else {
            searchTableView.isHidden = true
            searchTableViewBlurView.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.view.endEditing(true)
        blurView.isHidden = false
        let nameAndZip = cell?.textLabel?.text
        let nameZipArray = nameAndZip?.components(separatedBy: " ")
        self.name = "\(nameZipArray![0]) \(nameZipArray![1])"
        self.zip = nameZipArray![2]
    }
    
    
    
    //***************************************************************
    // MARK: - Navigaiton
    //***************************************************************

//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        var performSegue = true
//        if identifier == SegueIDs.FormSegue {
//            print("allows under 18 tatz:\(Studio.allowsUnder18Tattoos) - is under 18?: \(Client.isOver18) - tat(true) or pierce(false):\(Client.tattooORpiercing)")  // debugging
////            if !Studio.allowsUnder18Tattoos && !Client.isOver18 && Client.tattooORpiercing == true {
////                showUnder18TattooAlert()
////                performSegue = false
////            }
//        }
//
//        return performSegue
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopInfoVC = segue.destination as? ShopInfoViewController {
            shopInfoVC.client = Client
        }
        if let birthdayPasswordVC = segue.destination as? BirthdayPasswordViewController {
            birthdayPasswordVC.delegate = self
        }
        if let languageVC = segue.destination as? LanguageChooserTableViewController {
            languageVC.delegate = self
        }
    }

    
} // end of MainViewController

