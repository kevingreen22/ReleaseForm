//
//  LegalTableViewCell.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/9/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

class LegalTableViewCell: UITableViewCell {
    
    // MARK: - Instance Variables
    
    var segmentGreenColor = UIColor(red:0.19, green:0.53, blue:0.07, alpha:1.0)
    var segmentRedColor = UIColor(red:0.83, green:0.15, blue:0.15, alpha:1.0)
    var legaleseCompleted: Bool = false
    var legalClauseDelegate: LegalClauseDelegate!
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var yesNoSegment: UISegmentedControl! {
        didSet {
            yesNoSegment.selectedSegmentIndex = 1
            yesNoSegment.tintColor = segmentRedColor
            yesNoSegment.setTitle("Yes".localized(), forSegmentAt: 0)
            yesNoSegment.setTitle("No".localized(), forSegmentAt: 1)
        }
    }
    
    @IBOutlet weak var legalTextLabel: UILabel! 
    
    
    
    // MARK: - Actions
    
    @IBAction func didSelectYesNo(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            yesNoSegment.tintColor = segmentGreenColor
            legaleseCompleted = true
        }
        if sender.selectedSegmentIndex == 1 {
            yesNoSegment.tintColor = segmentRedColor
            legaleseCompleted = false
        }
        legalClauseDelegate?.didSelectYesNoSegment(yesNo: legaleseCompleted, for: self)
        legalClauseDelegate?.scrollCellToVisible(cell: self)
    }
    
    
}

