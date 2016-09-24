

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {

    var player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scc = MPRemoteCommandCenter.shared()
        scc.togglePlayPauseCommand.addTarget(self, action: #selector(doPlayPause))
        scc.playCommand.addTarget(self, action:#selector(doPlay))
        scc.pauseCommand.addTarget(self, action:#selector(doPause))
    }
    
    func doPlayPause(_ event:MPRemoteCommandEvent) {
        print("playpause")
        let p = self.player.player!
        if p.isPlaying { p.pause() } else { p.play() }
    }
    func doPlay(_ event:MPRemoteCommandEvent) {
        print("play")
        let p = self.player.player!
        p.play()
    }
    func doPause(_ event:MPRemoteCommandEvent) {
        print("pause")
        let p = self.player.player!
        p.pause()
    }
    
    deinit {
        let scc = MPRemoteCommandCenter.shared()
        scc.togglePlayPauseCommand.removeTarget(self)
        scc.playCommand.removeTarget(self)
        scc.pauseCommand.removeTarget(self)
    }

    
    @IBAction func doButton (_ sender: Any!) {
        // start over
        let path = Bundle.main.path(forResource:"aboutTiagol", ofType: "m4a")!
        self.player = Player() // just testing for leakage / retain cycle
        self.player.playFile(atPath:path)
        
        // this info shows up in the locked screen and control center
        let mpic = MPNowPlayingInfoCenter.default()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyArtist: "Matt Neuburg",
            MPMediaItemPropertyTitle: "About Tiagol"
        ]
    }


}
