

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
        guard let p = try? AVAudioPlayer(contentsOfURL: fileURL) else {return} // nicer
        self.player = p
        // error-checking omitted
        
        // switch to playback category while playing, interrupt background audio
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
        _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: [])
        
        self.player.prepareToPlay()
        self.player.delegate = self
        let ok = self.player.play()
        print("interrupter trying to play \(path): \(ok)")
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) { // *
        let sess = AVAudioSession.sharedInstance()
        // this is the key move
        _ = try? sess.setActive(false, withOptions: .NotifyOthersOnDeactivation)
        // now go back to ambient
        _ = try? sess.setCategory(AVAudioSessionCategoryAmbient, withOptions: [])
        _ = try? sess.setActive(true, withOptions: [])
        delegate?.soundFinished(self)
    }
    
    // to hear about interruptions, in iOS 8, use the session notifications
    
    func stop () {
        self.player?.pause()
    }
    
    deinit {
        print("interrupter player dealloc")
        self.player?.delegate = nil
    }
    
    
}
