//
//  PDFCreator.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/1/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
    
    let title: String
    let shopInfo: String
    let shopImage: UIImage
    let clientInfo: String
    let clientImages: [UIImage]
    let procedureInfo: String
    let legal: [String]
    let clientSignatureImages: [UIImage]
    let additionalNotes: String
    
    // Recall that PDF files use a coordinate system with 72 points per inch. To create a PDF document with a specific size, multiply the size in inches by 72 to get the number of points. Here, you’ll use 8.5 x 11 inches, because that’s the standard U.S. letter size. You then create a rectangle of the size you just calculated.
    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    
    var context: UIGraphicsPDFRendererContext!
    

    init(title: String, shopInfo: String, shopImage: UIImage, clientInfo: String, clientImages: [UIImage], procedureInfo: String, legal: [String], clientSignatureImages: [UIImage], additionalNotes: String) {
        self.title = title
        self.shopInfo = shopInfo
        self.shopImage = shopImage
        self.clientInfo = clientInfo
        self.clientImages = clientImages
        self.procedureInfo = procedureInfo
        self.legal = legal
        self.clientSignatureImages = clientSignatureImages
        self.additionalNotes = additionalNotes
    }
    
    
    
    func createClientForm() -> Data {
        // Create a dictionary with the PDF’s metadata using predefined keys.
        let pdfMetaData = [
            kCGPDFContextCreator: "Release Forms iOS App",
            kCGPDFContextAuthor: "SBKDigital.com",
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // Creates a PDFRenderer object with the dimensions of the rectangle and the format containing the metadata.
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        // A block where you create the PDF. The renderer creates a Core Graphics context that becomes the current context within the block. Drawing done on this context will appear on the PDF.
        let data = renderer.pdfData { (cont) in
            // Starts a new PDF page. You must call beginPage() one time before giving any other drawing instructions. You can call it again to create multi-page PDF documents.
            self.context = cont
            context.beginPage()
            
            let titleBottomY = addTitle(pageRect: pageRect)
                        
            let clientInfoBottomY = addClientInfo(pageRect: pageRect, textTop: titleBottomY + 10)
            let _ = addClientImage(pageRect: pageRect, imageTop: titleBottomY + 10)
            let _ = addProcedureInfo(pageRect: pageRect, textTop: titleBottomY + 10)
            
            let legalTextBottomY = addLegalText(pageRect: pageRect, textTop: clientInfoBottomY + 10.0)
                        
            let clientSignImageBottom = addClientSignatureImage(pageRect: pageRect, imageTop: legalTextBottomY + 10)
            
//            let additionalNotesBottomY = addAdditionalNotes(pageRect: pageRect, textTop: clientSignImageBottom + 10)
            
            let _ = addShopInfo(pageRect: pageRect, textTop: clientSignImageBottom)
            let _ = addShopImage(pageRect: pageRect, imageTop: clientSignImageBottom)
        }
        
        return data
    }

    
    
    
    
    fileprivate func addTitle(pageRect: CGRect) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)

        let titleAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: titleFont]

        let attributedTitle = NSAttributedString(
            string: title,
            attributes: titleAttributes
        )

        let titleStringSize = attributedTitle.size()

        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 10,
            width: titleStringSize.width,
            height: titleStringSize.height
        )

        attributedTitle.draw(in: titleStringRect)

        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    
    
    fileprivate func addClientInfo(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping

        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(
            string: clientInfo,
            attributes: textAttributes
        )
        let textStringSize = attributedText.size()

        let textRect = CGRect(
            x: 10,
            y: textTop,
            width: textStringSize.width,
            height: pageRect.height - textTop - pageRect.height / 5.0
        )
        attributedText.draw(in: textRect)
        return textRect.origin.y + textStringSize.height
    }
    
    
    
    fileprivate func addClientImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
        let maxHeight = pageRect.height * 0.1
        let maxWidth = pageRect.width * 0.1
        
        var clientImage = UIImage()
        var imageRect = CGRect()
        
        for image in clientImages {
            let numOfImages: CGFloat = CGFloat(clientImages.count)
            clientImage = image
            
            let aspectWidth = maxWidth / clientImage.size.width
            let aspectHeight = maxHeight / clientImage.size.height
            let aspectRatio = min(aspectWidth, aspectHeight)

            let scaledWidth = clientImage.size.width * aspectRatio
            let scaledHeight = clientImage.size.height * aspectRatio
            
            if clientImages.count > 1 {
                let imageX = (pageRect.width - scaledWidth) / numOfImages
                imageRect = CGRect(x: imageX, y: imageTop,
                                   width: scaledWidth, height: scaledHeight
                )
            } else {
                let imageX = (pageRect.width - scaledWidth) / 2.0  // centered
                imageRect = CGRect(x: imageX, y: imageTop,
                                       width: scaledWidth, height: scaledHeight)
            }
            clientImage.draw(in: imageRect)
        }
        
        return imageRect.origin.y + imageRect.size.height
    }
    
    
    
    fileprivate func addProcedureInfo(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.lineBreakMode = .byWordWrapping

        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(
            string: procedureInfo,
            attributes: textAttributes
        )
        let textStringSize = attributedText.size()

        let textRect = CGRect(
            x: pageRect.width - textStringSize.width - 10,
            y: textTop,
            width: textStringSize.width,
            height: pageRect.height - textTop - pageRect.height / 5.0
        )
        attributedText.draw(in: textRect)
        return textRect.origin.y + textStringSize.height
    }
    
    
    
    fileprivate func addLegalText(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        var totalHeight = textTop
        
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping

        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        
        
        for clause in legal {
            let studioName = Studio.name
            let line = clause.replacingOccurrences(of: "YOUR STUDIO NAME", with: studioName)
            let attributedText = NSAttributedString(string: "✅ : " + line, attributes: textAttributes)
            
//            print(attributedText.size().width)
//            print(attributedText.size().height)
            
            let textRectSize = getTextRectSize(attributedText: attributedText.size().width, height: attributedText.size().height)
            
            let textRect = CGRect( x: 10,
                                   y: totalHeight,
                                   width: textRectSize.width,
                                   height: textRectSize.height
            )
            
            attributedText.draw(in: textRect)
            
            totalHeight += textRect.height + 8
            
            if totalHeight > CGFloat(pageHeight - 180) {
                context.beginPage()
            }
            
        }
        
        
//        let attributedText = NSAttributedString(
//                                                string: legal,
//                                                attributes: textAttributes
//        )

//        let textRect = CGRect( x: 10,
//                               y: textTop,
//                               width: pageRect.width - 20,
//                               height: pageRect.height - textTop - pageRect.height / 3.0 // attributedText.size().height
//        )
        
       

        return totalHeight  // textRect.origin.y + textRect.height
    }
    
    
    
    fileprivate func getTextRectSize(attributedText width: CGFloat, height: CGFloat) -> CGSize {
        var textRectSize = CGSize()
        
        let numOfLines: CGFloat = width / CGFloat(pageWidth - 20)
        let rectHeight = ceil(numOfLines) * 14.5
        
        textRectSize.width = CGFloat(pageWidth - 20)
        textRectSize.height = rectHeight
        
        return textRectSize
    }
    
    
    
    fileprivate func addClientSignatureImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
        let maxHeight = pageRect.height * 0.2
        let maxWidth = pageRect.width * 0.2
        
        var clientSignatureImage = UIImage()
        var imageRect = CGRect()
        
        for image in clientSignatureImages {
            let numOfImages: CGFloat = CGFloat(clientSignatureImages.count)
            clientSignatureImage = image
            
            let aspectWidth = maxWidth / clientSignatureImage.size.width
            let aspectHeight = maxHeight / clientSignatureImage.size.height
            let aspectRatio = min(aspectWidth, aspectHeight)

            let scaledWidth = clientSignatureImage.size.width * aspectRatio
            let scaledHeight = clientSignatureImage.size.height * aspectRatio
            
            if clientImages.count > 1 {
                let imageX = (pageRect.width - scaledWidth) / numOfImages
                imageRect = CGRect(x: imageX, y: imageTop,
                                   width: scaledWidth, height: scaledHeight
                )
            } else {
                let imageX = (pageRect.width - scaledWidth) / 2.0  // centered
                imageRect = CGRect(x: imageX, y: imageTop,
                                       width: scaledWidth, height: scaledHeight)
            }
        }
        
        clientSignatureImage.draw(in: imageRect)
        return imageRect.origin.y + imageRect.size.height
    }
    
    
    
