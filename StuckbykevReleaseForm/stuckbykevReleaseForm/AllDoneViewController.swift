//
//  AllDoneViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 2/5/17.
//  Copyright © 2017 Kevin Green. All rights reserved.
//

import UIKit
import MessageUI
import Localize_Swift
//import CircularSpinner

class AllDoneViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var allDoneLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var aftercareLabel: UILabel!
    @IBOutlet weak var aftercareSwitch: UISwitch!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    
    
    
    // MARK: - Actions
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        if aftercareSwitch.isOn && isValidEmail(email: emailTextfield.text!) {
            resignFirstResponder()
            sendEmail(emailAddress: emailTextfield.text!)
        }
    }
    
    @IBAction func aftercareSwitchAction(_ sender: UISwitch) {
        if !aftercareSwitch.isOn {
            emailTextfield.resignFirstResponder()
        } else if aftercareSwitch.isOn {
            emailTextfield.becomeFirstResponder()
        }
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** AllDoneViewController ****")
        
        iCloud.uploadQueueToCloud(queue: Queue, viewController: self, completion: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        aftercareSwitch.isOn = false
        blurEffectView.isHidden = false
        backgroundImageView.image = Studio.logo
        backgroundImageView.contentMode = .scaleAspectFill
        
        if let clientEmail = Client.emailAddress {
            emailTextfield.text = clientEmail
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setText()
    }
    
    deinit { print("AllDoneViewController DEINIT") }
    
    
    
    // MARK: - Helper Methods
    
    fileprivate func setText() {
        allDoneLabel.text = "Thats it, your all done!".localized()
        readyLabel.text = "Your artist will call you when they're ready.".localized()
        aftercareLabel.text = "If you would like, we can send you a digital copy of your aftercare instructions.".localized()
        emailTextfield.placeholder = "Enter Email".localized()
    }
    
    
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func sendEmail(emailAddress: String) {
        var tatORpierce: String?
        DispatchQueue.global().async {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                let studioName = UserDefaults.standard.object(forKey: UDKeys.UDStudioName)
                mail.mailComposeDelegate = self
                mail.setToRecipients([emailAddress])
                mail.setSubject("Your Aftercare Instructions".localized())
                
                if Client.tattooORpiercing {
                    tatORpierce = "tattoo".localized()
                    guard let filePath = Bundle.main.path(forResource: "Tattoo Aftercare Instructions", ofType: "pdf") else { return }
                    guard let tattooAftercareData = NSData(contentsOfFile: filePath) else { return }
                    mail.addAttachmentData(tattooAftercareData as Data, mimeType: "application/pdf", fileName: "Tattoo Aftercare Instructions.pdf")
                } else {
                    tatORpierce = "piercing".localized()
                    guard let filePath = Bundle.main.path(forResource: "Piercing Aftercare Instructions", ofType: "pdf") else { return }
                    guard let piercingAftercareData = NSData(contentsOfFile: filePath) else { return }
                    mail.addAttachmentData(piercingAftercareData as Data, mimeType: "application/pdf", fileName: "Piercing Aftercare Instructions.pdf")
                    
                }
                mail.setMessageBody("Thank you for your recent \(tatORpierce!) from \(studioName!)\n Here is your requested copy of your aftercare instructions.".localized(), isHTML: false)
                
                self.present(mail, animated: true, completion: nil)
                
            } else {
                print("Device can not send mail.") // debugging
            }
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail Cancelled") // debugging
        case MFMailComposeResult.sent:
            print("Mail Sent") // debugging
        case MFMailComposeResult.saved:
            print("Draft Saved") // debugging
        case MFMailComposeResult.failed:
            print("Failed Mail: \(String(describing: error))") // debugging
        @unknown default:
            fatalError("Mail compose finished with unknown error.")
        }
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "Unwind To Main VC", sender: self)
        })
    }

    
}

