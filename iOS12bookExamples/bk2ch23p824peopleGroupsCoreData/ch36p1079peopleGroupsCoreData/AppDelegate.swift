

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let nav = self.window!.rootViewController as! UINavigationController
        let tvc = nav.topViewController as! GroupLister
        tvc.managedObjectContext = self.persistentContainer.viewContext
        return true
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
