

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // use NSLog so we can read from the device console
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        NSLog("%@", #function)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        NSLog("%@", #function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NSLog("%@", #function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        NSLog("%@", #function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NSLog("%@", #function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NSLog("%@", #function)
    }


}

