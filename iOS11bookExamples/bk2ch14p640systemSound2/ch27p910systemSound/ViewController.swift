

import UIKit
import AudioToolbox


class ViewController: UIViewController {
        
    // cool new iOS 9 way: pass the sound and the completion handler all in one call

    @IBAction func doButton (_ sender: Any!) {
        let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
        AudioServicesPlaySystemSoundWithCompletion(snd) {
            AudioServicesDisposeSystemSoundID(snd)
            print("finished!")
        }
    }


    
}
