import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        self.window = self.window ?? UIWindow()
        
        let theRVC = RootViewController(nibName:"MyNib", bundle:nil)
        
        self.window!.rootViewController = theRVC
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
        
    }
    
}
