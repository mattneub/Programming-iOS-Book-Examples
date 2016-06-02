

import UIKit
import AVFoundation

import CoreMedia
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
    var synchLayer : AVSynchronizedLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let m = NSBundle.main().urlForResource("ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(url:m, options:nil)
        let item = AVPlayerItem(asset:asset)
        let p = AVPlayer(playerItem:item)
        p.addObserver(self, forKeyPath:"status", context:nil)
        let vc = AVPlayerViewController()
        vc.player = p
        vc.view.frame = CGRect(10,10,300,200)
        vc.view.isHidden = true // looks nicer if we don't show until ready
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
        if keyPath == "status" {
            dispatch_async(dispatch_get_main_queue(), {
                self.finishConstructingInterface()
            })
        }
    }
    
    func finishConstructingInterface () {
        let vc = self.childViewControllers[0] as! AVPlayerViewController
        let p = vc.player! //
        if p.status != .readyToPlay {
            return
        }
        p.removeObserver(self, forKeyPath:"status")
        vc.view.isHidden = false
        
        // absolutely no reason why we shouldn't have a synch layer if we want one
        // (of course the one in this example is kind of pointless...
        // ...because the AVPlayerViewController's view gives us a position interface!)
        
        if self.synchLayer?.superlayer != nil {
            self.synchLayer.removeFromSuperlayer()
        }
        
        // create synch layer, put it in the interface
        let item = p.currentItem! //
        let syncLayer = AVSynchronizedLayer(playerItem:item)
        syncLayer.frame = CGRect(10,220,300,10)
        syncLayer.backgroundColor = UIColor.lightGray().cgColor
        self.view.layer.addSublayer(syncLayer)
        // give synch layer a sublayer
        let subLayer = CALayer()
        subLayer.backgroundColor = UIColor.black().cgColor
        subLayer.frame = CGRect(0,0,10,10)
        syncLayer.addSublayer(subLayer)
        // animate the sublayer
        let anim = CABasicAnimation(keyPath:"position")
        anim.fromValue = NSValue(cgPoint: subLayer.position)
        anim.toValue = NSValue(cgPoint: CGPoint(295,5))
        anim.isRemovedOnCompletion = false
        anim.beginTime = AVCoreAnimationBeginTimeAtZero // important trick
        anim.duration = CMTimeGetSeconds(item.asset.duration)
        subLayer.add(anim, forKey:nil)
        
        self.synchLayer = syncLayer
    }
    

    // exactly as before; the AVPlayerViewController's player's item's asset...
    // can be a mutable composition
    
    @IBAction func doButton2 (_ sender:AnyObject!) {
        let vc = self.childViewControllers[0] as! AVPlayerViewController
        let p = vc.player! //
        p.pause()
        
        let oldAsset = p.currentItem!.asset //
        
        let type = AVMediaTypeVideo
        let arr = oldAsset.tracks(withMediaType: type)
        let track = arr.last! //
        
        let duration : CMTime = track.timeRange.duration
        
        let comp = AVMutableComposition()
        let comptrack = comp.addMutableTrack(withMediaType: type,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        try! comptrack.insertTimeRange(CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(5,600)), of:track, at:CMTimeMakeWithSeconds(0,600))
        try! comptrack.insertTimeRange(CMTimeRangeMake(CMTimeSubtract(duration, CMTimeMakeWithSeconds(5,600)), CMTimeMakeWithSeconds(5,600)), of:track, at:CMTimeMakeWithSeconds(5,600))
        
        let type2 = AVMediaTypeAudio
        let arr2 = oldAsset.tracks(withMediaType: type2)
        let track2 = arr2.last! //
        let comptrack2 = comp.addMutableTrack(withMediaType: type2, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
        
        try! comptrack2.insertTimeRange(CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(5,600)), of:track2, at:CMTimeMakeWithSeconds(0,600))
        try! comptrack2.insertTimeRange(CMTimeRangeMake(CMTimeSubtract(duration, CMTimeMakeWithSeconds(5,600)), CMTimeMakeWithSeconds(5,600)), of:track2, at:CMTimeMakeWithSeconds(5,600))
        
        
        let type3 = AVMediaTypeAudio
        let s = NSBundle.main().urlForResource("aboutTiagol", withExtension:"m4a")!
        let asset = AVURLAsset(url:s)
        let arr3 = asset.tracks(withMediaType: type3)
        let track3 = arr3.last! //
        
        let comptrack3 = comp.addMutableTrack(withMediaType: type3, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
        try! comptrack3.insertTimeRange(CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(10,600)), of:track3, at:CMTimeMakeWithSeconds(0,600))
        
        let params = AVMutableAudioMixInputParameters(track:comptrack3)
        params.setVolume(1, at:CMTimeMakeWithSeconds(0,600))
        params.setVolumeRampFromStartVolume(1, toEndVolume:0, timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(7,600), CMTimeMakeWithSeconds(3,600)))
        let mix = AVMutableAudioMix()
        mix.inputParameters = [params]
        
        let item = AVPlayerItem(asset:comp)
        item.audioMix = mix
        
        // note this cool trick! the status won't change, so to trigger a KVO notification,
        // ...we supply the .Initial option
        p.addObserver(self, forKeyPath:"status", options:.initial, context:nil)
        p.replaceCurrentItem(with: item)
        (sender as! UIControl).isEnabled = false
    }

    

    
}
