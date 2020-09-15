
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    var tabBarController = UITabBarController()
    var myDataSource : MyDataSource!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    
        self.window = self.window ?? UIWindow()

        let arr = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth"]
        // to see an interesting bug on iPhone 6 Plus, pick "Eighth", rotate to landscape, rotate back to portrait
        var vcs = [UIViewController]()
        for t in arr {
            let vc = ViewController()
            vc.tabBarItem.title = t
            vc.tabBarItem.image = UIImage(named:"trashlittle")
            vcs.append(vc)
        }
        self.tabBarController.viewControllers = vcs
        self.window!.rootViewController = self.tabBarController
        
        var customize : Bool { return true }
        
        doneCustomizing:
        if customize {
            
            let more = self.tabBarController.moreNavigationController
            let list = more.viewControllers[0]
            list.title = ""
            let b = UIBarButtonItem()
            b.title = "Back"
            list.navigationItem.backBarButtonItem = b // so user can navigation back
            more.navigationBar.barTintColor = .red // ooooh
            more.navigationBar.tintColor = .white // oooh oooh
            more.navigationBar.isTranslucent = true
            
            // break doneCustomizing
            
            let tv = list.view as! UITableView
            let mds = MyDataSource(originalDataSource: tv.dataSource!)
            self.myDataSource = mds
            tv.dataSource = mds
            
            tv.contentInsetAdjustmentBehavior = .always
            
            
        }
        
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
    }
}
