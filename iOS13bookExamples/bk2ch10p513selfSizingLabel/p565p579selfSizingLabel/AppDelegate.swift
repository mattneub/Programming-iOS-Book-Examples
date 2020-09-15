import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    
        self.window = self.window ?? UIWindow()
        self.window!.rootViewController = ViewController(nibName: "ViewController", bundle: nil)
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
    }
}
