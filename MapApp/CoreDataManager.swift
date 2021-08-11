//
//  Persistence.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/29.
//

import CoreData
import CoreLocation

struct CoreDataManager {
    static let shared = CoreDataManager()
    static var preview: CoreDataManager = {
        let result = CoreDataManager(inMemory: true)
        
        
        var points: [Point] = []
        var osaka = Point(context: result.context)
        osaka.latitude = 34.68639
        osaka.longitude = 135.52
        points.append(osaka)
        
        var tokyo = Point(context: result.context)
        tokyo.latitude = 35.68944
        tokyo.longitude = 139.69167
        points.append(tokyo)
        
        let newRoot = Root(context: result.context)
        newRoot.rootnm = "大阪ー東京"
        newRoot.date = Date()
        newRoot.addToPoints([points[0],points[1]])
        result.save()
        return result
    }()

    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Using Lightweight Migration
//        let description = NSPersistentStoreDescription()
//        description.shouldMigrateStoreAutomatically = true
//        description.shouldInferMappingModelAutomatically = true
//        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        context = container.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
               try container.viewContext.save()
                print("saved...")
            } catch let error {
                print("save failed...\(error.localizedDescription)")
            }
        }
    }
    
    func delete(deleteObj: NSManagedObject) {
        self.context.delete(deleteObj)
        self.save()
    }
}
