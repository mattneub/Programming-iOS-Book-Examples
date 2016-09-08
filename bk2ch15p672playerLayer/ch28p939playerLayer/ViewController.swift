

import UIKit
import AVFoundation
import AVKit

import CoreMedia

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let m = Bundle.main.urlForResource("ElMirage", withExtension:"mp4")!
        //        let p = AVPlayer(URL:m)!
        let asset = AVURLAsset(url:m)
        let item = AVPlayerItem(asset:asset)
        let p = AVPlayer(playerItem:item)
        self.player = p // might need a reference later
        let lay = AVPlayerLayer(player:p)
        lay.frame = CGRect(10,10,300,200)
        self.playerLayer = lay
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            let pic = AVPictureInPictureController(playerLayer: lay)
            self.pic = pic
        } else {
            self.picButton.isHidden = true
        }
        
        lay.addObserver(self, forKeyPath:#keyPath(AVPlayerLayer.readyForDisplay), context:nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
        if keyPath == #keyPath(AVPlayerLayer.readyForDisplay) {
            DispatchQueue.main.async {
                self.finishConstructingInterface()
            }
        }
    }
    
    func finishConstructingInterface () {
        if (!self.playerLayer.isReadyForDisplay) {
            return
        }
        
        self.playerLayer.removeObserver(self, forKeyPath:#keyPath(AVPlayerLayer.readyForDisplay))
        
        if self.playerLayer.superlayer == nil {
            self.view.layer.addSublayer(self.playerLayer)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    
    @IBAction func doButton (_ sender: Any!) {
        let rate = self.player.rate
        if rate < 0.01 {
            self.player.rate = 1
        } else {
            self.player.rate = 0
        }
    }

    
    @IBAction func restart (_ sender: Any!) {
        let item = self.player.currentItem! //
        item.seek(to:CMTimeMake(0, 1))
    }

    @IBAction func doPicInPic(_ sender: Any) {
        if self.pic.isPictureInPicturePossible {
            self.pic.startPictureInPicture()
        }
    }

    
}
