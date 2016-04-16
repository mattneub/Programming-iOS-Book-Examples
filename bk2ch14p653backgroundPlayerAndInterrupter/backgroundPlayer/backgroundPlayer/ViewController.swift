

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {

    var player = Player()
    
    @IBAction func doButton (_ sender:AnyObject!) {
        // start over
        let path = NSBundle.main().pathForResource("aboutTiagol", ofType: "m4a")!
        self.player = Player() // just testing for leakage / retain cycle
        self.player.playFile(atPath:path)
        
        // this info shows up in the locked screen and control center
        let mpic = MPNowPlayingInfoCenter.default()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyArtist: "Matt Neuburg",
            MPMediaItemPropertyTitle: "About Tiagol"
        ]
    }

    override func canBecomeFirstResponder() -> Bool {
        return true // but we get the same effect if we return false; is that a bug?
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared().beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        let rc = event!.subtype
        print("bp received remote control \(rc.rawValue)")
        // 101 = pause, 100 = play (remote control interface on control center)
        // 103 = playpause (remote control button on earbuds)

        if let p = self.player.player {
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

}
