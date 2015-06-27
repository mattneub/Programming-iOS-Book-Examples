

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    let which = 1
    
    typealias RootViewController = ViewController
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        switch which {
        case 1:
            
            self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
            self.window!.rootViewController = RootViewController()
            self.window!.backgroundColor = UIColor.whiteColor()
            self.window!.makeKeyAndVisible()
            
        case 2:
            
            // if unwrapping many times drives you crazy, unwrap once into a local
            
            self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
            let window = self.window!
            window.rootViewController = RootViewController()
            window.backgroundColor = UIColor.whiteColor()
            window.makeKeyAndVisible()

            
            
        default:break
            


        }
        
        return true
    }
}
