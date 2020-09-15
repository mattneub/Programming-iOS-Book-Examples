
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        return true
    }
}

/*
 Not in the book.
 A table view controller should ideally be in a navigation controller.
 If you don't want to do that, you need to limit where the table view controller
 appears, so that it stays in the safe area on the iPhone X.
 This example illustrates.
 */

// unused:
// how to do in code the same thing that's being done in the storyboard
/*
class MyParentViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        let vc = RootViewController(nibName: "RootViewController", bundle: nil)
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        vc.didMove(toParentViewController: self)
    }
}
 */
