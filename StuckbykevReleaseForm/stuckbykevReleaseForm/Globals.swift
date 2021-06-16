//
//  Globals.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/23/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import Foundation
import UIKit
//import SCLAlertView
import Network
import Photos

var Client = ClientModel()

// *********** SINGELTONS *************
var Studio = StudioModel() { didSet { NotificationCenter.default.post(name: .studioDataChanged, object: nil) } }
var Queue = [ClientModel]() { didSet { NotificationCenter.default.post(name: .queueDataChanged, object: nil) } }
// ************************************



//***************************************************************
// MARK: - Global Insatance Variables
//***************************************************************

var appDelegate = AppDelegate()
let docDir = appDelegate.getDocDir()
var isNetworkActive: Bool = NetworkCheck.sharedInstance().currentStatus == .satisfied ? true : false


public let defaultHealthClauseDict: [String:Int] = ["Diabetes".localized():2,"Heart Condition".localized():2,"Blood Thinners".localized():2,"Fainting".localized():2,"Heavy Bleeding".localized():2,"Herpes".localized():2,"Eczema/Psoriasis".localized():2,"Hepatitis B/C".localized():2,"Tuberculosis".localized():2,"Pregnant/Nursing".localized():2,"Scarring/Keloiding".localized():2,"Animic(thin blood)".localized():2,"Skin Conditions".localized():2,"Epiliepsy".localized():2,"Latex Allergy".localized():2,"Eaten in last 4 hours".localized():2,"Mitral Valve Prolape".localized():2,"Antibiotics Before Dental Work".localized():2,"Other Communicable Disease".localized():2]


public let defaultLegalDict: [String:Int] = [
    "I have truthfully represented to YOUR STUDIO NAME that I am eighteen(18) years of age or older.".localized():2,
    
    "I acknowledge that it is not reasonably possible for the representatives and employees of YOUR STUDIO NAME to determine whether I might have and allergic reaction to any metals, inks or materials used during the procedure, and I agree to accept the risk that such a reactions is possible.".localized():2,
    
    "I acknowledge that I have advised my artist of any conditions that might affect the healing of this Tattoo/Piercing. I do not have any medical or skin conditions such as but not limited to: acne, scarring, eczema, psoriasis, freckles, moles, or sunburn in the area to be Tattooed/Pierced that may interfere with said Tattoo/Piercing. If I have any infection or rash anywhere on my body, I will advise the artist.".localized():2,
    
    "I am NOT pregnant or nursing.".localized():2,
    
    "I am NOT under the influence of alcohol or drugs.".localized():2,
    
    "I acknowledge that infection is always possible when obtaining a Tattoo/Piercing, particularly in the event that I do not take proper care of my Tattoo/Piercing. I have received aftercare instructions and I agree to follow them while my Tattoo/Piercing is healing.".localized():2,
    
    "I acknowledge that a Tattoo/Piercing is a permanent chance to my appearance. To my knowledge, I do NOT have physical, mental or medical impairment or disability which might affect my well being as a direct or indirect result of my decision to have a Tattoo/Piercing.".localized():2,
    
    "I acknowledge the decision for obtaining my Tattoo/Piercing is my own free will and choice. I consent to the location of the Tattoo/Piercing and performance of the Tattoo/Piercing procedure.".localized():2,
    
    "I acknowledge and agree to following any and all instructions given to me regarding the maintenance of a sanitary environment while I am being Tattooed/Pierced.".localized():2,
    
    "I agree to IMMEDIATELY notify my artist if I feel lightheaded, dizzy, and/or faint before, during or after the procedure. Failure to do so releases YOUR STUDIO NAME and the artists of all responsibility.".localized():2
]



// MARK: - SCLAlertView

/// Sets the SCLAlertView's appearance for use throughout the app.
public let alertAppearance = SCLAlertView.SCLAppearance(
    kWindowWidth: 400,
    kWindowHeight: 600,
    kTitleFont: UIFont(name: "HelveticaNeue", size: 26)!,
    kTextFont: UIFont(name: "HelveticaNeue", size: 19)!,
    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 19)!,
    showCloseButton: false
)



//***************************************************************
// MARK: - Global Methods
//***************************************************************

// MARK: - Public Studio Methods

