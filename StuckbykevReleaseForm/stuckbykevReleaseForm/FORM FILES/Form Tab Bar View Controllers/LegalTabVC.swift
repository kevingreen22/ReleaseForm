//
//  LegalTabVC.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/2/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

protocol LegalClauseDelegate {
    func didSelectYesNoSegment(yesNo: Bool, for cell: LegalTableViewCell)
    func scrollCellToVisible(cell: LegalTableViewCell)
}

class LegalTabVC: UIViewController, UITableViewDelegate, UITableViewDataSource, LegalClauseDelegate {
    
    // MARK: - Instance Variables
    
    private let reuseIdentifier = "Legal Clause Cell"
    var populatedLegalArray = [String]()
    var legaleseCompleted = [Bool]()
    
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelFormButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    
    
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIBarButtonItem) {
        print("Next button tapped")
        // go to next tab
        tabBarController?.selectedIndex = 3
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
        print("\n**** LegalTabVC ****")
        
        // delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Along with auto layout, these are the keys for enabling variable cell height
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.reloadData()
        
        view.backgroundColor = Studio.backgroundColor
        populateLegalArray()
        setTextForLocalization()
    }
    
    deinit { print("LegalTabVC DEINIT") }
    
    
    
    // MARK: - TableViewDelegate & datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return populatedLegalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? LegalTableViewCell else { return UITableViewCell() }
        let textWithStudioName = populatedLegalArray[indexPath.row].replacingOccurrences(of: "YOUR STUDIO NAME", with: Studio.name)
        cell.legalTextLabel.text = textWithStudioName
        cell.legalClauseDelegate = self
        cell.legalClauseDelegate.didSelectYesNoSegment(yesNo: false, for: cell)
        
        return cell
    }
    
    
    
    // MARK: - LegalCellDelegate
    
    func didSelectYesNoSegment(yesNo: Bool, for cell: LegalTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        legaleseCompleted.insert(yesNo, at: indexPath.row)
        legaleseCompleted.remove(at: indexPath.row + 1)
    }
    
    func scrollCellToVisible(cell: LegalTableViewCell) {
        DispatchQueue.main.async {
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    
    
    // MARK: - Private Helper Methods
    
    fileprivate func setTextForLocalization() {
        navigationItem.title = "Legal".localized()
        cancelFormButton.title = "Cancel Form".localized()
        nextButton.title = "Next".localized()
    }
    
    /// Populates the legal array depending if its a tattoo or piercing or both.
    fileprivate func populateLegalArray() {
        var nextClause = -1
        let legalese = Studio.legaleseDict
        if Client.tattooORpiercing {
            for (key,value) in legalese.sorted(by: { $0.key > $1.key }) {
                if value == 0 || value == 2 {
                    nextClause += 1
                    populatedLegalArray.append(key.localized())
                    legaleseCompleted.append(false) // initialize the legaleseCompleted array
                } else { nextClause += 1 }
            }
        } else {
            for (key,value) in legalese.sorted(by: { $0.key > $1.key }) {
                if value == 1 || value == 2 {
                    nextClause += 1
                    populatedLegalArray.append(key.localized())
                    legaleseCompleted.append(false) // initialize the legaleseCompleted array
                } else { nextClause += 1 }
            }
        }
        print("\(populatedLegalArray) : count: \(populatedLegalArray.count)")
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

