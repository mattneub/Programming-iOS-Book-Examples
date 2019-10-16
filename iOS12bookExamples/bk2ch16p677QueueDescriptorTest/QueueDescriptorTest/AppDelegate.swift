
import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode:.default)
        try? AVAudioSession.sharedInstance().setActive(true)
        NotificationCenter.default.addObserver(forName:
        AVAudioSession.interruptionNotification, object: nil, queue: nil) { n in
            let why = n.userInfo![AVAudioSessionInterruptionTypeKey] as! UInt
            let type = AVAudioSession.InterruptionType(rawValue: why)!
            switch type {
            case .began:
                // update interface if needed
                print("interruption began")
            case .ended:
                try? AVAudioSession.sharedInstance().setActive(true)
                // update interface if needed
                // resume playback?
                print("interruption ended")
            }
        }

        return true
    }


}

