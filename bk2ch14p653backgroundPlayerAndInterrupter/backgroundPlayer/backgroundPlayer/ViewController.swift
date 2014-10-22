

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {

    var player = Player()
    
    @IBAction func doButton (sender:AnyObject!) {
        // start over
        let path = NSBundle.mainBundle().pathForResource("aboutTiagol", ofType: "m4a")!
        self.player = Player() // just testing for leakage / retain cycle
        self.player.playFileAtPath(path)
        
        // this info shows up in the locked screen and control center
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyArtist: "Matt Neuburg",
            MPMediaItemPropertyTitle: "About Tiagol"
        ]
    }

    override func canBecomeFirstResponder() -> Bool {
        return true // but we get the same effect if we return false; is that a bug?
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        let rc = event.subtype
        println("bp received remote control \(rc.rawValue)")
        // 101 = pause, 100 = play (remote control interface on control center)
        // 103 = playpause (remote control button on earbuds)

        if let p = self.player.player {
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

}
