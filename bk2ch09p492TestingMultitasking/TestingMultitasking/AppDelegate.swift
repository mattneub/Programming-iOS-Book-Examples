

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // use NSLog so we can read from the device console
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NSLog("%@", #function)
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        NSLog("%@", #function)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        NSLog("%@", #function)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        NSLog("%@", #function)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        NSLog("%@", #function)
    }

    func applicationWillTerminate(application: UIApplication) {
        NSLog("%@", #function)
    }


}

