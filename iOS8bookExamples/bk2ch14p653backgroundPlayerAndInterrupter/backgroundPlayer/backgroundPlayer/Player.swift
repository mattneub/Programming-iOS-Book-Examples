

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
            AVAudioSessionInterruptionNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                [weak self](n:NSNotification!) in
                let why : AnyObject? = n.userInfo?[AVAudioSessionInterruptionTypeKey]
                if let why = why as? UInt {
                    if let why = AVAudioSessionInterruptionType(rawValue: why) {
                        if why == .Began {
                            println("interruption began:\n\(n.userInfo!)")
                        } else {
                            println("interruption ended:\n\(n.userInfo!)")
                            let opt : AnyObject? = n.userInfo![AVAudioSessionInterruptionOptionKey]
                            if let opt = opt as? UInt {
                                let opts = AVAudioSessionInterruptionOptions(opt)
                                if opts == .OptionShouldResume {
                                    println("should resume")
                                    self?.player.prepareToPlay()
                                    let ok = self?.player.play()
                                    println("bp tried to resume play: did I? \(ok)")
                                } else {
                                    println("not should resume")
                                }
                            }
                        }
                    }
                }
        })
    }
    
    func playFileAtPath(path:String) {
        self.player?.delegate = nil
        self.player?.stop()
        let fileURL = NSURL(fileURLWithPath: path)
        println("bp making a new Player")
        self.player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        // error-checking omitted
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
        
        
        self.player.prepareToPlay()
        self.player.delegate = self
        let ok = player.play()
        println("bp trying to play \(path): \(ok)")
    }
    
    func audioPlayerDidFinishPlaying(AVAudioPlayer!, successfully: Bool) {
        let sess = AVAudioSession.sharedInstance()
        sess.setActive(false, withOptions: .OptionNotifyOthersOnDeactivation, error: nil)
        sess.setCategory(AVAudioSessionCategoryAmbient, withOptions: nil, error: nil)
        sess.setActive(true, withOptions: nil, error: nil)
        delegate?.soundFinished(self)
    }
    
    // to hear about interruptions, in iOS 8, use the session notifications
    
    func stop () {
        self.player?.pause()
    }
    
    deinit {
        println("bp player dealloc")
        if self.observer != nil {
            NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        }
        self.player?.delegate = nil
    }
    
    
}
