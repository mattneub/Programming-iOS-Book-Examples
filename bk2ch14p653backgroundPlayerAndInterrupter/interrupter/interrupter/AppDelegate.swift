
import UIKit
import AVFoundation

// nb test on device

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    // standard behavior: category is ambient, activate on app activate and after interruption ends
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, withOptions: [])
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionInterruptionNotification, object: nil, queue: nil) {
                (n:NSNotification) in
                guard let why =
                    n.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
                    else {return}
                guard let type = AVAudioSessionInterruptionType(rawValue: why)
                    else {return}
                if type == .Ended {
                    _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: [])
                }
        }

        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("interrupter in \(__FUNCTION__)")
        _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: [])
    }
    
    func applicationWillTerminate(application: UIApplication) {
        print("interrupter in \(__FUNCTION__)") // never received; the normal situation
    }
}
