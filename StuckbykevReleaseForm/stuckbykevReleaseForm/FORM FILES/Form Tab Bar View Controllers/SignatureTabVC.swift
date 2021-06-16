//
//  SignatureTabVC.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/2/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

protocol SignatureImageDelegate {
    func didSetMainSignature(image: UIImage?)
    func didSetMinorSignature(image: UIImage?)
}

class SignatureTabVC: UIViewController, SignatureImageDelegate {
    
    // MARK: - Insatance Variables
    
    private var tabbarVC: FormTabBarController! = nil
    private var viewControllers: [UIViewController]! = nil
    var signatureImages = [UIImage]()
    var signatureImage: UIImage!
    var minorSignImage: UIImage?
    
    
    // MARK: - Outlets
    
    @IBOutlet var signaturePadStackView: UIStackView!
    @IBOutlet weak var declarationLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelFormButton: UIBarButtonItem!
    @IBOutlet weak var FinishedButton: UIBarButtonItem!
    
    
    
    // MARK: - Actions
    
    @IBAction func FinishedTapped(_ sender: UIBarButtonItem) {
        print("Finished button tapped")
    }
    
    @IBAction func cancelFormTapped(_ sender: UIBarButtonItem) {
        print("Cancel button tapped")
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** SignatureTabVC ****")
        
        tabbarVC = self.tabBarController as? FormTabBarController
        viewControllers = tabbarVC.viewControllers
        
        view.backgroundColor = Studio.backgroundColor
        setTextForLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSignaturePad()
    }
    
    deinit { print("SignatureTabVC DEINIT") }

    
    
    // MARK: - SignatureImageDelegate
    
    func didSetMainSignature(image: UIImage?) {
        signatureImage = image
    }
    
    func didSetMinorSignature(image: UIImage?) {
        minorSignImage = image
    }
    
    
    
    // MARK: - Private Helper Methods
    
    fileprivate func setTextForLocalization() {
        navigationItem.title = "Signature".localized()
        cancelFormButton.title = "Cancel Form".localized()
        FinishedButton.title = "Finished".localized()
        declarationLabel.text = "By my signature below, I certify under Penalty Of Perjury that the information provided is true and correct, and that I am at least 18 years of age or older; (or have a parent present with ID’s). I further understand that, if I give false information or produce false documents stating my name and age to be other that what is correct, I am liable for prosecution.".localized()
    }
    
    /// Adds one signature pad if over 18, and two pads if under 18, to the signature stack view.
    fileprivate func addSignaturePad() {
        // removes all previous signature pad. (In case user views signatureVC more that once).
        for pad in signaturePadStackView.arrangedSubviews {
            signaturePadStackView.removeArrangedSubview(pad)
        }
        
        // Adds one signature pad to the stackview.
        let signPad = SignaturePad()
        signaturePadStackView.addArrangedSubview(signPad)
        signPad.imageDelegate = self
        signPad.parentORminorLabel.isHidden = true
        signPad.isMinorSignature = false
        signPad.clearSignatureButton.setTitle("Clear Signature".localized(), for: .normal)
        
        // If client is under 18 then a second signature pad is added to the stackview.
        if !Client.isOver18 {
            signPad.parentORminorLabel.isHidden = false
            signPad.parentORminorLabel.text = "Parent/Guardian's Signature".localized()
            let signPadMinor = SignaturePad()
            signaturePadStackView.addArrangedSubview(signPadMinor)
            signPadMinor.imageDelegate = self
            signPadMinor.parentORminorLabel.text = "Minor's Signature".localized()
            signPadMinor.isMinorSignature = true
            signPad.clearSignatureButton.setTitle("Clear Signature".localized(), for: .normal)
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var performSegue = false
        
        if identifier == SegueIDs.unwindToMainSegue {
            Alerts.cancelFormAlert(viewController: self)
        }
        
        if identifier == SegueIDs.AllDoneSegue {
            let (comp, list) = tabbarVC.checkFormsCompleteness(viewControllers: viewControllers)
            if comp {
                // Sets the signature images to an array
                signatureImages.append(signatureImage)
                if minorSignImage != nil { signatureImages.append(minorSignImage!) }
                
                tabbarVC.saveClientAndAddToQueue()
                
                performSegue = true
                
            } else {
                Alerts.incompleteFormAlert(viewController: self, missingList: list ?? "There was an error.".localized())
            }
        }
        
        return performSegue
    }
    
    
}

