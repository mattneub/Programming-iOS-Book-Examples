import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let theRVC = RootViewController(nibName:"MyNib", bundle:nil) // explicit nib name
        
        // in iOS 3, 4, 5, 6, and 7,
        // but if the nib is called "RootView.xib" or "RootViewController.xib",
        // you can pass nil as the nibName here (or call init() with no args)
        // but in iOS 8 (starting with seed 5?) this feature is gone for "RootViewController.xib"
        // ... but it does still work for "RootView.xib"!
        // I don't know if that's a momentary bug or what, but...
        // (In one way, it feels deliberate, since RootViewController is a dumb name for xib file!)
        // since I can't rely on it, however, I'm going to stop relying on it from here on in
        // so it's going to be explicit nib names from now on, I guess
        
        self.window!.rootViewController = theRVC
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
        
    }
    
}
