//
//  SetPasscodeViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/6/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit

class SetPasscodeViewController: UIViewController {
    
    // MARK: - Instance variables

    var delegate: WriteSettingsInfoBack?
    var passcode = ""
    var isMaster = false
    var isArtist = false
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var passcodeDisplay: UILabel!
    @IBOutlet weak var oneDigit: UIButton!
    @IBOutlet weak var twoDigit: UIButton!
    @IBOutlet weak var threeDigit: UIButton!
    @IBOutlet weak var fourDigit: UIButton!
    @IBOutlet weak var fiveDigit: UIButton!
    @IBOutlet weak var sixDigit: UIButton!
    @IBOutlet weak var sevenDigit: UIButton!
    @IBOutlet weak var eightDigit: UIButton!
    @IBOutlet weak var nineDigit: UIButton!
    @IBOutlet weak var zeroDigit: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var setButton: UIButton! {
        didSet {
            setButton.isEnabled = false
        }
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func touchDigit(_ sender: UIButton) {
        guard let digit = sender.currentTitle else { return }
        passcodeDisplay.text?.append(Character(digit))
        if (passcodeDisplay.text?.count)! >= 4 {
            disableDigitButtons()
        }
        if passcodeDisplay.text?.count == 4 { setButton.isEnabled = true }
        passcode = passcodeDisplay.text!
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        if passcodeDisplay.text != "" {
            passcodeDisplay.text?.remove(at: (passcodeDisplay.text?.index(before: (passcodeDisplay.text?.endIndex)!))!)
            enableDigitButtons()
            if passcodeDisplay.text != "" {
                passcode = passcodeDisplay.text!
            }
        }
    }
    
    @IBAction func setButtonAction(_ sender: UIButton) {
        if passcode != "" && passcodeDisplay.text?.count == 4 {
            if isMaster {
                delegate?.writeMasterPasscodeBack(passcode: passcode)
                Studio.masterPasscode = passcode
            } else if isArtist {
                delegate?.writeArtistPasscodeBack(passcode: passcode)
                Studio.artistPasscode = passcode
            }
            
        }
    }

    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** SetPasscodeViewController ****")
    }
    
    deinit { print("SetPasscodeViewController DEINIT") }
   
    
    
    // MARK: - Helper Methods
    
    fileprivate func disableDigitButtons() {
        oneDigit.isEnabled = false
        twoDigit.isEnabled = false
        threeDigit.isEnabled = false
        fourDigit.isEnabled = false
        fiveDigit.isEnabled = false
        sixDigit.isEnabled = false
        sevenDigit.isEnabled = false
        eightDigit.isEnabled = false
        nineDigit.isEnabled = false
        zeroDigit.isEnabled = false
    }
    
    fileprivate func enableDigitButtons() {
        oneDigit.isEnabled = true
        twoDigit.isEnabled = true
        threeDigit.isEnabled = true
        fourDigit.isEnabled = true
        fiveDigit.isEnabled = true
        sixDigit.isEnabled = true
        sevenDigit.isEnabled = true
        eightDigit.isEnabled = true
        nineDigit.isEnabled = true
        zeroDigit.isEnabled = true
    }
    
    
}

