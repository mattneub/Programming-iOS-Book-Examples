

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

    @IBAction func doButton (_ sender:AnyObject!) {
        self.player.delegate = self
        let path = NSBundle.main().pathForResource("test", ofType: "aif")!
        if (sender as! UIButton).currentTitle == "Forever" {
            // for remote control to work, our audio session policy must be Playback
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            self.player.forever = true
        } else {
            // example works better if there is some background audio already playing
            let oth = AVAudioSession.sharedInstance().isOtherAudioPlaying
            print("other audio playing: \(oth)")
            // new iOS 8 feature! finer grained than merely whether other audio is playing
            let hint = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
            print("secondary hint: \(hint)")
            if !oth {
                let alert = UIAlertController(title: "Pointless", message: "You won't get the point of the example unless some other audio is already playing!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
                return
            }
            print("ducking")
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: .duckOthers)
            self.player.forever = false
        }
        self.player.playFile(atPath:path)
    }
    
    func soundFinished(_ sender: AnyObject) { // delegate message from Player
        self.unduck()
    }
    
    func unduck() {
        print("unducking")
        let sess = AVAudioSession.sharedInstance()
        _ = try? sess.setActive(false)
        _ = try? sess.setCategory(AVAudioSessionCategoryAmbient)
        _ = try? sess.setActive(true)
    }
    
    // ======== respond to remote controls
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared().beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceived(with event: UIEvent?) { // *
        let rc = event!.subtype
        let p = self.player.player!
        print("received remote control \(rc.rawValue)") // 101 = pause, 100 = play
        switch rc {
        case .remoteControlTogglePlayPause:
            if p.isPlaying { p.pause() } else { p.play() }
        case .remoteControlPlay:
            p.play()
        case .remoteControlPause:
            p.pause()
        default:break
        }

    }

    
}
