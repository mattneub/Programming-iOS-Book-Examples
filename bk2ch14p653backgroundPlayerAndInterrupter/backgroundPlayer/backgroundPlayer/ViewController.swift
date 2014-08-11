

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {

    var player = Player()
    
    @IBAction func doButton (sender:AnyObject!) {
        // start over
        let path = NSBundle.mainBundle().pathForResource("aboutTiagol", ofType: "m4a")
        self.player.playFileAtPath(path)
        
        // this info shows up in the locked screen and control center
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyArtist: "Matt Neuburg",
            MPMediaItemPropertyTitle: "About Tiagol"
        ]
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent!) {
        let rc = event.subtype
        let p = self.player.player
        println("bp received remote control \(rc.toRaw())") // 101 = pause, 100 = play
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
