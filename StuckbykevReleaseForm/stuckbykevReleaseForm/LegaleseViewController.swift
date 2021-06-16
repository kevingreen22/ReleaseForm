//
//  LegaleseViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/7/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit

protocol EditLegalClauseDelegate {
    func writeClauseBack(_ clause: String, legalChoice: Int)
}

class LegaleseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditLegalClauseDelegate {
    
    // MARK: - Instance variables
    
    var delegate: WriteSettingsInfoBack!
    var legalDict: [String:Int]!
    
    
    
    // MARK: - EditLegalClauseDelegate Protocol Methods
    
    func writeClauseBack(_ clause: String, legalChoice: Int) {
        legalDict.updateValue(legalChoice, forKey: clause)
//        delegate.writeLegaleseArraySetBack(legalese: legalDict)
        legaleseTableView.reloadData()
    }
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var legaleseTableView: UITableView!
    
    
    
    // MARK: - Actions
    
    @IBAction func restoreDefaultsButtonAction(_ sender: UIBarButtonItem) {
        let confirmSetDefaults = UIAlertController(title: "Legalese" , message: "Are you sure you want to reset to defult?" , preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK" , style: .default, handler: { (ACTION) in
            self.legalDict = defaultLegalDict
//            self.delegate.writeLegaleseArraySetBack(legalese: self.legalDict)
            self.legaleseTableView.reloadData()
            let defaultsSetAlert = UIAlertController(title: "Legalese" , message: "The legal clauses have been set to defult." , preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK" , style: .default, handler: nil)
            defaultsSetAlert.addAction(ok)
            self.present(defaultsSetAlert, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel" , style: .cancel, handler: nil)
        confirmSetDefaults.addAction(ok)
        confirmSetDefaults.addAction(cancel)
        self.present(confirmSetDefaults, animated: true, completion: nil)
    }
    
    @IBAction func addNewClauseButtonAction(_ sender: UIBarButtonItem) { }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** LegaleseViewController ****")
        
        title = "Legalese Editor"
        navigationItem.rightBarButtonItem = self.editButtonItem
        legaleseTableView.delegate = self
        legaleseTableView.dataSource = self
        legaleseTableView.estimatedRowHeight = 65
        legaleseTableView.rowHeight = UITableView.automaticDimension
        
        legalDict = Studio.legaleseDict
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Studio.legaleseDict = legalDict
    }
    
    deinit { print("LegaleseViewController DEINIT") }
    
    
    
    // MARK: - UITableViewDelegate & DataSource
    
    let cellReuseID = "Legal Cell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legalDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        let keys = Array(legalDict.keys)
        cell.textLabel?.text = keys[indexPath.row]
        
        let values = Array(legalDict.values)
        if values[indexPath.row] == 0 {
            cell.detailTextLabel?.text = "Tattoo"
        } else if values[indexPath.row] == 1 {
            cell.detailTextLabel?.text = "Piercing"
        } else if values[indexPath.row] == 2 {
            cell.detailTextLabel?.text = "Both"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let keys = Array(legalDict.keys)
            legalDict.removeValue(forKey: keys[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
//            delegate.writeLegaleseArraySetBack(legalese: legalDict)
            
            tableView.reloadData()
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing {
            legaleseTableView.isEditing = true
        } else {
            legaleseTableView.isEditing = false
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIDs.AddLegalClauseSegue {
            guard let addClauseVC = (segue.destination as? AddLegalClauseViewController) else { return }
            addClauseVC.delegate = self
        }
    }
    
    
}

