

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}


