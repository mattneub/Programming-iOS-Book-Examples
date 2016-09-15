
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
        -> Bool {
            self.window = UIWindow()
            self.window!.rootViewController = UIViewController()
            // here we can add subviews
            let mainview = self.window!.rootViewController!.view
            let v = UIView(frame:CGRectMake(100,100,50,50))
            v.backgroundColor = UIColor.redColor() // small red square
            mainview.addSubview(v) // add it to main view
            // and the rest is as before...
            self.window!.backgroundColor = UIColor.whiteColor()
            self.window!.makeKeyAndVisible()
            return true
    }



}

