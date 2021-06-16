//
//  ShopInfoViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/11/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

class ShopInfoViewController: UIViewController, UITextFieldDelegate, writeBackInfo {
    
    // MARK: - Insatnce Vaibles
    
    var client: ClientModel!

    
    // Shop info
    public var shopInfo: [String:String] = [
        "Artist Name": "",
        "Type Of Piercing": "",
        "Placement Of Tattoo": "",
        "Description Of Tattoo": ""
    ]
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tattooOrPiercingSegment: UISegmentedControl!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var artistPickerButton: UIButton! { didSet { initButtonUI(button: artistPickerButton) } }
    @IBOutlet weak var piercingPickerButton: UIButton! { didSet { initButtonUI(button: piercingPickerButton) } }
    @IBOutlet weak var tattooPlacementPickerButton: UIButton! { didSet { initButtonUI(button: tattooPlacementPickerButton) } }
    @IBOutlet weak var descriptionOfTattooTextField: UITextField! { didSet { descriptionOfTattooTextField.delegate = self } }
    @IBOutlet weak var priceTextField: UITextField! { didSet { priceTextField.delegate = self } }
    @IBOutlet weak var continueButton: UIButton!
    
    fileprivate func initButtonUI(button: UIButton) {
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.buttonBorderColor().cgColor
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func tattooOrPiercingSegmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Tattoo Segment selected: \(Client.tattooORpiercing)") // debugging
            Client.tattooORpiercing = true
        } else {
            print("Piercing Segment selected: \(Client.tattooORpiercing)") // debugging
            Client.tattooORpiercing = false
        }
        setupTattooOrPiercingOption()
    }
    
    @IBAction func artistPickerButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let artistPickerVC = storyboard!.instantiateViewController(withIdentifier: VCIdentifiers.ArtistPickerVC) as? ArtistPickerViewController {
            artistPickerVC.modalPresentationStyle = .popover
            artistPickerVC.popoverPresentationController?.sourceRect = sender.bounds
            artistPickerVC.popoverPresentationController?.sourceView = sender
            artistPickerVC.popoverPresentationController?.canOverlapSourceViewRect = true
            artistPickerVC.delegate = self
            present(artistPickerVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func piercingPickerButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let piercingPickerVC = storyboard!.instantiateViewController(withIdentifier: VCIdentifiers.PiercingPickerVC) as? PiercingTypePickerViewController {
            piercingPickerVC.modalPresentationStyle = .popover
            piercingPickerVC.popoverPresentationController?.sourceRect = sender.bounds
            piercingPickerVC.popoverPresentationController?.sourceView = sender
            piercingPickerVC.popoverPresentationController?.canOverlapSourceViewRect = true
            piercingPickerVC.delegate = self
            present(piercingPickerVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tattooPlacementPickerButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let placementPickerVC = storyboard!.instantiateViewController(withIdentifier: VCIdentifiers.PlacementPickerVC) as? PlacementPickerViewController {
            placementPickerVC.modalPresentationStyle = .popover
            placementPickerVC.popoverPresentationController?.sourceRect = sender.bounds
            placementPickerVC.popoverPresentationController?.sourceView = sender
            placementPickerVC.popoverPresentationController?.canOverlapSourceViewRect = true
            placementPickerVC.delegate = self
            present(placementPickerVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func descriptionOfTattooEdited(_ sender: UITextField) {
        print("Tattoo Desc Set") // debugging
        shopInfo["Description Of Tattoo"] = sender.text ?? ""
    }
    
    @IBAction func priceEdited(_ sender: UITextField) {
        print("Price set") // debugging
        Client.price = sender.text ?? ""
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        print("Continue button tapped")
        client.collectClientShopInfo(shopInfo: shopInfo)
        let _ = shouldPerformSegue(withIdentifier: "", sender: sender)
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** ShopInfoView ****")
        
        todaysDateLabel.text = Date().myDateFormatted(timeStyle: .short)
        setupTattooOrPiercingOption()
        populateClientInfo()
    }
    
    
    
    // MARK: - Public Methods
   
    /// Sets up the UI for tattoo or piercing.
    public func setupTattooOrPiercingOption() {
        if Client.tattooORpiercing {
            // tattoo
            tattooPlacementPickerButton.isHidden = false
            descriptionOfTattooTextField.isHidden = false
            shopInfo.removeValue(forKey: "Placement Of Tattoo")
            shopInfo.removeValue(forKey: "Description Of Tattoo")
            
            piercingPickerButton.isHidden = true
            shopInfo.removeValue(forKey: "Type Of Piercing")
        } else {
            // piercing
            piercingPickerButton.isHidden = false
            shopInfo.removeValue(forKey: "Type Of Piercing")
            
            tattooPlacementPickerButton.isHidden = true
            descriptionOfTattooTextField.isHidden = true
            shopInfo.removeValue(forKey: "Placement Of Tattoo")
            shopInfo.removeValue(forKey: "Description Of Tattoo")
        }
        removeAllValuesInView()
    }
    
    
    
    // MARK: - Private Methods
    
    fileprivate func populateClientInfo() {
        if client.tattooORpiercing {
            tattooOrPiercingSegment.selectedSegmentIndex = 0
            if client.placementOfTattoo != "" {
                tattooPlacementPickerButton.setTitle(client.placementOfTattoo, for: .normal)
            } else {
                tattooPlacementPickerButton.setTitle("Select Tattoo Placement", for: .normal)
                tattooPlacementPickerButton.setTitleColor(.lightGray, for: .normal)
            }
            
            if client.descriptionOfTattoo != "" {
                descriptionOfTattooTextField.text = client.descriptionOfTattoo
            } else {
                descriptionOfTattooTextField.placeholder = "Enter Description Of Tattoo"
            }
            
        } else {
            self.tattooOrPiercingSegment.selectedSegmentIndex = 1
            if client.typeOfPiercing != "" {
                piercingPickerButton.setTitle(self.client.typeOfPiercing, for: .normal)
            } else {
                piercingPickerButton.setTitle("Select Piercing", for: .normal)
                piercingPickerButton.setTitleColor(.lightGray, for: .normal)
            }
            
        }
        
        if client.artistName != "" {
            artistPickerButton.setTitle(self.client.artistName, for: .normal)
        } else {
            artistPickerButton.setTitle("Select Artist", for: .normal)
            artistPickerButton.setTitleColor(.lightGray, for: .normal)
        }
        
        if client.price != "" {
            priceTextField.text = client.price
        } else {
            priceTextField.text = ""
            priceTextField.placeholder = "Price"
        }
    }
    
    
    fileprivate func removeAllValuesInView() {
        artistPickerButton.setTitle("Select Artist", for: .normal)
        artistPickerButton.setTitleColor(.lightGray, for: .normal)
        piercingPickerButton.setTitle("Select Piercing", for: .normal)
        piercingPickerButton.setTitleColor(.lightGray, for: .normal)
        tattooPlacementPickerButton.setTitle("Select Tattoo Placement", for: .normal)
        tattooPlacementPickerButton.setTitleColor(.lightGray, for: .normal)
        descriptionOfTattooTextField.text = ""
        descriptionOfTattooTextField.placeholder = "Enter Description Of Tattoo"
        priceTextField.text = ""
        priceTextField.placeholder = "Price"
    }
    
    
    
    // MARK: - Protocol Methods
    
    func writeTattooBack(_ placement: String) {
        print("tattoo placement: \(placement)") // debugging
        shopInfo["Placement Of Tattoo"] = placement
        tattooPlacementPickerButton.setTitle(placement, for: .normal)
        tattooPlacementPickerButton.setTitleColor(.black, for: .normal)
    }
    
    func writePiercingBack(_ piercing: String) {
        print("piercing name: \(piercing)") // debugging
        shopInfo["Type Of Piercing"] = piercing
        piercingPickerButton.setTitle(piercing, for: .normal)
        piercingPickerButton.setTitleColor(.black, for: .normal)
    }
    
    func writeArtistBack(_ artist: String) {
        print("artist name: \(artist)") // debugging
        shopInfo["Artist Name"] = artist
        artistPickerButton.setTitle(artist, for: .normal)
        artistPickerButton.setTitleColor(.black, for: .normal)
    }
    
    func writeBirthdateBack(_ birthdateString: String, birthdateDate: Date) { }
    func writeStateBack(_ state: String) { }
    
    
    
    // MARK: - UITextfieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "", let index = Queue.firstIndex(of: client) {
            updateClientInQueue(with: self.client, at: index, viewController: nil)
            if let vc = self.presentingViewController as? ClientQueueDetailController {
                vc.client = client
                vc.viewWillAppear(true)
            }
            dismiss(animated: true, completion: nil)
            return false
        } else { return true }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let formTBC = segue.destination as? FormTabBarController {
            formTBC.modalPresentationStyle = .fullScreen
            Client = client
        }
    }

}