/// Returns the StudioModel saved withing user defaults. May not reflect the most current data saved in the cloud.
func getStudioModelFromUserDefaults() -> StudioModel? {
    let ud = UserDefaults.standard
    guard let decodedStudio = ud.data(forKey: "Studio Model")  else { return nil }
    do {
        let decodedStudioModel = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedStudio) as? StudioModel
        return decodedStudioModel
    } catch {
        print("Error unarchiving StudioModel from User Defaults: Globals.swift")
        return nil
    }
}



// MARK: - Global Queue Methods

func updateClientInQueue(with client: ClientModel, at index: Int, viewController: UIViewController?) {
    Queue[index] = client
    iCloud.uploadQueueToCloud(queue: Queue, viewController: viewController, completion: nil)
}




// MARK: Misc Methods

/// Checks photo library permissions.
func checkPermission() {
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    switch photoAuthorizationStatus {
    case .authorized: print("Photo library access is granted by user")
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization({ (newStatus) in
            print("Photo library status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {
                /* do stuff here */
                print("success")
            }
        })
        print("It is not determined until now")
    case .restricted: print("User do not have access to photo library.")
    case .denied: print("User has denied the permission to photo library.")
    @unknown default:
        fatalError()
    }
}

/// Checks if iCloud is signed in or not.
///
/// - Returns: True if iCloud is signed in, false otherwise.
public func isiCloudSignedin() -> Bool {
    if FileManager.default.ubiquityIdentityToken != nil {
//        print("iCloud available")  // debugging
        return true
    }
    else {
//        print("iCloud NOT available")  // debugging
        return false
    }
}


/// Validates an email address for corectness syntactically.
///
/// - Parameter email: The email address to validate as a string.
/// - Returns: True if the email gets validated, false otherwise.
func isValidEmail(email: String?) -> Bool {
    guard let _email = email else { return false }
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    print("Validating email - \(String(describing: email)): \(emailTest.evaluate(with: _email.replacingOccurrences(of: " ", with: "")))") // debugging
    return emailTest.evaluate(with: _email.replacingOccurrences(of: " ", with: ""))
}





//***************************************************************
// MARK: - Image/Photo Methods
//***************************************************************

/// This method saves an image to the Documents Dir, and also saves the URL path of that image to the UserDefaults. For use in the PDF Form Composer
///
/// - Parameters:
///   - image: The image to be saved locally.
///   - fileName: The filename of the image.
///   - defaulsKey: The user default key for the image.
//func saveImageToDocumentsDirectory(image: UIImage, fileName: String, defaulsKey: String) {
//    // creates a directory for image to be saved in Documents Dir
//    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//
//    // create a name for your image
//    let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
//    do {
//        // writes image to documents directory
//        try image.jpegData(compressionQuality: 1.0)?.write(to: fileURL, options: .atomic)
//        print("IMAGE URL: \(fileURL)") // debugging
//
//        // saves the image URL Path to User Defaults. FormComposer uses to load image to PDF
//        UserDefaults.standard.set(fileURL.path, forKey: defaulsKey)
//        print("Image saved Successfully") // debugging
//    } catch {
//        print("Image save error: \(error)") // debugging
//    }
//}

/// Gets the image's path and file name from the Documents Directory.
///
/// - Parameter fileName: The filename of the image.
/// - Returns: A string containing the directory in which the image is saved locally.
//func getPathofImageSavedInDocumentsDirectory(fileName: String) -> String? {
//    var imagePath: String?
//    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//    if let dirPath = paths.first {
//        imagePath = dirPath.appending("/\(fileName)")
//    }
//    return imagePath
//}

/// Removes the ClientModel specified images from the Documents Directory.
///
/// - Parameters:
///   - client: The client model that contains the images to be removed.
//func removeImagesFromDocumentsDirectory(_ client: ClientModel) {
//    let fileManager = FileManager.default
//    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//    if let dirPath = paths.first {
//        for (fileName,key) in client.imageFilenamesAndKeys {
//            let imagePath = dirPath.appending("/\(fileName)")
//            do {
//                try fileManager.removeItem(atPath: imagePath)
//                UserDefaults.standard.removeObject(forKey: key)
//                print("Image removed from local directory: \(imagePath)") // debugging
//            } catch let error {
//                print("Error removing image from local directory: \(error.localizedDescription)") // debugging
//            }
//        }
//    }
//}




//***************************************************************
// MARK: - Extensions
//***************************************************************


// MARK: - UIButton

extension UIButton {
    
