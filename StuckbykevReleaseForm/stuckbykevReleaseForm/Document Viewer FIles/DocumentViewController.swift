//
//  DocumentViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/7/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit
import PDFKit

class DocumentViewController: UIViewController {
    
    // MARK: Instance Variables
    var document: Document?
    
    // MARK: Outlets
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var navBar: UINavigationBar!
   
    // MARK: Actions
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
    
    
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\n**** DocumentViewController ****")
            
        // #4.1 - "Opens a document asynchronously."
        // Document data will become available for
        // me to display in this method's completion
        // handler, which must occur on the main queue.
        document?.open(completionHandler: { (success) in
            
            if success {
                // #4.2 - Display the document's file name.
                self.navBar.topItem?.title = self.document?.fileURL.lastPathComponent
                self.navBar.barTintColor = Studio.backgroundColor
                
                // #4.3 - If the UIDocument reports that it is an image file...
                if self.document?.fileType == "public.png" || self.document?.fileType == "public.jpeg" {
                    
                    // #4.4 - Display the image built from binary data read from the file in
                    // UIDocument's "load" method. See my "Document" class.
                    let imageView = UIImageView(image: UIImage(data: (self.document?.fileData)!))
                    imageView.frame = CGRect(origin: CGPoint(x: self.view.center.x - 250, y: self.view.center.y - 250), size: CGSize(width: 500, height: 500))
                    self.view.addSubview(imageView)
                  
                    
                } else if self.document?.fileType == "com.adobe.pdf" || self.document?.fileType == "public.data" {
                    // Shows the PDF in the PDFView
                    if let data = self.document?.fileData {
                        self.pdfView.document = PDFDocument(data: data)
                        self.pdfView.autoScales = true
                    }
                }
                
                print("Document state: \((self.document?.state)!)")
                
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
                Alerts.myAlert(title: "Error", message: "Failed to import file: \(String(describing: self.document?.state))", error: nil, actionsTitleAndStyle: nil, viewController: self, buttonHandler: nil)
            }
        })
    }
    
    deinit { print("DocumentViewController DEINIT") }
    
    
    
    
}
