

import UIKit
import AVFoundation

import CoreMedia

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController {
    @IBOutlet var player : AVPlayer!
    @IBOutlet var playerLayer : AVPlayerLayer!
    @IBOutlet var synchLayer : AVSynchronizedLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let m = NSBundle.mainBundle().URLForResource("ElMirage", withExtension:"mp4")
        //        let p = AVPlayer(URL:m)
        let asset = AVURLAsset(URL:m, options:nil)
        let item = AVPlayerItem(asset:asset)
        let p = AVPlayer(playerItem:item)
        self.player = p // might need a reference later
        let lay = AVPlayerLayer(player:p)
        lay.frame = CGRectMake(10,10,300,200)
        self.playerLayer = lay
        
        lay.addObserver(self, forKeyPath:"readyForDisplay", options:nil, context:nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
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
        
        if self.synchLayer?.superlayer != nil {
            self.synchLayer.removeFromSuperlayer()
        }
        
        // create synch layer, put it in the interface
        let item = self.player.currentItem
        let syncLayer = AVSynchronizedLayer(playerItem:item)
        syncLayer.frame = CGRectMake(10,220,300,10)
        syncLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        self.view.layer.addSublayer(syncLayer)
        // give synch layer a sublayer
        let subLayer = CALayer()
        subLayer.backgroundColor = UIColor.blackColor().CGColor
        subLayer.frame = CGRectMake(0,0,10,10)
        syncLayer.addSublayer(subLayer)
        // animate the sublayer
        let anim = CABasicAnimation(keyPath:"position")
        anim.fromValue = NSValue(CGPoint: subLayer.position)
        anim.toValue = NSValue(CGPoint: CGPointMake(295,5))
        anim.removedOnCompletion = false
        anim.beginTime = AVCoreAnimationBeginTimeAtZero // important trick
        anim.duration = CMTimeGetSeconds(item.asset.duration)
        subLayer.addAnimation(anim, forKey:nil)
        
        self.synchLayer = syncLayer
    }
    
    @IBAction func doButton (sender:AnyObject!) {
        let rate = self.player.rate
        if rate < 0.01 {
            self.player.rate = 1
        } else {
            self.player.rate = 0
        }
    }

    @IBAction func doButton2 (sender:AnyObject!) {
        let oldAsset = self.player.currentItem.asset
        
        let type = AVMediaTypeVideo
        let arr = oldAsset.tracksWithMediaType(type)
        let track = arr.last as! AVAssetTrack
        
        let duration : CMTime = track.timeRange.duration
        
        let comp = AVMutableComposition()
        let comptrack = comp.addMutableTrackWithMediaType(type,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        comptrack.insertTimeRange(CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(5,600)), ofTrack:track, atTime:CMTimeMakeWithSeconds(0,600), error:nil)
        comptrack.insertTimeRange(CMTimeRangeMake(CMTimeSubtract(duration, CMTimeMakeWithSeconds(5,600)), CMTimeMakeWithSeconds(5,600)), ofTrack:track, atTime:CMTimeMakeWithSeconds(5,600), error:nil)
        
        let type2 = AVMediaTypeAudio
        let arr2 = oldAsset.tracksWithMediaType(type2)
        let track2 = arr2.last as! AVAssetTrack
        let comptrack2 = comp.addMutableTrackWithMediaType(type2, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
        
        comptrack2.insertTimeRange(CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(5,600)), ofTrack:track2, atTime:CMTimeMakeWithSeconds(0,600), error:nil)
        comptrack2.insertTimeRange(CMTimeRangeMake(CMTimeSubtract(duration, CMTimeMakeWithSeconds(5,600)), CMTimeMakeWithSeconds(5,600)), ofTrack:track2, atTime:CMTimeMakeWithSeconds(5,600), error:nil)
        
        
        let type3 = AVMediaTypeAudio
        let s = NSBundle.mainBundle().URLForResource("aboutTiagol", withExtension:"m4a")
        let asset = AVURLAsset(URL:s, options:nil)
        let arr3 = asset.tracksWithMediaType(type3)
        let track3 = arr3.last as! AVAssetTrack
        
        let comptrack3 = comp.addMutableTrackWithMediaType(type3, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
        comptrack3.insertTimeRange(CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(10,600)), ofTrack:track3, atTime:CMTimeMakeWithSeconds(0,600), error:nil)
        
        
        
        let params = AVMutableAudioMixInputParameters(track:comptrack3)
        params.setVolume(1, atTime:CMTimeMakeWithSeconds(0,600))
        params.setVolumeRampFromStartVolume(1, toEndVolume:0, timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(7,600), CMTimeMakeWithSeconds(3,600)))
        let mix = AVMutableAudioMix()
        mix.inputParameters = [params]
        
        let item = AVPlayerItem(asset:comp)
        item.audioMix = mix
        
        // just proving that multiple running players are legal
        // this is why I took out the "Only One" language
        
        let player2 = AVPlayer(playerItem:item)
        let lay2 = AVPlayerLayer(player: player2)
        lay2.frame = CGRectMake(330,40,100,100)
        self.view.layer.addSublayer(lay2)
        delay(3) {
            player2.rate = 1
        }
    }
    
    @IBAction func restart (sender:AnyObject!) {
        let item = self.player.currentItem
        item.seekToTime(CMTimeMake(0, 1))
    }


    
}
