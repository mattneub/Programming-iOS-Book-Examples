

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let nav = self.window!.rootViewController as! UINavigationController
        let tvc = nav.topViewController as! GroupLister
        let del = UIApplication.shared.delegate as! AppDelegate
        tvc.managedObjectContext = del.persistentContainer.viewContext
        return true
    }
    
    func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            if let _ = try? context.save() {
                print("saved")
            }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let con = NSPersistentContainer(name: "PeopleGroupsCoreData")
        con.loadPersistentStores { desc, err in
            print(desc)
            if let err = err {
                fatalError("Unresolved error \(err)")
            }
        }
        return con
    }()
    
}
