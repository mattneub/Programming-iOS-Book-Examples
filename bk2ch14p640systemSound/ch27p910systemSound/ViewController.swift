

import UIKit
import AudioToolbox

// can be top level...

func soundFinished(_ snd:UInt32, _ c:UnsafeMutableRawPointer?) {
    print("finished!")
    AudioServicesRemoveSystemSoundCompletion(snd)
    AudioServicesDisposeSystemSoundID(snd)
}


class ViewController: UIViewController {
        
    // NB AudioServicesPlaySystemSound will be deprecated! This is just to show the old way
    // still hasn't actually been deprecated though

    @IBAction func doButton (_ sender: Any!) {
        let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
        // ... or could be defined here
        // but it can't be a method
        AudioServicesAddSystemSoundCompletion(snd, nil, nil, soundFinished, nil)
        AudioServicesPlaySystemSound(snd)
    }
    
    @IBAction func doButton2 (_ sender: Any!) {
        let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
        // watch _this_ little move
        AudioServicesAddSystemSoundCompletion(snd, nil, nil, {snd, _ in
            print("finished!")
            AudioServicesRemoveSystemSoundCompletion(snd)
            AudioServicesDisposeSystemSoundID(snd)
            }, nil)
        AudioServicesPlaySystemSound(snd)
    }


    
}
