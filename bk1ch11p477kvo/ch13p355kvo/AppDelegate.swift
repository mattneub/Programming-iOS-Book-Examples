

import UIKit

// both objects must derive from NSObject

class MyClass1 : NSObject {
    // absolutely crucial to say "dynamic" or this won't work
    dynamic var value : Bool = false
}

class MyClass2: NSObject {
    
    override func observeValueForKeyPath(keyPath: String,
        ofObject object: AnyObject, change: [NSObject : AnyObject],
        context: UnsafeMutablePointer<Void>) {
            println("I heard about the change!")
            println(object.valueForKeyPath(keyPath))
            println(change)
            println(context == &con) // aha
            let c = UnsafeMutablePointer<String>(context)
            let s = c.memory
            println(s)
        }
    
}

private var con = "ObserveValue"

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var objectA : NSObject!
    var objectB : NSObject!
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        self.window!.rootViewController = UIViewController()
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        
        
        objectA = MyClass1()
        objectB = MyClass2()
        let opts : NSKeyValueObservingOptions = .New | .Old
        objectA.addObserver(objectB, forKeyPath: "value", options: opts, context: &con)
        (objectA as! MyClass1).value = true
        // comment out next line if you wish to crash
        objectA.removeObserver(objectB, forKeyPath: "value")
        objectA = nil
        
        return true
    }
}
