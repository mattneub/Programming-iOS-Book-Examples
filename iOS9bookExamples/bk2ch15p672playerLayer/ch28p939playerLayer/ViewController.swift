

import UIKit
import AVFoundation
import AVKit

import CoreMedia

class ViewController: UIViewController {
    @IBOutlet var player : AVPlayer!
    @IBOutlet var playerLayer : AVPlayerLayer!
    var pic : AVPictureInPictureController!
    
    @IBOutlet weak var picButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let m = NSBundle.mainBundle().URLForResource("ElMirage", withExtension:"mp4")!
        //        let p = AVPlayer(URL:m)!
        let asset = AVURLAsset(URL:m, options:nil)
        let item = AVPlayerItem(asset:asset)
        let p = AVPlayer(playerItem:item)
        self.player = p // might need a reference later
        let lay = AVPlayerLayer(player:p)
        lay.frame = CGRectMake(10,10,300,200)
        self.playerLayer = lay
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            let pic = AVPictureInPictureController(playerLayer: lay)
            self.pic = pic
        } else {
            self.picButton.hidden = true
        }
        
        lay.addObserver(self, forKeyPath:"readyForDisplay", options:[], context:nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if keyPath == "readyForDisplay" {
            dispatch_async(dispatch_get_main_queue(), {
                self.finishConstructingInterface()
            })
        }
    }
    
    func finishConstructingInterface () {
        if (!self.playerLayer.readyForDisplay) {
            return
        }
        
        self.playerLayer.removeObserver(self, forKeyPath:"readyForDisplay")
        
        if self.playerLayer.superlayer == nil {
            self.view.layer.addSublayer(self.playerLayer)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
        _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: [])
    }

    
    @IBAction func doButton (sender:AnyObject!) {
        let rate = self.player.rate
        if rate < 0.01 {
            self.player.rate = 1
        } else {
            self.player.rate = 0
        }
    }

    
    @IBAction func restart (sender:AnyObject!) {
        let item = self.player.currentItem! //
        item.seekToTime(CMTimeMake(0, 1))
    }

    @IBAction func doPicInPic(sender: AnyObject) {
        if self.pic.pictureInPicturePossible {
            self.pic.startPictureInPicture()
        }
    }

    
}
