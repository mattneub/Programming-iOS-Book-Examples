import UIKit
import MediaPlayer
import AVFoundation

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        //try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        NotificationCenter.default.addObserver(forName:.MPMediaLibraryDidChange, object: nil, queue: nil) {
            _ in
            print("library changed!")
            print("library last modified \(MPMediaLibrary.default().lastModifiedDate)")
        }
        
        // NB this will trigger the authorization dialog, so we may as well
        // wrap it in a check
        
        checkForMusicLibraryAccess {
            MPMediaLibrary.default().beginGeneratingLibraryChangeNotifications()
            print("library last modified \(MPMediaLibrary.default().lastModifiedDate)")
        }
        
        return true
    }



    func applicationDidBecomeActive(_ application: UIApplication) {
        //try? AVAudioSession.sharedInstance().setActive(true)
    }

}

