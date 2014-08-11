

import UIKIt
import AVFoundation
import MediaPlayer

@objc protocol PlayerDelegate {
    func soundFinished(sender : AnyObject)
}

class Player : NSObject, AVAudioPlayerDelegate {
    var player : AVAudioPlayer!
    var forever = false
    weak var delegate : PlayerDelegate?

    func playFileAtPath(path:NSString) {
        player?.delegate = nil
        player?.stop()
        let fileURL = NSURL(fileURLWithPath: path)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        // error-checking omitted
        player.prepareToPlay()
        player.delegate = self
        if self.forever {
            self.player.numberOfLoops = -1
        }
        player.play()
        
        // cute little demo
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        mpic.nowPlayingInfo = [MPMediaItemPropertyTitle:"This Is a Test"]
    }
    
    // delegate method
    func audioPlayerDidFinishPlaying(AVAudioPlayer!, successfully: Bool) {
        delegate?.soundFinished(self)
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
        player?.pause()
    }

    deinit {
        player?.delegate = nil
    }


}
