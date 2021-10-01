

import UIKit

class MyWindow : UIWindow {
    override func becomeKey() {
        print("my window become key")
        super.becomeKey()
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow? {
        didSet {
            print("window")
        }
    }

    override init() {
        print("scene delegate init!")
        super.init()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        // this doesn't work; if you do it, you have to go the whole way
        // and create the entire interface I think
        // self.window = UIWindow(windowScene: scene)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("scene became active")
    }

}

