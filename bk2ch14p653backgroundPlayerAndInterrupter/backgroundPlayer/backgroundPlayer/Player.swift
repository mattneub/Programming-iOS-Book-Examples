

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
        println("bp making a new Player")
        // the idea here is to test what notifications we can get
        // there's a new iOS 8 way of dealing with "secondary audio" muting
        // i.e. you mute your soundtrack so user can listen to other music while using your app
        // we will only receive this *in the foreground*, when audio starts/stops in the background
        // so the way to test is: play Music app, then bring me to foreground,
        // then use remote control button on earbuds or control center to stop / start Music app!
        self.observer =
            NSNotificationCenter.defaultCenter()
                .addObserverForName(
                    AVAudioSessionSilenceSecondaryAudioHintNotification,
                    object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                        [weak self](note:NSNotification!) in
                        println("bp player: muting hint notification received")
                        let why : AnyObject? = note.userInfo?[
                            AVAudioSessionSilenceSecondaryAudioHintTypeKey
                        ]
                        if why != nil {
                            if let sself = self {
                                switch why! as UInt {
                                case 1: // began
                                    println("bp player: muting hint started")
                                case 0: // ended
                                    println("bp player: muting hint ended")
                                default:break
                                }
                            }
                        }
                })
        // interruption notification
        self.observer2 =
            NSNotificationCenter.defaultCenter()
                .addObserverForName(
                    AVAudioSessionInterruptionNotification,
                    object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                        [weak self](note:NSNotification!) in
                        println("bp player: interruption notification received")
                        // docs say same Hint key might appear in interruption notification
                        // but I've never actually seen that happen
                        // perhaps I just don't know the circumstances when this can happen
                        let why : AnyObject? = note.userInfo?[
                            AVAudioSessionSilenceSecondaryAudioHintTypeKey
                        ]
                        println("bp secondary silence hint in interruption: \(why)") // always nil
                        if why != nil { // never gotten to here
                            if let sself = self {
                                switch why! as UInt {
                                case 1: // began
                                    println("bp player: interruption with hint started at \(sself.player.currentTime)")
                                case 0: // ended
                                    println("bp player: interruption with hint ended")
                                default:break
                                }
                            }
                        }
                        // this is the one I seem to be able to receive
                        // just as in previous systems...
                        // and even then it only happens for apps like my Interrupter
                        // which add this option deliberately
                        let option : AnyObject? = note.userInfo?[
                            AVAudioSessionInterruptionOptionKey
                        ]
                        println("bp option: \(option)")
                        if option != nil {
                            if let sself = self {
                                switch option! as UInt {
                                case 0:
                                    println("bp player: interruption without resume option")
                                case 1:
                                    println("bp player: interruption with resume option")
                                    // I get this in background after using my Interrupter
                                    // respond by resuming in background
                                    sself.player.prepareToPlay()
                                    let ok = sself.player.play()
                                    println("bp tried to resume play: did I? \(ok)")
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
        player?.pause()
    }
    
    deinit {
        println("bp player dealloc")
        NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        NSNotificationCenter.defaultCenter().removeObserver(self.observer2)
        player?.delegate = nil
    }
    
    
}
