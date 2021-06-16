//
//  PreviewViewController.swift
//  StuckByKev Release Form
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import WebKit
//import CircularSpinner
//import SCLAlertView
import PDFKit

class PreviewViewController: UIViewController {
    
    //***************************************************************
    // MARK: - Instance variables
    //***************************************************************
    
    var client: ClientModel!
    var queueVCRef: ClientQueueCollectionViewController!
    var previewPDFClientIndexPath: Int?
//    var formComposer: FormComposer!
//    var HTMLContent: String!
//    var PDFData: Data!
//    let backgroundQueue = DispatchQueue(label: "com.stuckbykev.preview", qos: .background, target: nil)
    public var pdfDocumentData: Data?
    
    

    //***************************************************************
    // MARK: - Outlets
    //***************************************************************
    
    @IBOutlet weak var webPreview: WKWebView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var spinnerContainerView: UIView!
    @IBOutlet weak var PDFView: PDFView!
    
    
    
    //***************************************************************
    // MARK: - Actions
    //***************************************************************
    
    @IBAction func saveAndUploadbuttonAction(_ sender: AnyObject) {
//        PDFData = formComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        showOptionsAlert()
    }
    
    
    
    //***************************************************************
    // MARK: - Life Cycle
    //***************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** PreviewViewController ****")
        
        blurEffect.isHidden = true
        
        
        // Shows the PDF in the PDFView
        if let data = pdfDocumentData {
            PDFView.document = PDFDocument(data: data)
            PDFView.autoScales = true
        }
    }
    
    deinit { print("PreviewViewController DEINIT") }
    
    
    
    //***************************************************************
    // MARK: - Helper Methods
    //***************************************************************
    
    /// Creates the HTML content format of the form.
//    fileprivate func createFormAsHTML() {
//        client.saveImagesToDocumentsDirectory(for: .IDs)
//        client.saveImagesToDocumentsDirectory(for: .signatures)
//        formComposer = FormComposer()
//        let (formHTML, error) = formComposer.renderInvoice()
//        if error == nil, let formHTML = formHTML {
//            webPreview.loadHTMLString(formHTML, baseURL: NSURL(string: formComposer.pathToFormHTMLTemplate!) as URL?)
//            HTMLContent = formHTML
//        } else if let error = error {
//            print("Unable to open and use HTML template files") // debugging
//            Alerts.myAlert(title: "Error", message: "Unable to open and use HTML template files.", error: error, actionsTitleAndStyle: nil, viewController: self, buttonHandler: nil)
//        }
//    }
    
    
    
    /// Save Options Alert
    fileprivate func showOptionsAlert() {
        let alertView = SCLAlertView(appearance: alertAppearance)
        
        alertView.addButton("Finish & Upload") {
            self.blurEffect.isHidden = false
            CircularSpinner.useContainerView(self.spinnerContainerView)
            CircularSpinner.trackPgColor = Studio.backgroundColor
            CircularSpinner.show((""), animated: true, type: .indeterminate, showDismissButton: false)
            
            let filename = self.client.createFileName()
            
            iCloud.uploadClient(filename: filename, client: Client, viewController: self, completion: { (error) in
                if error == nil {
                    guard let pdfDocumentData = self.pdfDocumentData else { return }
                    iCloud.uploadClientPDFtoiCloudDrive(clientName: self.client.name, pdfData: pdfDocumentData, viewController: self, completion: { (error) in
                        if error == nil {
                            self.removeClientAndUploadQueue()
                        }
                    })
                } else {
                    self.restoreUI(withUnwind: false)
                }
            })
        }
        
        alertView.addButton("Cancel") {
            print("Cancel button tapped") // debugging
        }
        
        alertView.showSuccess("Client's PDF Loaded", subTitle: "")
    }

    
    /// Removes the client from the queue and uploads the queue to the cloud.
    fileprivate func removeClientAndUploadQueue() {
        print("Removing client") // debugging
        client.Health.removeAll() // Must first delete Health Info before saving to file/PDF per HIPAA requirements
        client.sterilizationLotNumber = "" // removes the lot number from the client model
        Queue.remove(at: self.previewPDFClientIndexPath!) // Removes the client from the Queue
        print("client removed from queue, -> count: \(Queue.count)") // debugging
        
        iCloud.uploadQueueToCloud(queue: Queue, viewController: queueVCRef, completion: { (error) in
            self.restoreUI(withUnwind: true)
        })
    }
    
    /// Restores the UI back to normal and unwinds back to the Queue VC
    fileprivate func restoreUI(withUnwind: Bool) {
        DispatchQueue.main.async {
            CircularSpinner.hide()
            self.blurEffect.isHidden = true
            
            if withUnwind {
                self.performSegue(withIdentifier: SegueIDs.unwindToQueueVCSegue, sender: self)
            }
        }
    }
    
    
}

