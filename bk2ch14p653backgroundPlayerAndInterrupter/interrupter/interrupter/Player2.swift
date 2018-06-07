

import UIKit
import AVFoundation
import MediaPlayer

protocol PlayerDelegate : class {
    func soundFinished(_ sender: Any)
}

class Player : NSObject, AVAudioPlayerDelegate {
    var player : AVAudioPlayer!
    var forever = false
    weak var delegate : PlayerDelegate?
    var observer : NSObjectProtocol!
    var observer2 : NSObjectProtocol!
    
    func playFile(atPath path:String) {
        self.player?.delegate = nil
        self.player?.stop()
        let fileURL = URL(fileURLWithPath: path)
        guard let p = try? AVAudioPlayer(contentsOf: fileURL) else {return} // nicer
        self.player = p
        // error-checking omitted
        
        // switch to playback category while playing, interrupt background audio
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode:.default)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        self.player.prepareToPlay()
        self.player.delegate = self
        let ok = self.player.play()
        print("interrupter trying to play \(path): \(ok)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) { // *
        let sess = AVAudioSession.sharedInstance()
        // this is the key move
        try? sess.setActive(false, options: .notifyOthersOnDeactivation)
        // now go back to ambient
        try? sess.setCategory(.ambient, mode:.default)
        try? sess.setActive(true)
        delegate?.soundFinished(self)
    }
        
    func stop () {
        self.player?.pause()
    }
    
    deinit {
        print("interrupter player dealloc")
        self.player?.delegate = nil
    }
    
    
}
