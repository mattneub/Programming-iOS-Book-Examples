
import UIKit
import AVFoundation

// nb test on device

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    // standard behavior: category is ambient, activate on app activate and after interruption ends
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        NotificationCenter.default.addObserver(forName:
            .AVAudioSessionInterruption, object: nil, queue: nil) {
                n in
                let why = n.userInfo![AVAudioSessionInterruptionTypeKey] as! UInt
                let type = AVAudioSessionInterruptionType(rawValue: why)!
                if type == .ended {
                    try? AVAudioSession.sharedInstance().setActive(true)
                }
        }

        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("interrupter in \(#function)")
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("interrupter in \(#function)") // never received; the normal situation
    }
}
