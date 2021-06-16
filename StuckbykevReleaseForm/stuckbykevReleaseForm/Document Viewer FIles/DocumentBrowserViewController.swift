//
//  DocumentBrowserViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/7/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** DocumentBrowserViewController ****")
        
        delegate = self
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    deinit { print("DocumentBrowserViewController DEINIT") }
    
    
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        guard let sourceURL = documentURLs.first else { return }
        presentDocument(at: sourceURL)
    }
    
    
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        let storyBoard = UIStoryboard(name: "DocumentViewer", bundle: nil)
        guard let documentViewController = storyBoard.instantiateViewController(withIdentifier: VCIdentifiers.DocumentVC) as? DocumentViewController else { return }
        documentViewController.document = Document(fileURL: documentURL)
        documentViewController.modalPresentationStyle = .fullScreen

        present(documentViewController, animated: true, completion: nil)
    }
    
    
}
