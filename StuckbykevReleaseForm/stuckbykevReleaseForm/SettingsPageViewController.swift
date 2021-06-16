//
//  Settings.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/8/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

class SettingsPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    var settingsTVCDelegate: WriteSettingsInfoBack!
    let userDefaults = UserDefaults.standard
//    let backgroundQueue = DispatchQueue(label: "com.stuckbykev.settings", qos: .background, target: nil)
    let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: VCIdentifiers.SettingsTVC) as! SettingsTableViewController
    let documentBrowserVC = UIStoryboard(name: "DocumentViewer", bundle: nil).instantiateViewController(withIdentifier: VCIdentifiers.DocumentBrowserVC) as! DocumentBrowserViewController
    
   fileprivate lazy var pages: [UIViewController] = {
        return [
            settingsVC,
            documentBrowserVC
        ]
    }()
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var settingsOrBrowserSegment: UISegmentedControl!
    @IBOutlet weak var restoreDefaultsButton: UIBarButtonItem!
    
    
    
    // MARK: - Actions
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) { print("Done button tapped") }
    
    @IBAction func settingsOrBrowerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if let firstVC = pages.first {
                setViewControllers([firstVC], direction: .reverse, animated: true, completion: nil)
                restoreDefaultsButton.isEnabled = true
            }
        case 1:
            if let secondVC = pages.last {
                setViewControllers([secondVC], direction: .forward, animated: true, completion: nil)
                restoreDefaultsButton.isEnabled = false
            }
        default:
            break
        }
    }
    
    @IBAction func restoreDefaultsTapped(_ sender: UIBarButtonItem) {
        firstRestoreAppSettingsAlert()
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** SettingsPageViewController ****")
                
        self.delegate = self
        
        settingsTVCDelegate = settingsVC
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    deinit { print("SettingspageViewController DEINIT") }
    
    
    
    
    // MARK: - Private Methods
    
    /// Shows the first confim alert for 'app restore defaults' and if accepted, shows the second confirmation alert.
    fileprivate func firstRestoreAppSettingsAlert() {
        let restoreAlert = UIAlertController(title: "Confirm Restore App Settings" , message: "Are you sure you want to completely restore the app settings to default? This will delete all app information. This will also delete any studio info and queue info stored in iCloud. This will NOT delete any client PDF's" , preferredStyle: UIAlertController.Style.alert)
        let accept = UIAlertAction(title: "Accept" , style: .default, handler: { (ACTION) in
            self.showSecondConfirmation()
        })
        let cancel = UIAlertAction(title: "Cancel" , style: .cancel, handler: nil)
        restoreAlert.addAction(accept)
        restoreAlert.addAction(cancel)
        self.present(restoreAlert, animated: true, completion: nil)
    }
    
    /// Shows second confirm alert for 'app restore defaults' and if accepted, restores app defaults.
    fileprivate func showSecondConfirmation() {
        let confirmRestoreAlert = UIAlertController(title: "Are You Sure?" , message: "This will also reset the app passcodes and delete any clients in the queue." , preferredStyle: UIAlertController.Style.alert)
        let accept = UIAlertAction(title: "Accept" , style: .default, handler: { (_) in
            
            // Delete shopModel from iCloud
            iCloud.deleteStudioModel(viewController: self, completion: { (error) in
                if error == nil {
                    self.userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    self.userDefaults.synchronize()
                    self.settingsTVCDelegate.setLocalize()
                    
                    // Clear the current studio model singleton
                    Studio = StudioModel()
                    
                    self.confirmResetAppSettingsToDefault()
                }
            })
        })
        let cancel = UIAlertAction(title: "Cancel" , style: .cancel, handler: nil)
        confirmRestoreAlert.addAction(accept)
        confirmRestoreAlert.addAction(cancel)
        self.present(confirmRestoreAlert, animated: true, completion: nil)
    }
    
    /// Confirms app restored to defaults
    fileprivate func confirmResetAppSettingsToDefault() {
        let confirmAlert = UIAlertController(title: "App Reset" , message: "The app settings have been restored." , preferredStyle: UIAlertController.Style.alert)
        let accept = UIAlertAction(title: "Ok" , style: .default, handler: { (ACTION) in
            self.settingsVC.tableView.reloadData()
        })
        confirmAlert.addAction(accept)
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainVC = segue.destination as? MainViewController {
            StudioModel.storeStudioIntoUserDefaults()
            iCloud.uploadStudioModel(studioModel: Studio, viewController: mainVC, completion: nil)
            mainVC.view.layoutIfNeeded()
        }
    }
    
    
}
