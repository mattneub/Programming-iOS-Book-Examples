

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
    var synchLayer : AVSynchronizedLayer!
    
    var obs = Set<NSKeyValueObservation>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // just playing around
        let t = CMTime(seconds:2.5, preferredTimescale:600)
        print(t)
        
        let m = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(url:m)
        let item = AVPlayerItem(asset:asset)
        let p = AVPlayer(playerItem:item)
        let vc = AVPlayerViewController()
        vc.player = p
        vc.view.frame = CGRect(10,10,300,200)
        vc.view.isHidden = true // looks nicer if we don't show until ready
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        var ob : NSKeyValueObservation!
        ob = p.observe(\.status) { vc, ch in
            if p.status == .readyToPlay {
                self.obs.remove(ob)
                DispatchQueue.main.async {
                    print("status is ready to play")
                    self.finishConstructingInterface()
                }
            }
        }
        self.obs.insert(ob)
    }
    
    func finishConstructingInterface () {
        let vc = self.children[0] as! AVPlayerViewController
        let p = vc.player!

        vc.view.isHidden = false
        
        self.addSynchLayer()
    }
    
    func addSynchLayer() {
        // absolutely no reason why we shouldn't have a synch layer if we want one
        // (of course the one in this example is kind of pointless...
        // ...because the AVPlayerViewController's view gives us a position interface!)
        
        let vc = self.children[0] as! AVPlayerViewController
        let p = vc.player!
        
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
        syncLayer.backgroundColor = UIColor.lightGray.cgColor
        self.view.layer.addSublayer(syncLayer)
        // give synch layer a sublayer
        let subLayer = CALayer()
        subLayer.backgroundColor = UIColor.black.cgColor
        subLayer.frame = CGRect(0,0,10,10)
        syncLayer.addSublayer(subLayer)
        // animate the sublayer
        let anim = CABasicAnimation(keyPath:#keyPath(CALayer.position))
        anim.fromValue = subLayer.position
        anim.toValue = CGPoint(295,5)
        anim.isRemovedOnCompletion = false
        anim.beginTime = AVCoreAnimationBeginTimeAtZero // important trick
        anim.duration = item.asset.duration.seconds
        subLayer.add(anim, forKey:nil)
        
        self.synchLayer = syncLayer
    }
    

    // exactly as before; the AVPlayerViewController's player's item's asset...
    // can be a mutable composition
    
    @IBAction func doButton2 (_ sender: Any!) {
        
        let vc = self.children[0] as! AVPlayerViewController
        let p = vc.player! //
        p.pause()
        
        let asset1 = p.currentItem!.asset //
        
        let type = AVMediaType.video
        let arr = asset1.tracks(withMediaType: type)
        let track = arr.last! //
        
        let duration : CMTime = track.timeRange.duration
        
        let comp = AVMutableComposition()
        let comptrack = comp.addMutableTrack(withMediaType: type,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))!
        
        try! comptrack.insertTimeRange(CMTimeRange(start: CMTime(seconds:0, preferredTimescale:600), duration: CMTime(seconds:5, preferredTimescale:600)), of:track, at:CMTime(seconds:0, preferredTimescale:600))
        try! comptrack.insertTimeRange(CMTimeRange(start: duration - CMTime(seconds:5, preferredTimescale:600), duration: CMTime(seconds:5, preferredTimescale:600)), of:track, at:CMTime(seconds:5, preferredTimescale:600))
        
        let type2 = AVMediaType.audio
        let arr2 = asset1.tracks(withMediaType: type2)
        let track2 = arr2.last! //
        let comptrack2 = comp.addMutableTrack(withMediaType: type2, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))!
        
        try! comptrack2.insertTimeRange(CMTimeRange(start: CMTime(seconds:0, preferredTimescale:600), duration: CMTime(seconds:5, preferredTimescale:600)), of:track2, at:CMTime(seconds:0, preferredTimescale:600))
        try! comptrack2.insertTimeRange(CMTimeRange(start: duration - CMTime(seconds:5, preferredTimescale:600), duration: CMTime(seconds:5, preferredTimescale:600)), of:track2, at:CMTime(seconds:5, preferredTimescale:600))
        
        
        let type3 = AVMediaType.audio
        let s = Bundle.main.url(forResource:"aboutTiagol", withExtension:"m4a")!
        let asset2 = AVURLAsset(url:s)
        let arr3 = asset2.tracks(withMediaType: type3)
        let track3 = arr3.last! //
        
        let comptrack3 = comp.addMutableTrack(withMediaType: type3, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))!
        try! comptrack3.insertTimeRange(CMTimeRange(start: CMTime(seconds:0, preferredTimescale:600), duration: CMTime(seconds:10, preferredTimescale:600)), of:track3, at:CMTime(seconds:0, preferredTimescale:600))
        
        let params = AVMutableAudioMixInputParameters(track:comptrack3)
        params.setVolume(1, at:CMTime(seconds:0, preferredTimescale:600))
        params.setVolumeRamp(fromStartVolume: 1, toEndVolume:0, timeRange:CMTimeRange(start: CMTime(seconds:5, preferredTimescale:600), duration: CMTime(seconds:5, preferredTimescale:600)))
        let mix = AVMutableAudioMix()
        mix.inputParameters = [params]
        
        let vidcomp = AVVideoComposition(asset: comp) { req in
            // req is an AVAsynchronousCIImageFilteringRequest
            let f = "CISepiaTone"
            let im = req.sourceImage.applyingFilter(f, parameters: ["inputIntensity":0.95])
            req.finish(with: im, context: nil)
        }
                
        let item = AVPlayerItem(asset:comp)
        item.audioMix = mix
        item.videoComposition = vidcomp
        
        p.replaceCurrentItem(with: item)
        
        (sender as! UIControl).isEnabled = false
        
        var ob : NSKeyValueObservation!
        ob = p.observe(\.status, options:.initial) { vc, ch in
            if p.status == .readyToPlay {
                if let ob = ob {
                    self.obs.remove(ob)
                }
                DispatchQueue.main.async {
                    print("status is ready to play")
                    self.finishConstructingInterface()
                }
            }
        }
        self.obs.insert(ob)

    }

    

    
}
