//
//  PlacementPickerViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 12/21/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

class PlacementPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Instance Variables

    var delegate: writeBackInfo?
    var selectedPlacement1 = ""
    var selectedPlacement2 = ""
    var limbPlacement = [
        ["Arm".localized(),
         "Hand".localized(),
         "Back".localized(),
         "Torso/Ribs".localized(),
         "Leg".localized(),
         "Foot".localized(),
         "Head/Face".localized(),
         "Other".localized()],
        ["Right".localized(),
         "Left".localized(),
         "Right/Upper".localized(),
         "Right/Lower".localized(),
         "Left/Upper".localized(),
         "Left/Lower".localized(),
         "Left/Full".localized(),
         "Center".localized()],
    ]



    // MARK: - Outlets

    @IBOutlet weak var placementLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!



    // MARK: - Actions

    @IBAction func doneButtonAction(_ sender: UIButton) {
        delegate?.writeTattooBack(selectedPlacement1 + "-" + selectedPlacement2)
        self.dismiss(animated: true, completion: nil)
    }



    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** PlacementPickerViewController ****")
        placementLabel.text = "Select Your Tattoo Placement".localized()
        doneButton.setTitle("Done".localized(), for: .normal)
        selectedPlacement1 = limbPlacement[0][0]
        selectedPlacement2 = limbPlacement[1][0]
    }

    deinit { print("PlacementPickerViewController deinit") }



    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return limbPlacement.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return limbPlacement[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return limbPlacement[component][row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (component) {
        case 0: selectedPlacement1 = limbPlacement[component][row]
        case 1: selectedPlacement2 = limbPlacement[component][row]
        default: break
        }
    }


}

