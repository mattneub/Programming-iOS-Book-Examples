import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow()
        
        let theRVC = RootViewController(nibName:"MyNib", bundle:nil)
        
        self.window!.rootViewController = theRVC
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
        
    }
    
}
