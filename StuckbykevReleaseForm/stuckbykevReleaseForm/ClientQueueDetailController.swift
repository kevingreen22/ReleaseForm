//
//  ClientQueueDetailController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 3/16/18.
//  Copyright © 2018 Kevin Green. All rights reserved.
//

import UIKit

class ClientQueueDetailController: UIViewController {
    
    // MARK: - Instance Variables
    
    var client = ClientModel()
    var infoLabel1Text = ""
    var infoLabel2Text = ""
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var infoLabel3: UILabel!
    @IBOutlet weak var editClientShopInfoButton: UIButton!
    
    
    
    // MARK: - Actions
    
    @IBAction func editClientShopInfoTapped(_ sender: UIButton) {
        print("Edit client shop info tapped")
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** ClientQueueDetailController ****")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        infoLabel1Text = ""
        infoLabel2Text = ""
        setBioInfo()
        setStudioInfo()
        setHealthInfo()
        view.layoutIfNeeded()
    }
    
    deinit { print("ClientQueueDetailController DEINIT") }

    
    
    // MARK: - Helper Methods
    
    func getFrameHeight() -> CGFloat {
        var frameHeight: CGFloat!
        frameHeight = infoLabel1.frame.height + infoLabel2.frame.height + infoLabel3.frame.height
        frameHeight! += CGFloat(20.0)
        return frameHeight
    }
    
    func setBioInfo() {
        infoLabel1Text += "Name - " + client.name + "\n"
        infoLabel1Text += "Birthdate - " + client.birthdateString + "\n"
        infoLabel1Text += "Age - " + client.age + "\n"
        infoLabel1Text += "Phone Number - " + client.phoneNumber + "\n"
        infoLabel1Text += "Address - " + client.fullAddress
        
        infoLabel1.text = infoLabel1Text
    }
    
    func setStudioInfo() {
        infoLabel2Text += "NOTES: - " + client.additionalNotes + "\n"
        infoLabel2Text += "Procedure Date - " + client.procedureDate + "\n"
        infoLabel2Text += "Artist's Name - " + client.artistName + "\n"
        if client.tattooORpiercing {
            infoLabel2Text += "Tattoo Description - " + client.descriptionOfTattoo + "\n"
            infoLabel2Text += "Placement - " + client.placementOfTattoo + "\n"
        } else {
            infoLabel2Text += "Piercing - " + client.typeOfPiercing
        }
        infoLabel2Text += "Price - " + (client.price ?? "")
        
        infoLabel2.text = infoLabel2Text
    }
    
    func setHealthInfo() {
        infoLabel3.text = client.printHealthInfo(asList: true)
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopInfoVC = segue.destination as? ShopInfoViewController {
            shopInfoVC.client = client
        }
    }
    
    
    
    
}

