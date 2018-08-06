

import UIKit
import AVFoundation

class ViewController: UIViewController, PlayerDelegate {
    var player = Player()
    
    // instructions: run the app on a device
    // play music with the iPod / Music app
    // tap the Once button to experience ducking
    
    // now tap the Looping button; we silence other audio and loop
    // if you set audio background mode in Info.plist,
    // then Looping even plays when we are in the background

    @IBAction func doDuck (_ sender: Any!) {
        self.player.delegate = self
        // let path = Bundle.main.path(forResource:"test", ofType: "aif")!
        // proving that flac now works
        let path = Bundle.main.path(forResource:"test", ofType: "flac")!
        // example works better if there is some background audio already playing
        let oth = AVAudioSession.sharedInstance().isOtherAudioPlaying
        print("other audio is playing: \(oth)")
        // new iOS 8 feature! finer grained than merely whether other audio is playing
        let hint = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        print("secondary hint is: \(hint)")
        if !oth {
            let alert = UIAlertController(title: "Pointless", message: "You won't get the point of the example unless some other audio is already playing!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            return
        }
        print("ducking")
        let sess = AVAudioSession.sharedInstance()
        try? sess.setCategory(.ambient, mode:.default)
        try? sess.setActive(false)
        let opts = sess.categoryOptions.union(.duckOthers)
        try? sess.setCategory(sess.category, mode: sess.mode, options: opts)
        try? sess.setActive(true)
        self.player.looping = false
        self.player.playFile(atPath:path)
    }
    
    @IBAction func doLoop (_ sender: Any) {
        self.player.delegate = self
        DispatchQueue.global(qos:.userInitiated).async {
            let path = Bundle.main.path(forResource:"test", ofType: "aif")!
            // interrupt background audio if any
            let ok : Void? = try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            if ok == nil { print("failed to set session to playback") }
            try? AVAudioSession.sharedInstance().setActive(true)
            DispatchQueue.main.async {
                self.player.looping = true
                self.player.playFile(atPath:path)
            }
        }
    }
    
    @IBAction func doStop (_ sender: Any) {
        self.player.stop()
    }
    
    func soundFinished(_ sender: Any) { // delegate message from Player
        self.unduck()
    }
    
    func unduck() {
        print("unducking")
        let sess = AVAudioSession.sharedInstance()
        try? sess.setActive(false)
        let opts = sess.categoryOptions.subtracting(.duckOthers)
        try? sess.setCategory(sess.category, mode: sess.mode, options:opts)
        try? sess.setActive(true)
    }
    
    // ======== respond to remote controls
    
    /*
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
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
 
 */

    
}
