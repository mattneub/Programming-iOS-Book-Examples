
import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // new in iOS 9, can check beforehand
        let ok = AVAudioSession.sharedInstance().availableCategories.contains(AVAudioSessionCategoryAmbient)
        print(ok)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        // deliberate leak here
        
        NotificationCenter.default.addObserver(forName:
            .AVAudioSessionRouteChange, object: nil, queue: nil) {
                n in
                print("change route \(n.userInfo)")
                print("current route \(AVAudioSession.sharedInstance().currentRoute)")
        }
        // properly, if the route changes from some kind of Headphones to Built-In Speaker,
        // we should pause our sound (doesn't happen automatically)
        
        NotificationCenter.default.addObserver(forName:
            .AVAudioSessionInterruption, object: nil, queue: nil) {
                n in
                guard let why =
                    n.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
                    else {return}
                guard let type = AVAudioSessionInterruptionType(rawValue: why)
                    else {return}
                if type == .began {
                    print("interruption began:\n\(n.userInfo!)")
                } else {
                    print("interruption ended:\n\(n.userInfo!)")
                    guard let opt = n.userInfo![AVAudioSessionInterruptionOptionKey] as? UInt else {return}
                    let opts = AVAudioSessionInterruptionOptions(rawValue: opt)
                    if opts.contains(.shouldResume) {
                        print("should resume")
                    } else {
                        print("not should resume")
                    }
                }
        }
        
        // use control center to test, e.g. start and stop a Music song
        
        NotificationCenter.default.addObserver(forName:
            .AVAudioSessionSilenceSecondaryAudioHint, object: nil, queue: nil) {
                n in
                guard let why = n.userInfo?[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt else {return}
                guard let type = AVAudioSessionSilenceSecondaryAudioHintType(rawValue:why) else {return}
                if type == .begin {
                    print("silence hint begin:\n\(n.userInfo!)")
                } else {
                    print("silence hint end:\n\(n.userInfo!)")
                }
        }
        
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("app became active")
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("app will resign active")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app did enter background")
    }
}
