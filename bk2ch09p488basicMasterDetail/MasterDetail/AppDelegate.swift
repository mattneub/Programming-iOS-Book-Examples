import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var didChooseDetail = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
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
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        
//        let tc = UIScreen.main.traitCollection
//        if tc.horizontalSizeClass == .Regular {
//            self.didExpand = true
//        }
        return true
    }
}

extension AppDelegate : UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, separateSecondaryFrom vc1: UIViewController) -> UIViewController? {
        print("expanding")
        return nil
    }
    func splitViewController(_ svc: UISplitViewController, collapseSecondary vc2: UIViewController, onto vc1: UIViewController) -> Bool {
        print("collapsing")
        return !self.didChooseDetail
    }
}
