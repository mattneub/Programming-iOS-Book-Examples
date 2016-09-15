

import UIKit
import AVFoundation

class ViewController: UIViewController, PlayerDelegate {
    var player = Player()
    
    // instructions: run the app on a device
    // play music with the iPod / Music app
    // tap the Once button to experience ducking
    
    // now tap the Forever button; we loop forever
    // switch out to the remote controls to stop play (see p. 650)
    
    // feel free to experiment further; if you set audio background mode in Info.plist,
    // then Forever even plays when we are in the background

    @IBAction func doButton (sender:AnyObject!) {
        self.player.delegate = self
        let path = NSBundle.mainBundle().pathForResource("test", ofType: "aif")!
        if (sender as! UIButton).currentTitle == "Forever" {
            // for remote control to work, our audio session policy must be Playback
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
            self.player.forever = true
        } else {
            // example works better if there is some background audio already playing
            let oth = AVAudioSession.sharedInstance().otherAudioPlaying
            print("other audio playing: \(oth)")
            // new iOS 8 feature! finer grained than merely whether other audio is playing
            let hint = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
            print("secondary hint: \(hint)")
            if !oth {
                let alert = UIAlertController(title: "Pointless", message: "You won't get the point of the example unless some other audio is already playing!", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            print("ducking")
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, withOptions: .DuckOthers)
            self.player.forever = false
        }
        self.player.playFileAtPath(path)
    }
    
    func soundFinished(sender: AnyObject) { // delegate message from Player
        self.unduck()
    }
    
    func unduck() {
        print("unducking")
        let sess = AVAudioSession.sharedInstance()
        _ = try? sess.setActive(false, withOptions: [])
        _ = try? sess.setCategory(AVAudioSessionCategoryAmbient, withOptions: [])
        _ = try? sess.setActive(true, withOptions: [])
    }
    
    // ======== respond to remote controls
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) { // *
        let rc = event!.subtype
        let p = self.player.player
        print("received remote control \(rc.rawValue)") // 101 = pause, 100 = play
        switch rc {
        case .RemoteControlTogglePlayPause:
            if p.playing { p.pause() } else { p.play() }
        case .RemoteControlPlay:
            p.play()
        case .RemoteControlPause:
            p.pause()
        default:break
        }

    }

    
}
