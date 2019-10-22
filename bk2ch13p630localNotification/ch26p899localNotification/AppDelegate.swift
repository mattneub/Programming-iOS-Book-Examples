
import UIKit
import UserNotifications
import AudioToolbox

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func beep() {
    let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
    var snd : SystemSoundID = 0
    AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
    AudioServicesPlaySystemSoundWithCompletion(snd) {
        AudioServicesDisposeSystemSoundID(snd)
    }
}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    let notifHelper = MyUserNotificationHelper()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // must set user notification center delegate before we finish launching!
        let center = UNUserNotificationCenter.current()
        center.delegate = self.notifHelper
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("start \(#function)")
        print("end \(#function)")
    }
    
    // cute feature, but it's a pity we can't prevent ourselves from being activated
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "coffee.schedule" {
            if let d = shortcutItem.userInfo {
                if let time = d["time"] as? Int {
                    // for debugging purposes, let's show an actual alert
                    let alert = UIAlertController(title: "Coffee!", message: "Coffee reminder scheduled in \(time) minutes", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.window!.rootViewController?.present(alert, animated: true)
                    completionHandler(true)
                }
            }
        }
        completionHandler(false) // really not sure what the point is
    }
}

@available(iOS 13.0, *)
class SceneDelegate : UIResponder, UIWindowSceneDelegate {
    var window : UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let shortcutItem = connectionOptions.shortcutItem {
            if shortcutItem.type == "coffee.schedule" {
                if let d = shortcutItem.userInfo {
                    if let time = d["time"] as? Int {
                        let alert = UIAlertController(title: "Coffee1", message: "Coffee reminder scheduled in \(time) minutes", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.window?.makeKeyAndVisible()
                        self.window?.rootViewController?.present(alert, animated: true)
                    }
                }
            }
        }
        if let resp = connectionOptions.notificationResponse {
            // under what circumstances does a notification arrive here?
            let title = resp.notification.request.content.title
            let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController?.present(alert, animated: true)
            // so the answer seems to be: only if the user taps the notification (i.e. not an action)
            // but I don't see the purpose of that,
            // since I also get the tap in `didReceive` anyway
        }
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "coffee.schedule" {
            if let d = shortcutItem.userInfo {
                if let time = d["time"] as? Int {
                    // for debugging purposes, let's show an actual alert
                    let alert = UIAlertController(title: "Coffee!", message: "Coffee reminder scheduled in \(time) minutes", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.window?.rootViewController?.present(alert, animated: true)
                    completionHandler(true)
                }
            }
        }
        completionHandler(false) // really not sure what the point is
    }
}
