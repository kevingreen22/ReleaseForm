//
//  AddLegalClauseViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/8/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit

class AddLegalClauseViewController: UIViewController {
    
    // MARK: - Instance variables

    var delegate: EditLegalClauseDelegate?
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** AddLegalClauseViewController ****")
        
        clauseTextField.becomeFirstResponder()
    }
    
    deinit { print("AddLegalClauseViewController DEINIT") }

    

    // MARK: - Outlets
    
    @IBOutlet weak var clauseTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var chooseWhichLegaleseSegmentedControl: UISegmentedControl!
    
    
    
    // MARK: - Actions
    
    @IBAction func clauseTextFieldAction(_ sender: UITextField) { }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        if clauseTextField.text != "" {
            print(clauseTextField.text!)  // debugging
            guard let newClause = clauseTextField.text else { return }
            delegate?.writeClauseBack(newClause, legalChoice: chooseWhichLegaleseSegmentedControl.selectedSegmentIndex)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

