
import UIKit
import SwiftUI
import Combine

class Defaults : ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    var username : String {
        get {
            UserDefaults.standard.string(forKey: "name") ?? ""
        }
        set {
            self.objectWillChange.send()
            UserDefaults.standard.set(newValue, forKey: "name")
        }
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController =
                UIHostingController(
                    rootView: ContentView()
                       .environmentObject(Defaults())
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

