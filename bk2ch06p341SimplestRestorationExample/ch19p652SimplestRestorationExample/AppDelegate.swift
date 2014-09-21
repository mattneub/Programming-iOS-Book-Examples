import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    /*
    As of this writing, interesting bug where the launch image screen shot
    is whipped away too soon and we see the presented view controller
    animate into place. This is a problem only for presented view controllers,
    not pushed view controllers, and only in this simple situation where
    we rely on the storyboard to do all the restoration work for us.
*/
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
        
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    let which = 0
    
    /*
    func application(application: UIApplication!, viewControllerWithRestorationIdentifierPath ip: [AnyObject]!, coder: NSCoder!) -> UIViewController! {
        
        if which == 0 {
            return nil
        }
        
        println(ip)
        let last = (ip as NSArray).lastObject as String
        if last == "nav" {
            return self.window!.rootViewController
        }
        if last == "root" {
            return (self.window!.rootViewController as UINavigationController).viewControllers[0] as UIViewController
        }
        let board = coder.decodeObjectForKey(UIStateRestorationViewControllerStoryboardKey) as UIStoryboard
        return board.instantiateViewControllerWithIdentifier(last) as UIViewController
        
    }
*/

    
}

