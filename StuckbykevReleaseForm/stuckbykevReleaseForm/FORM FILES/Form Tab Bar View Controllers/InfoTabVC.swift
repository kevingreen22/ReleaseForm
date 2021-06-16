//
//  InfoTabVC.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/2/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

protocol CollectBioInfoDelegate {
    func getBioInfo(info: [String:String])
}

class InfoTabVC: UIViewController, UITextFieldDelegate, CollectBioInfoDelegate {
    
    // MARK: - Instance Variables
    var clientInfo = [String:String]()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelFormBarButton: UIBarButtonItem!
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    @IBOutlet weak var helpButton: SpringButton!
    @IBOutlet weak var bioInfoView: BioInfoView! { didSet { setupViewToOrientation() } }
    
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIBarButtonItem) {
        print("Next button tapped")
        // go to next tab
        tabBarController?.selectedIndex = 2
    }
    
    var currentlyVisible: Bool = false
    @IBAction func helpTapped(_ sender: SpringButton) {
        print("Help button tapped")
        Animate.pop(for: sender, loop: false, completion: {})
        let helpView = HelpView()
        if !currentlyVisible {
            helpView.frame.origin = CGPoint(x: sender.frame.maxX + 5, y: sender.frame.minY - sender.frame.height * 2)
            helpView.label.text = "Long press to show the help tutorial".localized()
            view.bringSubviewToFront(helpView)
            self.view.addSubview(helpView)
            currentlyVisible = true
        } else {
            delay(delay: 3.0) {
                helpView.removeFromSuperview()
                self.currentlyVisible = false
            }
        }
        delay(delay: 3.0) {
            helpView.removeFromSuperview()
            self.currentlyVisible = false
        }
    }
    
    @IBAction func longPressOnHelpButton(_ sender: UILongPressGestureRecognizer) {
        print("Long press gesture triggered")
        if sender.state == .began {
            showHelpTutorial(viewController: self)
        }
    }
    
    @IBAction func cancelFormTapped(_ sender: UIBarButtonItem) {
        print("Cancel button tapped")
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** InfoTabVC ****")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        bioInfoView.infoTabVCRef = self
        bioInfoView.collectInfoDelegate = self
        
        view.backgroundColor = Studio.backgroundColor
        setTextForLocalization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit { print("InfoTabVC DEINIT") }
    
    
    
    // MARK: - Private Helper Methods
    
    func setupViewToOrientation() {
//        guard infoViewsStackView != nil else { return }
//        if UIDevice.current.orientation.isLandscape {
//            print("InfoTabVC Orientation changed to landscape")
//            infoViewsStackView.axis = .horizontal
//            infoViewsStackView.distribution = .fillEqually
//            infoViewsStackView.spacing = 8
//
//        } else if UIDevice.current.orientation.isPortrait {
//            print("InfoTabVC Orientation changed to portrait")
//            infoViewsStackView.axis = .vertical
//            infoViewsStackView.distribution = .fillProportionally
//            infoViewsStackView.spacing = 8
//        }
    }
    
    fileprivate func setTextForLocalization() {
        navigationItem.title = "Information".localized()
        cancelFormBarButton.title = "Cancel Form".localized()
        nextBarButton.title = "Next".localized()
    }
    
    
//    // Adjusts the view so the keyboard wont cover the text fields
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    /// Adjusts the view so the keyboard wont cover the text fields
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    var activeField: UITextField?
    private var activeFieldSuperViewOriginalFrameY:CGFloat = 0.0
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let activeField = self.activeField else { return }
        guard let activeFieldSuperview = activeField.superview else { return }
        activeFieldSuperViewOriginalFrameY = activeFieldSuperview.frame.origin.y
        let keyboardFrame = keyboardSize.cgRectValue
        var bkgndRect = activeFieldSuperview.frame
        bkgndRect.size.height += keyboardFrame.height
        activeFieldSuperview.frame = bkgndRect
        
        if activeFieldSuperview.frame.origin.y >= keyboardFrame.minY {
            activeFieldSuperview.frame.origin.y = (activeFieldSuperview.frame.origin.y - (keyboardFrame.height))
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let activeField = self.activeField else { return }
        guard let activeFieldSuperview = activeField.superview else { return }
        
        if activeFieldSuperview.frame.origin.y != activeFieldSuperViewOriginalFrameY {
            activeFieldSuperview.frame.origin.y = activeFieldSuperViewOriginalFrameY
        }
    }
    
    
    
    // MARK: - CollectShopAndBioInfoDelegate
    
    /// Gets the client info from the form and saves it to a local variable. Used for ClientModel's collection of form info.
    ///
    /// - Parameter info: The info as a dictionary.
    func getBioInfo(info: [String : String]) {
        clientInfo = info
    }
    
    
    
    // MARK: - Orientation Delegate
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupViewToOrientation()
    }
    
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let performSegue = false
        
        if identifier == SegueIDs.unwindToMainSegue {
            Alerts.cancelFormAlert(viewController: self)
        }
        return performSegue
    }
    

}

