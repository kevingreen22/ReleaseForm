//
//  BackgroundViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/12/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
//import ChromaColorPicker

class BackgroundViewController: UIViewController, ChromaColorPickerDelegate {
    
    // MARK: - Instance variables

    var writeBackDelegate: WriteSettingsInfoBack!
    var colorPicker: ChromaColorPicker!
    var delegate: ReturnInfoDelegate!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var colorDisplayView: UIView!
    
    
    
    // MARK: - Actions
    
    @IBAction func doneButton(_ sender: UIButton) { }
    

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** BackgroundViewController ****")
        
        colorDisplayView.layer.cornerRadius = colorDisplayView.frame.width * 0.5
        
        /* Calculate relative size and origin in bounds */
        let pickerSize = CGSize(width: 300, height: 300)
        let pickerOrigin = CGPoint(x: 50, y: 50)
        
        /* Create Color Picker */
        colorPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colorPicker.delegate = self
        
        /* Customize the view (optional) */
        colorPicker.padding = 10
        colorPicker.stroke = 3 //stroke of the rainbow circle
        colorPicker.currentAngle = Float.pi
        colorPicker.handleLine.strokeColor = UIColor.lightGray.cgColor
        
        /* Customize for grayscale (optional) */
        colorPicker.supportsShadesOfGray = true // false by default
//        colorPicker.colorToggleButton.grayColorGradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor] // You can also override gradient colors
        
        
        colorPicker.hexLabel.textColor = UIColor.gray
        
        // Set the color picker options to the current studio color
        colorDisplayView.backgroundColor = Studio.backgroundColor
        colorPicker.adjustToColor(Studio.backgroundColor)
        
        self.view.addSubview(colorPicker)
    }
    
    deinit { print("BackgroundViewController DEINIT") }
    
    
    
    // MARK: - ChromaColorPickerDelegate
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        // Set color for the display view
        colorDisplayView.backgroundColor = color
        
        // Send color to writeBackDelegate
//        writeBackDelegate.writeColorBack(color: color)
        Studio.backgroundColor = color
        
        // Perform zesty animation
        UIView.animate(withDuration: 0.2, animations: {
            self.colorDisplayView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { (done) in
            UIView.animate(withDuration: 0.2, animations: {
                self.colorDisplayView.transform = CGAffineTransform.identity
            })
        })
    }
    
    
}

