//
//  HealthClauseCollectionCell.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 1/2/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

class HealthClauseCollectionCell: UICollectionViewCell {

    // MARK: - Instance Variables
    
    var healthDelegate: HealthClauses!
    var healthTabVCRef: HealthTabVC!
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var healthClauseLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView! {
        didSet {
            checkBoxImageView.layer.cornerRadius = checkBoxImageView.frame.width / 2
            checkBoxImageView.layer.borderWidth = 2
            checkBoxImageView.layer.borderColor = UIColor.buttonBorderColor().cgColor
            checkBoxImageView.layer.masksToBounds = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(checkMark))
            checkBoxImageView.addGestureRecognizer(tap)
        }
    }
    
    
    
    // MARK: - Objc Methods
    
    /// Adds or removes the checkmark in the box of the Clause view.
    @objc func checkMark() {
        if checkBoxImageView.image == nil {
            addCheckMark()
        } else {
            removeCheckMark()
        }
    }
    
    
    
    // MARK: - Private Helper Methods
    
    /// Adds the check mark to the box in the Clause view.
    fileprivate func addCheckMark() {
        print("add check mark tapped")
        let checkImage = UIImage(named: "check")
//        let roundShape = UIImageView(image: UIImage(named: "filled-circle-8"))
//        roundShape.tintColor = .black
//        roundShape.center = checkBoxImageView.center
//        roundShape.alpha = 0
//        roundShape.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//        checkBoxImageView.addSubview(roundShape)
        
//        UIView.animate(withDuration: 0.3, animations: {
            self.checkBoxImageView.image = checkImage
//            roundShape.alpha = 1
//            roundShape.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
//        })
        
        guard let healthInfoString = healthClauseLabel.text else { return }
        if healthInfoString != "Pregnant/Nursing" {
            healthDelegate.addHealthClause(clause: healthInfoString)
        } else {
            healthDelegate.illegalClauseChecked(cell: self)
            removeCheckMark()
        }
    }
    
    /// Removes the checkmark from the box in the Clause view.
    fileprivate func removeCheckMark() {
        checkBoxImageView.image = nil
        guard let healthInfoString = healthClauseLabel.text else { return }
        healthDelegate.removeHealthClause(clause: healthInfoString)
    }
    
    
}

