import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        self.window?.backgroundColor = .white
        // return true // uncomment to remove test buttons
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateInitialViewController()!
        let undoButton = UIBarButtonItem(title: "Undo", style: .plain, target: nil, action: #selector(MyView.undo))
        let redoButton = UIBarButtonItem(title: "Redo", style: .plain, target: nil, action: #selector(MyView.redo))
        vc.navigationItem.rightBarButtonItems = [undoButton, redoButton]
        self.window?.rootViewController = UINavigationController(rootViewController:vc)
        return true
    }
}

