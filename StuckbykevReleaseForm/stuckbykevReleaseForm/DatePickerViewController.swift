//
//  DatePickerViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/29/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

class DatePickerViewController: UIViewController {
    
    // MARK: - Instance variables
    
    var delegate: writeBackInfo?
    
    
    
    // MARK: - Acions
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        let dateAsString = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
        self.dismiss(animated: true, completion: {
            self.delegate?.writeBirthdateBack(dateAsString, birthdateDate: self.datePicker.date)
        })
    }
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** DatePickerViewController ****")
        birthdayLabel.text = "Select Your Birthdate".localized()
        doneButton.setTitle("Done".localized(), for: .normal)
    }
    
    deinit { print("DatePickerViewController DEINIT") }
    
    
}

