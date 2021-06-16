//
//  ClientModel.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/26/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import Foundation
import Localize_Swift
import CloudKit

@objc(clientModel)
class ClientModel: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = false
    
    
    
    // ********************************************************************
    // MARK: - NSCoding
    // ********************************************************************
    
    // ** NOTE: If any of these NSCoding coder/decoder objects change, it will break all the currently saved assets stored in iCloud!! **
    
    /// required init for encoding/decoding NSKeyedArchiver/Unarchiver/UserDefaults
    required override init() { super.init() }

    required init(coder aDecoder: NSCoder) {
        birthdate = aDecoder.decodeObject(forKey: "birthdate") as? Date ?? Date()
        IDImages = aDecoder.decodeObject(forKey: "idImages") as? [UIImage] ?? [UIImage]()
        sterilizationLotNumber = aDecoder.decodeObject(forKey: "sterilizationLotNumber") as? String ?? ""
        additionalNotes = aDecoder.decodeObject(forKey: "additionalNotes") as? String ?? ""
        signatureImages = aDecoder.decodeObject(forKey: "signatureImage") as? [UIImage] ?? [UIImage]()
        emailAddress = aDecoder.decodeObject(forKey: "emailAddress") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        tattooORpiercing = aDecoder.decodeObject(forKey: "tattooORpiercing") as? Bool ?? true
        isOver18 = aDecoder.decodeObject(forKey: "isOver18") as? Bool ?? false
        returningClient = aDecoder.decodeObject(forKey: "returningClient") as? Bool ?? false
        isStudioInfoSet = aDecoder.decodeBool(forKey: "isStudioInfoSet")

        Bio = aDecoder.decodeObject(forKey: "Bio") as! Dictionary<String, String>
        Studio = aDecoder.decodeObject(forKey: "Studio") as! Dictionary<String, String>
        Health = aDecoder.decodeObject(forKey: "Health") as! [String]
        Legal = aDecoder.decodeObject(forKey: "Legal") as! [String]
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(birthdate, forKey: "birthdate")
        aCoder.encode(IDImages, forKey: "idImages")
        aCoder.encode(sterilizationLotNumber, forKey: "sterilizationLotNumber")
        aCoder.encode(additionalNotes, forKey: "additionalNotes")
        aCoder.encode(signatureImages, forKey: "signatureImage")
        aCoder.encode(emailAddress, forKey: "emailAddress")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(tattooORpiercing, forKey: "tattooORpiercing")
        aCoder.encode(isOver18, forKey: "isOver18")
        aCoder.encode(returningClient, forKey: "returningClient")
        aCoder.encode(isStudioInfoSet, forKey:"isStudioInfoSet")

        aCoder.encode(Bio, forKey: "Bio")
        aCoder.encode(Studio, forKey: "Studio")
        aCoder.encode(Health, forKey: "Health")
        aCoder.encode(Legal, forKey: "Legal")
    }

    
    
    // ********************************************************************
    // MARK: - Instance variables
    // ********************************************************************

    var birthdate = Date() { didSet { processAge() } }
    var returningClient = false
    var tattooORpiercing: Bool = true // true = tattoo, false = piercing
    var isOver18: Bool = true // true = 18 and over, false = under 18
    var sterilizationLotNumber: String = ""
    var additionalNotes: String = ""
    var IDImages: [UIImage] = []
    var signatureImages: [UIImage] = [] 
    var imageFilenamesAndKeys = [String : String]()
    var emailAddress: String?
    var price: String?
    
    
    
    
    // ********************************************************************
    // MARK: - Bio Info
    // ********************************************************************
    
    public var name: String { get { return Bio["First Name"]! + " " + Bio["Last Name"]! } }
    
    public var age: String { get { return Bio["Age"]! } }

    public var gender: String { get { return Bio["Gender"]! } }

    public var birthdateString: String { get { return Bio["Birthdate"]! } }
    
    public var streetAddress: String { get { return Bio["Street Address"]! } }

    public var city: String { get { return Bio["City"]! } }
    
    public var state: String { get { return Bio["State"]! } }
    
    public var zipcode: String { get { return Bio["Zip Code"]! } }

    public var fullAddress: String { get { return "\(Bio["Street Address"]!)\n\(Bio["City"]!), \(Bio["State"]!) \(Bio["Zip Code"]!)" } }

    public var phoneNumber: String { get { return Bio["Phone Number"]! } }
    
    fileprivate var Bio: Dictionary<String, String> = [
        "First Name" : "",
        "Last Name" : "",
        "Birthdate" : "",
        "Age" : "",
        "Gender" : "",
        "Street Address" : "",
        "City" : "",
        "State" : "",
        "Zip Code" : "",
        "Phone Number" : ""
        ]
    
    /// Processes a full name into first and last names. First contains all names (i.e. first and middle) except the last.
    ///
    /// - Parameter name: A string containing the full name.
    /// - Returns: A tuple of the first and last names.
    fileprivate func processFullName(name: String) -> (String, String) {
        if name != "" {
            var first: String = ""
            var last: String = ""
            let arrayOfNames = name.split(separator: " ")
            last = String(arrayOfNames.last!)
            if arrayOfNames.count > 2 {
                for i in arrayOfNames {
                    first += String(i)
                }
            } else { first = String(arrayOfNames.first!) }
            return (first,last)
        }
        return ("","")
    }
    
    fileprivate func processAge() {
        let now = Date()
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let ageComponents = calendar.components(.year, from: birthdate, to: now, options: [])
        let age = ageComponents.year!
        let ageCalculated = String(age)
        print("age: \(ageCalculated)") // debugging
        Bio["Age"] = ageCalculated
        (age >= 18) ? (isOver18 = true) : (isOver18 = false)
    }
    
    
    
    
    // ********************************************************************
    // MARK: - Client's Studio Info
    // ********************************************************************
    
    public var isStudioInfoSet: Bool = false
    
    public var procedureDate: String = Date().myDateFormatted()
    
    public var artistName: String { get { return Studio["Artist Name"]! } }

    public var typeOfPiercing: String { get { return Studio["Type Of Piercing"]! } }

    public var placementOfTattoo: String { get { return Studio["Placement Of Tattoo"]! } }

    public var descriptionOfTattoo: String { get { return Studio["Description Of Tattoo"]! } }
    
    fileprivate var Studio: Dictionary<String, String> = [
        "Artist Name": "",
        "Type Of Piercing": "",
        "Placement Of Tattoo": "",
        "Description Of Tattoo": ""
    ]

    
    
    
    // ********************************************************************
    // MARK: - Health Info
    // ********************************************************************
    
    /// Must NOT store or save these settings after the client is done and finished per HIPPA requirements.
    public var Health: [String] = []
    
    
    /// Creates a string of the clients Health info.
    ///
    /// - Parameter asList: If true, Health info will be returned as a list, otherwise a continuous string will be returned.
    ///     (i.e. '\n') Adds a newline specifier after each health choice.
    /// - Returns: That string
    public func printHealthInfo(asList: Bool) -> String {
        var healthText: String = ""
        for index in Health {
            healthText.append("\(index), ")
            healthText.append("\n")
        }
        if healthText == "" {
            healthText.append("No Health Issues")
        }
        print("Client health info: \(healthText)") // debugging
        return healthText
    }
    
    /// Retuns a bool of the specified index of the health array.
    ///
    /// - Parameter index: A key, value pair. (String, Bool)
    /// - Returns: A string.
