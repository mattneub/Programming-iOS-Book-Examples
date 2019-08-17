

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    
        self.window = self.window ?? UIWindow()
        self.window!.rootViewController = RootViewController() // now works!
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
    }
}

@available(iOS 13.0, *)
class SceneDelegate : UIResponder, UIWindowSceneDelegate {
    var window : UIWindow?
    func scene(_ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
            if let windowScene = scene as? UIWindowScene {
                print("here")
                self.window = UIWindow(windowScene: windowScene)
                self.window!.rootViewController = RootViewController() // now works!
                self.window!.backgroundColor = .white
                self.window!.makeKeyAndVisible()
            }
    }

}
