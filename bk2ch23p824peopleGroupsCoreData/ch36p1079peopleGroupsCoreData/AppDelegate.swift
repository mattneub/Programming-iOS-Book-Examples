

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationController = self.window!.rootViewController as! UINavigationController
        let controller = navigationController.topViewController as! GroupLister
        controller.managedObjectContext = self.persistentContainer.viewContext
        return true
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let con = NSPersistentContainer(name: "ch36p1079peopleGroupsCoreData")
        con.loadPersistentStores { desc, err in
            if let err = err {
                fatalError("Unresolved error \(err)")
            }
        }
        return con
    }()

    // MARK: - Core Data Saving support
    
    func saveContext () {
        let con = persistentContainer.viewContext
        if con.hasChanges {
            do {
                try con.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
}
