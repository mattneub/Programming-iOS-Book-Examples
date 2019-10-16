


import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    
        self.window = self.window ?? UIWindow()
        
        // how to check whether assignment into an optional chain worked
        let ok : Void? = self.window?.rootViewController = ViewController()
        if ok != nil {
            print("it worked")
        }
        // or:
        if (self.window?.rootViewController = ViewController()) != nil {
            print("it worked")
        }

        
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        return true
    }
}
