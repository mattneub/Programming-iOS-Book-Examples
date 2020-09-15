
import UIKit
import AVFoundation

// nb test on device

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode:.default)
        try? AVAudioSession.sharedInstance().setActive(true)

        NotificationCenter.default.addObserver(forName:
            AVAudioSession.interruptionNotification, object: nil, queue: nil) {
                n in
                let why = n.userInfo![AVAudioSessionInterruptionTypeKey] as! UInt
                let type = AVAudioSession.InterruptionType(rawValue: why)!
                if type == .ended {
                    print("interruption ended, reactivating audio session")
                    try? AVAudioSession.sharedInstance().setActive(true)
                }
        }

        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("interrupter in \(#function)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("interrupter in \(#function)") // never received; the normal situation
    }
}
