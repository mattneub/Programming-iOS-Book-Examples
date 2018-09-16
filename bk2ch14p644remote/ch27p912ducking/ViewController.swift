

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    var player = Player()
    
    @IBAction func doButton (_ sender: Any!) {
        let path = Bundle.main.path(forResource:"test", ofType: "aif")!
        if (sender as! UIButton).currentTitle == "Forever" {
            // for remote control to work, our audio session policy
            // must be Playback or SoloAmbient
            // for background audio to work, it must be Playback
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try? AVAudioSession.sharedInstance().setActive(true)
            self.player.forever = true
        }
        self.player.playFile(atPath:path)
    }
    
    // ======== respond to remote controls
    
    var opaques = [String:Any]()
    
    var which = 0 // 0 means use target-action, 1 means use handler

    override func viewDidLoad() {
        super.viewDidLoad()
        let scc = MPRemoteCommandCenter.shared()
        switch which {
        case 0:
            scc.togglePlayPauseCommand.addTarget(self, action: #selector(doPlayPause))
            scc.playCommand.addTarget(self, action:#selector(doPlay))
            scc.pauseCommand.addTarget(self, action:#selector(doPause))
            // fun fun fun
            scc.likeCommand.addTarget(self, action:#selector(doLike))
            scc.likeCommand.localizedTitle = "Fantastic"
        case 1:
            opaques["playPause"] = scc.togglePlayPauseCommand.addTarget {
                [unowned self] _ in
                let p = self.player.player!
                if p.isPlaying { p.pause() } else { p.play() }
                return .success
            }
            opaques["play"] = scc.playCommand.addTarget {
                [unowned self] _ in
                let p = self.player.player!
                p.play()
                return .success
            }
            opaques["pause"] = scc.pauseCommand.addTarget {
                [unowned self] _ in
                let p = self.player.player!
                p.pause()
                return .success
            }
        default:break
        }
    }
    
    // these are used only in case 0
    
    @objc func doPlayPause(_ event:MPRemoteCommandEvent) {
        print("playpause")
        let p = self.player.player!
        if p.isPlaying { p.pause() } else { p.play() }
    }
    @objc func doPlay(_ event:MPRemoteCommandEvent) {
        print("play")
        let p = self.player.player!
        p.play()
    }
    @objc func doPause(_ event:MPRemoteCommandEvent) {
        print("pause")
        let p = self.player.player!
        p.pause()
    }
    @objc func doLike(_ event:MPRemoteCommandEvent) {
        print("like")
    }

    
    // must deregister or can crash later!
    
    deinit {
        print("deinit")
        // return; // uncomment to test the crash
        let scc = MPRemoteCommandCenter.shared()
        switch which {
        case 0:
            scc.togglePlayPauseCommand.removeTarget(self)
            scc.playCommand.removeTarget(self)
            scc.pauseCommand.removeTarget(self)
            scc.likeCommand.removeTarget(self)
        case 1:
            scc.togglePlayPauseCommand.removeTarget(self.opaques["playPause"])
            scc.playCommand.removeTarget(self.opaques["play"])
            scc.pauseCommand.removeTarget(self.opaques["pause"])
        default:break
        }
    }
    
    


    
}
