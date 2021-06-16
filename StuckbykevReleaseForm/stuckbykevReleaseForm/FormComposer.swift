//
//  FormComposer.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 12/2/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

//import UIKit
import Localize_Swift
//
//class FormComposer: NSObject {
//    
//    //***************************************************************
//    // MARK: - Instance Vaiables
//    //***************************************************************
//    
//    let pathToFormHTMLTemplate = Bundle.main.path(forResource: "release_form", ofType: "html")
//    
//    var pdfFilename: String!
//    
//    let IdImagesURL = { () -> [String] in
//        var url = [String]()
//        for (count,image) in Client.IDImages.enumerated() {
//            guard let filename = getPathofImageSavedInDocumentsDirectory(fileName: ImagesKeys.IDImageJPG + "/" + Client.name.replacingOccurrences(of: " ", with: "_") + "_\(count).jpg") else { return url }
//            url.append("file://" + filename)
//            print("ID image directory path\(url) - ")
//        }
//        return url
//    }
//    
//    let signatureImageURL = { () -> [String] in
//        var url = [String]()
//        for (count,image) in Client.signatureImages.enumerated() {
//            guard let filename = getPathofImageSavedInDocumentsDirectory(fileName: ImagesKeys.SignatureJPG + "/" + Client.name.replacingOccurrences(of: " ", with: "_") + "_\(count).jpg") else { return url }
//            url.append("file://" + filename)
//            print("Signature image directory path\(url) - ")
//        }
//        return url
//    }
//    
//    let studioImageURL = { () -> String in
//        var url = ""
//        guard let filename = getPathofImageSavedInDocumentsDirectory(fileName: ImagesKeys.StudioLogoJPG) else { return url }
//        url = "file://" + filename
//        print("Studio logo image directory path\(url) - ")
//        return url
//    }
//            
//    
//    
//    // MARK: - Initialization
//    
//    override init() {
//        super.init()
//    }
//    
//    
//    
//    //***************************************************************
//    // MARK: - Render Invoice
//    //***************************************************************
//    
//    func renderInvoice() -> (String?, Error?) {
//        
//        // Replace all the placeholders with real values.
//        do {
//            // Load the invoice HTML template code into a String variable.
//            var HTMLContent = try String(contentsOfFile: pathToFormHTMLTemplate!)
//            
//            // ID images.
//            var imagesHTML = ""
//            let imagesHTMLcode = "<td class=\"title\"> <img src=\"#ID_IMAGE|#\" style=\"width:100%; max-width:200px; border-color: #ffffff; background-color: #ffffff\">"
//            for (count,url) in IdImagesURL().enumerated() {
//                let temp = imagesHTMLcode.replacingOccurrences(of: "|", with: "\(count)")
//                imagesHTML.append(contentsOf: temp.replacingOccurrences(of: "#ID_IMAGE\(count)#", with: url))
//            }
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#ID_IMAGES#", with: imagesHTML)
//            
//            
//            // The Studio Logo image.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#STUDIO_LOGO_IMAGE#", with: studioImageURL())
//            
//            
//            // Signature images.
//            var signatureImagesHTML = ""
//            let signatureImagesHTMLcode = "<td class=\"title\"> <img src=\"#SIGNATURE_IMAGE|#\" style=\"width:100%; max-width:200px; border-color: #ffffff; background-color: #ffffff\">"
//            for (count,url) in signatureImageURL().enumerated() {
//                let temp = signatureImagesHTMLcode.replacingOccurrences(of: "|", with: "\(count)")
//                signatureImagesHTML.append(contentsOf: temp.replacingOccurrences(of: "#SIGNATURE_IMAGE\(count)#", with: url))
//            }
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#SIGNATURE_IMAGES#", with: signatureImagesHTML)
//            
//            
//            // Procedure date.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#PROCEDURE_DATE#", with: Client.procedureDate)
//            
//            // Price
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#PRICE#", with: Client.price ?? "")
//           
//            // Artist name.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#ARTIST_NAME#", with: Client.artistName)
//            
//            // Type of procedure.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#TYPE_OF_PROCEDURE#", with: getProcedureType())
//            
//            // Studio info.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#STUDIO_INFO#", with: populateStudioInfo())
//            
//            // Client info.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#CLIENT_INFO#", with: populateClientInfo())
//            
//            // Sterilization Number.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#STERILIZATION_NUMBER#", with: Client.sterilizationLotNumber)
//            
//            // Additional Notes.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#ADDITIONAL_NOTES#", with: Client.additionalNotes)
//            
//            // Legalese Info.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#LEGALESE#", with: populateLegaleseInfo())
//            
//            // The HTML code is ready.
//            print(HTMLContent)
//            return (HTMLContent, nil)
//        } catch {
//            return (nil, error)
//        }
//    }
//    
//    
//    
//    //***************************************************************
//    // MARK: - Helper Methods
//    //***************************************************************
//    
//    /// Creates a string of all the Client info.
//    ///
//    /// - Returns: A string representation of all of the client's info, separated by an HTML line break - <br>.
//    fileprivate func populateClientInfo() -> String {
//        let clientInfoArray = [Client.name, Client.streetAddress, Client.city, Client.state, Client.zipcode, Client.age, Client.birthdateString, Client.phoneNumber, Client.gender]
//        
//        var clientInfo = ""
//        for info in clientInfoArray {
//            clientInfo += info + "<br>"
//        }
//        
//        clientInfo += Client.emailAddress ?? ""
//        
//        print("Populated client info for PDF.")  // debugging
//        return clientInfo
//    }
//    
//    /// Creates a string of the procedure type.
//    ///
//    /// - Returns: A string representation of the procedure type along with any other info for it, separated by an HTML line break - <br>.
//    fileprivate func getProcedureType() -> String {
//        var procedureType = ""
//        if Client.tattooORpiercing {
//            let tattooDescription = Client.descriptionOfTattoo
//            let placement = Client.placementOfTattoo
//            procedureType = "Tattoo: " + tattooDescription + "<br>Placement: " + placement
//        } else {
//            let piercingDescription = Client.typeOfPiercing
//            procedureType = "Piercing: " + piercingDescription
//        }
//        print("Populated procedure type for PDF.") // debugging
//        return procedureType
//    }
//    
//    /// Creates a string of the Studio's information.
//    ///
//    /// - Returns: A string representation of all the studio's info, separated by an HTML line break - <br>.
//    fileprivate func populateStudioInfo() -> String {
//        let name = Studio.name + "<br>"
//        let address = Studio.address + "<br>"
//        let phone = Studio.phoneNumber + "<br>"
//        let website = Studio.website + "<br>"
//        let email = Studio.email + "<br>"
//        
//        let info = name + address + phone + website + email
//        print("Populated Studio Info for PDF.") // debugging
//        return info
//    }
//    
//        
//    /// Creates a string of all the legal clauses.
//    ///
//    /// - Returns: A string representation of all the legalese, separated by an HTML line break - <br>.
//    fileprivate func populateLegaleseInfo() -> String {
//        var legalese = ""
//        for i in Client.Legal {
//            if i != "" {
//                let studioName = Studio.name
//                let line = i.replacingOccurrences(of: "YOUR STUDIO NAME", with: studioName)
//                legalese +=  "✅ : " + line + "<br><br>"
//            }
//        }
//        print("Populated legalese info for PDF.") // debugging
//        return legalese
//    }
//    
//    
//    
//    //***************************************************************
//    // MARK: - Export to PDF
//    //***************************************************************
//    
//    func exportHTMLContentToPDF(HTMLContent: String) -> Data {
//        let printPageRenderer = CustomPrintPageRenderer()
//
//        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
//
//        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
//
//        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
//
//        pdfFilename = "\(docDir)/\(Client.name).pdf"
//        pdfData?.write(toFile: pdfFilename, atomically: true)
//        print("PDF Filename: \(pdfFilename!)") // debugging
//        return pdfData! as Data
//    }
//    
//    fileprivate func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
//        let data = NSMutableData()
//        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
//        
//        // Prints to the proper amount of pages
//        for i in 1...printPageRenderer.numberOfPages {
//            UIGraphicsBeginPDFPage()
//            let bounds = UIGraphicsGetPDFContextBounds()
//            printPageRenderer.drawPage(at: i - 1, in: bounds)
//        }
//        UIGraphicsEndPDFContext()
//        return data
//    }
//
//    
//}

