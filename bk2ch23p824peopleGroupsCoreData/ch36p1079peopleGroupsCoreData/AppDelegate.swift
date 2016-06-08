

import UIKit
import CoreData

// this is all template code! Slightly simplified, took out comments, etc.
// The only significant change I made was MasterViewController -> GroupLister

extension NSManagedObject {
    @NSManaged var firstName : String
    @NSManaged var lastName : String
    @NSManaged var name : String
    @NSManaged var uuid : String
    @NSManaged var timestamp : NSDate
    @NSManaged var group : NSManagedObject
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let navigationController = self.window!.rootViewController as! UINavigationController
        let controller = navigationController.topViewController as! GroupLister
        controller.managedObjectContext = self.managedObjectContext
        return true
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).last!
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.main().urlForResource("ch36p1079peopleGroupsCoreData", withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("ch36p1079peopleGroupsCoreData.sqlite")
        do {
            try coordinator!.addPersistentStore(ofType:NSSQLiteStoreType, configurationName: nil, at: url)
        } catch {
            print("Unresolved error \(error)")
            fatalError("Terminating with unresolved error")
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch {
                    print("Unresolved error \(error)")
                    fatalError("Terminating with unresolved error")
                }
            }
        }
    }
}
