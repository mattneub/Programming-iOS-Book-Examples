

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player : AVMIDIPlayer!
    var engine = AVAudioEngine()
    var seq : AVAudioSequencer!

    @IBAction func doButton(_ sender: Any) {
        
        let midurl = Bundle.main.urlForResource("presto", withExtension: "mid")!
        let sndurl = Bundle.main.urlForResource("PianoBell", withExtension: "sf2")!
        
        var which : Int { return 2 } // 1 or 2
        
        switch which {
        case 1:
            self.player = try! AVMIDIPlayer(contentsOf: midurl, soundBankURL: sndurl)
            self.player.prepareToPlay()
            self.player.play(nil)
        case 2:
            let unit = AVAudioUnitSampler()
            engine.attach(unit)
            let mixer = engine.outputNode
            engine.connect(unit, to: mixer, format: mixer.outputFormat(forBus:0))
            
            try! unit.loadInstrument(at:sndurl) // do this only after configuring engine
            
            self.seq = AVAudioSequencer(audioEngine: engine)
            try! self.seq.load(from:midurl)
            
            engine.prepare()
            try! engine.start()
            
            try! self.seq.start()
        default: break
        }
        
        
        
    }


}

