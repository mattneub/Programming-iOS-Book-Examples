

import UIKit

// new in Swift 5.3, instead of your own main.swift file you can have Swift generate it
// you mark a struct as `@main` and provide a `main()` static func
// here you can do just what you would have done in the main.swift file!
@main
struct MyMain {
    static func main() -> Void {
         UIApplicationMain(
             CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self)
         )
    }
}

// look, ma, no @UIApplicationMain!
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // look, ma, no storyboard!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        self.window = self.window ?? UIWindow()
        self.window!.backgroundColor = .white
        self.window!.rootViewController = ViewController()
        self.window!.makeKeyAndVisible()
        return true
    }



}

