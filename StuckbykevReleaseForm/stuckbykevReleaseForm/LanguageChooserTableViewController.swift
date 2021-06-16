//
//  LanguageChooserTableViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 7/8/17.
//  Copyright © 2017 Kevin Green. All rights reserved.
//

import UIKit
import Localize_Swift

struct cellData {
    let text: String!
    let code: String!
    let image: UIImage!
}

class LanguageChooserTableViewController: UITableViewController {
    
    // MARK: - Instance Variables
    
    var delegate: ReturnInfoDelegate?
    var arrayOfCellData = [cellData]()
    let availableLanguages = Localize.availableLanguages()
    
    // "de", "en", "es-MX", "fr", "it", "ja", "ru", "zh-Hans"
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** LanguageChooserTableViewController ****")
        
        arrayOfCellData = [cellData(text: "English", code: "en", image: UIImage(named: "langButton_en")),
                           cellData(text: "Spanish (Mexico)", code: "es-MX", image: UIImage(named: "langButton_es-MX")),
                           cellData(text: "Chinese (Simplified)", code: "zh-Hans", image: UIImage(named: "langButton_zh-Hans")),
                           cellData(text: "Japanese", code: "ja", image: UIImage(named: "langButton_ja")),
                           cellData(text: "French", code: "fr", image: UIImage(named: "langButton_fr")),
                           cellData(text: "German", code: "de", image: UIImage(named: "langButton_de")),
                           cellData(text: "Italian", code: "it", image: UIImage(named: "langButton_it")),
                           cellData(text: "Russian", code: "ru", image: UIImage(named: "langButton_ru"))
        ]
    }

    deinit { print("LanguageChooserTableViewController DEINIT") }

    

    // MARK: - UITableViewDelegate & Datasource
    
    let cellReuseIdentifier = "Language Cell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LanguageChooserTableViewCell else { return UITableViewCell() }
        cell.languageLabel.text = arrayOfCellData[indexPath.row].text
        cell.flagImage.image = arrayOfCellData[indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 1)
        if (indexPath.row == lastRowIndex - 1) {
            Localize.resetCurrentLanguageToDefault()
        } else {
            delegate?.writeLanguageBack(arrayOfCellData[indexPath.row].code)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

