import UIKit
import MediaPlayer

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        
        NotificationCenter.default.addObserver(forName:.MPMediaLibraryDidChange, object: nil, queue: nil) {
            _ in
            print("library changed!")
            print("library last modified \(MPMediaLibrary.default().lastModifiedDate)")
        }
        MPMediaLibrary.default().beginGeneratingLibraryChangeNotifications()
        print("library last modified \(MPMediaLibrary.default().lastModifiedDate)")
        
        return true
    }
}

