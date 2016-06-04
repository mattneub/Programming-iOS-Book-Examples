

import UIKit
import AVFoundation
import MediaPlayer

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
    
    var opaques = [String:AnyObject]()
    
    var which = 0 // 0 means use target-action, 1 means use handler

    override func viewDidLoad() {
        super.viewDidLoad()
        let scc = MPRemoteCommandCenter.shared()
        switch which {
        case 0:
            scc.togglePlayPauseCommand.addTarget(self, action: #selector(doPlayPause))
            scc.playCommand.addTarget(self, action:#selector(doPlay))
            scc.pauseCommand.addTarget(self, action:#selector(doPause))
        case 1:
            opaques["playPause"] = scc.togglePlayPauseCommand.addTarget {
                [unowned self] _ in
                let p = self.player.player
                if p.isPlaying { p.pause() } else { p.play() }
                return .success
            }
            opaques["play"] = scc.playCommand.addTarget {
                [unowned self] _ in
                let p = self.player.player
                p.play()
                return .success
            }
            opaques["pause"] = scc.pauseCommand.addTarget {
                [unowned self] _ in
                let p = self.player.player
                p.pause()
                return .success
            }
        default:break
        }
    }
    
    // these are used only in case 0
    
    func doPlayPause(_ event:MPRemoteCommandEvent) {
        let p = self.player.player
        if p.isPlaying { p.pause() } else { p.play() }
    }
    func doPlay(_ event:MPRemoteCommandEvent) {
        let p = self.player.player
        p.play()
    }
    func doPause(_ event:MPRemoteCommandEvent) {
        let p = self.player.player
        p.pause()
    }

    
    // must deregister or can crash later!
    
    deinit {
        print("deinit")
        let scc = MPRemoteCommandCenter.shared()
        switch which {
        case 0:
            scc.togglePlayPauseCommand.removeTarget(self)
            scc.playCommand.removeTarget(self)
            scc.pauseCommand.removeTarget(self)
        case 1:
            scc.togglePlayPauseCommand.removeTarget(self.opaques["playPause"])
            scc.playCommand.removeTarget(self.opaques["play"])
            scc.pauseCommand.removeTarget(self.opaques["pause"])
        default:break
        }
    }
    
    


    
}
