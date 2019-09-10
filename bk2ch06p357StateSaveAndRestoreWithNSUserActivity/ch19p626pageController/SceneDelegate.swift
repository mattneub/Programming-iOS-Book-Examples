

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("will connect")
        guard let scene = (scene as? UIWindowScene) else { return }
        scene.userActivity =
            session.stateRestorationActivity ??
            NSUserActivity(activityType: "restoration")
        print("incoming activity is", scene.userActivity?.userInfo as Any)
        // my strategy: each v.c. must have a restorationInfo property...
        // ...and must be handed this userInfo as it is created...
        // ...before its viewDidLoad has a chance to run
        // but then it must destroy it when it no longer needs it!
        if let rvc = window?.rootViewController as? RootViewController {
            rvc.restorationInfo = scene.userActivity?.userInfo
        }
    }
    
    // "Each key and value must be of the following types: NSArray, NSData, NSDate, NSDictionary, NSNull, NSNumber, NSSet, NSString, NSURL, or NSUUID"
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity // cause other v.c.'s `update` to be called
    }
    
    /*
     After calling this method, and before archiving the NSUserActivity object and saving it to disk, UIKit lets you add state information in the following ways:

     If the NSUserActivity object contains a delegate, UIKit calls the delegate's userActivityWillSave(_:) method.

     If the NSUserActivity object is assigned to the userActivity property of any responders, UIKit calls each responder's updateUserActivityState(_:) method.

     When reconnecting the scene later, UIKit includes the NSUserActivity object in the UIScene.ConnectionOptions passed to your scene delegate's scene(_:willConnectTo:options:) method.
     */
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print(userActivity)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

