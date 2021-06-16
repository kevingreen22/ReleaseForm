//
//  ClientQueueCollectionViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 3/16/18.
//  Copyright © 2018 Kevin Green. All rights reserved.
//

import UIKit
import CloudKit

protocol ClientInfoProtocol: class  {
    func lotNumORnotesChanged(for client: ClientModel, at index: Int)
}

class ClientQueueCollectionViewController: UICollectionViewController, ClientInfoProtocol {
    
    //***************************************************************
    // MARK: - Instance Variables
    //***************************************************************
    
    let cellResuseIdentifier = "Client Queue Cell"
    var selectedClient: ClientModel!
    let backgroundQueue = DispatchQueue(label: "com.stuckbykev.queueTable", qos: .background, target: nil)
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    
    
    //***************************************************************
    // MARK: - Outlets & Actions
    //***************************************************************
    
    // Outlets
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var collectionViewEmptyLabel: UILabel!
    
    
    // Actions
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) { print("Back button tapped") }
    
    @IBAction func trashButtonTapped(_ sender: UIBarButtonItem) {
        print("Trash button tapped")
        deleteClients()
    }
    
    @IBAction func unwindToQueueVC(segue: UIStoryboardSegue) {
        print("unwindToQueueVC triggered")
        self.collectionView.reloadData() }
    
    
    
    //***************************************************************
    // MARK: - Life Cycle
    //***************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** QueueTableViewController ****")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .queueDataChanged, object: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        trashButton(isEnabled: false)
        navigationItem.rightBarButtonItem = editButtonItem
        navigationController?.navigationBar.barTintColor = Studio.backgroundColor
        
        collectionView?.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit { print("QueueTableViewController DEINIT") }
    
    
    
    //***************************************************************
    // MARK: - Refresh Control
    //***************************************************************
    
    /// Handle Refresh
    ///
    /// - Parameter refreshControl: A UIRefreshControl object.
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        iCloud.retrieveQueueFromCloud(viewController: self, completion: { (error) in
            DispatchQueue.main.async { self.refreshControl.endRefreshing() }
        })
    }
    
   
    
    //***************************************************************
    // MARK: - UICollectionViewDelegate & DataSource
    //***************************************************************
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Queue.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdentifier, for: indexPath) as? ClientQueueCell else { return UICollectionViewCell() }
        
        if Queue.count > 0 {
            let client = Queue[indexPath.row]
            cell.client = client
            cell.cellIndex = indexPath.row
            cell.clientIDImage.image = client.IDImages.first
            cell.clientNameLabel.text = client.name
            cell.lotNumTextField.text = client.sterilizationLotNumber
            cell.additionalNotesTextField.text = client.additionalNotes
            cell.deleteClientCheckBox.isHidden = true
            if client.printHealthInfo(asList: false) != "No Health Issues" {
                Animate.flash(for: cell.clientDetailButton, duration: 0.5, loop: true) { }
            }
            cell.clientInfoDelegate = self
            cell.collectionCellDelegate = self
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isEditing, let cell = collectionView.cellForItem(at: indexPath) as? ClientQueueCell else { return }
        select(cell: cell)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard isEditing, let cell = collectionView.cellForItem(at: indexPath) as? ClientQueueCell else { return }
        deselect(cell: cell)
    }
    
    fileprivate func select(cell: ClientQueueCell) {
        cell.isSelected = true
        UIView.animate(withDuration: 0.3) {  // Adds a visual key that the cell is selected. i.e. checkmark AND pops the cell "up"
            cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            cell.addCheckedMark()
        }
    }
    
    fileprivate func deselect(cell: ClientQueueCell) {
        cell.isSelected = false
        UIView.animate(withDuration: 0.3) { // Removes the visual key that the cell is selected. i.e. checkmark AND pops the cell back down.
            cell.transform = CGAffineTransform.identity
            cell.removeCheckedMark()
        }
    }
    
   
    
    //***************************************************************
    // MARK: - ClientInfoProtocol
    //***************************************************************
    
    func lotNumORnotesChanged(for client: ClientModel, at index: Int) {
        updateClientInQueue(with: client, at: index, viewController: self)
    }
    
    
    
    //***************************************************************
    // MARK: - UICollectionViewCell Editing
    //***************************************************************
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.refreshControl.endRefreshing()
        
        if editing {
            collectionView?.allowsMultipleSelection = true
            trashButton(isEnabled: true)
            self.refreshControl.removeFromSuperview()
        } else {
            trashButton(isEnabled: false)
            collectionView?.addSubview(refreshControl)
        }
        
        var delayFloat: CGFloat = 0.0
        var delayTime: CFTimeInterval = 0.0
        
        // Sets the visible state of visible cells in collectionView for isEditing
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths.enumerated() {
                if let cell = collectionView?.cellForItem(at: indexPath.element) as? ClientQueueCell {
                    if editing {
                        cell.clientDetailButton.isEnabled = false
                        cell.additionalNotesTextField.isEnabled = false
                        cell.lotNumTextField.isEnabled = false
                        cell.deleteClientCheckBox.isHidden = false
                        delayFloat += 0.1
                        delayTime += 0.1
                        Animate.startJiggle(collectionView: collectionView!, with: delayTime)
                    } else {
                        deselect(cell: cell)
                        cell.clientDetailButton.isEnabled = true
                        cell.additionalNotesTextField.isEnabled = true
                        cell.lotNumTextField.isEnabled = true
                        cell.deleteClientCheckBox.isHidden = true
                        delayFloat += 0.1
                        Animate.stopJiggling(collectionView: collectionView!)
                    }
                }
            }
        }
    }
    
    
    
    //***************************************************************
    // MARK: - Private Helper Methods
    //***************************************************************
    
    /// Sets the enables/disabled state of the trash button.
    ///
    /// - Parameter isEnabled: True to enable, false to disable.
    fileprivate func trashButton(isEnabled: Bool) {
        if isEnabled {
            trashButton.tintColor = .black
            trashButton.isEnabled = true
        } else {
            trashButton.tintColor = .clear
            trashButton.isEnabled = false
        }
    }
    
    /// Deletes the client
    ///
    /// - Parameter cells: The cells to delete.
    fileprivate func deleteClients() {
        var deletedClientsFromQueue = [ClientModel : Int]()
  
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            for index in selectedCells {
                let deletedClient = Queue.remove(at: index.row)
                deletedClientsFromQueue.updateValue(index.row, forKey: deletedClient)
            }
            
//            let items = selectedCells.map { $0.item }.sorted().reversed()
//            for index in items {
//                let deletedClient = Queue.remove(at: index)
//                deletedClientsFromQueue.updateValue(index, forKey: deletedClient)
//            }
            
            self.collectionView.deleteItems(at: selectedCells)
            print("\(deletedClientsFromQueue.count) client(s) deleted from Collection View.") // debugging
        }
        
        iCloud.uploadQueueToCloud(queue: Queue, viewController: self, completion: { (error) in
            if let error = error {
                // Adds client back into the queue array (at their indexes) if the queue upload failed/errored.
                for (client,index) in deletedClientsFromQueue {
                    Queue.insert(client, at: index)
                    print("Error: Client(s) inserted back into Queue. \n\(error.localizedDescription)") // debugging
                }
            }
            
            // Check if there are anymore clients in the collectionView and sets the 'Done' button back to edit, otherwise editing is still active.
            DispatchQueue.main.async { if Queue.count == 0 { self.setEditing(false, animated: true) } }
            
            deletedClientsFromQueue.removeAll()
            self.updateUI()
        })
    }
    
    /// Updates the view controllers basic UI, empty queue label, ends refreshing.
    @objc fileprivate func updateUI() {
        DispatchQueue.main.async {
            Queue.count > 0 ? (self.collectionViewEmptyLabel.isHidden = true) : (self.collectionViewEmptyLabel.isHidden = false)
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    /// Creates a string of all the legal clauses.
    ///
    /// - Returns: A string representation of all the legalese, separated by an HTML line break - <br>.
    fileprivate func populateLegaleseInfo() -> String {
        var legalese = ""
        for clause in selectedClient.Legal {
            if clause != "" {
                let studioName = Studio.name
                let line = clause.replacingOccurrences(of: "YOUR STUDIO NAME", with: studioName)
                legalese +=  "✅ : " + line + "\n\n"
            }
        }
        print("Populated legalese info for PDF.") // debugging
        return legalese
    }
    
    
    
    //***************************************************************
    // MARK: - Navigation
    //***************************************************************
    
    // Should Perform Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var performSegue = false
        
        if identifier == SegueIDs.unwindToMainSegue {
            performSegue = true
        }
        
        guard let cell = sender as? ClientQueueCell else { return performSegue }
        guard let indexpath = collectionView.indexPath(for: cell) else { return performSegue }
        selectedClient = Queue[indexpath.row]
        
        if !isEditing {
            if selectedClient.isStudioInfoSet {
                if Studio.lotNumsRequired && identifier == SegueIDs.PreviewSegue {
                    if selectedClient.sterilizationLotNumber != "" {
                        performSegue = true
                    } else {
                        Alerts.myAlert(title: "Lot Number Missing", message: "A lot number is required to view and upload the client's PDF.", error: nil, actionsTitleAndStyle: nil, viewController: self, buttonHandler: nil)
                        performSegue = false
                    }
                } else if !Studio.lotNumsRequired { performSegue = true }
            } else {
                Alerts.myAlert(title: "Studio Info Not Set", message: "All studio info for the client must be completed in order to view the form.", error: nil, actionsTitleAndStyle: nil, viewController: self, buttonHandler: nil)
            }
        }
        
        return performSegue
    }
    
    
    /// Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIDs.PreviewSegue, let cell = sender as? ClientQueueCell {
            guard let previewViewController = segue.destination as? PreviewViewController else { return }
            resignFirstResponder()
            let pdfCreator = PDFCreator(title: "Release and Waiver Form",
                                        shopInfo: Studio.getStudioInfo(),
                                        shopImage: Studio.logo ?? UIImage(named: "no logo image holder.png")!,
                                        clientInfo: selectedClient.getClientInfo(),
                                        clientImages: selectedClient.IDImages,
                                        procedureInfo: selectedClient.getProcedureInfo(),
                                        legal: selectedClient.Legal, // populateLegaleseInfo(),
                                        clientSignatureImages: selectedClient.signatureImages,
                                        additionalNotes: selectedClient.additionalNotes
            )
            previewViewController.client = selectedClient
            previewViewController.pdfDocumentData = pdfCreator.createClientForm()
            previewViewController.queueVCRef = self
            previewViewController.previewPDFClientIndexPath = collectionView?.indexPath(for: cell)?.row
        }
    }
    
    
} // end of ClientQueueCollectionViewController





