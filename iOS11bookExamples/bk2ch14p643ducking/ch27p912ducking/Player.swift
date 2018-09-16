

import UIKit
import AVFoundation
import MediaPlayer

protocol PlayerDelegate : class {
    func soundFinished(_ sender: Any)
}

class Player : NSObject, AVAudioPlayerDelegate {
    var player : AVAudioPlayer!
    var looping = false
    weak var delegate : PlayerDelegate?

    func playFile(atPath path:String) {
        self.player?.delegate = nil
        self.player?.stop()
        let fileURL = URL(fileURLWithPath: path)
        guard let p = try? AVAudioPlayer(contentsOf: fileURL) else {return} // nicer
        self.player = p
        // error-checking omitted
        self.player.prepareToPlay()
        self.player.delegate = self
        if self.looping {
            self.player.numberOfLoops = -1
        }
        
//        player.enableRate = true
//        player.rate = 1.2 // cool feature
        
        self.player.play()
        
    }
    
    // delegate method
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) { // *
        self.delegate?.soundFinished(self)
    }
        
    func stop () {
        self.player?.stop()
    }

    deinit {
        self.player?.delegate = nil
    }


}
