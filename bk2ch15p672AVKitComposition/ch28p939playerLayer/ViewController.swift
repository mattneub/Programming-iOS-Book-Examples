

import UIKit
import AVFoundation

import CoreMedia
import AVKit

class ViewController: UIViewController {
    var synchLayer : AVSynchronizedLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let m = NSBundle.mainBundle().URLForResource("ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(URL:m, options:nil)
        let item = AVPlayerItem(asset:asset)
        let p = AVPlayer(playerItem:item)
        p.addObserver(self, forKeyPath:"status", options:[], context:nil)
        let vc = AVPlayerViewController()
        vc.player = p
        vc.view.frame = CGRectMake(10,10,300,200)
        vc.view.hidden = true // looks nicer if we don't show until ready
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if keyPath == "status" {
            dispatch_async(dispatch_get_main_queue(), {
                self.finishConstructingInterface()
            })
        }
    }
    
    func finishConstructingInterface () {
        let vc = self.childViewControllers[0] as! AVPlayerViewController
        let p = vc.player! //
        if p.status != .ReadyToPlay {
            return
        }
        p.removeObserver(self, forKeyPath:"status")
        vc.view.hidden = false
        
        // absolutely no reason why we shouldn't have a synch layer if we want one
        // (of course the one in this example is kind of pointless...
        // ...because the AVPlayerViewController's view gives us a position interface!)
        
        if self.synchLayer?.superlayer != nil {
            self.synchLayer.removeFromSuperlayer()
        }
        
        // create synch layer, put it in the interface
        let item = p.currentItem! //
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
    

    // exactly as before; the AVPlayerViewController's player's item's asset...
    // can be a mutable composition
    
    @IBAction func doButton2 (sender:AnyObject!) {
        let vc = self.childViewControllers[0] as! AVPlayerViewController
        let p = vc.player! //
        p.pause()
        
        let oldAsset = p.currentItem!.asset //
        
        let type = AVMediaTypeVideo
        let arr = oldAsset.tracksWithMediaType(type)
        let track = arr.last! //
        
        let duration : CMTime = track.timeRange.duration
        
        let comp = AVMutableComposition()
        let comptrack = comp.addMutableTrackWithMediaType(type,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        try! comptrack.insertTimeRange(CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(5,600)), ofTrack:track, atTime:CMTimeMakeWithSeconds(0,600))
        try! comptrack.insertTimeRange(CMTimeRangeMake(CMTimeSubtract(duration, CMTimeMakeWithSeconds(5,600)), CMTimeMakeWithSeconds(5,600)), ofTrack:track, atTime:CMTimeMakeWithSeconds(5,600))
        
        let type2 = AVMediaTypeAudio
        let arr2 = oldAsset.tracksWithMediaType(type2)
        let track2 = arr2.last! //
        let comptrack2 = comp.addMutableTrackWithMediaType(type2, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
        
        try! comptrack2.insertTimeRange(CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(5,600)), ofTrack:track2, atTime:CMTimeMakeWithSeconds(0,600))
        try! comptrack2.insertTimeRange(CMTimeRangeMake(CMTimeSubtract(duration, CMTimeMakeWithSeconds(5,600)), CMTimeMakeWithSeconds(5,600)), ofTrack:track2, atTime:CMTimeMakeWithSeconds(5,600))
        
        
        let type3 = AVMediaTypeAudio
        let s = NSBundle.mainBundle().URLForResource("aboutTiagol", withExtension:"m4a")!
        let asset = AVURLAsset(URL:s, options:nil)
        let arr3 = asset.tracksWithMediaType(type3)
        let track3 = arr3.last! //
        
        let comptrack3 = comp.addMutableTrackWithMediaType(type3, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
        try! comptrack3.insertTimeRange(CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(10,600)), ofTrack:track3, atTime:CMTimeMakeWithSeconds(0,600))
        
        let params = AVMutableAudioMixInputParameters(track:comptrack3)
        params.setVolume(1, atTime:CMTimeMakeWithSeconds(0,600))
        params.setVolumeRampFromStartVolume(1, toEndVolume:0, timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(7,600), CMTimeMakeWithSeconds(3,600)))
        let mix = AVMutableAudioMix()
        mix.inputParameters = [params]
        
        let item = AVPlayerItem(asset:comp)
        item.audioMix = mix
        
        // note this cool trick! the status won't change, so to trigger a KVO notification,
        // ...we supply the .Initial option
        p.addObserver(self, forKeyPath:"status", options:.Initial, context:nil)
        p.replaceCurrentItemWithPlayerItem(item)
        (sender as! UIControl).enabled = false
    }

    

    
}
