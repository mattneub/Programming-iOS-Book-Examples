import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = self.window ?? UIWindow()
        
        let theRVC = RootViewController()
        
        // proving that device-specific nibs do still work
        
        self.window!.rootViewController = theRVC
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
        
    }
    
}
