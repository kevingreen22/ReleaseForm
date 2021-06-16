//
//  CameraTabVC.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/29/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import AVFoundation
import Localize_Swift
//import SCLAlertView

protocol PreviewPhotos {
    func removePhoto(view: PhotoPreviewView)
}

class CameraTabVC: UIViewController, AVCapturePhotoCaptureDelegate, PreviewPhotos {
    
    //***************************************************************
    // MARK: - Instance variables
    //***************************************************************
    
    var photos: [UIImage] = []
    private var isHelpViewVisible: Bool = false
    
    
    
    //***************************************************************
    // MARK: - Outlets
    //***************************************************************
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelFormButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var startPhotoSessionButton: SpringButton! { didSet {
        startPhotoSessionButton.layer.cornerRadius = startPhotoSessionButton.frame.height / 2
        }}
    @IBOutlet weak var helpButton: SpringButton!
    @IBOutlet weak var photoPreviewStackView: UIStackView!
    @IBOutlet weak var noPhotosImageview: UIImageView!
 
    
    
    //***************************************************************
    // MARK: - Actions
    //***************************************************************
    
    @IBAction func nextTapped(_ sender: UIBarButtonItem) {
        print("Next button tapped") // debugging
        // go to next tab
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func startPhotoSessionButton(_ sender: SpringButton) {
         print("Take-photo-button tapped") // debugging
        Animate.pop(for: sender, loop: false, completion: { })
        CameraHandler.shared.camera(vc: self)
    }
    
    @IBAction func helpButtonAction(_ sender: SpringButton) {
        print("Help button tapped")  // debugging
        Animate.pop(for: sender, loop: false, completion: {})
        showHelpViewInstruction(sender)
    }
    
    
    /// Shows the initial help view instruction. i.e. Tells the user to long press on the help icon in order to show the help tutorial.
    ///
    /// - Parameter sender: The SpringButton that triggered the event.
    fileprivate func showHelpViewInstruction(_ sender: SpringButton) {
        let helpView = HelpView()
        if !isHelpViewVisible {
            helpView.frame.origin =  CGPoint(x: sender.frame.maxX + 5, y: sender.frame.minY - sender.frame.height * 2)
            helpView.label.text = "Long press to show the help tutorial".localized()
            view.bringSubviewToFront(helpView)
            self.view.addSubview(helpView)
            isHelpViewVisible = true
        } else {
            delay(delay: 3.0) {
                helpView.removeFromSuperview()
                self.isHelpViewVisible = false
            }
        }
        delay(delay: 3.0) {
            helpView.removeFromSuperview()
            self.isHelpViewVisible = false
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
    
    
    
    //***************************************************************
    // MARK: - Life Cycle
    //***************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** CameraTabVC ****")
        
        setTextForLocalization()
        self.view.backgroundColor = Studio.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Saves the photo taken to the photos array
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.photos.append(image)
            self.addPhotoPreviewViewToPreviewStack(image: image)
        }
    }
    
    deinit { print("CameraTabVC DEINIT") }
    
    
    
    //***************************************************************
    // MARK: - PreviewPhotos Protocol Methods
    //***************************************************************
    
    /// Removes a PhotoPreviewView from the stackView of previews and from the array of photos.
    ///
    /// - Parameter view: The PhotoPreviewView that was double tapped.
    func removePhoto(view: PhotoPreviewView) {
        photos.removeAll { $0 == view.imageView.image } // removes the photo from the photos array via reference from PHotoPreviewView
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0.0
        }) { (complete) in
            self.photoPreviewStackView.removeArrangedSubview(view) // remove the PhotoPreviewView from the stackview of PhotoPreviewViews
            view.removeFromSuperview() // then removes the PhotoPreviewView from its superview
            if self.photoPreviewStackView.arrangedSubviews.count == 0 {
                self.noPhotosImageview.isHidden = false
            }
        }
    }

    fileprivate func setTextForLocalization() {
        navigationItem.title = "Identification".localized()
        cancelFormButton.title = "Cancel Form".localized()
        nextButton.title = "Next".localized()
        infoLabel1.text = "Align your ID with the iPad camera at the top/side and take a photo of your ID.".localized()
    }
    
    fileprivate func addPhotoPreviewViewToPreviewStack(image: UIImage) {
        let photoPreview = PhotoPreviewView()
        photoPreview.delegate = self
        photoPreview.imageView.image = image
        noPhotosImageview.isHidden = true
        photoPreviewStackView.addArrangedSubview(photoPreview)
        print("Photo preview added") // debugging
    }
    
    

    //***************************************************************
    // MARK: - Navigation
    //***************************************************************

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let performSegue = false

        if identifier == SegueIDs.unwindToMainSegue {
            Alerts.cancelFormAlert(viewController: self)
        }
        return performSegue
    }
    
    
}

