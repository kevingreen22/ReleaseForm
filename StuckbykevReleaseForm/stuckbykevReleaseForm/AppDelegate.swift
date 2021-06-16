//
//  AppDelegate.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 8/20/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import Network
//import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NetworkCheckObserver {
    
    /// Sets the status of the network connection to a global variable.
    func statusDidChange(status: NWPath.Status) {
        switch status {
        case .satisfied:
            isNetworkActive = true
        case .unsatisfied:
            isNetworkActive = false
        case .requiresConnection:
            isNetworkActive = false
        default:
            isNetworkActive = false
        }
    }
    
    
    // MARK: - Instance Variables
    
    var window: UIWindow?
    private let sb = UIStoryboard(name: "Main", bundle: nil)
    var delegate: WriteSettingsInfoBack?
    private let userDefaults = UserDefaults.standard
    var networkCheck = NetworkCheck.sharedInstance()
    
    
    // MARK: - Application Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // enables automatic keyboard/textfield adjustments.
        IQKeyboardManager.shared.enable = true
        
        networkCheck.addObserver(observer: self)
        
        // Checks for a studio model in user defaults, and if not runs the setup vc.
        // Sets Studio singleton to the UD saved StudioModel.
        if let studio = getStudioModelFromUserDefaults() {
            Studio = studio
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            guard let setupVC = sb.instantiateViewController(withIdentifier: "Setup VC") as? SetupShopInfoVC else { return false }
            self.window?.rootViewController = setupVC
            self.window?.makeKeyAndVisible()
        }
        
        
        // Checks for iCloud Drive folder/directory is present, if not creates a folder/directory. For saving form pdf's.
        if let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            if !FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: nil) {
                do {
                    try FileManager.default.createDirectory(at: iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error creating dir in iCloudDrive: \(error)") // debugging
                }
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        networkCheck.removeObserver(observer: self)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        networkCheck.addObserver(observer: self)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        // Ensure the URL is a file URL
//        guard inputURL.isFileURL else { return false }
//
//        // Reveal / import the document at the URL
//        guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController else { return false }
//
//        documentBrowserViewController.revealDocument(at: inputURL, importIfNeeded: true) { (revealedDocumentURL, error) in
//            if let error = error {
//                // Handle the error appropriately
//                print("Failed to reveal the document at URL \(inputURL) with error: '\(error)'")
//                return
//            }
//
//            // Present the Document View Controller for the revealed URL
//            documentBrowserViewController.presentDocument(at: revealedDocumentURL!)
//        }
//
//        return true
//    }

    
    
    // MARK: Custom AppDelegate Methods
        
    /// Sets a global reference variable to the AppDelegate file.
    class func getAppDelegate() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    /// The documents directory.
    ///
    /// - Returns: Returns a string containing the apps documents directory.
    func getDocDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
  
  
    
    
}

