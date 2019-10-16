import UIKit


@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var didChooseDetail = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    
        self.window = self.window ?? UIWindow()

        let svc = UISplitViewController()
        svc.delegate = self
        let master = MasterViewController(style:.plain)
        master.title = "Pep"
        let nav1 = UINavigationController(rootViewController:master)
        let detail = DetailViewController()
        let nav2 = UINavigationController(rootViewController:detail)
        svc.viewControllers = [nav1, nav2]
        self.window!.rootViewController = svc
        let b = svc.displayModeButtonItem
        detail.navigationItem.leftBarButtonItem = b
        detail.navigationItem.leftItemsSupplementBackButton = true
        
        self.configureAppearance()
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        
//        let tc = UIScreen.main.traitCollection
//        if tc.horizontalSizeClass == .Regular {
//            self.didExpand = true
//        }
        
        // this line compiles but we'll crash at launch (if we have any bar button items)
        // UIBarButtonItem.appearance().action = #selector(configureAppearance)
        
        
        return true
    }
    
    @objc func configureAppearance() {
        return; // comment out to see bug connected with nav bar background image
        // the bug is that the safe area stops working correctly
        // okay, fixed the bug! the secret is to mess with the initializers of the view controllers, q.v.
        let im = UIGraphicsImageRenderer(size:CGSize(20,20)).image { _ in
            let con = UIGraphicsGetCurrentContext()
            con?.setFillColor(UIColor.red.cgColor)
            con?.fill(CGRect(0,0,20,20))
        }
        UINavigationBar.appearance().setBackgroundImage(im, for: .default)
    }
}

extension AppDelegate : UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, separateSecondaryFrom vc1: UIViewController) -> UIViewController? {
        print("expanding")
        return nil
    }
    func splitViewController(_ svc: UISplitViewController, collapseSecondary vc2: UIViewController, onto vc1: UIViewController) -> Bool {
        print("collapsing")
        if let nav = vc2 as? UINavigationController,
            nav.topViewController is DetailViewController,
            self.didChooseDetail {
                return false
        }
        return true
    }
    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewController.DisplayMode {
        print("target display mode")
        return .automatic
    }
}
