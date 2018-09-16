import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        self.window = self.window ?? UIWindow()
        
        // big news! in iOS 9, this works!
        
        let theRVC = RootViewController()
        // print(NSStringFromClass(RootViewController.self))
        
        // the reason is that when "ch19p579nibViewController.RootViewController.xib" is not found...
        // the module name is stripped off and we try again (just as I always said we should do)
        
        // moreover, if RootViewController.xib is not part of the app target...
        // ... we correctly fall back on RootView.xib
        
        // note that this does _not_ work in iOS 8
        // we get a black screen - no nib was loaded
        
        self.window!.rootViewController = theRVC
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
        
    }
    
}
