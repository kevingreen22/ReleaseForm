//
//  SignaturePad.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 6/6/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit
//import SwiftSignatureView

class SignaturePad: UIView, SwiftSignatureViewDelegate {
    
    // MARK: - Instance Variables
    
    let kCONTENT_XIB_NAME = "SignaturePad"
    var imageDelegate: SignatureImageDelegate!
    var isMinorSignature: Bool = false
    
    
    
    // MARK: - Outlets

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var signaturePadImageView: UIImageView!
    @IBOutlet weak var swiftSignatureView: SwiftSignatureView!
    @IBOutlet weak var clearSignatureButton: UIButton!
    @IBOutlet weak var parentORminorLabel: UILabel!
    
    
    
    // MARK: - Actions
    
    @IBAction func clearSignatureTapped(_ sender: UIButton) {
        swiftSignatureView.clear()
        isMinorSignature ? imageDelegate.didSetMinorSignature(image: nil) : imageDelegate.didSetMainSignature(image: nil)
        UIView.animate(withDuration: 0.2) { self.parentORminorLabel.alpha = 1 }
    }
    
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        print("\n**** SignaturePad ****")
        let bundle = Bundle(for: FormTabBarController.self)
        bundle.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        
        swiftSignatureView.delegate = self
    }
    
    
    
    // MARK: - SwiftSignature Protocol Methods
    
    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView) {
        print("Did tap inside Signature box") // debugging
        UIView.animate(withDuration: 0.2) { self.parentORminorLabel.alpha = 0.0 }
        isMinorSignature ? imageDelegate.didSetMinorSignature(image: swiftSignatureView.signature) : imageDelegate.didSetMainSignature(image: swiftSignatureView.signature)
    }
   
    func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView, _ pan: UIPanGestureRecognizer) {
        print("Did pan inside Signature box") // debugging
        UIView.animate(withDuration: 0.2) { self.parentORminorLabel.alpha = 0.0 }
        isMinorSignature ? imageDelegate.didSetMinorSignature(image: swiftSignatureView.signature) : imageDelegate.didSetMainSignature(image: swiftSignatureView.signature)
    }
    
    
}

