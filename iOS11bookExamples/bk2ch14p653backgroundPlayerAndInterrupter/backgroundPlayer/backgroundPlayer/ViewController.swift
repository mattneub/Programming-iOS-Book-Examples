

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
        scc.changePlaybackPositionCommand.isEnabled = false
    }
    
    @objc func doPlayPause(_ event:MPRemoteCommandEvent) {
        print("playpause")
        guard let p = self.player.player else { return }
        if p.isPlaying { self.doPause(event) } else { self.doPlay(event) }
    }
    @objc func doPlay(_ event:MPRemoteCommandEvent) {
        print("play")
        guard let p = self.player.player else { return }
        p.play()
        let mpic = MPNowPlayingInfoCenter.default()
        if var d = mpic.nowPlayingInfo {
            d[MPNowPlayingInfoPropertyPlaybackRate] = 1
            mpic.nowPlayingInfo = d
        }
    }
    @objc func doPause(_ event:MPRemoteCommandEvent) {
        print("pause")
        guard let p = self.player.player else { return }
        p.pause()
        let mpic = MPNowPlayingInfoCenter.default()
        if var d = mpic.nowPlayingInfo {
            d[MPNowPlayingInfoPropertyPlaybackRate] = 0
            d[MPNowPlayingInfoPropertyElapsedPlaybackTime] = p.currentTime // *
            mpic.nowPlayingInfo = d
        }
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
            MPMediaItemPropertyTitle: "About Tiagol",
            MPMediaItemPropertyPlaybackDuration: self.player.player.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: 0,
            MPNowPlayingInfoPropertyPlaybackRate: 1
        ]
    }


}
