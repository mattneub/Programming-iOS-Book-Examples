import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)

        let svc = UISplitViewController()
        svc.delegate = self
        let master = MasterViewController()
        master.title = "Pep"
        let nav1 = UINavigationController(rootViewController:master)
        svc.addChildViewController(nav1)
        let detail = DetailViewController()
        let nav2 = UINavigationController(rootViewController:detail)
        svc.addChildViewController(nav2)
        self.window!.rootViewController = svc
        let b = svc.displayModeButtonItem()
        detail.navigationItem.leftBarButtonItem = b
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate : UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
    
}
