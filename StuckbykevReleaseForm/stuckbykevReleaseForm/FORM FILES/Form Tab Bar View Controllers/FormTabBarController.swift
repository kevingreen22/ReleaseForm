//
//  FormTabBarController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/1/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

class FormTabBarController: FluidTabBarController {
    
    // MARK: - Instance Variables
    
    var cameraTabVC: CameraTabVC!
    var infoTabVC: InfoTabVC!
    var legalTabVC: LegalTabVC!
    var healthTabVC: HealthTabVC!
    var signatureTabVC: SignatureTabVC!
    
    var myViewControllers = [UIViewController]()
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** FormTabBarController ****")
        
        guard let viewControllers = viewControllers else { return }
        for vc in viewControllers {
            switch vc {
            case is CameraTabVC:
                cameraTabVC = vc as? CameraTabVC
                myViewControllers.append(cameraTabVC)
                let item = FluidTabBarItem(title: "Identification", image: UIImage(named: "camera icon"), tag: 1)
                cameraTabVC.tabBarItem = item
                
            case is InfoTabVC:
                infoTabVC = vc as? InfoTabVC
                myViewControllers.append(infoTabVC)
                let item = FluidTabBarItem(title: "Information", image: UIImage(named: "form icon"), tag: 2)
                infoTabVC.tabBarItem = item
                
            case is LegalTabVC:
                legalTabVC = vc as? LegalTabVC
                myViewControllers.append(legalTabVC)
                let item = FluidTabBarItem(title: "Leagal", image: UIImage(named: "legal icon"), tag: 3)
                legalTabVC.tabBarItem = item
                
            case is HealthTabVC:
                healthTabVC = vc as? HealthTabVC
                myViewControllers.append(healthTabVC)
                let item = FluidTabBarItem(title: "Health", image: UIImage(named: "health tab icon"), tag: 4)
                healthTabVC.tabBarItem = item
                
            case is SignatureTabVC:
                signatureTabVC = vc as? SignatureTabVC
                myViewControllers.append(signatureTabVC)
                let item = FluidTabBarItem(title: "Signature", image: UIImage(named: "signature icon"), tag: 5)
                signatureTabVC.tabBarItem = item
                
            default: break
            }
            
            self.viewControllers = myViewControllers
            self.tabBar.tintColor = Studio.backgroundColor
        }
    }
    
    deinit { print("FormTabBarController DEINIT") }
    
   
 
    
    // MARK: - Helper Methods
    
    /// Checks the form for completeness. i.e. all required fields are completed.
    ///
    ///   - viewControllers: The view controllers contained in the Form Tab Bar Controller.
    ///   - Returns: True if all fields are completed, and false otherwise occumpanied by a list of fields that still need to be filled out.
    public func checkFormsCompleteness(viewControllers: [UIViewController]) -> (Bool, String?) {
        var list: [String] = []
        
        // Checks the ID image(s)
        if cameraTabVC.photos.count == 0 {
            list.append("Photograph ID(s)".localized())
        }
  
        // Checks the client's info
        if infoTabVC.clientInfo.count > 0 {
            var checkedClient = false
            if !checkedClient {
                for info in infoTabVC.clientInfo {
                    if info.value == "" {
                        list.append(info.key.localized())
                        checkedClient = true
                    }
                }
            }
        } else { list.append("Personal Info".localized()) }
        
        // Checks the legal clauses.
        if legalTabVC.legaleseCompleted.count > 0 {
            for legal in legalTabVC.legaleseCompleted {
                if legal == false {
                    list.append("All Legal Clauses".localized())
                    break
                }
            }
        } else { list.append("All Legal Clauses".localized()) }
        
        // Checks the signature image(s)
        if signatureTabVC.signatureImage == nil {
            list.append("Signature(s)".localized())
        }
        
        if list.count > 0 {
            var _list: String = ""
            for item in list {
                _list += "\n" + item.replacingOccurrences(of: "\"", with: "")
            }
            return (false, _list)
        } else {
            return (true, nil)
        }
    }
    
    
    /// Saves the client's completed form info to the client model and adds the client to the queue.
    func saveClientAndAddToQueue() {
        // ****** Save the form info to the client model *****
        Client.collectFormInfo(IDImages: cameraTabVC.photos,
                               bioInfo: infoTabVC.clientInfo,
                               healthInfo: healthTabVC.clausesChecked,
                               legalInfo: legalTabVC.populatedLegalArray,
                               signatureImages: signatureTabVC.signatureImages
        )
        
        // ****** ADD CLIENT TO QUEUE *****
        Queue.append(Client)
        
        // Initializes a clean/blank client model. i.e. removes all client info from the current ClientModel singleton.
        Client = ClientModel()
    }
    
    
    
    
}
