
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        println("start \(__FUNCTION__)")
        println("end \(__FUNCTION__)")

        return true
    }
    
    // handleOpenURL deprecated? but it does seem to work just fie
    
//    func application(_ application: UIApplication!,
//        openURL url: NSURL!,
//        sourceApplication sourceApplication: String!,
//        annotation annotation: AnyObject!) -> Bool {
//    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        println("start \(__FUNCTION__)")
        println(url)
        
        // new code: copy out of the inbox into the documents folder
        // I don't know why, but for some reason Quick Look can no longer preview
        // a document in the inbox
        
        var finalurl = url

        let dir = url.URLByDeletingLastPathComponent?.lastPathComponent
        if dir == "Inbox" {
            println("inbox")
            let fm = NSFileManager()
            var err : NSError?
            let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err)
            let dest = docsurl!.URLByAppendingPathComponent(url.lastPathComponent)
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
        
        let vc = self.window?.rootViewController as ViewController
        vc.displayPDF(finalurl)
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
