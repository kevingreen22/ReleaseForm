//
//  AddDeleteArtistViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/6/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit

class AddDeleteArtistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Instance variables
    
    var artistDict = [String : UIImage]()
    var chosenImageIndexPath: IndexPath!
    var delegate: WriteSettingsInfoBack?
    
    
 
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addArtistButton: UIButton!
    
    
    
    // MARK: - Actions
    
    @IBAction func addArtistButtonTapped(_ sender: UIButton) { showAddArtistNameAlert() }
    
    @IBAction func doneButtonAction(_ sender: UIButton) { }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** AddDeleteArtistTableViewController ****")
        
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
        
        artistDict = Studio.artistList
        
        print(artistDict)  // debugging

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dismissKeyboard()
        Studio.artistList = self.artistDict
    }
    
    deinit { print("AddDeleteArtistViewController DEINIT") }
    
    
    
    // MARK: - UITableViewDataSource
    
    fileprivate struct CellResueIDs {
        static let AddNewArtistCell = "Add New Artist Cell"
        static let ArtistCell = "Artist Name Cell"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellResueIDs.ArtistCell, for: indexPath) as? ArtistNameTableViewCell else { return UITableViewCell() }
        cell.artistNameLabel.text = Array(artistDict.keys)[indexPath.row]
        cell.artistPhotoView.image = Array(artistDict.values)[indexPath.row]
        cell.artistPhotoView.contentMode = .scaleAspectFit
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let key = Array(artistDict.keys)
            artistDict.removeValue(forKey: key[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self
        myPicker.sourceType = .photoLibrary
        myPicker.modalPresentationStyle = .popover
        let ppc = myPicker.popoverPresentationController
        ppc?.sourceView = self.tableView.cellForRow(at: indexPath)
        ppc?.sourceRect = (self.tableView.cellForRow(at: indexPath)?.bounds.standardized)!
        ppc?.permittedArrowDirections = .any
        self.present(myPicker, animated: true, completion: nil)
        chosenImageIndexPath = indexPath
        tableView.reloadData()

    }
    
    
    
    // MARK: -  UIImagePickerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let keys = Array(artistDict.keys)
        artistDict.updateValue(image, forKey: keys[chosenImageIndexPath!.row])
        self.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard let defaultPhoto = UIImage(named: ImagesKeys.DefaultArtistPhoto) else { return }
        let keys = Array(artistDict.keys)
        artistDict.updateValue(defaultPhoto, forKey: keys[chosenImageIndexPath!.row])
        self.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    
    
    // MARK: - Private Helper Methods

    /// Shows the add artist's name alert.
    fileprivate func showAddArtistNameAlert() {
        let alert = UIAlertController(title: "Add Artist Name" , message: "Enter Artist Name" , preferredStyle: .alert)
        alert.addTextField { (textField) in  textField.autocapitalizationType = .words}
        alert.addAction(UIAlertAction(title: "Add" , style: .default, handler: { (_) in
            guard let textField = alert.textFields?[0] else { return }
            print("Artist Name Added: \(String(describing: textField.text))")  // debugging
            self.artistDict.updateValue(UIImage(named: ImagesKeys.DefaultArtistPhoto)!, forKey: textField.text ?? "Artist")
            self.tableView.reloadData()
        }))
        let cancel = UIAlertAction(title: "Cancel" , style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

