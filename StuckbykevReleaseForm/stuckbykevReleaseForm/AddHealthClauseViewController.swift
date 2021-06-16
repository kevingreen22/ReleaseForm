//
//  AddHealthClauseViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 1/7/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

class AddHealthClauseViewController: UIViewController {

    // MARK: - Instance variables
    
    var delegate: EditHealthClauseDelegate?
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** AddHealthClauseViewController ****")
        
        clauseTextField.becomeFirstResponder()
    }
    
    deinit { print("AddHealthClauseViewController DEINIT") }
    

    
    // MARK: - Outlets
    
    @IBOutlet weak var clauseTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var chooseWhichSegementControl: UISegmentedControl!
    
    
    
    // MARK: - Actions
    
    @IBAction func clauseTextFieldAction(_ sender: UITextField) { }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        if clauseTextField.text != "" {
            print(clauseTextField.text!)  // debugging
            guard let newClause = clauseTextField.text else { return }
            delegate?.writeClauseBack(newClause, healthChoice: chooseWhichSegementControl.selectedSegmentIndex)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

