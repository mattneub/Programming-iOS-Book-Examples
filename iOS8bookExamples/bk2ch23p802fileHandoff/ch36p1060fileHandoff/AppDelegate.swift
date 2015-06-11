
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")

        return true
    }
    
    // handleOpenURL deprecated? but it does seem to work just fine
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        println("start \(__FUNCTION__)")
        println(url)
        
        
        var finalurl = url
        
        // new code: copy out of the inbox into the documents folder
        // I don't know why, but for some reason Quick Look can no longer preview
        // a document in the inbox

        let dir = url.URLByDeletingLastPathComponent?.lastPathComponent
        if dir == "Inbox" {
            println("inbox")
            let fm = NSFileManager()
            var err : NSError?
            let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err)
            let dest = docsurl!.URLByAppendingPathComponent(url.lastPathComponent!)
            println("copying")
            var ok = fm.copyItemAtURL(url, toURL: dest, error: &err)
            if !ok {
                println(err)
            } else {
                finalurl = dest
                println("removing")
                ok = fm.removeItemAtURL(url, error: &err)
                if !ok {
                    println(err)
                }
            }
        }
        
        let vc = self.window!.rootViewController as! ViewController
        vc.displayDoc(finalurl)
        println("end \(__FUNCTION__)")
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")
    }
    
    // logging shows that handleOpenURL: comes *between* willEnter and didBecome

}
