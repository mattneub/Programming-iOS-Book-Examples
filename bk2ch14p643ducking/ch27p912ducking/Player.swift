

import UIKit
import AVFoundation
import MediaPlayer

protocol PlayerDelegate : class {
    func soundFinished(sender : AnyObject)
}

class Player : NSObject, AVAudioPlayerDelegate {
    var player : AVAudioPlayer!
    var forever = false
    weak var delegate : PlayerDelegate?

    func playFileAtPath(path:String) {
        self.player?.delegate = nil
        self.player?.stop()
        let fileURL = NSURL(fileURLWithPath: path)
        self.player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
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
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle:"This Is a Test",
            MPMediaItemPropertyArtist:"Matt Neuburg"
        ]
    }
    
    // delegate method
    func audioPlayerDidFinishPlaying(AVAudioPlayer!, successfully: Bool) {
        self.delegate?.soundFinished(self)
    }
    
    /* 
    NB! delegate interruption methods deprecated in iOS 8
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        println("audio player interrupted")
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer!, withOptions flags: Int) {
        println("audio player ended interruption, options \(flags)")
    }

    */
    
    func stop () {
        self.player?.pause()
    }

    deinit {
        self.player?.delegate = nil
    }


}
