
import UIKit
import os.log

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

let log = OSLog(subsystem: "CoffeeTime", category: "Coffee")

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        os_log("%{public}@ %{public}@", log: log, launchOptions ?? [:], #function)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let scheme = url.scheme
        let host = url.host
        if scheme == "coffeetime" {
            os_log("%{public}@ %{public}@", log: log, self, #function)
            if let host = host, let min = Int(host) {
                print("got \(min) from our today extension")
                return true
            }
        }
        return false
    }
}

@available(iOS 13.0, *)
class SceneDelegate : UIResponder, UIWindowSceneDelegate {
    var window : UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        os_log("%{public}@ %{public}@", log: log, connectionOptions.urlContexts, #function)
        guard let url = connectionOptions.urlContexts.first?.url else { return }
        let scheme = url.scheme
        let host = url.host
        if scheme == "coffeetime" {
            if let host = host, let min = Int(host) {
                print("got \(min) from our today extension")
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        let scheme = url.scheme
        let host = url.host
        if scheme == "coffeetime" {
            os_log("%{public}@ %{public}@", log: log, self, #function)
            if let host = host, let min = Int(host) {
                print("got \(min) from our today extension")
            }
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }
    
}
