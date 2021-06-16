//
//  LogoViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/14/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import Photos

class LogoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Instance Variables
    
    var delegate: WriteSettingsInfoBack!
    var currentLogoImage: UIImage!
    let myPicker = UIImagePickerController()
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var chooseLogoImage: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resetLogoButton: UIButton!
    
    
    
    // MARK: - Actions
    
    @IBAction func setLogoButtonAction(_ sender: AnyObject?) {
        myPicker.sourceType = .photoLibrary
        myPicker.modalPresentationStyle = .popover
        let ppc = myPicker.popoverPresentationController
        ppc?.sourceView = sender as? UIButton
        ppc?.permittedArrowDirections = .any
        present(myPicker, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) { }
    
    @IBAction func resetLogoButtonAction(_ sender: UIButton) {
        currentLogoImage = UIImage(named: ImagesKeys.NoLogoImageHolder)
        imageView.image = resizeImage(image: currentLogoImage!, targetSize: CGSize.init(width: 100, height: 100))
//        delegate.writeLogoBack(logo: currentLogoImage)
//        saveImageToDocumentsDirectory(image: currentLogoImage, fileName: ImagesKeys.StudioLogoJPG, defaulsKey: UDKeys.UDLogoImageURLPath)
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** LogoViewController ****")
        
        myPicker.delegate = self
        currentLogoImage = Studio.logo ?? UIImage(named: ImagesKeys.NoLogoImageHolder)
        imageView.image = resizeImage(image: currentLogoImage!, targetSize: CGSize.init(width: 100, height: 100))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Studio.logo = currentLogoImage
//        saveImageToDocumentsDirectory(image: currentLogoImage, fileName: ImagesKeys.StudioLogoJPG, defaulsKey: UDKeys.UDLogoImageURLPath)
    }
    
    deinit { print("LogoViewController DEINIT") }
    
    

    // MARK: - UIImagePickerDelegate
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        currentLogoImage = image
        imageView.image = resizeImage(image: image, targetSize: CGSize.init(width: 100, height: 100))
//        delegate.writeLogoBack(logo: currentLogoImage)
//        saveImageToDocumentsDirectory(image: currentLogoImage, fileName: ImagesKeys.StudioLogoJPG, defaulsKey: UDKeys.UDLogoImageURLPath)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Private Helper Methods
    
    // This method resizes an image to the target size
    fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what the orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
}

