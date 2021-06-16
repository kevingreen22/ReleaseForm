//
//  Identifiers.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 12/31/18.
//  Copyright © 2018 Kevin Green. All rights reserved.
//

import Foundation
import NotificationCenter

let appFeedbackEmails = ["stuckbykev@gmail.com"]


extension Notification.Name {
    static let queueDataChanged = Notification.Name("queueDataChanged")
    static let studioDataChanged = Notification.Name("studioDataChanged")
}


/// Global UserDefault Keys
struct UDKeys {
    static let UDSettingsSet = "Settings Set"
    static let UDMasterPasscode = "Master Passcode"
    static let UDArtistPasscode = "Artist Passcode"
    
    static let UDStudioName = "Studio Name"
    static let UDStudioAddress = "Studio Address"
    static let UDStudioPhoneNum = "Studio Phone Number"
    static let UDStudioWebsite = "Studio Website"
    static let UDStudioEmail = "Studio Email"
    static let UDAllowUnder18Tattoos = "Allow Under 18 Tattoos"
    static let UDRequireLotNums = "Require Lot Numbers"
    
    static let UDArtistArray = "Artist Array"
    static let UDArtistPhotoArray = "Artist Photo Array"
    static let UDLegaleseArray = "Legalese Array"
    static let UDLegaleseIntArray = "Legalese Int Array"
    static let UDHealthClauseArray = "Health Clause Array"
    static let UDHealthClauseIntArray = "Health Clause Int Array"
    static let UDCloudService = "Cloud Service"
    static let UDQueue = "Saved Clients Queue Key"
    static let UDBackgroundColor = "Background Color"
    static let UDLogoImage =  "Logo Image"
    static let UDLogoImageURLPath = "Logo Image URL Path"
    static let UDIDImageURLPath = "ID Image URL Path"
//    static let UDMinorIDImageURLPath = "Minor ID Image URL Path"
    static let UDSignatureImageURLPath = "Signature Image URL Path"
    static let UDSignature2ImageURLPath = "Signature Image 2 URL Path"
    static let UDiCloudSignedIn = "iCloud Signed In"
}

/// Used for CloudRail Service
//struct CLRLService {
//    static let CurrentCloudService = "Current Cloud Service" // use this to set "typeOfService" var accordingly
//    static let SBKFolderPath = "/Release_Form_by_SBK"
//    static let ClientsFolderPath = "/Release_Form_by_SBK/clients"
//    static let StudioFolderPath = "/Release_Form_by_SBK/studio"
//    static let credentialsPath = "/Release_Form_by_SBK/studio/studioCredentials.data"
//    static let logoPath = "/Release_Form_by_SBK/studio/studioLogo.jpg"
//    static let queuePath = "/Release_Form_by_SBK/studio/queue.data"
//}

/// JPG Images Keys
struct ImagesKeys {
    static let StudioLogoJPG = "studioLogo.jpg"
    static let IDImageJPG = "IDImage" // .jpg is added in saveImageToDocumentsDirectory(imageType)
    static let SignatureJPG = "SignatureImage" // .jpg is added in saveImageToDocumentsDirectory(imageType)
    static let DefaultArtistPhoto = "default artist photo"
    static let NoBackgroundColorPlaceholder = "no background color placeholder"
    static let NoLogoImageHolder = "no logo image holder.jpg"
}

/// View Controller Identifiers
struct VCIdentifiers {
    static let LaunchScreenVC = "Launch Screen VC"
    static let SetupVC = "Setup VC"
    static let MainVC = "Main VC"
    static let PasscodeVC = "Passcode VC"
    static let CloudHelpVC = "Cloud Help VC"
    static let BirthdayPasswordVC = "Birthday Password VC"
    static let LanguageChooserTVC = "Language Chooser TVC"
//    static let TattooPiercing18VC = "Tattoo Piercing 18 VC"
    static let TakePictureNC = "Take Picture NC"
    static let TakePictureVC = "Take Picture VC"
    static let RootPageVC = "Root Page VC"
    static let AllDoneVC = "All Done VC"
    static let QueueNC = "Queue NC"
    static let ClientQueueCVC = "Client Queue CVC"
    static let ClientQueueDetailVC = "Client Queue Detail VC"
    static let PreviewVC = "Preview VC"
    static let SettingsNC = "Settings NC"
    static let SettingsTVC = "Settings TVC"
    static let AddDeleteArtistVC = "Add Delete Artist VC"
    static let SetPasscodeVC = "Set Passcode VC"
    static let BackgroundColorVC = "Background Color VC"
    static let LogoVC = "Logo VC"
    static let LegaleseVC = "Legalese VC"
    static let HealthClauseVC = "Health Clause VC"
    static let AddLegalClauseVC = "Add Legal Clause VC"
    static let AddHealthClauseVC = "Add Health Clause VC"
    static let PrivacyPolicyVC = "Privacy Policy VC"
    static let DatePickerVC = "Date Picker VC"
    static let StatePickerVC = "State Picker VC"
    static let ArtistPickerVC = "Artist Picker VC"
    static let PiercingPickerVC = "Piercing Picker VC"
    static let PlacementPickerVC = "Placement Picker VC"
    static let DocumentBrowserVC = "Document Browser VC"
    static let DocumentVC = "Document VC"
}

/// Segue Identifiers
struct SegueIDs {
    static let MainNavConSegue = "MainNavCon Segue"
    static let LanguageSegue = "Language Segue"
    static let BirthdayPasswordSegue = "Birthday Password Segue"
    static let ShopInfoViewSegue = "Shop Info View Segue"
//    static let TattooPiercing18Segue = "Tattoo Piercing 18 Segue"
    static let TakePictureSegue = "Take Picture Segue"
    static let FormSegue = "Form Segue"
    static let SelectBirthdateSegue = "Select Birthdate Segue"
    static let SelectStateSegue = "Select State Segue"
    static let SelectArtistSegue = "Select Artist Segue"
    static let SelectPiercingPlacementSegue = "Select Piercing Placement Segue"
    static let SelectTattooPlacementSegue = "Select Tattoo Placement Segue"
    static let PasscodeToQueueSegue = "Passcode To Queue Segue"
    static let PreviewSegue = "Preview Segue"
    static let PasscodeToSettingsSegue = "Passcode To Settings Segue"
    static let DocumentBrowserSegue = "Show Document Browser Segue"
    static let AddDeleteArtistSegue = "Add Delete Artist Segue"
    static let SetMasterPasscodeSegue = "Set Master Passcode Segue"
    static let SetArtistPasscodeSegue = "Set Artist Passcode Segue"
    static let SetBackgroundColorSegue = "Set Background Color Segue"
    static let SetStudioLogoSegue = "Set Studio Logo Segue"
    static let EditLegaleseSegue = "Edit Legalese Segue"
    static let EditHealthClauseSegue = "Edit Health Clause Segue"
    static let AddLegalClauseSegue = "Add Legal Clause Segue"
    static let AddHealthClauseSegue = "Add Health Clause Segue"
    static let PrivacyPolicySegue = "Privacy Policy Segue"
    static let HelpSegue = "Help Segue"
    static let unwindToMainSegue = "Unwind To Main VC"
    static let unwindToQueueVCSegue = "Unwind To Queue VC"
    static let AllDoneSegue = "All Done Segue"
}

