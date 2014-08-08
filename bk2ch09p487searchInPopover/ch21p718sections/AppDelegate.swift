
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
    
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        let nav = UINavigationController(rootViewController:
            RootViewController(nibName: "RootViewController", bundle: nil))
        self.window!.rootViewController = nav
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
}
