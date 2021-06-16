//
//  HelpView.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 5/19/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import Foundation
import UIKit

class HelpView: UIView {
    
    let kCONTENT_XIB_NAME = "HelpView"
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView! { didSet { contentView.layer.cornerRadius = 8 } }
    @IBOutlet weak var backgroundView: UIView! { didSet { backgroundView.layer.cornerRadius = 8 } }
    @IBOutlet weak var label: UILabel! { didSet { label.layer.cornerRadius = 8 } }
    
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        print("\n**** HelpView ****")
        let bundle = Bundle(for: HelpView.self)
        bundle.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutIfNeeded()
        self.addSubview(contentView)
        width = label.frame.width
        height = label.frame.height
    }
    
    deinit { print("\nHelpView DEINIT") }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.preferredMaxLayoutWidth = 300
        super.layoutSubviews()
        
    }

    
}

