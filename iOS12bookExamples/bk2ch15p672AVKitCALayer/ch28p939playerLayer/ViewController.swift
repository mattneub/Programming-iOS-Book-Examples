

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
        vc.view.isHidden = false
    }
    
    // warning, test only on device, doesn't work properly in simulator

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
        
        // =======
        
        let vidtrack = comp.tracks(withMediaType: .video)[0]
        let sz = vidtrack.naturalSize
        print(sz)
        let parent = CALayer()
        parent.frame = CGRect(origin: .zero, size: sz)
        let child = CALayer()
        child.frame = parent.bounds
        parent.addSublayer(child)
        
        let lay = CATextLayer()
        lay.string = "This is cool!"
        lay.alignmentMode = .center
        lay.foregroundColor = UIColor.black.cgColor
        lay.frame = child.bounds
        child.addSublayer(lay)
        // did you want fries with that? let's animate the layer
        let ba = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        ba.duration = 1
        ba.fromValue = 0
        ba.toValue = 1
        ba.beginTime = AVCoreAnimationBeginTimeAtZero + 1 // crucial
        ba.fillMode = .backwards
        lay.add(ba, forKey: nil)
        // boilerplate:
        let tool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: child, in: parent)
        let vidcomp = AVMutableVideoComposition()
        vidcomp.animationTool = tool
        // crash if we don't supply renderSize, frameDuration, and instructions
        vidcomp.renderSize = sz
        vidcomp.frameDuration = CMTime(value: 1, timescale: 30)
        // minimal instruction "dance"
        let inst = AVMutableVideoCompositionInstruction()
        let dur = comp.duration
        inst.timeRange = CMTimeRange(start: .zero, duration: dur)
        let layinst = AVMutableVideoCompositionLayerInstruction(assetTrack: vidtrack)
        inst.layerInstructions = [layinst]
        vidcomp.instructions = [inst]
        
        let pre = AVAssetExportPresetHighestQuality
        guard let exporter = AVAssetExportSession(asset: comp, presetName: pre) else {
            print("oops")
            return
        }
        
        let fm = FileManager.default
        var url = fm.temporaryDirectory
        let uuid = UUID().uuidString
        url.appendPathComponent(uuid + ".mov")
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        //
        exporter.videoComposition = vidcomp
        //
        print("beginning export")
        (sender as! UIControl).isEnabled = false
        exporter.exportAsynchronously() {
            DispatchQueue.main.async {
                print("exported!")
                let item = AVPlayerItem(url: url)
                p.replaceCurrentItem(with:item)
            }
        }

        

    }

    

    
}
