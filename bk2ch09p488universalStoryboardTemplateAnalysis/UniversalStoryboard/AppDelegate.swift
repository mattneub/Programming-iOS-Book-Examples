

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    /*
    It's important to study the storyboard:
    we have the setup you'd expect: 
    the storyboard has relationships to the nav controllers,
    ...which have root view controller relationships to the master view and detail view
    But the master's table has a Replace (detail) segue to the second nav controller!
    Thus, every time the segue is performed from a table row, 
    we get a _new_ second nav controller with a _new_ detail view.
    This was not necessary on iPad alone where the second nav controller is always present...
    but on iPhone it must be created freshly every time.
*/

    var window: UIWindow?

    // basically, this is pure template code
    // I have neatened it up, shortened some names, and commented on it (and added logging)
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        let svc = self.window!.rootViewController as UISplitViewController
        // place button in detail controller's nav bar
        let nav = (svc.viewControllers as NSArray).lastObject as UINavigationController
        // new in iOS 8, split v.c. vends the button with a method
        // note duplication!
        // the button will be added when the user taps a row in the master v.c....
        // but what if the split view appears _originally_ in portrait so there is no master?
        // then if we don't also added the button here, there is no button
        // the user can summon with swipe but might not realize that
        nav.topViewController.navigationItem.leftBarButtonItem = svc.displayModeButtonItem()
        svc.delegate = self
        return true
    }
    
    // MARK: - Split view
    
    // on iPhone, the split v.c. will be "collapsed"
    // this means the second view controller is "merged" onto the first in appropriate way
    // with a nav interface, what's appropriate is:
    // discard the 2nd nav controller, push 2nd v.c. onto 1st nav controller

    func splitViewController(splitViewController: UISplitViewController!, collapseSecondaryViewController vc2:UIViewController!, ontoPrimaryViewController vc1:UIViewController!) -> Bool {
        println("collapse!")
        if let vc2 = vc2 as? UINavigationController {
            if let detail = vc2.topViewController as? DetailViewController {
                if !detail.detailItem {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }

}

