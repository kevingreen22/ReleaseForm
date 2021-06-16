//
//  BioInfoView.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 2/10/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

protocol writeBackInfo {
    func writeBirthdateBack(_ birthdateAsString: String, birthdateDate: Date)
    func writeStateBack(_ state: String)
    func writeTattooBack(_ placement: String)
    func writePiercingBack(_ piercing: String)
    func writeArtistBack(_ artist: String)
}

class BioInfoView: UIView, UITextFieldDelegate, writeBackInfo {
    
    // MARK: - Insatnce Vaibles
    
    let kCONTENT_XIB_NAME = "BioInfoView"
    let sb = UIStoryboard(name: "Form", bundle: nil)
    var infoTabVCRef: InfoTabVC!
    var collectInfoDelegate: CollectBioInfoDelegate!
    
    // Client info
    private var clientInfo: [String: String] = [
        "Name": "",
        "Street Address": "",
        "City": "",
        "Zip Code": "",
        "State": "",
        "Phone Number": "",
        "Email": "",
        "Birthdate": "",
        "Gender": "Private"
    ]

    
    
    // MARK: - Outlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bioInfoLabel: UILabel!
    @IBOutlet weak var nameField: UITextField! { didSet { nameField.delegate = self } }
    @IBOutlet weak var addressField: UITextField!  { didSet { addressField.delegate = self } }
    @IBOutlet weak var cityField: UITextField!  { didSet { cityField.delegate = self } }
    @IBOutlet weak var statePickerButton: UIButton!  {
        didSet {
            statePickerButton.titleLabel?.textAlignment = .center
            statePickerButton.layer.cornerRadius = 5
            statePickerButton.layer.borderWidth = 0.5
            statePickerButton.layer.borderColor = UIColor.buttonBorderColor().cgColor
            statePickerButton.setTitleColor(UIColor.greyPlaceholderColor(), for: .normal)
        }
    }
    @IBOutlet weak var zipcodeField: UITextField!  { didSet { zipcodeField.delegate = self } }
    @IBOutlet weak var phoneNumberField: UITextField!  { didSet { phoneNumberField.delegate = self } }
    @IBOutlet weak var emailField: UITextField!  { didSet { emailField.delegate = self } }
    @IBOutlet weak var birthdatePicker: UIButton! {
        didSet {
            birthdatePicker.titleLabel?.textAlignment = .center
            birthdatePicker.layer.cornerRadius = 5
            birthdatePicker.layer.borderWidth = 0.5
            birthdatePicker.layer.borderColor = UIColor.buttonBorderColor().cgColor
            birthdatePicker.setTitleColor(UIColor.greyPlaceholderColor(), for: .normal)
        }
    }
    @IBOutlet weak var genderSegment: UISegmentedControl! {
        didSet {
            let fontSize = UIFont.systemFont(ofSize: 26)
            let color = UIColor.greyPlaceholderColor()
            genderSegment.setTitleTextAttributes([NSAttributedString.Key.font: fontSize, NSAttributedString.Key.foregroundColor: color], for: .normal)
        }
    }


    
    // MARK: - Actions
    
    @IBAction func nameFieldAction(_ sender: UITextField) {
        if let name = sender.text {
            print("name set: \(name)") // debugging
            clientInfo["Name"] = sender.text
            collectInfoDelegate.getBioInfo(info: clientInfo)
        }
    }
    
    @IBAction func addressFieldAction(_ sender: UITextField) {
        print("address set: \(sender.text ?? "")") // debugging
        clientInfo["Street Address"] = sender.text ?? ""
        collectInfoDelegate.getBioInfo(info: clientInfo)
    }
    
    @IBAction func cityField(_ sender: UITextField) {
        print("city set: \(sender.text ?? "")") // debugging
        clientInfo["City"] = sender.text ?? ""
        collectInfoDelegate.getBioInfo(info: clientInfo)
    }
    
    @IBAction func zipcodeField(_ sender: UITextField) {
        print("zipcode set: \(sender.text ?? "")") // debugging
        clientInfo["Zip Code"] = sender.text ?? ""
        collectInfoDelegate.getBioInfo(info: clientInfo)
    }
    
