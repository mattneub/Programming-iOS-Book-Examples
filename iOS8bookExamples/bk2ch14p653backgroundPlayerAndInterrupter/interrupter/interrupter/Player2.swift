

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
    var observer : NSObjectProtocol!
    var observer2 : NSObjectProtocol!
    
    func playFileAtPath(path:String) {
        self.player?.delegate = nil
        self.player?.stop()
        let fileURL = NSURL(fileURLWithPath: path)
        self.player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        // error-checking omitted
        
        // switch to playback category while playing, interrupt background audio
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
        
        self.player.prepareToPlay()
        self.player.delegate = self
        let ok = player.play()
        println("interrupter trying to play \(path): \(ok)")
    }
    
    func audioPlayerDidFinishPlaying(AVAudioPlayer!, successfully: Bool) {
        let sess = AVAudioSession.sharedInstance()
        // this is the key move
        sess.setActive(false, withOptions: .OptionNotifyOthersOnDeactivation, error: nil)
        // now go back to ambient
        sess.setCategory(AVAudioSessionCategoryAmbient, withOptions: nil, error: nil)
        sess.setActive(true, withOptions: nil, error: nil)
        delegate?.soundFinished(self)
    }
    
    // to hear about interruptions, in iOS 8, use the session notifications
    
    func stop () {
        self.player?.pause()
    }
    
    deinit {
        println("interrupter player dealloc")
        self.player?.delegate = nil
    }
    
    
}
