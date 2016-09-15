


import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow()
        
        let rvc = RootViewController()
        rvc.restorationIdentifier = "root"
        let nav = UINavigationController(rootViewController:rvc)
        nav.restorationIdentifier = "nav"
        
        self.window!.rootViewController = nav
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.restorationIdentifier = "window"
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        print("app should restore \(coder)")
        // how to examine the coder
        if let idiomraw = coder.decodeObjectForKey(
            UIApplicationStateRestorationUserInterfaceIdiomKey) as? Int {
                if let idiom = UIUserInterfaceIdiom(rawValue:idiomraw) {
                    if idiom == .Phone {
                        print("phone")
                    } else {
                        print("pad")
                    }
                }
        }
        return true
    }
    
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        print("app should save \(coder)")
        return true
    }
    
    func application(application: UIApplication, willEncodeRestorableStateWithCoder coder: NSCoder) {
        print("app will encode \(coder)")
    }
    
    func application(application: UIApplication, didDecodeRestorableStateWithCoder coder: NSCoder) {
        print("app did decode \(coder)")
    }
    
    /*
    
    func application(application: UIApplication, viewControllerWithRestorationIdentifierPath ip: [AnyObject], coder: NSCoder) -> UIViewController? {
        
        print("app delegate \(ip) \(coder)")
        let last = ip.last as String
        if last == "nav" {
            return self.window!.rootViewController
        }
        if last == "root" {
            return (self.window!.rootViewController as UINavigationController).viewControllers[0] as? UIViewController
        }
        return nil // shouldn't happen; the others all have restoration classes
    }

*/

    
}
