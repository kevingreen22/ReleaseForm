//
//  HealthClauseViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/2/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

protocol HealthClauses {
    func addHealthClause(clause: String)
    func removeHealthClause(clause: String)
    func illegalClauseChecked(cell: HealthClauseCollectionCell)
}

class HealthTabVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HealthClauses {
    
    // MARK: - Instance Variables
    
    private let reuseIdentifier = "Health Clause Cell"
    var clauses: [String] = []
    var clausesChecked: [String] = []
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelFormButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var helpButton: SpringButton!
    
    
    
    // MARK: - Actions
    
    @IBAction func nextTapepd(_ sender: UIBarButtonItem) {
        print("Next button tapped")
        // go to next tab
        tabBarController?.selectedIndex = 4
    }
    
    var currentlyVisible: Bool = false
    @IBAction func helpTapped(_ sender: SpringButton) {
        print("Help button tapped")
        Animate.pop(for: sender, loop: false, completion: {})
        let helpView = HelpView()
        if !currentlyVisible {
            helpView.frame.origin = CGPoint(x: sender.frame.maxX + 5, y: sender.frame.minY - sender.frame.height * 2)
            helpView.label.text = "Long press to show the help tutorial".localized()
            view.bringSubviewToFront(helpView)
            self.view.addSubview(helpView)
            currentlyVisible = true
        } else {
            delay(delay: 3.0) {
                helpView.removeFromSuperview()
                self.currentlyVisible = false
            }
        }
        delay(delay: 3.0) {
            helpView.removeFromSuperview()
            self.currentlyVisible = false
        }
    }
    
    @IBAction func longPressOnHelpButton(_ sender: UILongPressGestureRecognizer) {
        print("Long press gesture triggered")
        if sender.state == .began {
            showHelpTutorial(viewController: self)
        }
    }
    
    @IBAction func cancelFormTapped(_ sender: UIBarButtonItem) {
        print("Cancel button tapped")
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** HealthTabVC ****")
        
        clauses = Array(Studio.healthClausesDict.keys).sorted()
        
        view.backgroundColor = Studio.backgroundColor
        setTextForLocalization()
    }
    
    deinit { print("HealthTabVC DEINIT") }

    
    
    // MARK: - Protocol Methods
    
    /// Adds the health clause checked by the user to an array.
    /// For later reference for the mainViewcontroller.
    ///
    /// - Parameter clause: A string representing the clause check by the user in the form.
    func addHealthClause(clause: String) {
        clausesChecked.append(clause)
    }
    
    /// Removes the health clause un-checked by the user from the array.
    ///
    /// - Parameter clause: A string representing the clause un-checked by the user in the form.
    func removeHealthClause(clause: String) {
        clausesChecked.removeAll { $0 == clause }
    }
    
    /// Shows an alert that an illegal clause was selected.
    ///
    /// - Parameter cell: The cell that was selected
    func illegalClauseChecked(cell: HealthClauseCollectionCell) {
        Alerts.pregnantAlert(viewController: self, cell: cell, segueTo: SegueIDs.unwindToMainSegue)
    }
    
    

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clauses.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HealthClauseCollectionCell else { return UICollectionViewCell() }
        cell.healthClauseLabel.text = clauses[indexPath.row].localized()
        cell.healthDelegate = self
        
        return cell
    }

    
    
    // MARK: UICollectionViewDelegate

    /// Specifies if the specified item should be highlighted during tracking
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /// Specifies if the specified item should be selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    
    
    // MARK: - Private Helper Methods
    
    fileprivate func setTextForLocalization() {
        navigationItem.title = "Health".localized()
        cancelFormButton.title = "Cancel Form".localized()
        nextButton.title = "Next".localized()
    }
    
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let performSegue = false
        
        if identifier == SegueIDs.unwindToMainSegue {
            Alerts.cancelFormAlert(viewController: self)
        }
        return performSegue
    }
    

}

