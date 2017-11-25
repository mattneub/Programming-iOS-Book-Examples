

import UIKit
import AVFoundation

class MyDelegate : NSObject, AVSpeechSynthesizerDelegate {
    
}

class ViewController: UIViewController {
    
    var synth : AVSpeechSynthesizer!
    var del : MyDelegate! = MyDelegate()

    @IBAction func doButton1(_ sender: Any) {
        self.synth = AVSpeechSynthesizer()
        self.synth.delegate = self.del
    }
    
    let crash = true
    
    @IBAction func doButton2(_ sender: Any) {
        if crash {
            self.del = nil
        }
        if let s = self.synth {
            let utt = AVSpeechUtterance(string:"Hello, world!")
            s.speak(utt)
        }
    }

}