//    func addAdditionalNotes(pageRect: CGRect, textTop: CGFloat) -> CGFloat{
//        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
//        // 1
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .natural
//        paragraphStyle.lineBreakMode = .byWordWrapping
//        // 2
//        let textAttributes = [
//            NSAttributedString.Key.paragraphStyle: paragraphStyle,
//            NSAttributedString.Key.font: textFont
//        ]
//        let attributedText = NSAttributedString(
//            string: "Notes: \(additionalNotes)",
//            attributes: textAttributes
//        )
//        let textStringSize = attributedText.size()
//        // 3
//        let textRect = CGRect(
//            x: 10,
//            y: textTop,
//            width: pageRect.width - 20,
//            height: textStringSize.height
//        )
//        attributedText.draw(in: textRect)
//        return textRect.origin.y + textStringSize.height
//    }
    
    
    
    
    fileprivate func addShopInfo(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.lineBreakMode = .byWordWrapping

        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(
            string: shopInfo,
            attributes: textAttributes
        )
        let textStringSize = attributedText.size()

        let textRect = CGRect(
            x: 150,
            y: pageRect.height - textStringSize.height,
            width: textStringSize.width,
            height: textStringSize.height - 5
        )
        attributedText.draw(in: textRect)
        return textRect.origin.y + textStringSize.height
    }
    
    
    fileprivate func addShopImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {

        let maxHeight = pageRect.height * 0.1
        let maxWidth = pageRect.width * 0.1

        let aspectWidth = maxWidth / shopImage.size.width
        let aspectHeight = maxHeight / shopImage.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        let scaledWidth = shopImage.size.width * aspectRatio
        let scaledHeight = shopImage.size.height * aspectRatio

        let imageX = (pageRect.width - scaledWidth) - 150
        let imageY = (pageRect.height - scaledHeight - 5)
        let imageRect = CGRect(x: imageX, y: imageY,
                               width: scaledWidth, height: scaledHeight)

        shopImage.draw(in: imageRect)
        return imageRect.origin.y + imageRect.size.height
    }
    
    
}
