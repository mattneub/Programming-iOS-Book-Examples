
import UIKit
import os.log

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


let mylog = OSLog(subsystem: "fileHandoff", category: "testing")

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        print("start \(#function)")
        print("end \(#function)")
        if let d = launchOptions {
            os_log("launching %{public}@", log: mylog, type: .default, d as NSDictionary)
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print("start \(#function)")
        print(url)
        
        
        var finalurl = url
        
        // work around bug where Quick Look can no longer preview a document in the inbox
        // okay, they seem to have fixed the bug in iOS 9, cutting for now
        
        /*

        let dir = url.URLByDeletingLastPathComponent?.lastPathComponent
        if dir == "Inbox" {
            do {
                print("inbox")
                let fm = FileManager.default
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
        vc.displayDoc(url: finalurl)
        print("end \(#function)")
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("start \(#function)")
        print("end \(#function)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("start \(#function)")
        print("end \(#function)")
    }
    
    // logging shows that handleOpenURL: comes *between* willEnter and didBecome

}

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("start \(#function)")
        print("end \(#function)")
        let cons = connectionOptions.urlContexts
        os_log("connect %{public}@", log: mylog, type: .default, cons)
        print("cons", cons)
//        if let _ = scene as? UIWindowScene {
            if let vc = self.window?.rootViewController as? ViewController,
                let url = cons.first?.url {
                vc.loadViewIfNeeded() // can't call method until we have a view
                vc.displayDoc(url: url)
            }
//        }
    }
        
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("open context", URLContexts.first?.url as Any)
        let cons = URLContexts.first!.url as NSURL
        os_log("open context %{public}@", log: mylog, type: .default, cons)
        if let vc = self.window?.rootViewController as? ViewController,
            let url = URLContexts.first?.url {
            vc.displayDoc(url: url)
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("start \(#function)")
        print("end \(#function)")
        os_log("foreground", log: mylog, type: .default)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("start \(#function)")
        print("end \(#function)")
        os_log("active", log: mylog, type: .default)
    }

}
