//
//  HealthClauseEditorViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 1/7/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

protocol EditHealthClauseDelegate {
    func writeClauseBack(_ clause: String, healthChoice: Int)
}

class HealthClauseEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditHealthClauseDelegate {
    
    // MARK: - Instance variables
    
    var delegate: WriteSettingsInfoBack!
    var healthDict: [String:Int]!
    
    
    
    // MARK: - EditHealthClauseDelegate Protocol Methods
    
    func writeClauseBack(_ clause: String, healthChoice: Int) {
        healthDict.updateValue(healthChoice, forKey: clause)
//        delegate.writeHealthClauseArraySetBack(healthClause: healthDict)
        healthClauseTableView.reloadData()
    }
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var healthClauseTableView: UITableView!
    
    

    // MARK: - Actions
    
    @IBAction func restoreDefaultsButtonTapped(_ sender: UIBarButtonItem) {
        let confirmSetDefaults = UIAlertController(title: "Health Clauses" , message: "Are you sure you want to reset to defult?" , preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK" , style: .default, handler: { (ACTION) in
            self.healthDict = defaultHealthClauseDict
            self.healthClauseTableView.reloadData()
            let defaultsSetAlert = UIAlertController(title: "Health Clause" , message: "The health clauses have been set to defult." , preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK" , style: .default, handler: nil)
            defaultsSetAlert.addAction(ok)
            self.present(defaultsSetAlert, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel" , style: .cancel, handler: nil)
        confirmSetDefaults.addAction(ok)
        confirmSetDefaults.addAction(cancel)
        self.present(confirmSetDefaults, animated: true, completion: nil)
    }
    
    @IBAction func addNewClauseTapped(_ sender: UIBarButtonItem) {
        
    }
    
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** HealthClauseViewController ****")
        
        title = "Health Clause Editor"
        navigationItem.rightBarButtonItem = self.editButtonItem
        healthClauseTableView.delegate = self
        healthClauseTableView.dataSource = self
        healthClauseTableView.estimatedRowHeight = 65
        healthClauseTableView.rowHeight = UITableView.automaticDimension
        
        healthDict = Studio.healthClausesDict
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Studio.healthClausesDict = healthDict
    }
    
    deinit { print("HealthClauseEditorViewController DEINIT") }
    
    
    
    // MARK: - UITableViewDelegate & DataSource
    
    let cellReuseID = "Health Cell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        let keys = Array(healthDict.keys)
        cell.textLabel?.text = keys[indexPath.row]
        
        let values = Array(healthDict.values)
        if values[indexPath.row] == 0 {
            cell.detailTextLabel?.text = "Tattoo"
        } else if values[indexPath.row] == 1 {
            cell.detailTextLabel?.text = "Pericing"
        } else if values[indexPath.row] == 2 {
            cell.detailTextLabel?.text = "Both"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let keys = Array(healthDict.keys)
            healthDict.removeValue(forKey: keys[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
//            delegate.writeHealthClauseArraySetBack(healthClause: healthDict)
            tableView.reloadData()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing {
            healthClauseTableView.isEditing = true
        } else {
            healthClauseTableView.isEditing = false
        }
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIDs.AddHealthClauseSegue {
            guard let addClauseVC = (segue.destination as? AddHealthClauseViewController) else { return }
            addClauseVC.delegate = self
        }
    }

    
}

