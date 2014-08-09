

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    let helper = SystemSoundHelper()

    // test on device (doesn't work in simulator)
    
    @IBAction func doButton (sender:AnyObject!) {
        let sndurl = NSBundle.mainBundle().URLForResource("test", withExtension: "aif")
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl, &snd)
        // unfortunately Swift cannot form a C function...
        // ...or create a pointer to a C function
        // so we have an Objective-C helper object that does both
        AudioServicesAddSystemSoundCompletion(snd, nil, nil, self.helper.completionHandler(), nil)
        AudioServicesPlaySystemSound(snd)
    }

}
