
import UIKit


@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
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
        print("scene config")
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        config.storyboard = UIStoryboard(name: "Main", bundle: nil)
        return config
    }


}
