
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var animator : Animator?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        if let nav = self.window?.rootViewController as? UINavigationController {
            self.animator = Animator()
            nav.delegate = self.animator
        }
        return true
        
    }
}

