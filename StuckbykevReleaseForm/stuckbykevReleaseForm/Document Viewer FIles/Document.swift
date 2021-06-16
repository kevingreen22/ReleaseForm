//
//  Document.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/7/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import UIKit

public class Document: UIDocument {
    
    // #2.0 - Model for storing binary data when file type is "public.image".
    public var fileData: Data?
    
    
    // Load your document from contents
    override public func load(fromContents contents: Any, ofType typeName: String?) throws {
        // #4.1 - We can only read data if we know
        // what type of file we're reading from.
        if let fileType = typeName {
            
            // #4.2 - I only support .PNG and .JPG type image files.
            if fileType == "public.png" || fileType == "public.jpeg" { // .jpg not recognized
                // #4.3 - If reading was successful, store
                // the binary data into the document model.
                if let fileContents = contents as? Data {
                    fileData = fileContents
                }
                
            } else if fileType == "com.adobe.pdf" || fileType == "public.data" {
                if let fileContents = contents as? Data {
                    fileData = fileContents
                }
                
            } else {
                print("File type unsupported.")
            }
        }
    }
    
    
    
    /* A UIDocument object has a specific state at
     any moment in its life cycle. You can check
     the current state by querying the documentState
     property..." State can help us in debugging.
     */
    public var state: String {
        
        switch documentState {
            
        case .normal:
            return "Normal"
        case .closed:
            return "Closed"
        case .inConflict:
            return "Conflict"
        case .savingError:
            return "Save Error"
        case .editingDisabled:
            return "Editing Disabled"
        case .progressAvailable:
            return "Progress Available"
        default:
            return "Unknown"
            
        }
        
    }
    
    
}

