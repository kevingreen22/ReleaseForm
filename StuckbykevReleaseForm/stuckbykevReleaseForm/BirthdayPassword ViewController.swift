//
//  BirthdayPasswordViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 1/13/17.
//  Copyright © 2017 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

class BirthdayPasswordViewController: UIViewController {
    
    // MARK: - Instance Variables
    
    var delegate: ReturnInfoDelegate?
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var birthDateLabel: UILabel!
    
    
    
    // MARk: - Actions
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        let date = DateFormatter.localizedString(from: birthdayPicker.date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
        self.dismiss(animated: true, completion: nil)
        delegate?.writeBirthdateBack(date)
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** BirthdayPasswordViewController ****")
        
        birthDateLabel.text = "Birth Date".localized()
        doneButton.setTitle("Done".localized(), for: .normal)
    }
   
    deinit { print("BirthdayPasswordViewController DEINIT") }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let main = segue.destination as? MainViewController {
            main.searchActive = false
        }
    }
    
    
}

