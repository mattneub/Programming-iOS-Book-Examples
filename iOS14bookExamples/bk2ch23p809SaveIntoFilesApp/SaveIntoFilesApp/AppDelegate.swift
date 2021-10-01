

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var ubiq : URL!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        DispatchQueue.global(qos:.default).async {
            let fm = FileManager.default
            let ubiq = fm.url(forUbiquityContainerIdentifier:nil)
            print("ubiq: \(ubiq as Any)")
            DispatchQueue.main.async {
                self.ubiq = ubiq
            }
        }

        return true
    }



}

