
import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, withOptions: nil, error: nil)
        
        // deliberate leak here
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionRouteChangeNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                (note:NSNotification!) in
                println("change route \(note.userInfo)")
                println("current route \(AVAudioSession.sharedInstance().currentRoute)")
        })
        // properly, if the route changes from some kind of Headphones to Built-In Speaker,
        // we should pause our sound (doesn't happen automatically)
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionInterruptionNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                (note:NSNotification!) in
                let why : AnyObject? = note.userInfo?[AVAudioSessionInterruptionTypeKey]
                if let why = why as? UInt {
                    if let why = AVAudioSessionInterruptionType(rawValue: why) {
                        if why == .Began {
                            println("interruption began:\n\(note.userInfo!)")
                        } else {
                            println("interruption ended:\n\(note.userInfo!)")
                            let opt : AnyObject? = note.userInfo![AVAudioSessionInterruptionOptionKey]
                            if let opt = opt as? UInt {
                                let opts = AVAudioSessionInterruptionOptions(opt)
                                if opts == .OptionShouldResume {
                                    println("should resume")
                                } else {
                                    println("not should resume")
                                }
                            }
                        }
                    }
                }
        })
        
        // use control center to test, e.g. start and stop a Music song
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionSilenceSecondaryAudioHintNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                (note:NSNotification!) in
                let why : AnyObject? = note.userInfo?[AVAudioSessionSilenceSecondaryAudioHintTypeKey]
                if let why = why as? UInt {
                    if let why = AVAudioSessionSilenceSecondaryAudioHintType(rawValue:why) {
                        if why == .Begin {
                            println("silence hint begin:\n\(note.userInfo!)")
                        } else {
                            println("silence hint end:\n\(note.userInfo!)")
                        }
                    }
                }
            })
        
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        println("app became active")
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
    }
}
