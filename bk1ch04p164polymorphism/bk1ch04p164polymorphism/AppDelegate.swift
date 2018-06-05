

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let name = "MyNib" // Swift String
        let vc = ViewController(nibName:name, bundle:nil) // no problem because no bridge
        
        _ = vc
        
        return true
    }



}

