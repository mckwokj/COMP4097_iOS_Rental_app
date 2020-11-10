//
//  DataController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 5/11/2020.
//

import Foundation
import CoreData

class DataController {
    var persistentContainer: NSPersistentContainer
    let networkController = NetworkController()
    var estates: [Estate] = []
    var shouldSeedDatabase: Bool = false
    
    init(completion: @escaping() -> ()) {
        
        // Check if the database exists
        do {
            let databaseUrl =
                try FileManager.default.url(for: .applicationSupportDirectory,
                                            in: .userDomainMask, appropriateFor: nil,
                                            create: false).appendingPathComponent("EstatesModel.sqlite")
            
            shouldSeedDatabase = !FileManager.default.fileExists(atPath: databaseUrl.path)
        } catch {
            shouldSeedDatabase = true
        }
        
        
        persistentContainer = NSPersistentContainer(name:"EstatesModel")
        persistentContainer.loadPersistentStores {
            (description, error) in
            
            if let error = error {
                fatalError("Core Data stack could not be loaded. \(error)")
            }
            
            // Called once initialization of Core Data stack is complete
            DispatchQueue.main.async {
                self.networkController.fetchEstates(completionHandler: {(estates) in
                    DispatchQueue.main.async {
                        //                        self.estates = estates
                        Estate.estateData = estates
                        
                        if self.shouldSeedDatabase {
                        // call seedData after fetching estate data
                            self.seedData()
                        //                self.tableView.reloadData()
                        }
                    }
                }) {(error) in
                    DispatchQueue.main.async {
                        //                        self.estates = []
                        Estate.estateData = []
                        //                self.tableView.reloadData()
                    }
                }
                completion()
            }
        }
    }
    
    private func seedData() {
        
        persistentContainer.performBackgroundTask {
            (managedObjectContext) in
            
            Estate.estateData.forEach{ (estate) in
                let estateManagedObject = EstateManagedObject(context: managedObjectContext)
                estateManagedObject.bedrooms = Int32(estate.bedrooms)
                estateManagedObject.estate = estate.estate
                estateManagedObject.expected_tenants = Int32(estate.expected_tenants)
                estateManagedObject.gross_area = Int32(estate.gross_area)
                estateManagedObject.id = Int32(estate.id)
                estateManagedObject.image_URL = estate.image_URL
                estateManagedObject.property_title = estate.property_title
                estateManagedObject.rent = Int32(estate.rent)
                
            }
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Could not save managed object context. \(error)")
            }
        }
    }
}
