

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
    
    var opaques = [String:AnyObject]()
    
    var which = 0 // 0 means use target-action, 1 means use handler

    override func viewDidLoad() {
        super.viewDidLoad()
        let scc = MPRemoteCommandCenter.sharedCommandCenter()
        switch which {
        case 0:
            scc.togglePlayPauseCommand.addTarget(self, action: #selector(doPlayPause))
            scc.playCommand.addTarget(self, action:#selector(doPlay))
            scc.pauseCommand.addTarget(self, action:#selector(doPause))
        case 1:
            opaques["playPause"] = scc.togglePlayPauseCommand.addTargetWithHandler {
                [unowned self] _ in
                let p = self.player.player
                if p.playing { p.pause() } else { p.play() }
                return .Success
            }
            opaques["play"] = scc.playCommand.addTargetWithHandler {
                [unowned self] _ in
                let p = self.player.player
                p.play()
                return .Success
            }
            opaques["pause"] = scc.pauseCommand.addTargetWithHandler {
                [unowned self] _ in
                let p = self.player.player
                p.pause()
                return .Success
            }
        default:break
        }
    }
    
    // these are used only in case 0
    
    func doPlayPause(event:MPRemoteCommandEvent) {
        let p = self.player.player
        if p.playing { p.pause() } else { p.play() }
    }
    func doPlay(event:MPRemoteCommandEvent) {
        let p = self.player.player
        p.play()
    }
    func doPause(event:MPRemoteCommandEvent) {
        let p = self.player.player
        p.pause()
    }

    
    // must deregister or can crash later!
    
    deinit {
        print("deinit")
        let scc = MPRemoteCommandCenter.sharedCommandCenter()
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
