import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var didChooseDetail = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        self.window = UIWindow()

        let svc = UISplitViewController()
        svc.delegate = self
        let master = MasterViewController()
        master.title = "Pep"
        let nav1 = UINavigationController(rootViewController:master)
        let detail = DetailViewController()
        let nav2 = UINavigationController(rootViewController:detail)
        svc.viewControllers = [nav1, nav2]
        self.window!.rootViewController = svc
        let b = svc.displayModeButtonItem()
        detail.navigationItem.leftBarButtonItem = b
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        
//        let tc = UIScreen.mainScreen().traitCollection
//        if tc.horizontalSizeClass == .Regular {
//            self.didExpand = true
//        }
        return true
    }
}

extension AppDelegate : UISplitViewControllerDelegate {
    func splitViewController(svc: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController vc1: UIViewController) -> UIViewController? {
        print("expanding")
        return nil
    }
    func splitViewController(svc: UISplitViewController, collapseSecondaryViewController vc2: UIViewController, ontoPrimaryViewController vc1: UIViewController) -> Bool {
        print("collapsing")
        return !self.didChooseDetail
    }
}
