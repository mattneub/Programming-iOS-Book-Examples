
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
                if why != nil {
                    let what = (why! as UInt == 1) ? "began" : "ended"
                    println("interruption \(what):\n\(note.userInfo!)")
                }
        })
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        println("app became active")
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
    }
}
