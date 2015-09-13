

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var dothis = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // showing that Swift no longer warns when AnyObject is implicitly assigned
        
        let arr = [1 as AnyObject, "howdy" as AnyObject]
        let thing = arr[0] // in Swift 1.2 and before we'd get a warning here
        _ = thing
        
        // var opts = [.Autoreverse, .Repeat] // compile error
        
        let opts : UIViewAnimationOptions = [.Autoreverse, .Repeat]
        _ = opts
        
        if dothis {
            let asset = AVAsset()
            let track = asset.tracks[0]
            let duration : CMTime = track.timeRange.duration
            _ = duration
        }

        
    
    }
    
    // wrapped in a function so that `val` is unknown to the compiler
    func conditionalInitializationExample(val:Int) {
        
        let timed : Bool
        if val == 1 {
            timed = true
        } else {
            timed = false
        }
        
        _ = timed
        
    }
    
    // but in that case I would rather use a computed initializer:
    func computedInitializerExample(val:Int) {
        
        let timed : Bool = {
            if val == 1 {
                return true
            } else {
                return false
            }
        }()

        _ = timed
        
    }
    
    func btiExample() {
        /*
        do {
            let bti = UIApplication.sharedApplication()
                .beginBackgroundTaskWithExpirationHandler({
                    UIApplication.sharedApplication().endBackgroundTask(bti)
                }) // error: variable used within its own initial value
        }
*/
        /*
        do {
            var bti : UIBackgroundTaskIdentifier
            bti = UIApplication.sharedApplication()
                .beginBackgroundTaskWithExpirationHandler({
                    UIApplication.sharedApplication().endBackgroundTask(bti)
                }) // error: variable captured by a closure before being initialized
        }
*/
        do {
            var bti : UIBackgroundTaskIdentifier = 0
            bti = UIApplication.sharedApplication()
                .beginBackgroundTaskWithExpirationHandler({
                    UIApplication.sharedApplication().endBackgroundTask(bti)
                })

        }

    }
    


}

