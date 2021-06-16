//
//  iCloud.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/26/17.
//  Copyright © 2017 Kevin Green. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
import Network

/// Put the CloudKit shared database in a constant
let publicDatabase = CKContainer.default().publicCloudDatabase

class iCloud {
    
    static let backgroundQueue = DispatchQueue(label: "com.stuckbykev.cloud", qos: .background, target: nil)
    
    struct RecordTypes {
        static let queue = "Queue"
        static let studioInfo = "StudioInfo"
        static let client = "Client"
    }
    
    struct Assets {
        static let queue = "QueueListAsset"
        static let studioModel = "StudioModel"
        static let client = "ClientAsset"
    }
  
    //***************************************************************
    // MARK: - Queue methods
    //***************************************************************
    
    /// Downloads only the queue.data file from iCloud and assignes it to the singleton Queue (declared in Globals.swift).
    ///
    /// - Parameters:
    ///   - view: The view controller calling this method. For error alerting only.
    ///   - completion: An optional error completion.
    class func retrieveQueueFromCloud(viewController: UIViewController?, completion: ((_ error: Error?) -> Void)?) {
        backgroundQueue.async {
            if isNetworkActive && isiCloudSignedin() {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
                let predicate = NSPredicate(value: true)
                let query = CKQuery(recordType: RecordTypes.queue, predicate: predicate)
                
                publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
                    if error == nil, let record = results?.first {
                        if let asset = record.object(forKey: Assets.queue) as? CKAsset {
                            do {
                                let modelData = try Data(contentsOf: (asset.fileURL!))
                                let model = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(modelData) as? [ClientModel]
                                print("Queue retireved/set.") // debugging
                                Queue = model!
                                completion?(error)
                            } catch {
                                print("Error unarchiving asset data") // debugging
                                guard let viewController = viewController else { completion?(error); return }
                                Alerts.myAlert(title: "Error", message: "Error unarchiving asset data.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                completion?(error)
                            }
                        } else {
                            print("Could NOT create CKAsset from CKRecord") // debugging
                            guard let viewController = viewController else { completion?(error); return }
                            Alerts.myAlert(title: "Error", message: "Error creating asset.", error: nil, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                            completion?(error)
                        }
                    } else if let error = error {
                        print("Error querying Queue") // debugging
                        guard let viewController = viewController else { completion?(error); return }
                        handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                            if !ckerrorWasHandled {
                                Alerts.myAlert(title: "Error", message: "Error querying Queue", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                completion?(error)
                            }
                        })
                    } else {
                        print("No queue in iCloud.") // debugging
                        Queue = [ClientModel]()
                        completion?(error)
                    }
                    
                    DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
                })
            } else {
                guard let viewController = viewController else { return }
                Alerts.iCloudSignedInError(viewController: viewController)
                completion?(nil)
            }
        }
    }
    
        
    /// Uploads only the queue.data file to the iCloud. The reason this is stored in the cloud is for the use of multiple devices and/or companion app ability to all have access to a current list of clients in the queue.
    ///
    /// - Parameters:
    ///   - queue: A [ClientModel] object to save to iCloud.
    ///   - completion: An optional error completion.
    class func uploadQueueToCloud(queue: [ClientModel], viewController: UIViewController?, completion: ((_ error: Error?) -> Void)?) {
        backgroundQueue.async {
            if isNetworkActive && isiCloudSignedin() {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
                var idsToDelete: [CKRecord.ID]?
                let record = CKRecord(recordType: RecordTypes.queue)
                let asset = createAsset(anyData: queue)
                record.setObject(asset, forKey: Assets.queue)
                
                let predicate = NSPredicate(value: true)
                let query = CKQuery(recordType: RecordTypes.queue, predicate: predicate)
                publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
                    if error == nil, let record = results?.first {
                        idsToDelete = [record.recordID]
                    } else if let error = error {
                        print("Error uploading queue") // debugging
                        guard let viewController = viewController else { completion?(error); return }
                        handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                            if !ckerrorWasHandled {
                                Alerts.myAlert(title: "Error", message: "Error uploading queue.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                completion?(error)
                            }
                        })
                    }
                    
                    let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: idsToDelete)
                    let timeoutIntervals = CKOperation.Configuration()
                    timeoutIntervals.timeoutIntervalForRequest = 10
                    timeoutIntervals.timeoutIntervalForResource = 10
                    modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
                        if error == nil {
                            print("iCloud upload queue succeeded") // debugging
                            Queue = queue
                            completion?(error)
                        } else if let error = error {
                            guard let viewController = viewController else { completion?(error); return }
                            handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                                if !ckerrorWasHandled {
                                    Alerts.myAlert(title: "Error", message: "Error uploading queue.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                    completion?(error)
                                }
                            })
                        }
                        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
                    }
                    publicDatabase.add(modifyRecordsOperation)
                })
            } else {
                guard let viewController = viewController else { return }
                Alerts.iCloudSignedInError(viewController: viewController) }
        }
    }
    
    
    
    //***************************************************************
    // MARK: - Studio methods
    //***************************************************************
    
    /// Queries iCloud for the StudioModel and assignes it to the singleton Studio (declared in Globals.swift).
    ///
    /// - Parameters:
    ///   - view: The view controller calling this method. For error alerting only.
    ///   - completion: An optional error completion.
    class func retrieveStudioModelFromCloud(viewController: UIViewController?, completion: ((_ error: Error?) -> Void)?) {
        backgroundQueue.async {
            if isNetworkActive && isiCloudSignedin() {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
                let predicate = NSPredicate(value: true)
                let query = CKQuery(recordType: RecordTypes.studioInfo, predicate: predicate)
                
                publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
                    if error == nil, let record = results?.first {
                        if let asset = record.object(forKey: Assets.studioModel) as? CKAsset {
                            do {
                                let modelData = try Data(contentsOf: (asset.fileURL!))
                                let model = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(modelData) as? StudioModel
                                print("StudioModel Retrieved.") // debugging
                                Studio = model!
                                Studio.recordID = record.recordID
                                StudioModel.storeStudioIntoUserDefaults()
                                completion?(error)
                            } catch {
                                print("Error unarchiving asset data") // debugging
                                guard let viewController = viewController else { completion?(error); return }
                                Alerts.myAlert(title: "Error", message: "Error unarchiving asset data.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                completion?(error)
                            }
                        } else {
                            print("Could NOT create CKAsset from CKRecord") // debugging
                            guard let viewController = viewController else { completion?(error); return }
                            Alerts.myAlert(title: "Error", message: "Error creating asset.", error: nil, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                            completion?(error)
                        }
                    } else if let error = error {
                        print("Error querying StudioModel") // debugging
                        guard let viewController = viewController else { completion?(error); return }
                        handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                            if !ckerrorWasHandled {
                                Alerts.myAlert(title: "Error", message: "Error querying Studio info.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                completion?(error)
                            }
                        })
                    } else {
                        print("No StudioModel in iCloud.") // debugging
                        completion?(error)
                    }
                    
                    DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
                })
            } else {
                guard let viewController = viewController else { return }
                Alerts.iCloudSignedInError(viewController: viewController) }
        }
    }
    
    
    
    /// Uploads the Studio variable to iCloud. The reason this is stored in the cloud is for the use of multiple devices and/or companion app ability to all be the same studio's info.
    ///
    /// - Parameters:
    ///   - studioModel: The StudioModel class to save to the cloud.
    ///   - viewController: The view controller calling this method. For error alerting only.
    ///   - completion: An optional error completion.
    class func uploadStudioModel(studioModel: StudioModel, viewController: UIViewController?, completion: ((_ error: Error?) -> Void)?) {
        backgroundQueue.async {
            if isNetworkActive && isiCloudSignedin() {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
                var idsToDelete: [CKRecord.ID]?
                let record = CKRecord(recordType: RecordTypes.studioInfo)
                let asset = createAsset(anyData: studioModel)
                record.setObject(asset, forKey:Assets.studioModel)
                
                let predicate = NSPredicate(value: true)
                let query = CKQuery(recordType:RecordTypes.studioInfo, predicate: predicate)
                
                publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
                    if error == nil, let record = results?.first {
                        idsToDelete = [record.recordID]
                    } else if let error = error {
                        print("Error uploading studio info") // debugging
                        guard let viewController = viewController else { completion?(error); return }
                        handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                            if !ckerrorWasHandled {
                                Alerts.myAlert(title: "Error", message: "Error uploading studio info.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                completion?(error)
                            }
                        })
                    }
                    
                    let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: idsToDelete)
                    let timeoutIntervals = CKOperation.Configuration()
                    timeoutIntervals.timeoutIntervalForRequest = 10
                    timeoutIntervals.timeoutIntervalForResource = 10
                    modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
                        if error == nil {
                            print("iCloud upload studio model succeeded") // debugging
                            Studio = studioModel
                            completion?(error)
                        } else if let error = error {
                            print("Error uploading studio info") // debugging
                            guard let viewController = viewController else { completion?(error); return }
                            handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                                if !ckerrorWasHandled {
                                    Alerts.myAlert(title: "Error", message: "Error uploading studio info.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                    completion?(error)
                                }
                            })
                        }
                        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
                    }
                    publicDatabase.add(modifyRecordsOperation)
                })
            } else {
                guard let viewController = viewController else { return }
                Alerts.iCloudSignedInError(viewController: viewController) }
        }
    }
    
    
    
    
    
    /// Deletes the studio model in iCloud.
    ///
    /// - Parameters:
    ///   - viewController: The view controller calling this method. For error alerting only.
    ///   - completion: An optional error completion.
    class func deleteStudioModel(viewController: UIViewController?, completion: ((_ error: Error?) -> Void)?) {
        backgroundQueue.async {
            if isNetworkActive && isiCloudSignedin() {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
                publicDatabase.delete(withRecordID: Studio.recordID, completionHandler: { (recordId, error) in
                    if error == nil {
                        print("Studio model Deleted") // debugging
                        completion?(nil)
                    } else if let error = error {
                        print("Error deleting Studio model") // debugging
                        guard let viewController = viewController else { completion?(error); return }
                        handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                            if !ckerrorWasHandled {
                                Alerts.myAlert(title: "Error", message: "Error Deleting Studio info.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                completion?(error)
                            }
                        })
                    }
                    DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
                })
            }
        }
    }
   
    
  
    
    
    //***************************************************************
    // MARK: - Client Method(s)
    //***************************************************************

    /// Uploads ClientModel to iCloud.
    /// This is the final step for a ClientModel. i.e. The Client is done and gone.
    ///
    /// - Parameters:
    ///   - filename: The filename to upload to, not including the path.
    ///   - client: The ClientModel to upload.
    ///   - view: The view controller that called this method. Used for error alert.
    ///   - completion: Error will not be nil if an error occured uploading.
    class func uploadClient(filename: String, client: ClientModel, viewController: UIViewController?, completion: ((_ error: Error?) -> Void)?) {
        backgroundQueue.async {
            if isNetworkActive && isiCloudSignedin() {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
//                var recordToUpdate: CKRecord? // used if the client exists in the db. For updating client info.
                let clientRecord = CKRecord(recordType: RecordTypes.client) // used for saving a new client into the db.
                
                // queries to see if the client already exists in the DB.
                let predicate = NSPredicate(format: "name == %@ AND zip == %@", client.name, client.zipcode)
                let query = CKQuery(recordType: RecordTypes.client, predicate: predicate)
                publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                    if error == nil, let records = records {
                        if let recordToUpdate = records.first {
                            print("Client already exists in DB.")
                            
                            // UPDATE
                            publicDatabase.fetch(withRecordID: recordToUpdate.recordID, completionHandler: { (record, error) in
                                recordToUpdate["name"] = client.name as CKRecordValue
                                recordToUpdate["streetAddress"] = client.streetAddress as CKRecordValue
                                recordToUpdate["city"] = client.city as CKRecordValue
                                recordToUpdate["state"] = client.state as CKRecordValue
                                recordToUpdate["zip"] = client.zipcode as CKRecordValue
                                recordToUpdate["age"] = client.age as CKRecordValue
                                recordToUpdate["birth"] = client.birthdateString as CKRecordValue
                                recordToUpdate["birthdate"] = client.birthdate as CKRecordValue
                                recordToUpdate["phone"] = client.phoneNumber as CKRecordValue
                                recordToUpdate["gender"] = client.gender as CKRecordValue
                                recordToUpdate["email"] = client.emailAddress as CKRecordValue? ?? nil
                                
                                // Updates the clientRecord in iCloud
                                let modifyRecords = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
                                modifyRecords.savePolicy = .allKeys
                                modifyRecords.qualityOfService = .userInitiated
                                modifyRecords.modifyRecordsCompletionBlock = { (modifiedRecord, deletedRecordIDs, error) in
                                    if error == nil {
                                        print("iCloud update CLIENT succeeded") // debugging
                                        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
                                        completion?(nil)
                                    } else if let error = error {
                                        print("Error updating client") // debugging
                                        guard let viewController = viewController else { completion?(error); return }
                                        handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                                            if !ckerrorWasHandled {
                                                Alerts.myAlert(title: "Error", message: "Error updating client.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                                completion?(error)
                                            }
                                        })
                                    }
                                }
                                publicDatabase.add(modifyRecords)
                                
                            })
                            
                        } else {
                            // SAVE
                            clientRecord["name"] = client.name as CKRecordValue
                            clientRecord["streetAddress"] = client.streetAddress as CKRecordValue
                            clientRecord["city"] = client.city as CKRecordValue
                            clientRecord["state"] = client.state as CKRecordValue
                            clientRecord["zip"] = client.zipcode as CKRecordValue
                            clientRecord["age"] = client.age as CKRecordValue
                            clientRecord["birth"] = client.birthdateString as CKRecordValue
                            clientRecord["birthdate"] = client.birthdate as CKRecordValue
                            clientRecord["phone"] = client.phoneNumber as CKRecordValue
                            clientRecord["gender"] = client.gender as CKRecordValue
                            clientRecord["email"] = client.emailAddress as CKRecordValue? ?? nil
                            
                            // Saves the clientRecord to iCloud
                            publicDatabase.save(clientRecord, completionHandler: { (saveRecord, error) in
                                if error == nil {
                                    print("iCloud upload CLIENT succeeded") // debugging
                                    completion?(nil)
                                } else if let error = error {
                                    print("Error uploading client") // debugging
                                    guard let viewController = viewController else { completion?(error); return }
                                    handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                                        if !ckerrorWasHandled {
                                            Alerts.myAlert(title: "Error", message: "Error uploading client.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                            completion?(error)
                                        }
                                    })
                                }
                                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
                            })
                        }
                    } else if let error = error {
                        print("Error querying client") // debugging
                        guard let viewController = viewController else { completion?(error); return }
                        handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                            if !ckerrorWasHandled {
                                Alerts.myAlert(title: "Error", message: "Error querying client.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                                completion?(error)
                            }
                            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
                        })
                    }
                })
                
            } else {
                guard let viewController = viewController else { return }
                Alerts.iCloudSignedInError(viewController: viewController) }
        }
    }
    
    
 
    /// Uploads Client PDF file to iCloud Drive
    ///
    /// - Parameter clientName: The client's name
    /// - Parameter viewController: The view controller performing the call to this method. Used for error alert.
    class func uploadClientPDFtoiCloudDrive(clientName: String, pdfData: Data, viewController: UIViewController?, completion: ((_ error: Error?) -> Void)?) {
        backgroundQueue.async {
            if isNetworkActive && isiCloudSignedin() {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
                let fileManager = FileManager.default
                createDirectoryIniCloudDrive(nameOfNewDir: clientName)
                
//                let localDocumentsURL = URL(fileURLWithPath: "\(docDir)/\(clientName).pdf")
                var iCloudDocumentsURL: URL!
                
                let iCloudDocumentsDir = fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent(clientName, isDirectory: true)
                var mostRecentNum: Int!
                
                // Search for multiple PDF files in client's dir
                do {
                    let contentsArray = try fileManager.contentsOfDirectory(at: iCloudDocumentsDir!, includingPropertiesForKeys: nil, options: [])
                    if contentsArray.count > 0 {
                        mostRecentNum = getMostRecentFileNum(contentsArray: contentsArray)
                    }
                } catch {
                    print("Error getting contents of/or directory") // debugging
                    guard let viewController = viewController else { completion?(error); return }
                    Alerts.myAlert(title: "Error", message: "iCloud Error: ", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                    completion?(error)
                }
                
                // append '(number)' to iCloudDocumentsURL
                if mostRecentNum != nil {
                    iCloudDocumentsURL = fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent("\(clientName)").appendingPathComponent("\(clientName)(\(mostRecentNum! + 1)).pdf")
                } else {
                    iCloudDocumentsURL = fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent("\(clientName)").appendingPathComponent("\(clientName).pdf")
                }
                
                // Copy PDF to iCoudDrive
                let pdfFileAttributes: [FileAttributeKey: Any] = [FileAttributeKey.appendOnly : true, FileAttributeKey.creationDate: Date()]
                print(" iCloud PDF path with filename: - iCloudDocumentsURL!.path")
                if fileManager.createFile(atPath: iCloudDocumentsURL!.path, contents: pdfData, attributes: pdfFileAttributes) == true {
                    print("PDF saved to iCloudDrive") // debugging
                    completion?(nil)
                } else {
                    print("Error creating file in iCloudDrive") // debugging
                    let error = NSError(domain: "File creation failed.", code: 404, userInfo: nil)
                    guard let viewController = viewController else { completion?(error); return }
                    Alerts.myAlert(title: "Error", message: "Error creating file in iCloudDrive: ", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                    completion?(error)
                }

                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            } else {
                guard let viewController = viewController else { return }
                Alerts.iCloudSignedInError(viewController: viewController) }
        }
    }
    
    
    /// Downloads client model from iCloud via the CKRecord.ID.
    ///
    /// - Parameters:
    ///   - recordID: The CKRecord.ID of the client.
    ///   - viewController: The ViewController that called the method.
    ///   - completion: Contains a data object of the client's info, an array of CKRecord of the clients info, or an error.
    class func downloadClientFromiCloud(with recordID: CKRecord.ID, viewController: UIViewController?, completion: ((_ error: Error?) -> Void)?) {
        backgroundQueue.async {
            if isNetworkActive && isiCloudSignedin() {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }

                publicDatabase.fetch(withRecordID: recordID, completionHandler: { (record, error) in
                    if error == nil {
                        if let record = record {
                            print("queryResult: \(record)")
                            Client.setReturningClient(from: record)
                            print("Client retrieved.") // debugging
                            completion?(nil)
                           
                        } else if record == nil {
                            print("CKRecord.ID not found") // debugging
                            guard let viewController = viewController else { completion?(error); return }
                            Alerts.myAlert(title: "No Result", message: "No matching information was found.\nPlease start a new form.", error: nil, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                            completion?(error)
                        }
                    } else if let error = error {
                        guard let viewController = viewController else { completion?(error); return }
                        handleCKErrors(error: error, viewController: viewController, handler: { (ckerrorWasHandled) in
                            if !ckerrorWasHandled {
                            Alerts.myAlert(title: "Error", message: "There was an error searching for client.", error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                            completion?(error)
                            }
                        })
                    }
                    DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
                })
            } else {
                guard let viewController = viewController else { return }
                Alerts.iCloudSignedInError(viewController: viewController) }
        }
    }
    
    
    
    
    
    
    
    
    
    //***************************************************************
    // MARK: - Private Method(s)
    //***************************************************************
    
    /// Find the number of the most recent pdf uploaded to the clients dir.
    ///
    /// - Parameter contentsArray: An array of contents.
    /// - Returns: A number if any pdf's exist in the directory.
    fileprivate class func getMostRecentFileNum(contentsArray: [URL]) -> Int? {
        var recentNums = [Int]()
        
        for path in contentsArray {
            let pathWOExtention = path.deletingPathExtension()
            var lastPathComponent = pathWOExtention.lastPathComponent
            if lastPathComponent[lastPathComponent.index(before: lastPathComponent.endIndex)] == ")" {
                lastPathComponent.removeLast()
                let num = String(lastPathComponent.removeLast())
                recentNums.append(Int(num)!)
            }
        }
        
        if recentNums.count > 0 {
            return recentNums.max()
        } else {
            return 0
        }
    }
    
    
    
    ///  Creates a CKAsset from Data passed and returns that CKAsset.
    ///
    /// - Parameter anyData: Any Data type that conforms to CKAsset
    /// - Returns: A CKAsset.
    fileprivate class func createAsset(anyData: Any) -> CKAsset {
        
        var returnAsset: CKAsset!
        let tempStr = ProcessInfo.processInfo.globallyUniqueString
        let filename = "\(tempStr)_file.bin"
        let baseURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileURL = baseURL.appendingPathComponent(filename, isDirectory: false)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: anyData, requiringSecureCoding: false)
            try data.write(to: fileURL, options: [.atomicWrite])
            returnAsset = CKAsset(fileURL: fileURL)
        } catch {
            print("Error creating asset for iCloud: \(error)") // debugging
        }
        return returnAsset
    }
    
    
    
    /// Creates a dir for the specific client if one doesn't already exist.
    ///
    /// - Parameter nameOfNewDir: The name of the directory to create.
    fileprivate class func createDirectoryIniCloudDrive(nameOfNewDir: String) {
        if let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent(nameOfNewDir) {
            if !FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: nil) {
                do {
                    try FileManager.default.createDirectory(at: iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error creating dir in iCloudDrive: \n\(error)") // debugging
                }
            }
        }
    }
    
    
    
    
    
    

    /// https://stackoverflow.com/questions/44023936/cloudkit-full-and-complete-error-handling-example
    /// In CloudKit, you have convenience API and Batch Operations API. If you are only using convenience API in your app, this means that you add/update/fetch/deleted single record at a time. Thus you will never get CKErrorPartialFailure because you are NOT communicating with iCloud Server in batches. If you are using only Batch Operations API in your app then you will get CKErrorPartialFailure. It is a high level error that actually contains a sub-error (CKError instance) for each record/zone/subscription included in your operation.
    
    /// I agree with you that the documentation is not clear what could occur only as a partial error and what could not. Plus what could occur on both cases. To answer this question, you can take a simple approach by assuming that all errors might occur in both cases or you either another more detailed oriented approach by finding out the possible cases for each error. For the second approach, I had to simulate different error scenarios and see what errors do I get from iCloud Server. Please take the following points into considerations:
    
    /// Try as many CKOperation as you can to get list of errors. You have operations for records, zones, database, subscriptions.
    /// Does the operation atomic or not.
    /// Some errors are impossible to simulate because we don't control iCloud Server responses by any means. Example: CKInternalError, CKServerRejectedRequest, CKServiceUnavailable
    /// Some errors would only occur during Development phase and should not occur during Production phase. Example: CKBadContainer,CKMissingEntitlement,CKBadDatabase
    /// Some errors are clearly non-partial errors because they are more related to the whole request sent to iCloud. Examples: CKIncompatibleVersion, CKRequestRateLimited, CKOperationCancelled, CKLimitExceeded, CKServerResponseLost, CKManagedAccountRestricted
    /// Some errors can only occur as partial errors. Example CKBatchRequestFailed. This one only occur for atomic CKOperations
    /// Some errors can occur as both partial/non-partial errors. Examples: CKNotAuthenticated, CKNetworkUnavailable, CKNetworkFailure. They occur as a partial error for record zone operations while they occur as non-partial error for records operations.
    /// Some Zone related errors will appear as partial errors when using Batch Operations API. Examples:CKUserDeletedZone , CKZoneBusy. Exception: CKChangeTokenExpired i got it as a non-partial error when I was performing an Operation Based Calls.
    /// CKZoneNotFound occurs as a partial and non-partial error. If you use CKModifyRecordsOperation to upload to a non-existing zone, you will get a partial error. However, if you use CKFetchRecordZoneChanges to fetch from a non-existing zone, you will get non-partial error.
    /// Merge Conflicts error occurs as a partial error when using Batch Operations API.
    /// In WWDC 2015 Video, CKInvalidArguments was mentioned as one of the errors that might occur as partial error when using Batch Operations API. However, I tried different error scenarios (such as: creating/updating a record in the same request) and it occurs as a non-partial error. So to be in the safe side, I might handle it for both partial and non-partial errors.
    /// CKQuotaExceeded occurs as a non partial error. I managed to reproduce that error by filling my iCloud storage by data from different apps except Photos. Backup will fill most of the storage then it won't be hard to fill in the rest of the available space.
    /// CKUnkownItem occurs as a non-partial error when using convenience API. Also occurs as a partial error when using Batch Operation API.
    /// All the sharing/assets related-errors, I am not familiar with them but I think the relative ones that you listed in your question, are good to be considered as partial errors.
    ///
    /// - Parameter error: An Error to be checked for CKError conformance.
    fileprivate class func handleCKErrors(error: Error, viewController: UIViewController, handler: ((_ errorWasHandled: Bool) -> Void)?) {
        if let ckerror = error as? CKError {
            switch ckerror {
                
            // An error indicating that a record or share cannot be saved because doing so would cause the same hierarchy of records to exist in multiple shares.
            case CKError.alreadyShared:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the content of the specified asset file was modified while being saved.
            case CKError.assetFileModified:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when the specified asset file is not found.
            case CKError.assetFileNotFound:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when the specified container is unknown or unauthorized.
            case CKError.badContainer:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the operation could not be completed on the given database.
            case CKError.badDatabase:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the entire batch was rejected.
            case CKError.batchRequestFailed:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the previous server change token is too old.
            case CKError.changeTokenExpired:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the server rejected the request because of a conflict with a unique field.
            case CKError.constraintViolation:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that your app version is older than the oldest version allowed.
            case CKError.incompatibleVersion:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // A nonrecoverable error encountered by CloudKit.
            case CKError.internalError:
                Alerts.myAlert(title: "Service Unavailable", message: nil, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when the specified request contains bad information.
            case CKError.invalidArguments:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when a request to the server is too large.
            case CKError.limitExceeded:
//            guard let retryInterval = ckerror.userInfo[CKErrorRetryAfterKey] as? TimeInterval else { return }
//            DispatchQueue.main.async {
//                Timer.scheduledTimer(timeInterval: retryInterval, target: self, selector: #selector(self.files_saveNotes), userInfo: nil, repeats: false)
//                }
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when a request is rejected due to a managed-account restriction.
            case CKError.managedAccountRestricted:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when the app is missing a required entitlement.
            case CKError.missingEntitlement:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when the network is available but cannot be accessed.
            case CKError.networkFailure:
                Alerts.myAlert(title: "Network Failure", message: nil, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when the network is not available.
            case CKError.networkUnavailable:
                Alerts.myAlert(title: "No Wifi", message: nil, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the current user is not authenticated, and no user record was available.
            case CKError.notAuthenticated:
                Alerts.myAlert(title: "iCloud not signed in", message: nil, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that an operation was explicitly canceled.
            case CKError.operationCancelled:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that some items failed, but the operation succeeded overall.
            case CKError.partialFailure:
                Alerts.myAlert(title: "partial Failure", message: error.localizedDescription, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when the user is not a member of the share.
            case CKError.participantMayNeedVerification:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the user did not have permission to perform the specified save or fetch operation.
            case CKError.permissionFailure:
                Alerts.myAlert(title: "Permission Denied", message: nil, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when saving the record would exceed the user’s current storage quota.
            case CKError.quotaExceeded:
                Alerts.myAlert(title: "iCloud storage full", message: nil, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when the target of a record's parent or share reference is not found.
            case CKError.referenceViolation:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // Transfers to and from the server are being rate limited for the client at this time.
            case CKError.requestRateLimited:
//                guard let retryInterval = ckerror.userInfo[CKErrorRetryAfterKey] as? TimeInterval else { return }
//                DispatchQueue.main.async {
//                    Timer.scheduledTimer(timeInterval: retryInterval, target: self, selector: #selector(self.files_saveNotes), userInfo: nil, repeats: false)
//                }
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the record was rejected because the version on the server is different.
            case CKError.serverRecordChanged:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the server rejected the request.
            case CKError.serverRejectedRequest:
                Alerts.myAlert(title: "Request Rejected", message: nil, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
                
//            case CKError.serverResponseLost:  // iOS 11 +
                
            // An error that is returned when the CloudKit service is unavailable.
            case CKError.serviceUnavailable:
                Alerts.myAlert(title: "Service Unavailable", message: nil, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that a share cannot be saved because too many participants are attached to the share.
            case CKError.tooManyParticipants:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error that is returned when the specified record does not exist.
            case CKError.unknownItem:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the user has deleted this zone from the settings UI.
            case CKError.userDeletedZone:
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the server is too busy to handle the zone operation.
            case CKError.zoneBusy:
//                guard let retryInterval = ckerror.userInfo[CKErrorRetryAfterKey] as? TimeInterval else {return }
//                DispatchQueue.main.async {
//                    Timer.scheduledTimer(timeInterval: retryInterval, target: self, selector: #selector(self.files_saveNotes), userInfo: nil, repeats: false)
//                }
                print(ckerror.localizedDescription)
                handler?(true)
                
            // An error indicating that the specified record zone does not exist on the server.
            case CKError.zoneNotFound:
                print(ckerror.localizedDescription)
                handler?(true)
                
            default:
                Alerts.myAlert(title: "Unknown Error", message: error.localizedDescription, error: error, actionsTitleAndStyle: nil, viewController: viewController, buttonHandler: nil)
                print(ckerror.localizedDescription)
                handler?(true)
            }
        } else {
            handler?(false)
        }
    }

    
    
    
    
    
    
    
    
}

