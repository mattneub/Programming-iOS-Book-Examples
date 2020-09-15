


import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    
        self.window = self.window ?? UIWindow()

        // how to check whether assignment into an optional chain worked
        let ok : Void? = self.window?.rootViewController = vc
        if ok != nil {
            print("it worked")
        }
        // or:
        if (self.window?.rootViewController = vc) != nil {
            print("it worked")
        }


        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        return true
    }
}
