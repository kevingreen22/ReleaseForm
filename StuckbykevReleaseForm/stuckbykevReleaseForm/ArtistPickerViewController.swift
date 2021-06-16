//
//  ArtistPickerViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 10/16/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

class ArtistPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Instance variables

    var delegate: writeBackInfo?
    var names: [String] = [""]
    var photos: [UIImage] = []
    var selectedArtist: String = ""
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var artistPickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    
    // MARK: - Actions
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        delegate?.writeArtistBack(selectedArtist)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** ArtistPickerViewController ****")
        
        setText()
        names = Array(Studio.artistList.keys)
        photos = Array(Studio.artistList.values)
        selectedArtist = names[0]
    }
    
    deinit { print("ArtistPickerViewController DEINIT") }

    fileprivate func setText() {
        artistLabel.text = "Select Your Artist".localized()
        doneButton.setTitle("Done".localized(), for: .normal)
    }
    
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Studio.artistList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 50, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        imageView.image = photos[row]
        
        let myLabel = UILabel(frame: CGRect(x: pickerView.bounds.width/2 - 20, y: 0, width: pickerView.bounds.width - 90, height: 30 ))
        myLabel.font = UIFont.systemFont(ofSize: 18)
        myLabel.text = names[row]
        
        pickerView.addSubview(myLabel)
        pickerView.addSubview(imageView)
        
        return pickerView
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedArtist = names[row]
    }

    
}

