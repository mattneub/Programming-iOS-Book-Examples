

import UIKit
import AVFoundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    
    var player : AVMIDIPlayer!
    var engine = AVAudioEngine()
    var seq : AVAudioSequencer!

    @IBAction func doButton(_ sender: Any) {
        
        let midurl = Bundle.main.url(forResource:"presto", withExtension: "mid")!
        let sndurl = Bundle.main.url(forResource:"PianoBell", withExtension: "sf2")!
        
        var which : Int { return 2 } // 1 or 2
        
        switch which {
        case 1:
            self.player = try! AVMIDIPlayer(contentsOf: midurl, soundBankURL: sndurl)
            self.player.prepareToPlay()
            self.player.play()
        case 2:
            // self.engine.isAutoShutdownEnabled = true // doesn't help
            let unit = AVAudioUnitSampler()
            self.engine.attach(unit)
            let mixer = self.engine.outputNode
            self.engine.connect(unit, to: mixer, format: mixer.outputFormat(forBus:0))
            
            try! unit.loadInstrument(at:sndurl) // do this only after configuring engine
            
            self.seq = AVAudioSequencer(audioEngine: self.engine)
            try! self.seq.load(from:midurl)
            
            self.engine.prepare()
            try! engine.start()
            
            try! self.seq.start()
            
        default: break
        }
        
        
        
    }


}