//    fileprivate func answer(_ index: (String, Bool)) -> String {
//        var answer: String = ""
//        if index.1 == true {
//            answer = "Yes"
//        }
//        return answer
//    }
    
    
    
    
    // ********************************************************************
    // MARK: - Legal Info
    // ********************************************************************
    
    public var Legal: [String] = []
    
    
    
    // ********************************************************************
    // MARK: - Public Helper Methods
    // ********************************************************************

    /// Collects all the stored client information from each view in the form and saves it into the Client Model.
    ///
    /// - Parameters:
    ///   - shopInfo: shopInfoView.shopInfo
    ///   - bioInfo: bioInfoView.clientInfo
    ///   - healthInfo: healthStackView?.clausesChecked
    ///   - leagalInfo: legaleseView.populatedLegalArray
    ///   - signatureImages: signatureView.currentImage
    public func collectFormInfo(IDImages: [UIImage], bioInfo: [String:String], healthInfo: [String], legalInfo: [String], signatureImages: [UIImage]) {
        
        // Sets the ID images to the client model
        Client.IDImages = IDImages
        
        // Sets the Signature images to the client model
        Client.signatureImages = signatureImages
        
        // Set the "info" to the client model bio
        for info in bioInfo {
            var processedName: (String, String)!
            if info.key == "Name" {
                let name = bioInfo[info.key]
                processedName = processFullName(name: name ?? "")
                Bio["First Name"] = processedName.0
                Bio["Last Name"] = processedName.1
            } else if info.key == "Email" {
                emailAddress = info.value
            } else {
                Bio[info.key] = info.value
            }
        }
        
        // Set the "info" to the client model Health clauses
        Client.Health = healthInfo
        
        // Set the "info" to the client model Legalese
        Client.Legal = legalInfo
       
    }
    
    
    /// Set the shop info to the client model
    /// - Parameter shopInfo: A dictionary containing the key/value pairs to save & check.
    public func collectClientShopInfo(shopInfo: [String:String]) {
        for info in shopInfo {
            Studio[info.key] = info.value
        }
        
        // These next lines check the validity of the Studio values and sets the isStudioInfoSet variable accordingly.
        Studio["Artist Name"] != "" ? (isStudioInfoSet = true) : (isStudioInfoSet = false)
        
        myLabel: if tattooORpiercing {
            if Studio["Placement Of Tattoo"] != "" { (isStudioInfoSet = true) } else { (isStudioInfoSet = false); break myLabel }
            if Studio["Description Of Tattoo"] != "" { (isStudioInfoSet = true) } else { (isStudioInfoSet = false) }
        } else {
            Studio["Type Of Piercing"] != "" ? (isStudioInfoSet = true) : (isStudioInfoSet = false)
        }
    }
    
    
    /// Creates a filename for the client' pdf file.
    /// - Returns: That filename.
    public func createFileName() -> String {
        let bio = zipcode.trimmingCharacters(in: .whitespaces) + "_"
        let filename = name + ";" + bio + birthdateString
        print("Created client filename: - \(filename)") // debugging
        return filename
    }
    
    
    /// Sets the client model with the downloaded client info from iCloud.
    ///
    /// - Parameter record: The CkRecord retrieved from iCloud.
    public func setReturningClient(from record: CKRecord) {
        if let name = record.object(forKey: "name") as? String {
            let processedName = processFullName(name: name)
            self.Bio["First Name"] = processedName.0
            self.Bio["Last Name"] = processedName.1
        }
        self.Bio["Birthdate"] = record.object(forKey: "birth") as? String
        self.birthdate = record.object(forKey: "birthdate") as! Date
        // self.Bio["age"] is set dynamicaly when birthdate var is set.
        self.Bio["Gender"] = record.object(forKey: "gender") as? String
        self.Bio["Street Address"] = record.object(forKey: "streetAddress") as? String
        self.Bio["City"] = record.object(forKey: "city") as? String
        self.Bio["State"] = record.object(forKey: "state") as? String
        self.Bio["Zip Code"] = record.object(forKey: "zip") as? String
        self.Bio["Phone Number"] = record.object(forKey: "phone") as? String
    }
    
    
    /// Returns a string of the client's basic info with linebreaks. Mainly used for PDF compilation.
    public func getClientInfo() -> String {
        var info = name + "\n"
        info += fullAddress + "\n"
        info += phoneNumber + "\n"
        info += birthdateString + "\n"
        info += gender
        return info
    }
    
    
    /// Returns the client's current procedure info. Manily used for PDF compilation.
    public func getProcedureInfo() -> String {
        var info = "Date: \(procedureDate)\n"
        info += "Lot #: \(sterilizationLotNumber)\n"
        info += "Artist: \(artistName)\n"
        
        if Client.tattooORpiercing {
            info += "Tattoo: " + descriptionOfTattoo + "\n"
            info += "Placement: " + placementOfTattoo + "\n"
        } else {
            info += "Piercing: " + typeOfPiercing + "\n"
        }
        
        info += "Price: $\(price ?? "n/a")"
        
        return info
    }
    
    
    //    public enum TypeOfImages {
    //        case IDs
    //        case signatures
    //    }
        
        /// Saves the ID and Signature images to the Documents Directory on the device. This is essential for the URL path of the image for the PDF creation.
        ///
        /// - Parameter imageType: The type of images to be saved. (TypeOfImages enum)
    //    public func saveImagesToDocumentsDirectory(for imageType: TypeOfImages) {
    //        switch imageType {
    //        case .IDs:
    //            for (count,image) in IDImages.enumerated() {
    //                let nameForFile = "/" + name.replacingOccurrences(of: " ", with: "_")
    //                let fileName = ImagesKeys.IDImageJPG + nameForFile + "_\(count).jpg"
    //                let defaultsKey = UDKeys.UDIDImageURLPath + nameForFile + "_\(count)"
    ////                saveImageToDocumentsDirectory(image: image, fileName: fileName, defaulsKey: defaultsKey)
    ////                imageFilenamesAndKeys.updateValue(fileName, forKey: defaultsKey)
    //            }
    //
    //        case .signatures:
    //            for (count,image) in signatureImages.enumerated() {
    //                let nameForFile = "/" + name.replacingOccurrences(of: " ", with: "_")
    //                let fileName = ImagesKeys.SignatureJPG + nameForFile + "_\(count).jpg"
    //                let defaultsKey = UDKeys.UDSignatureImageURLPath + nameForFile + "_\(count)"
    ////                saveImageToDocumentsDirectory(image: image, fileName: fileName, defaulsKey: defaultsKey)
    ////                imageFilenamesAndKeys.updateValue(fileName, forKey: defaultsKey)
    //            }
    //        }
    //    }
    
    
    
    

    // ********************************************************************
    // MARK: - Debugging
    
    /// A debugging string
    internal override var description: String { return " Bio - \(Bio), \(emailAddress ?? "")), Studio - \(Studio), Health - \(Health), Legal - \(Legal),  - Lot: \(sterilizationLotNumber) - Notes: \(additionalNotes) - Tattoo Or Piercing: \(String(describing: tattooORpiercing)) - Returning Client: \(String(describing: returningClient)) - Minor: \(isOver18))"
    }
    
    
    
}

