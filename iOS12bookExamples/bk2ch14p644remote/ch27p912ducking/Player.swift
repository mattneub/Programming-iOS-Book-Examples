

import UIKit
import AVFoundation
import MediaPlayer

protocol PlayerDelegate : class {
    func soundFinished(_ sender: Any)
}

class Player : NSObject, AVAudioPlayerDelegate {
    var player : AVAudioPlayer!
    var forever = false
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
        if self.forever {
            self.player.numberOfLoops = -1
        }
        
//        player.enableRate = true
//        player.rate = 1.2 // cool feature
        
        self.player.play()
        
        // cute little demo
        let mpic = MPNowPlayingInfoCenter.default()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle:"This Is a Test",
            MPMediaItemPropertyArtist:"Matt Neuburg"
        ]
    }
    
    // delegate method
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) { // *
        self.delegate?.soundFinished(self)
    }
        
    func stop () {
        self.player?.pause()
    }

    deinit {
        self.player?.delegate = nil
    }


}
