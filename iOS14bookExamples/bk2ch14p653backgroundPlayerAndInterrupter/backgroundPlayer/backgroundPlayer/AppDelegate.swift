
import UIKit
import AVFoundation

// nb test on device

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var timer : Timer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("bp in \(#function)")
        return; // comment out to perform timer experiment
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval:1, target: self, selector: #selector(fired), userInfo: nil, repeats: true)
    }
    
    // timer fires while we are in background, provided
    // (1) we scheduled it before going into the background
    // (2) we are running in the background (i.e. playing)
    @objc func fired(_ timer:Timer) {
        print("bp timer fired")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("bp in \(#function)")
        print("bp state while entering background: \(application.applicationState.rawValue)")
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("bp in \(#function)")
    }
    
    // we are a player app, we activate playback category only when we actually start playing
    // the rest of the time we use ambient just so we have an active category
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("bp in \(#function)")
                
        // new iOS 8 feature
        let mute = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        let s = mute ? "to" : "not"
        print("I need \(s) mute my secondary audio at this point")
    }
    
    // trying killing app from app switcher while playing in background;
    // we receive this!
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("bp in \(#function)")
    }
}
