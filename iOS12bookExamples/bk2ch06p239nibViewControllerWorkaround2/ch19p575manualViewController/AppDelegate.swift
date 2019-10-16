import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        self.window = self.window ?? UIWindow()
        
        let theRVC = RootViewController()
        
        // workaround 2: change the swift name by using @objc() notation
        
        self.window!.rootViewController = theRVC
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
        
    }
    
}
