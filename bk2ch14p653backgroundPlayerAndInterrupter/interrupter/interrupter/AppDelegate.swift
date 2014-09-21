
import UIKit
import AVFoundation

// nb test on device

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    // standard behavior: category is ambient, activate on app activate and after interruption ends
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, withOptions: nil, error: nil)
        
        NSNotificationCenter.defaultCenter().addObserverForName(AVAudioSessionInterruptionNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            (note:NSNotification!) -> Void in
            let which : AnyObject? = note.userInfo?[AVAudioSessionInterruptionTypeKey]
            if which != nil {
                if let began = which! as? UInt {
                    if began == 0 {
                        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
                    }
                }
            }
        }
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        println("interrupter in \(__FUNCTION__)")
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        println("interrupter in \(__FUNCTION__)") // never received; the normal situation
    }
}
