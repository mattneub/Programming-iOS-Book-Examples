

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
    var observer : NSObjectProtocol!
    var observer2 : NSObjectProtocol!
    
    override init() {
        super.init()
        println("interrupter making a new Player")
        // the idea here is to test what notifications we can get
        // first, there's supposedly a new iOS 8 of dealing with "secondary audio" muting
        // however, so far I have never actually received this one
        self.observer =
            NSNotificationCenter.defaultCenter()
                .addObserverForName(
                    AVAudioSessionSilenceSecondaryAudioHintNotification,
                    object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                        [weak self](note:NSNotification!) in
                        println("interrupter player: muting hint notification received") // not receiving this
                        let why = note.userInfo[
                            AVAudioSessionSilenceSecondaryAudioHintTypeKey
                            ]! as? UInt
                        if let sself = self {
                            switch why! {
                            case 1: // began
                                println("interrupter player: muting hint started at \(sself.player.currentTime)")
                            case 0: // ended
                                println("interrupter player: muting hint ended")
                            default:break
                            }
                        }
                })
        // it is said that same Hint key might appear in interruption notification instead
        // but again, I've never actually seen that happen
        self.observer2 =
            NSNotificationCenter.defaultCenter()
                .addObserverForName(
                    AVAudioSessionInterruptionNotification,
                    object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                        [weak self](note:NSNotification!) in
                        println("interrupter player: interruption notification received")
                        let why : AnyObject? = note.userInfo[
                            AVAudioSessionSilenceSecondaryAudioHintTypeKey
                        ]
                        println("interrupter hint: \(why)") // always nil
                        if why != nil {
                            if let sself = self {
                                switch why! as UInt {
                                case 1: // began
                                    println("interrupter player: interruption with hint started at \(sself.player.currentTime)")
                                case 0: // ended
                                    println("interrupter player: interruption with hint ended")
                                default:break
                                }
                            }
                        }
                        // this is the only one I seem to be able to receive
                        // just as in previous systems...
                        // and even then it only happens for apps like my Interrupter
                        // which add this option deliberately
                        let option : AnyObject? = note.userInfo[
                            AVAudioSessionInterruptionOptionKey
                        ]
                        println("interrupter option: \(option)")
                        if option != nil {
                            if let sself = self {
                                switch option! as UInt {
                                case 0:
                                    println("interrupter player: interruption without resume option")
                                case 1:
                                    println("interrupter player: interruption with resume option")
                                    // I do get this in background using my Interrupter
                                    // respond by resuming in background
                                    sself.player.prepareToPlay()
                                    let ok = sself.player.play()
                                    println("interrupter tried to resume play: did I? \(ok)")
                                default:break
                                }
                            }
                        }
                })
        
    }
    
    func playFileAtPath(path:NSString) {
        player?.delegate = nil
        player?.stop()
        let fileURL = NSURL(fileURLWithPath: path)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        // error-checking omitted
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
        
        //        player.enableRate = true
        //        player.rate = 1.2 // cool feature
        
        player.prepareToPlay()
        player.delegate = self
        let ok = player.play()
        println("interrupter trying to play \(path): \(ok)")
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
        player?.pause()
    }
    
    deinit {
        println("interrupter player dealloc")
        NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        NSNotificationCenter.defaultCenter().removeObserver(self.observer2)
        player?.delegate = nil
    }
    
    
}
