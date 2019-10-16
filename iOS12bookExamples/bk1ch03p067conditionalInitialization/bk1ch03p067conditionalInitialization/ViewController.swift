

import UIKit
import AVFoundation

func imageOfSize(_ size:CGSize, _ whatToDraw:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    whatToDraw()
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return result
}


class RootViewController : UITableViewController {
    let cellBackgroundImage : UIImage = {
        return imageOfSize(CGSize(width:320, height:44)) {
            // ... drawing goes here ...
        }
    }()
    
    // let cellBackgroundImage2 : UIImage = self.makeTheImage() // illegal
    func makeTheImage() -> UIImage {
        return imageOfSize(CGSize(width:320, height:44)) {
            // ... drawing goes here ...
        }
    }
}


class ViewController: UIViewController {
    
    var dothis = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // showing that Swift no longer warns when AnyObject is implicitly assigned
        
        let arr = [1 as AnyObject, "howdy" as AnyObject]
        let thing = arr[0] // in Swift 1.2 and before we'd get a warning here
        _ = thing
        
        // however, the universal type is now Any (Xcode 8, seed 6)
        let arr2 : [Any] = [1,"howdy"]
        let thing2 = arr2[0] // no warning, it's okay
        _ = thing2
        
        // var opts1 = [.autoreverse, .repeat] // compile error
        
        let opts : UIView.AnimationOptions = [.autoreverse, .repeat]
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
            let bti = UIApplication.shared.beginBackgroundTask {
                    UIApplication.shared.endBackgroundTask(bti)
                } // error: variable used within its own initial value
        }
*/
        /*
        do {
            var bti : UIBackgroundTaskIdentifier
            bti = UIApplication.shared.beginBackgroundTask {
                    UIApplication.shared.endBackgroundTask(bti)
                } // error: variable captured by a closure before being initialized
        }
*/
        do {
            var bti : UIBackgroundTaskIdentifier = .invalid
            bti = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(bti)
            }
        }
        
        // but Joe Groff points out that this might be a better way to write it
        
        do {
            var bti : UIBackgroundTaskIdentifier?
            bti = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(bti!)
            }
        }
    }
    
}