    /// Sets a shadow on a UIButton. Preserves corner radius.
    ///
    /// - Parameters:
    ///   - shadowColor: The color of the shadow. Default is black.
    ///   - shadowOffset: The offset of the shadow. Default is -1, 5.
    ///   - shadowOpacity: The opacity of the shadow. Default is 0.5.
    ///   - shadowRadius: The radius of the shadow. Default is 10.
    ///   - scale: If you don't pass any parameter to this function, then the scale argument will be true by default.
    /// layer.shouldRasterize = true will make the shadow static and cause a shadow for the initial state of the UIView. So I would recommend not to use layer.shouldRasterize = true in dynamic layouts like view inside a UITableViewCell.
    func setDropShadowOnButton(with color: UIColor = UIColor.black, offset: CGSize = CGSize(width: -1.0, height: 5.0), opacity: Float = 0.5, radius: CGFloat = 10 /*, shouldRasterize: Bool = true, scale: Bool = true*/) {
        
        let cornerRadius = self.layer.cornerRadius
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        layer.shouldRasterize = shouldRasterize
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

extension UILabel {

    /// Sets a shadow on a UILabel. Preserves corner radius.
    ///
    /// - Parameters:
    ///   - shadowColor: The color of the shadow. Default is black.
    ///   - shadowOffset: The offset of the shadow. Default is -1, 5.
    ///   - shadowOpacity: The opacity of the shadow. Default is 0.5.
    ///   - shadowRadius: The radius of the shadow. Default is 10.
    ///   - scale: If you don't pass any parameter to this function, then the scale argument will be true by default.
    /// layer.shouldRasterize = true will make the shadow static and cause a shadow for the initial state of the UIView. So I would recommend not to use layer.shouldRasterize = true in dynamic layouts like view inside a UITableViewCell.
    func setDropShadowOnLabel(with color: UIColor = UIColor.black, offset: CGSize = CGSize(width: -1.0, height: 5.0), opacity: Float = 0.5, radius: CGFloat = 10 /*, shouldRasterize: Bool = true, scale: Bool = true*/) {
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        shadowLayer.masksToBounds = false

//        layer.shouldRasterize = shouldRasterize
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1

        self.layer.addSublayer(shadowLayer)

        self.layoutSubviews()
    }
}




// MARK: UIView

extension UIView {
    
    /// Sets a shadow on a UIView. Preserves corner radius
    ///
    /// - Parameters:
    ///   - color: The shadow color. Default is black
    ///   - opacity: The shadow opacity. Default is 0.5
    ///   - offSet: The shadow offset. Default is CGSize(width: -1.0, height: 5.0)
    ///   - radius: The shadow radius. Default is 10
    ///   - scale: If you don't pass any parameter to this function, then the scale argument will be true by default.
    /// layer.shouldRasterize = true will make the shadow static and cause a shadow for the initial state of the UIView. So I would recommend not to use layer.shouldRasterize = true in dynamic layouts like view inside a UITableViewCell.
    func setDropShadow(with color: UIColor = UIColor.black, opacity: Float = 0.5, offSet: CGSize = CGSize(width: -1.0, height: 5.0), radius: CGFloat = 10, shouldRasterize: Bool = true, scale: Bool = true) {
        
        let cornerRadius = self.layer.cornerRadius
        self.layer.cornerRadius = cornerRadius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.masksToBounds = false

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = shouldRasterize
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
 
}


// MARK: UIColor

extension UIColor {
    
    /// Color of placeholder text.
    class func greyPlaceholderColor() -> UIColor {
        return UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    }
    
    /// Color of UIButton border.
    class func buttonBorderColor() -> UIColor {
        return UIColor(red:0.74, green:0.71, blue:0.71, alpha:1.0)
    }
    
    /// Color of UIBarButtonBadge green.
    class func badgeGreenColor() -> UIColor {
        return UIColor(red:0.07, green:0.51, blue:0.19, alpha:1.0)
    }
    
    /// Color of UIBarButtonBadge red.
    class func badgeRedColor() -> UIColor {
        return UIColor.red
    }
    
    
}





// MARK: Date

extension Date {
    
    /// DateFormatter() has 5 format style options for each of Date and Time. These are:
    /// .none .short .medium .long .full
    
    /// DATE      TIME     DATE/TIME STRING
    /// "none"    "none"
    /// "none"    "short"   9:42 AM
    /// "none"    "medium"  9:42:27 AM
    /// "none"    "long"    9:42:27 AM EDT
    /// "none"    "full"    9:42:27 AM Eastern Daylight Time
    /// "short"   "none"    10/10/17
    /// "short"   "short"   10/10/17, 9:42 AM
    /// "short"   "medium"  10/10/17, 9:42:27 AM
    /// "short"   "long"    10/10/17, 9:42:27 AM EDT
    /// "short"   "full"    10/10/17, 9:42:27 AM Eastern Daylight Time
    /// "medium"  "none"    Oct 10, 2017
    /// "medium"  "short"   Oct 10, 2017, 9:42 AM
    /// "medium"  "medium"  Oct 10, 2017, 9:42:27 AM
    /// "medium"  "long"    Oct 10, 2017, 9:42:27 AM EDT
    /// "medium"  "full"    Oct 10, 2017, 9:42:27 AM Eastern Daylight Time
    /// "long"    "none"    October 10, 2017
    /// "long"    "short"   October 10, 2017 at 9:42 AM
    /// "long"    "medium"  October 10, 2017 at 9:42:27 AM
    /// "long"    "long"    October 10, 2017 at 9:42:27 AM EDT
    /// "long"    "full"    October 10, 2017 at 9:42:27 AM Eastern Daylight Time
    /// "full"    "none"    Tuesday, October 10, 2017
    /// "full"    "short"   Tuesday, October 10, 2017 at 9:42 AM
    /// "full"    "medium"  Tuesday, October 10, 2017 at 9:42:27 AM
    /// "full"    "long"    Tuesday, October 10, 2017 at 9:42:27 AM EDT
    /// "full"    "full"    Tuesday, October 10, 2017 at 9:42:27 AM Eastern Daylight Time
    ///
    /// Swift 4 - OCT. 2017
    ///
    /// - Parameters:
    ///   - dateStyle: The style of date to use. Default is medium.
    ///   - timeStyle: The style of time to use. Default is none.
    /// - Returns: The date formatted as a string.
    func myDateFormatted(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none) -> String {
        let dfs = DateFormatter()
        dfs.dateStyle = dateStyle
        dfs.timeStyle = timeStyle
        return dfs.string(from: self)
    }
}




public extension CAGradientLayer {
    
    /// Sets the start and end points on a gradient layer for a given angle.
    ///
    /// - Important:
    /// *0°* is a horizontal gradient from left to right.
    ///
    /// With a positive input, the rotational direction is clockwise.
    ///
    ///    * An input of *400°* will have the same output as an input of *40°*
    ///
    /// With a negative input, the rotational direction is clockwise.
    ///
    ///    * An input of *-15°* will have the same output as *345°*
    ///
    /// - Parameters:
    ///     - angle: The angle of the gradient.
    ///
    func calculatePoints(for angle: CGFloat) {
        
        
        var ang = (-angle).truncatingRemainder(dividingBy: 360)
        
        if ang < 0 { ang = 360 + ang }
        
        let n: CGFloat = 0.5
        
        switch ang {
            
        case 0...45, 315...360:
            let a = CGPoint(x: 0, y: n * tanx(ang) + n)
            let b = CGPoint(x: 1, y: n * tanx(-ang) + n)
            startPoint = a
            endPoint = b
            
        case 45...135:
            let a = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            let b = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            startPoint = a
            endPoint = b
            
        case 135...225:
            let a = CGPoint(x: 1, y: n * tanx(-ang) + n)
            let b = CGPoint(x: 0, y: n * tanx(ang) + n)
            startPoint = a
            endPoint = b
            
        case 225...315:
            let a = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            let b = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            startPoint = a
            endPoint = b
            
        default:
            let a = CGPoint(x: 0, y: n)
            let b = CGPoint(x: 1, y: n)
            startPoint = a
            endPoint = b
            
        }
    }
    
    /// Private function to aid with the math when calculating the gradient angle
    private func tanx(_ 𝜽: CGFloat) -> CGFloat {
        return tan(𝜽 * CGFloat.pi / 180)
    }
    
    
    // Overloads
    
    /// Sets the start and end points on a gradient layer for a given angle.
    func calculatePoints(for angle: Int) {
        calculatePoints(for: CGFloat(angle))
    }
    
    /// Sets the start and end points on a gradient layer for a given angle.
    func calculatePoints(for angle: Float) {
        calculatePoints(for: CGFloat(angle))
    }
    
    /// Sets the start and end points on a gradient layer for a given angle.
    func calculatePoints(for angle: Double) {
        calculatePoints(for: CGFloat(angle))
    }
    
}

