//
//  CoreDataStack.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/12.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    
    let modelName = "Diary Model"
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.modelName)
        print(url)
        do{
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption:true]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        }catch{
            print("Error adding persistent store")
        }
        return coordinator
    }()
    
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    func saveContext(){
        if context.hasChanges{
            do{
                try context.save()
            }catch let error as NSError{
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
}
