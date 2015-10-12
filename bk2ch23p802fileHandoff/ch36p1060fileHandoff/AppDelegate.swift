
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("start \(__FUNCTION__)")
        print("end \(__FUNCTION__)")

        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("start \(__FUNCTION__)")
        print(url)
        
        
        var finalurl = url
        
        // work around bug where Quick Look can no longer preview a document in the inbox
        // okay, they seem to have fixed the bug in iOS 9, cutting for now
        
        /*

        let dir = url.URLByDeletingLastPathComponent?.lastPathComponent
        if dir == "Inbox" {
            do {
                print("inbox")
                let fm = NSFileManager()
                let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                let dest = docsurl.URLByAppendingPathComponent(url.lastPathComponent!)
                print("copying")
                try fm.copyItemAtURL(url, toURL: dest)
                finalurl = dest
                print("removing")
                try fm.removeItemAtURL(url)
            } catch {
                print(error)
            }
        }

*/
        
        let vc = self.window!.rootViewController as! ViewController
        vc.displayDoc(finalurl)
        print("end \(__FUNCTION__)")
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        print("start \(__FUNCTION__)")
        print("end \(__FUNCTION__)")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("start \(__FUNCTION__)")
        print("end \(__FUNCTION__)")
    }
    
    // logging shows that handleOpenURL: comes *between* willEnter and didBecome

}