    @IBAction func statePickerButtonTapped(_ sender: UIButton) {
        self.endEditing(true)
        
        if let statePickerVC = sb.instantiateViewController(withIdentifier: VCIdentifiers.StatePickerVC) as? StatePickerViewController {
            statePickerVC.modalPresentationStyle = .popover
            statePickerVC.popoverPresentationController?.sourceRect = sender.bounds
            statePickerVC.popoverPresentationController?.sourceView = sender
            statePickerVC.popoverPresentationController?.canOverlapSourceViewRect = true
            statePickerVC.delegate = self
            infoTabVCRef.present(statePickerVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func phoneNumberField(_ sender: UITextField) {
        print("phone num set: \(sender.text ?? "")") // debugging
        clientInfo["Phone Number"] = sender.text ?? ""
        collectInfoDelegate.getBioInfo(info: clientInfo)
    }
    
    @IBAction func emailField(_ sender: UITextField) {
        print("email set: \(sender.text ?? "none")") // debugging
        if sender.text == "" {
            clientInfo["Email"] = "none"
        } else {
            clientInfo["Email"] = sender.text
        }
        collectInfoDelegate.getBioInfo(info: clientInfo)
    }
    
    @IBAction func birthdatePickerPicked(_ sender: UIButton) {
        self.endEditing(true)

        if let datePickerVC = sb.instantiateViewController(withIdentifier: VCIdentifiers.DatePickerVC) as? DatePickerViewController {
            datePickerVC.modalPresentationStyle = .popover
            datePickerVC.popoverPresentationController?.sourceRect = sender.bounds
            datePickerVC.popoverPresentationController?.sourceView = sender
            datePickerVC.popoverPresentationController?.canOverlapSourceViewRect = true
            datePickerVC.delegate = self
            infoTabVCRef.present(datePickerVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func genderSegmentTapped(_ sender: UISegmentedControl) {
        self.endEditing(true)
        if sender.selectedSegmentIndex == 0 {
            clientInfo["Gender"] = "Female"
        } else if sender.selectedSegmentIndex == 1 {
            clientInfo["Gender"] = "Male"
        } else if sender.selectedSegmentIndex == 2 {
            clientInfo["gender"] = "Private"
        }
        collectInfoDelegate.getBioInfo(info: clientInfo)
        print("gender set") // debugging
    }
    
    
    
    
    // MARK: - Protocol Methods
    
    func writeStateBack(_ state: String) {
        clientInfo["State"] = state
        collectInfoDelegate.getBioInfo(info: clientInfo)
        statePickerButton.setTitle(state, for: .normal)
        print("state set: \(state)") // debugging
        statePickerButton.setTitleColor(.black, for: .normal)
        zipcodeField.becomeFirstResponder()
    }
    
    func writeBirthdateBack(_ birthdateString: String, birthdateDate: Date) {
        clientInfo["Birthdate"] = birthdateString
        Client.birthdate = birthdateDate
        collectInfoDelegate.getBioInfo(info: clientInfo)
        print("birthdate set: \(birthdateString)") // debugging
        birthdatePicker.setTitle(birthdateString, for: .normal)
        birthdatePicker.setTitleColor(.black, for: .normal)
    }
    
    func writeTattooBack(_ placement: String) { }
    func writePiercingBack(_ piercing: String) { }
    func writeArtistBack(_ artist: String) { }
    

    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
    // MARK: - Private Helper Methods
    
    fileprivate func commonInit() {
        print("\n**** BioInfoView ****")
        let bundle = Bundle(for: FormTabBarController.self)
        bundle.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        
        setTextForLocalization()
        populateBioWithReturningClientsInfo()
    }
    
    fileprivate func setTextForLocalization() {
        nameField.placeholder = "Enter Name - First and Last".localized()
        addressField.placeholder = "Enter Street Address".localized()
        cityField.placeholder = "Enter City".localized()
        statePickerButton.setTitle("Enter State".localized(), for: .normal)
        zipcodeField.placeholder = "Enter Zipcode".localized()
        phoneNumberField.placeholder = "Enter Phone Number".localized()
        emailField.placeholder = "Enter Email (optional)".localized()
        birthdatePicker.setTitle("Select Birthdate".localized(), for: .normal)
        genderSegment.setTitle("Female".localized(), forSegmentAt: 0)
        genderSegment.setTitle("Male".localized(), forSegmentAt: 1)
        genderSegment.setTitle("Private".localized(), forSegmentAt: 2)
    }
    
    
    /// Populate all textfields/button-titles with client info.
    fileprivate func populateBioWithReturningClientsInfo() {
        if Client.returningClient {
            print(Client)
            nameField.text = Client.name
            addressField.text = Client.streetAddress
            cityField.text = Client.city
            statePickerButton.setTitle(Client.state, for: .normal)
            statePickerButton.setTitleColor(.black, for: .normal)
            zipcodeField.text = Client.zipcode
            phoneNumberField.text = Client.phoneNumber
            emailField.text = Client.emailAddress
            birthdatePicker.setTitle(Client.birthdateString, for: .normal)
            birthdatePicker.setTitleColor(.black, for: .normal)
            switch Client.gender {
            case "Female": genderSegment.selectedSegmentIndex = 0
            case "Male": genderSegment.selectedSegmentIndex = 1
            case "Private": genderSegment.selectedSegmentIndex = 2
            default: genderSegment.selectedSegmentIndex = 2
            }
            
        }
    }
    
    
    
    // MARK: - UITextfieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            addressField.becomeFirstResponder()
        case addressField:
            cityField.becomeFirstResponder()
        case cityField:
            statePickerButton.sendActions(for: .touchUpInside)
        case zipcodeField:
            phoneNumberField.becomeFirstResponder()
        case phoneNumberField:
            emailField.becomeFirstResponder()
        case emailField:
            birthdatePicker.sendActions(for: .touchUpInside)
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        infoTabVCRef.activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        infoTabVCRef.activeField = nil
    }
    

}
