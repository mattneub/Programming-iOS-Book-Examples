
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    var tabBarController = UITabBarController()
    var myDataSource : MyDataSource!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)

        let arr = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth"]
        var vcs = [UIViewController]()
        for i in 0 ..< 6 {
            let vc = UIViewController()
            vc.tabBarItem.title = arr[i]
            vcs.append(vc)
        }
        self.tabBarController.viewControllers = vcs
        self.window!.rootViewController = self.tabBarController
        
        let more = self.tabBarController.moreNavigationController
        let list = more.viewControllers[0] as! UIViewController
        list.title = ""
        let b = UIBarButtonItem()
        b.title = "Back"
        list.navigationItem.backBarButtonItem = b // so user can navigation back
        more.navigationBar.barTintColor = UIColor.redColor() // ooooh
        more.navigationBar.tintColor = UIColor.whiteColor() // oooh oooh
        
        let tv = list.view as! UITableView
        let mds = MyDataSource(originalDataSource: tv.dataSource!)
        self.myDataSource = mds
        tv.dataSource = mds
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
}
