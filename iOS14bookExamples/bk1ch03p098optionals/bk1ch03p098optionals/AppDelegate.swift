

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    let which = 1
    
    typealias RootViewController = ViewController
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    
        switch which {
        case 1:
            
            self.window = self.window ?? UIWindow()
            self.window!.rootViewController = RootViewController()
            self.window!.backgroundColor = UIColor.white
            self.window!.makeKeyAndVisible()
            
        case 2:
            
            // if unwrapping many times drives you crazy, unwrap once into a local
            
            self.window = self.window ?? UIWindow()
            let window = self.window!
            window.rootViewController = RootViewController()
            window.backgroundColor = UIColor.white
            window.makeKeyAndVisible()

            
            
        default:break
            


        }
        
        return true
    }
}
