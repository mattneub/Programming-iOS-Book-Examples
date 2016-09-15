


import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        self.window = UIWindow()
        
        // how to check whether assignment into an optional chain worked
        let ok : Void? = self.window?.rootViewController = ViewController()
        if ok != nil {
            print("it worked")
        }
        // or:
        if (self.window?.rootViewController = ViewController()) != nil {
            print("it worked")
        }

        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
}
