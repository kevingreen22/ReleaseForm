//
//  PiercingTypeViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/27/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

class PiercingTypePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Instance variables

    var delegate: writeBackInfo?
    var selectedPiercing: String!
    var typeOfPiercingArray = ["Ampallang",
                               "Anchor(s)",
                               "Apadravya",
                               "Bridge",
                               "Cartilage(s)",
                               "Christina",
                               "Clitoral Hood",
                               "Conch",
                               "Daith(s)",
                               "Dydoe(s)",
                               "Ear Lobe(s)",
                               "Eyebrow(s)",
                               "Foreskin(s)",
                               "Foward Helix(s)",
                               "Frenum",
                               "Helix(s)",
                               "Industrial",
                               "labia(s)",
                               "Labret",
                               "Lip(s)",
                               "Navel",
                               "Nipple(s)",
                               "Nostril(s)",
                               "Other, Not Listed".localized(),
                               "Prince Albert",
                               "Rook(s)",
                               "Septum",
                               "Smiley",
                               "Snug(s)",
                               "Surface(s)",
                               "Tongue(s)",
                               "Tongue Web",
                               "Tragus(s)",
                               "Triangle",
    ]



    // MARK: - Outlets

    @IBOutlet weak var piercingTypeLabel: UILabel!
    @IBOutlet weak var piercingTypePicker: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!



    // MARK: - Actions

    @IBAction func doneButtonAction(_ sender: UIButton) {
        delegate?.writePiercingBack(selectedPiercing)
        self.dismiss(animated: true, completion: nil)
    }



    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** PiercingTypePickerViewController ****")
        piercingTypeLabel.text = "Select Your Piercing Type".localized()
        doneButton.setTitle("Done".localized(), for: .normal)
        selectedPiercing = typeOfPiercingArray[0]
    }

    deinit { print("PiercingTypePickerViewController deinit") }



    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfPiercingArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOfPiercingArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPiercing = typeOfPiercingArray[row]
    }


}

