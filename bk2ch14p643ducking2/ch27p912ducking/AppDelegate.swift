
import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // new in iOS 9, can check beforehand
        let ok = AVAudioSession.sharedInstance().availableCategories.contains(AVAudioSessionCategoryAmbient)
        print(ok)
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, withOptions: [])
        
        // deliberate leak here
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionRouteChangeNotification, object: nil, queue: nil) {
                (note:NSNotification!) in
                print("change route \(note.userInfo)")
                print("current route \(AVAudioSession.sharedInstance().currentRoute)")
        }
        // properly, if the route changes from some kind of Headphones to Built-In Speaker,
        // we should pause our sound (doesn't happen automatically)
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionInterruptionNotification, object: nil, queue: nil) {
                (n:NSNotification) in
                guard let why =
                    n.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
                    else {return}
                guard let type = AVAudioSessionInterruptionType(rawValue: why)
                    else {return}
                if type == .Began {
                    print("interruption began:\n\(n.userInfo!)")
                } else {
                    print("interruption ended:\n\(n.userInfo!)")
                    guard let opt = n.userInfo![AVAudioSessionInterruptionOptionKey] as? UInt else {return}
                    let opts = AVAudioSessionInterruptionOptions(rawValue: opt)
                    if opts.contains(.ShouldResume) {
                        print("should resume")
                    } else {
                        print("not should resume")
                    }
                }
        }
        
        // use control center to test, e.g. start and stop a Music song
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionSilenceSecondaryAudioHintNotification, object: nil, queue: nil) {
                (n:NSNotification) in
                guard let why = n.userInfo?[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt else {return}
                guard let type = AVAudioSessionSilenceSecondaryAudioHintType(rawValue:why) else {return}
                if type == .Begin {
                    print("silence hint begin:\n\(n.userInfo!)")
                } else {
                    print("silence hint end:\n\(n.userInfo!)")
                }
        }
        
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("app became active")
        _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: [])
    }
    
    func applicationWillResignActive(application: UIApplication) {
        print("app will resign active")
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        print("app did enter background")
    }
}
