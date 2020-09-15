
import UIKit
import os.log

let log = OSLog(subsystem: "MultipleWindows", category: "TestingMultiple")

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        os_log("%{public}@ %{public}@", log: log, self, #function)
        return true
    }
    
    /*
        <key>UIWindowSceneSessionRoleApplication</key>
        <array>
            <dict>
                <key>Class Name NOT</key>
                <string></string>
                <key>UISceneDelegateClassName</key>
                <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
                <key>UISceneConfigurationName</key>
                <string>Default Configuration</string>
                <key>UISceneStoryboardFile</key>
                <string>Main</string>
            </dict>
        </array>
*/
    
    // can do here what we would do in Info.plist
    // NB to test, be sure to kill all sessions first! otherwise not a cold launch
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("scene config", options)
        // let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: .windowApplication)
        config.delegateClass = SceneDelegate.self
        config.storyboard = UIStoryboard(name: "Main", bundle: nil)
        os_log("%{public}@ %{public}@", log: log, self, #function)
        return config
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("did discard") // e.g. user swiped up? but I'm not seeing it
        // video says can be delayed, but for me it never seems to come in
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }


}
