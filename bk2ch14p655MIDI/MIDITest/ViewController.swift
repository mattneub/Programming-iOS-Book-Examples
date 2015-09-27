

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player : AVMIDIPlayer!
    var engine = AVAudioEngine()
    var seq : AVAudioSequencer!

    @IBAction func doButton(sender: AnyObject) {
        
        let midurl = NSBundle.mainBundle().URLForResource("presto", withExtension: "mid")!
        let sndurl = NSBundle.mainBundle().URLForResource("PianoBell", withExtension: "sf2")!
        
        var which : Int { return 2 } // 1 or 2
        
        switch which {
        case 1:
            self.player = try! AVMIDIPlayer(contentsOfURL: midurl, soundBankURL: sndurl)
            self.player.prepareToPlay()
            self.player.play(nil)
        case 2:
            let unit = AVAudioUnitSampler()
            engine.attachNode(unit)
            let mixer = engine.outputNode
            engine.connect(unit, to: mixer, format: mixer.outputFormatForBus(0))
            
            try! unit.loadInstrumentAtURL(sndurl) // do this only after configuring engine
            
            self.seq = AVAudioSequencer(audioEngine: engine)
            try! self.seq.loadFromURL(midurl, options: [])
            
            engine.prepare()
            try! engine.start()
            
            try! self.seq.start()
        default: break
        }
        
        
        
    }


}

