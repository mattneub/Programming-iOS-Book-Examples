

import UIKit
import os.log

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
        print("will connect", session.persistentIdentifier, window as Any)
        print("scene title", scene.title as Any)
        guard let scene = (scene as? UIWindowScene) else { return }
        
        scene.userActivity =
            session.stateRestorationActivity ??
            NSUserActivity(activityType: "com.neuburg.mw.restoration")
        
        // look for conditions under which we are an independent pep editor
        // either we've just been told to make a new editor...
        var pepName = ""
        let key = PepEditorViewController.whichPepBoyWeAreEditing
        let type = PepEditorViewController.newEditorActivityType
        if let act = connectionOptions.userActivities.first(where: {
            $0.activityType == type
        }) {
            if let pep = act.userInfo?[key] as? String {
                print("I have new window activity")
                pepName = pep
            }
        }
        // ...or we're restoring an independent editor
        if let pep = scene.userActivity?.userInfo?[key] as? String {
            let idkey = PepEditorViewController.sessionid
            if let id = scene.userActivity?.userInfo?[idkey] as? String {
                print("I have a whichPepBoyWeAreEditing key")
                if id == session.persistentIdentifier {
                    print("and I have an identifier match")
                    pepName = pep
                }
            }
        }
        // if either of those is true, make an independent editor and stop
        if !pepName.isEmpty {
            scene.title = "Editing"
            let s = scene.session.configuration.storyboard!
            let peped = s.instantiateViewController(identifier: "pepEditor") as! PepEditorViewController
            peped.pepName = pepName
            self.window?.rootViewController = peped
            peped.restorationInfo = scene.userActivity?.userInfo
            return
        }
        
        print("I have none of those, starting at the root")
        if let rvc = window?.rootViewController as? RootViewController {
            rvc.restorationInfo = scene.userActivity?.userInfo
        }

    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        os_log("%{public}@ %{public}@", log: log, self, #function)
        print("scene state restoration activity called")
        return scene.userActivity
    }
    
    /*
     After calling this method, and before archiving the NSUserActivity object and saving it to disk, UIKit lets you add state information in the following ways:

     If the NSUserActivity object contains a delegate, UIKit calls the delegate's userActivityWillSave(_:) method.

     If the NSUserActivity object is assigned to the userActivity property of any responders, UIKit calls each responder's updateUserActivityState(_:) method.

     When reconnecting the scene later, UIKit includes the NSUserActivity object in the UIScene.ConnectionOptions passed to your scene delegate's scene(_:willConnectTo:options:) method.
     */
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        os_log("%{public}@ %{public}@", log: log, self, #function)
    }


}

