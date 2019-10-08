

import UIKit
import AVFoundation
import AVKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController: UIViewController {
    @IBOutlet var player : AVPlayer!
    @IBOutlet var playerLayer : AVPlayerLayer!
    var pic : AVPictureInPictureController!
    
    @IBOutlet weak var picButton: UIButton!
    
    let which = 2
    
    var obs = Set<NSKeyValueObservation>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch which {
        case 1:
            let m = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
            //        let p = AVPlayer(URL:m)!
            let asset = AVURLAsset(url:m)
            let item = AVPlayerItem(asset:asset)
            let p = AVPlayer(playerItem:item)
            self.player = p // might need a reference later
            let lay = AVPlayerLayer(player:p)
            lay.frame = CGRect(10,10,300,200)
            self.playerLayer = lay // might need a reference later
            // self.view.layer.addSublayer(lay)
        case 2:
            let m = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
            let asset = AVURLAsset(url:m)
            let item = AVPlayerItem(asset:asset)
            let p = AVPlayer() // *
            self.player = p
            let lay = AVPlayerLayer(player:p)
            lay.frame = CGRect(10,10,300,200)
            self.playerLayer = lay
            p.replaceCurrentItem(with: item) // *
            // self.view.layer.addSublayer(lay)
        default:break
        }
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            let pic = AVPictureInPictureController(playerLayer: self.playerLayer)
            self.pic = pic
        } else {
            self.picButton.isHidden = true
        }
        
        var ob : NSKeyValueObservation!
        ob = self.playerLayer.observe(\.isReadyForDisplay, options:.new) { lay, ch in
            guard let ready = ch.newValue, ready else {return}
            self.obs.remove(ob)
            DispatchQueue.main.async {
                print("finishing")
                if lay.superlayer == nil {
                    self.view.layer.addSublayer(lay)
                }
            }
        }
        self.obs.insert(ob)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode:.default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    
    @IBAction func doButton (_ sender: Any) {
        let rate = self.player.rate
        self.player.rate = rate < 0.01 ? 1 : 0
    }

    
    @IBAction func restart (_ sender: Any) {
        let item = self.player.currentItem! //

        let time: CMTime = CMTime(seconds:0, preferredTimescale:600)
        item.seek(to:time, completionHandler:nil)
    }

    @IBAction func doPicInPic(_ sender: Any) {
        if self.pic.isPictureInPicturePossible {
            self.pic.startPictureInPicture()
        }
    }

    
}

extension ViewController : AVPictureInPictureControllerDelegate {
    
    // this is the nuttiest bit of renamification!
    // ooh, and in Swift 4.2 it has a new name even nuttier
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @ escaping (Bool) -> Void) {
        
    }
    // old name:
    /*
     func picture(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @ escaping (Bool) -> Void) {
     }

 */

}
