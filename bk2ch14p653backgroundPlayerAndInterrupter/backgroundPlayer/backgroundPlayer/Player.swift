

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
    
    override init() {
        super.init()
        // interruption notification
        // note (irrelevant for bk 2, but useful for bk 1) how to prevent retain cycle
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionInterruptionNotification, object: nil, queue: nil) {
                [weak self](n:NSNotification) in
                guard let why =
                    n.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
                    else {return}
                guard let type = AVAudioSessionInterruptionType(rawValue: why)
                    else {return}
                if type == .Began {
                    print("interruption began:\n\(n.userInfo!)")
                } else {
                    print("interruption ended:\n\(n.userInfo!)")
                    guard let opt = n.userInfo![AVAudioSessionInterruptionOptionKey] as? UInt else {return}
                    let opts = AVAudioSessionInterruptionOptions(rawValue: opt)
                    if opts.contains(.ShouldResume) {
                        print("should resume")
                        self?.player.prepareToPlay()
                        let ok = self?.player.play()
                        print("bp tried to resume play: did I? \(ok)")
                    } else {
                        print("not should resume")
                    }
                }
        }
    }
    
    func playFileAtPath(path:String) {
        self.player?.delegate = nil
        self.player?.stop()
        let fileURL = NSURL(fileURLWithPath: path)
        print("bp making a new Player")
        guard let p = try? AVAudioPlayer(contentsOfURL: fileURL) else {return} // nicer
        self.player = p
        // error-checking omitted
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
        
        // try this, to prove that mixable _background_ sound is not interrupted by nonmixable foreground sound
        // I find this kind of weird; you aren't allowed to interrupt any sound you want to interrupt?
        // _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers)

        _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: [])
        
        
        self.player.prepareToPlay()
        self.player.delegate = self
        let ok = player.play()
        print("bp trying to play \(path): \(ok)")
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) { // *
        let sess = AVAudioSession.sharedInstance()
        _ = try? sess.setActive(false, withOptions: .NotifyOthersOnDeactivation)
        _ = try? sess.setCategory(AVAudioSessionCategoryAmbient, withOptions: [])
        _ = try? sess.setActive(true, withOptions: [])
        delegate?.soundFinished(self)
    }
    
    // to hear about interruptions, in iOS 8, use the session notifications
    
    func stop () {
        self.player?.pause()
    }
    
    deinit {
        print("bp player dealloc")
        if self.observer != nil {
            NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        }
        self.player?.delegate = nil
    }
    
    
}
