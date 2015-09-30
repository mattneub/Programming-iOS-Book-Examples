

import UIKit
import AVFoundation
import MediaPlayer

protocol PlayerDelegate : class {
    func soundFinished(sender : AnyObject)
}

class Player : NSObject, AVAudioPlayerDelegate
{
    var player : AVAudioPlayer!
    var forever = false
    weak var delegate : PlayerDelegate?

    func playFileAtURL(fileURL:NSURL) {
        player?.delegate = nil
        player?.stop()
        player = try! AVAudioPlayer(contentsOfURL: fileURL)
        // error-checking omitted
        player.prepareToPlay()
        player.delegate = self
        if self.forever {
            self.player.numberOfLoops = -1
        }
        player.play()
        
    }
    
    // delegate method
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.soundFinished(self)
    }
        
    func stop () {
        player?.pause()
    }

    deinit {
        player?.delegate = nil
    }


}
