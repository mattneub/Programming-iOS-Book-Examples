

import UIKit

class MyWindow : UIWindow {
    override func becomeKey() {
        print("my window become key")
        super.becomeKey()
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow? = MyWindow() {
        didSet {
            print("window")
        }
    }

    override init() {
        print("scene delegate init!")
        super.init()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("scene became active")
    }

}

