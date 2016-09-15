import UIKit
import MediaPlayer

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NSNotificationCenter.defaultCenter().addObserverForName(MPMediaLibraryDidChangeNotification, object: nil, queue: nil) {
            _ in
            print("library changed!")
            print("library last modified \(MPMediaLibrary.defaultMediaLibrary().lastModifiedDate)")
        }
        MPMediaLibrary.defaultMediaLibrary().beginGeneratingLibraryChangeNotifications()
        print("library last modified \(MPMediaLibrary.defaultMediaLibrary().lastModifiedDate)")
        
        return true
    }
}

