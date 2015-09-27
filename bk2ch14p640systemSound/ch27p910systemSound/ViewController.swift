

import UIKit
import AudioToolbox

// can be top level...

func soundFinished(snd:UInt32, _ c:UnsafeMutablePointer<Void>) -> Void {
    print("finished!")
    AudioServicesRemoveSystemSoundCompletion(snd)
    AudioServicesDisposeSystemSoundID(snd)
}



class ViewController: UIViewController {
    
    // test on device (doesn't work in simulator)
    
    // NB AudioServicesPlaySystemSound will be deprecated! This is just to show the old way

    @IBAction func doButton (sender:AnyObject!) {
        let sndurl = NSBundle.mainBundle().URLForResource("test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl, &snd)
        // ... or could be defined here
        // but it can't be a method
        AudioServicesAddSystemSoundCompletion(snd, nil, nil, soundFinished, nil)
        AudioServicesPlaySystemSound(snd)
    }
    
    @IBAction func doButton2 (sender:AnyObject!) {
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
