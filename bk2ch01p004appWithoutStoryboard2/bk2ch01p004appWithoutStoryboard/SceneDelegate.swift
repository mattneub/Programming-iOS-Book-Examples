
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window : UIWindow?
    
    func scene(_ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
            if let windowScene = scene as? UIWindowScene {
                self.window = UIWindow(windowScene: windowScene) //<1>
                let vc = ViewController()                      //<2>
                self.window!.rootViewController = vc             //<3>
                self.window!.makeKeyAndVisible()                 //<4>
                
                self.window!.backgroundColor = .red
            }
    }


}
    

