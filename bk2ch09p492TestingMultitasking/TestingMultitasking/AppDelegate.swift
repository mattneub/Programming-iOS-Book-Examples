

import UIKit
import os.log

let log = OSLog(subsystem: "com.neuburg.matt", category: "TestingMultitasking")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // use os_log so we can read from the device console
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        os_log("%{public}@", log: log, #function)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        os_log("%{public}@", log: log, #function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        os_log("%{public}@", log: log, #function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        os_log("%{public}@", log: log, #function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        os_log("%{public}@", log: log, #function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        os_log("%{public}@", log: log, #function)
    }


}

