
import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var ob : NSKeyValueObservation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        // new in iOS 9, can check beforehand
        let ok = AVAudioSession.sharedInstance().availableCategories.contains(.ambient)
        print(ok)
        let cat = AVAudioSession.sharedInstance().category
        print(cat)
        // default is solo ambient
        
        let sess = AVAudioSession.sharedInstance()
        try? sess.setCategory(.ambient, mode:.default)
        try? sess.setActive(true)
        print("secondary hint? ", sess.secondaryAudioShouldBeSilencedHint)

        
        // deliberate leak here
        
        NotificationCenter.default.addObserver(forName:
            AVAudioSession.routeChangeNotification, object: nil, queue: nil) {
                n in
                NSLog("change route %@", n.userInfo!)
                print("current route \(AVAudioSession.sharedInstance().currentRoute)")
        }
        // properly, if the route changes from some kind of Headphones to Built-In Speaker,
        // we should pause our sound (doesn't happen automatically)
        
        NotificationCenter.default.addObserver(forName:
        AVAudioSession.interruptionNotification, object: nil, queue: nil) {
                n in
                // sure takes a long time for end interruption notification arrive
                let why = n.userInfo![AVAudioSessionInterruptionTypeKey] as! UInt
                let type = AVAudioSession.InterruptionType(rawValue: why)!
                switch type {
                case .began:
                    print("interruption began:\n\(n.userInfo!)")
                case .ended:
                    print("interruption ended:\n\(n.userInfo!)")
                    try? AVAudioSession.sharedInstance().setActive(true)
                    guard let opt = n.userInfo![AVAudioSessionInterruptionOptionKey] as? UInt else {return}
                    if AVAudioSession.InterruptionOptions(rawValue:opt).contains(.shouldResume) {
                        print("should resume")
                    } else {
                        print("not should resume")
                    }
                @unknown default: fatalError()
                }
        }
        
        // use control center to test, e.g. start and stop a Music song
        // need to be _ambient_ (not solo ambient) to get this
        
        NotificationCenter.default.addObserver(forName:
            AVAudioSession.silenceSecondaryAudioHintNotification, object: nil, queue: nil) { n in
                let why = n.userInfo![AVAudioSessionSilenceSecondaryAudioHintTypeKey] as! UInt
                let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: why)!
                switch type {
                case .begin:
                    print("silence hint begin:\n\(n.userInfo!)")
                case .end:
                    print("silence hint end:\n\(n.userInfo!)")
                @unknown default: fatalError()
                }
        }
        
        let ob = AVAudioSession.sharedInstance().observe(\.promptStyle) { (sess, ch) in
            print(ch) // never prints so I guess I don't know the circumstances
        }
        self.ob = ob
                
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("app became active")
        let sess = AVAudioSession.sharedInstance()
        print("secondary hint? ", sess.secondaryAudioShouldBeSilencedHint)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("app will resign active")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app did enter background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("app will enter foreground")
    }
}


