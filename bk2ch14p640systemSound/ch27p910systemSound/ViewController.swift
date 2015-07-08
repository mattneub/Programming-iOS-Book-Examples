

import UIKit
import AudioToolbox

// can be top level...

func soundFinished(snd:SystemSoundID, _ context:UnsafeMutablePointer<Void>) -> Void {
    print("finished!")
    AudioServicesRemoveSystemSoundCompletion(snd)
    AudioServicesDisposeSystemSoundID(snd)
}



class ViewController: UIViewController {
    
    // test on device (doesn't work in simulator)

    @IBAction func doButton (sender:AnyObject!) {
        let sndurl = NSBundle.mainBundle().URLForResource("test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl, &snd)
        // ... or could be defined here
        // but it can't be a method
        AudioServicesAddSystemSoundCompletion(snd, nil, nil, soundFinished, nil)
        AudioServicesPlaySystemSound(snd)
    }
    
    func doButton2 (sender:AnyObject!) { // not hooked to anything, just showing syntax
        let sndurl = NSBundle.mainBundle().URLForResource("test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl, &snd)
        // watch _this_ little move
        AudioServicesAddSystemSoundCompletion(snd, nil, nil, {
            sound, context in
            print("finished!")
            AudioServicesRemoveSystemSoundCompletion(sound)
            AudioServicesDisposeSystemSoundID(sound)
            }, nil)
        AudioServicesPlaySystemSound(snd)
    }


    
}
