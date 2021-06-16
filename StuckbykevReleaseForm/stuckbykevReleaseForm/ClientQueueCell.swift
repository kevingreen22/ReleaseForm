//
//  ClientQueueCell.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 3/16/18.
//  Copyright © 2018 Kevin Green. All rights reserved.
//

import UIKit

protocol CollectionCellProtocol: class {
    func showClientDetailVC(view: UIView, cell: ClientQueueCell)
}

class ClientQueueCell: UICollectionViewCell, UITextFieldDelegate {
    
    // MARK: - Instance Variables
    
    var collectionCellDelegate: CollectionCellProtocol?
    var clientInfoDelegate: ClientInfoProtocol?
    var client = ClientModel()
    var cellIndex = Int()
    
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDropShadow()
    }
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientDetailButton: SpringButton!
    @IBOutlet weak var deleteClientCheckBox: SpringImageView! {
        didSet {
                deleteClientCheckBox.layer.cornerRadius = 2
                deleteClientCheckBox.layer.borderColor = UIColor.gray.cgColor
                deleteClientCheckBox.layer.borderWidth = 2
                deleteClientCheckBox.clipsToBounds = true
                deleteClientCheckBox.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var clientIDImage: SpringImageView!
    @IBOutlet weak var lotNumTextField: UITextField! { didSet { lotNumTextField.delegate = self } }
    @IBOutlet weak var additionalNotesTextField: UITextField! {
        didSet {
            additionalNotesTextField.text = ""
            additionalNotesTextField.delegate = self
        }
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func lotNumTextFieldAction(_ sender: UITextField) {
        client.sterilizationLotNumber = sender.text!
        clientInfoDelegate?.lotNumORnotesChanged(for: client, at: cellIndex)
        updateUI()
    }
    
    @IBAction func notesTextFieldAction(_ sender: UITextField) {
        client.additionalNotes = sender.text!
        clientInfoDelegate?.lotNumORnotesChanged(for: client, at: cellIndex)
        updateUI()
    }
    
    @IBAction func clientDetailButtonAction(_ sender: UIButton) {
        collectionCellDelegate?.showClientDetailVC(view: sender, cell: self)
    }
    
    
    
    // MARK: - Helper methods
    
    func updateUI() {
        clientNameLabel.text = client.name
        clientIDImage.image = client.IDImages.first
        lotNumTextField.text = client.sterilizationLotNumber
        additionalNotesTextField.text = client.additionalNotes
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateUI()
        return true
    }

    
}

