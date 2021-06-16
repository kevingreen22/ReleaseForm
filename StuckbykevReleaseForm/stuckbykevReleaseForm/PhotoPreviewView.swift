//
//  PhotoPreviewView.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 5/5/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

class PhotoPreviewView: UIView {

    // MARK: - Instance Variables
    
    let kCONTENT_XIB_NAME = "PhotoPreviewView"
    var delegate: PreviewPhotos!
    
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var doubleTap: UITapGestureRecognizer!
    
    
    
    // MARK: - Actions
    
    @IBAction func doubleTapTapped(_ sender: UITapGestureRecognizer) {
        delegate?.removePhoto(view: self)
    }
    
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        print("\n**** PhotoPreviewView ****")
        let bundle = Bundle(for: BioInfoView.self)
        bundle.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.frame = self.frame
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
    }
    
    
    
}
