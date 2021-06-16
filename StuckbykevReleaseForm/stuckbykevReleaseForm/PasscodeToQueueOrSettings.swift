//
//  PasscodeToQueueOrSettings.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/20/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

class PasscodeToQueueOrSettings: UIViewController, UITextFieldDelegate {
    
    // MARK: - Instance variables

    private var passcode = ""
    var segueIdentifier: String!
    var isMaster = false
    var isArtist = false
    var delegate: ReturnInfoDelegate?
    
    
    
    // MARK: - Actions
    
    @IBAction func touchDigitButtonAction(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if h1.text == "" {
            h1.text = digit
            s1.text = digit
            passcode += digit
        } else if h2.text == "" {
            h2.text = digit
            s2.text = digit
            passcode += digit
        } else if h3.text == "" {
            h3.text = digit
            s3.text = digit
            passcode += digit
        } else if h4.text == "" {
            h4.text = digit
            s4.text = digit
            passcode += digit
            print("Passcode entered \(passcode)") // debugging
            if isMaster {
                if passcode == Studio.masterPasscode {
                    performSegue(withIdentifier: segueIdentifier, sender: self)
                } else { showWrongPassAlert() }
            } else if isArtist {
                if passcode == Studio.artistPasscode || passcode == Studio.masterPasscode {
                    performSegue(withIdentifier: segueIdentifier, sender: self)
                } else { showWrongPassAlert() }
            }
        }
    }
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var h1: UITextField!
    @IBOutlet weak var h2: UITextField!
    @IBOutlet weak var h3: UITextField!
    @IBOutlet weak var h4: UITextField!
    @IBOutlet weak var s1: UITextField!
    @IBOutlet weak var s2: UITextField!
    @IBOutlet weak var s3: UITextField!
    @IBOutlet weak var s4: UITextField!
    
    
    
    // MARK: - Helper Methods
    
    fileprivate func showWrongPassAlert() {
        let conformationAlert = UIAlertController(title: "Wrong Password".localized(), message: "Please Try Again".localized(), preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Ok".localized(), style: .cancel, handler: { (ACTION) in
            self.h1.text = ""
            self.h2.text = ""
            self.h3.text = ""
            self.h4.text = ""
            self.s1.text = nil
            self.s2.text = nil
            self.s3.text = nil
            self.s4.text = nil
            self.passcode = ""
        })
        conformationAlert.addAction(cancel)
        self.present(conformationAlert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** PasscodeToQueueOrSettings ****")
        
        h1.text = ""
        h2.text = ""
        h3.text = ""
        h4.text = ""
        s1.text = nil
        s2.text = nil
        s3.text = nil
        s4.text = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.popupDidDismis(true)
    }
    
    deinit { print("PasscodeToQueueOrSettings DEINIT") }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIDs.PasscodeToQueueSegue {
            guard let queue = segue.destination as? UINavigationController else { return }
            queue.modalPresentationStyle = .fullScreen
        }
    }
    
    
}