extension ClientQueueCell {
    func addCheckedMark() { self.deleteClientCheckBox.image = UIImage(named: "check") }
    func removeCheckedMark() { self.deleteClientCheckBox.image = nil }
}


extension ClientQueueCollectionViewController: CollectionCellProtocol {
    
    /// Shows the Client Detail VC as a popover
    /// - Parameters:
    ///   - view: The source view.
    ///   - cell: The Client queue cell calling.
    func showClientDetailVC(view: UIView, cell: ClientQueueCell) {
        let clientQueueDetailVC = storyboard?.instantiateViewController(withIdentifier: VCIdentifiers.ClientQueueDetailVC) as? ClientQueueDetailController
        clientQueueDetailVC?.client = cell.client
        clientQueueDetailVC?.modalPresentationStyle = .popover
        present(clientQueueDetailVC!, animated: true, completion: nil)
        let popoverController = clientQueueDetailVC?.popoverPresentationController
        popoverController!.sourceView = view
        popoverController!.sourceRect = view.bounds
        popoverController!.permittedArrowDirections = .any
    }
    
}


extension UIRefreshControl {
    
    func beginRefreshingManually(from viewController: UIViewController) {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
            if self.isRefreshing {
                self.endRefreshing()
                let alert = UIAlertController(title: "Request Timed Out", message: "The network request timed out. Please try again.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                viewController.present(alert, animated: true, completion: nil)
            }
        })
    }
}




