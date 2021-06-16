//
//  CustomPrintPageRenderer.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 12/2/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {
    
    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
        
        // Specify the header and footer sizes
        self.headerHeight = 10.0
        self.footerHeight = 10.0
        
        // Specify the frame of the A4 page.
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth , height: A4PageHeight)
        
        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        
        // Set the horizontal and vertical insets (that's optional), along with top, bottom, and side indents for better printing results
        self.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10.0, dy: 10.0)), forKey: "printableRect")
    }
    
    /*
    // Specifies the header content
    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
        // Specify the header text.
        let headerText: NSString = "Release and waiver of all claims"
        
        // Set the desired font.
        let font = UIFont(name: "AmericanTypewriter-Bold", size: 20)
        
        // Specify some text attributes we want to apply to the header text.
        let textAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName: UIColor(red: 243.0/255, green: 82.0/255.0, blue: 30.0/255.0, alpha: 1.0), NSKernAttributeName: 7.5] as [String : Any]
        
        // Calculate the text size.
        let textSize = getTextSize(text: headerText as String, font: nil, textAttributes: textAttributes as [String : AnyObject]!)
        
        // Determine the offset to the right side.
        let offsetX: CGFloat = 20.0
        
        // Specify the point that the text drawing should start from.
        let pointX = headerRect.size.width - textSize.width - offsetX
        let pointY = headerRect.size.height/2 - textSize.height/2
        
        // Draw the header text.
        headerText.draw(at: CGPoint(x: pointX, y: pointY), withAttributes: textAttributes)
        
    }
    
    
    // Returns the header text size
    func getTextSize(text: String, font: UIFont!, textAttributes: [String: AnyObject]! = nil) -> CGSize {
        let testLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.paperRect.size.width, height: footerHeight))
        if let attributes = textAttributes {
            testLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        } else {
            testLabel.text = text
            testLabel.font = font!
        }
    
        testLabel.sizeToFit()
    
        return testLabel.frame.size
    }
    
    
    //  Specifies the footer content
    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
        /* NOTE: If you want to use a 'String' object instead of 'NSString' object, then cast it as follows: (text as! NSString).drawAtPoint(...) */
        
        let footerText: NSString = "Thank you!"
        
        let font = UIFont(name: "Noteworthy-Bold", size: 14.0)
        let textSize = getTextSize(text: footerText as String, font: font!)
        
        let centerX = footerRect.size.width/2 - textSize.width/2
        let centerY = footerRect.origin.y + self.footerHeight/2 - textSize.height/2
        let attributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName: UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255, alpha: 1.0)]
        
        footerText.draw(at: CGPoint(x: centerX, y: centerY), withAttributes: attributes)
        
        // Draw a horizontal line.
        let lineOffsetX: CGFloat = 20.0
        let context = UIGraphicsGetCurrentContext()
        let moveToPoint = CGPoint(x: lineOffsetX, y: footerRect.origin.y)
        context!.setStrokeColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255, alpha: 1.0)
        context?.move(to: moveToPoint)
        let addLinePoint = CGPoint(x: footerRect.size.width - lineOffsetX, y: footerRect.origin.y)
        context?.addLine(to: addLinePoint)
        context!.strokePath()
    }
*/

}

