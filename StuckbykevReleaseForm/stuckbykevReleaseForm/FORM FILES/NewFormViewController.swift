////
////  NewFormViewController.swift
////  StuckByKev Release Form
////
////  Created by Kevin Green on 2/10/19.
////  Copyright © 2019 Kevin Green. All rights reserved.
////
//
//import UIKit
//import Localize_Swift
//
//class NewFormViewController: UIViewController, UIScrollViewDelegate {
//    
//    // MARK: - Outlets
//    
//    @IBOutlet weak var topView: UIView!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var contentView: UIView!
//    
//    
//    @IBOutlet weak var shopInfoView: ShopInfoView! {
//        didSet {
//            shopInfoView.formControllerRef = self
//            shopInfoView.setupTattooOrPiercingOption()
//        }
//    }
//    @IBOutlet weak var legaleseView: LegalView! {
//        didSet {
//            legaleseView.formControllerRef = self
//            legaleseView.setupLegalView()
//        }
//    }
//    @IBOutlet weak var healthStackView: HealthVertStackView! {
//        didSet {
//            healthStackView.formControllerRef = self
//            healthStackView.addDelegateToHealthClauseViews()
//        }
//    }
//    @IBOutlet weak var bioInfoView: BioInfoView! {
//        didSet {
//            bioInfoView.formControllerRef = self
//        }
//    }
//    @IBOutlet weak var signatureView: SignatureView! {
//        didSet {
////            signatureView.formControllerRef = self
////            signatureView.setSwiftSignatureDelegate()
//        }
//    }
//    
//    @IBOutlet weak var finnishedButton: UIButton! {
//        didSet {
//            finnishedButton.layer.cornerRadius = finnishedButton.bounds.height/2
//        }
//    }
//    
//    
//    
//    // MARK: - Actions
//    
//    @IBAction func finnishedButtonTapped(_ sender: UIButton) { }
//    
//    
//    
//    
//    // MARK: - Life Cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("\n**** NewFormViewController ****")
//        
//        title = Studio.name + " Release & Waiver"
//        view.backgroundColor = Studio.backgroundColor
//        topView.backgroundColor = Studio.backgroundColor        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setText()
//    }
//    
//    deinit { print("NewFormViewController DEINIT") }
//    
//    
//    
//    
//    
//    
//    
//    // MARK: - Localization Method for Localize_Swift
//    
    /// Sets the visual text the user sees to localized() for eaiser language manipulation.
//    fileprivate func setText() {
//        navigationItem.leftBarButtonItem?.title = "Cancel Form".localized()
//        navigationItem.rightBarButtonItem?.title = "Finished".localized()
//
//        signatureView.declarationLabel.text = "By my signature below, I certify under Penalty Of Perjury that the information provided is true and correct, and that I am at least 18 years of age or older; (or have a parent present with ID’s). I further understand that, if I give false information or produce false documents stating my name and age to be other that what is correct, I am liable for prosecution.".localized()
//
//        legaleseView.legalSectionLabel.text = "Legal Section".localized()
//
//        healthStackView.healthSectionLabel.text = "Health Section".localized()
//        healthStackView.healthSectionInfoLabel.text = "Please check any and all conditions that apply to you as listed below:".localized()
//    }
//
//
//    
//    
//    // MARK: - Navigation
//    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        var perform = false
//        
//        if identifier == SegueIDs.AllDoneSegue {
//            let (comp, _list) = checkFormsCompleteness()
//            if comp {
//                perform = true
//            } else {
//                var list: String = ""
//                for item in _list! {
//                    list += "\n" + item.replacingOccurrences(of: "\"", with: "")
//                }
//                Alerts.incompleteFormAlert(viewController: self, missingList: list)
//            }
//        }
//        
//        if identifier == SegueIDs.unwindToMainSegue {
//            Alerts.cancelFormAlert(viewController: self)
//        }
//        return perform
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SegueIDs.AllDoneSegue {
//            
//            // ****** Save the form info to the client model *****
//            Client.collectFormInfo(shopInfo: shopInfoView.shopInfo, bioInfo: bioInfoView.clientInfo, healthInfo: healthStackView.clausesChecked, legalInfo: legaleseView.populatedLegalArray, signatureImages: [signatureView.signatureImage, signatureView.minorSignImage])
//            
//            // ****** ADD CLIENT TO QUEUE *****
//            Queue.append(Client)
//        }
//    }
//
//    
//    
//  
//    /// Checks the form for completeness. i.e. all required fields are completed.
//    ///
//    /// - Returns: True if all fields are completed, and false otherwise occumpanied by a list of fields that stil need to be filled out.
//    fileprivate func checkFormsCompleteness() -> (Bool, [String]?) {
//        var list: [String] = []
//        
//        for info in shopInfoView.shopInfo {
//            if info.value == "" {
//                list.append(info.key)
//            }
//        }
//        
//        for info in bioInfoView.clientInfo {
//            if info.value == "" {
//                list.append(info.key)
//            }
//        }
//        
//        for legal in legaleseView.legaleseCompleted {
//            if legal == false {
//                list.append("All Legal Clauses")
//                break
//            }
//        }
//
//        if signatureView.signatureImage == nil {
//            list.append("Signature(s)")
//        }
//        
//        if list.count > 0 {
//            return (false, list)
//        } else {
//            return (true, nil)
//        }
//    }
//    
//    
//    
//}
//
