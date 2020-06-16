//
//  CireDataStack.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataStackDetails {

    private let managedObjectModel: NSManagedObjectModel
    internal let persistentCoordinator: NSPersistentStoreCoordinator
    private let dataBasePath: URL
    internal let persistingDBContext: NSManagedObjectContext
    let currentMOContext: NSManagedObjectContext
    internal let databasePath: URL
    internal let backgroundDBContext: NSManagedObjectContext

    static func getSharedInstance() -> CoreDataStackDetails {
        struct Singleton {
            static var shared = CoreDataStackDetails(dbName: "VirtualTouristData")!
        }
        return Singleton.shared
    }

    init?(dbName: String) {
        guard let dataBasePath = Bundle.main.url(forResource: dbName, withExtension: "momd") else {
            return nil
        }
        self.dataBasePath = dataBasePath

        guard let dbModel = NSManagedObjectModel(contentsOf: dataBasePath) else {
            return nil
        }
        
        self.managedObjectModel = dbModel
        persistentCoordinator = NSPersistentStoreCoordinator(managedObjectModel: dbModel)
        persistingDBContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingDBContext.persistentStoreCoordinator = persistentCoordinator

        currentMOContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        currentMOContext.parent = persistingDBContext

        backgroundDBContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundDBContext.parent = currentMOContext

        let fileManager = FileManager.default
        guard let docUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }

        self.databasePath = docUrl.appendingPathComponent("managedObjectModel.sqlite")

        do {
            try addPersistentStoreCoordinator(NSSQLiteStoreType, configuration: nil, storePath: databasePath, options:
                [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]as [NSObject : AnyObject]?)
        } catch {
            print("Data Base Issue \(databasePath)")
        }
    }
    
    func addPersistentStoreCoordinator(_ storeType: String, configuration: String?, storePath: URL, options : [NSObject:AnyObject]?) throws {
        try persistentCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: databasePath, options: nil)
    }
    
    func saveCurrentContext() throws {
           currentMOContext.performAndWait() {
               if self.currentMOContext.hasChanges {
                   do {
                       try self.currentMOContext.save()
                   } catch { print("Data base Issue \(error)") }
                   
                   self.persistingDBContext.perform() {
                       do {
                           try self.persistingDBContext.save()
                       } catch { print("Data base Issue : \(error)") }
                   }
               }
           }
       }

}

