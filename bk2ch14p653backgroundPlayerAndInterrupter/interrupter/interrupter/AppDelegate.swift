
import UIKit
import AVFoundation

// nb test on device

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    // standard behavior: category is ambient, activate on app activate and after interruption ends
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        NSNotificationCenter.default().addObserver(forName:
            AVAudioSessionInterruptionNotification, object: nil, queue: nil) {
                (n:NSNotification) in
                guard let why =
                    n.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
                    else {return}
                guard let type = AVAudioSessionInterruptionType(rawValue: why)
                    else {return}
                if type == .ended {
                    _ = try? AVAudioSession.sharedInstance().setActive(true)
                }
        }

        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("interrupter in \(#function)")
        _ = try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("interrupter in \(#function)") // never received; the normal situation
    }
}
