

import UIKit
import AVKit
import AVFoundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


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
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

//    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
//            return UIInterfaceOrientationMask.All
//        }
//        return UIInterfaceOrientationMask.Landscape
//    }
    

    let which = 2
    
    @IBAction func go() {
        switch which {
        case 1:
            let url = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
            let asset = AVURLAsset(url:url)
            let item = AVPlayerItem(asset:asset)
            let player = AVPlayer(playerItem:item)
            let av = AVPlayerViewController()
            av.view.frame = CGRect(10,10,300,200)
            av.player = player
            self.addChild(av)
            self.view.addSubview(av.view)
            av.didMove(toParent: self)
        case 2:
            self.setUpChild()
        default: break
        }
    }
    
    func setUpChild() {
        print("starting", Date().timeIntervalSince1970)
        let url = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(url:url)
        let track = #keyPath(AVURLAsset.tracks)
        asset.loadValuesAsynchronously(forKeys:[track]) {
            let status = asset.statusOfValue(forKey:track, error: nil)
            if status == .loaded {
                DispatchQueue.main.async {
                    print("got the tracks", Date().timeIntervalSince1970)
                    self.getVideoTrack(asset)
                }
            }
        }
    }
    
    func getVideoTrack(_ asset:AVAsset) {
        // we have tracks or we wouldn't be here
        let visual = AVMediaCharacteristic.visual
        let vtrack = asset.tracks(withMediaCharacteristic: visual)[0]
        let size = #keyPath(AVAssetTrack.naturalSize)
        vtrack.loadValuesAsynchronously(forKeys: [size]) {
            let status = vtrack.statusOfValue(forKey: size, error: nil)
            if status == .loaded {
                DispatchQueue.main.async {
                    print("got the natural size", Date().timeIntervalSince1970)
                    self.getNaturalSize(vtrack, asset)
                }
            }
        }
    }
    
    var obs = Set<NSKeyValueObservation>()
    
    func getNaturalSize(_ vtrack:AVAssetTrack, _ asset:AVAsset) {
        // we have a natural size or we wouldn't be here
        print("finishing view setup")
        let sz = vtrack.naturalSize
        let item = AVPlayerItem(asset:asset)
        let player = AVPlayer(playerItem:item)
        let av = AVPlayerViewController()
        av.view.frame = AVMakeRect(aspectRatio: sz, insideRect: CGRect(10,10,300,200))
        av.player = player
        self.addChild(av)
        av.view.isHidden = true
        self.view.addSubview(av.view)
        av.didMove(toParent: self)
        
        // an alternative solution
        print("asking for poster", Date().timeIntervalSince1970)
        let gen = AVAssetImageGenerator(asset: asset)
        var iv : UIImageView?
        if let cgim = try? gen.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 60), actualTime: nil) {
            let im = UIImage(cgImage: cgim)
            iv = UIImageView(image:im)
            iv!.contentMode = .scaleAspectFit
            iv!.frame = av.view.frame
            print("show poster", Date().timeIntervalSince1970)
            self.view.addSubview(iv!)
        }
        

        var ob : NSKeyValueObservation!
        ob = av.observe(\.isReadyForDisplay, options: [.initial, .new]) { vc, ch in
            guard let ok = ch.newValue, ok else {return}
            self.obs.remove(ob)
            DispatchQueue.main.async {
                print("ready for display!", Date().timeIntervalSince1970)
                vc.view.isHidden = false // hmm, maybe I should be animating the alpha instead
                // delay(0.2) { // I just want to see if they match
                iv?.removeFromSuperview()
                // }
                // just playing, pay no attention
                let player = vc.player!
                let item = player.currentItem!
                // well _this_ seems like a step back from renamification!
                print(CMTimebaseGetRate(item.timebase!))
            }
        }
        self.obs.insert(ob)
        
        let ob2 = av.player!.observe(\.status) { player, ch in
            if player.status == .failed {
                let err = player.error
                print(err as Any)
            }
        }
        self.obs.insert(ob2)
        
        

    }
    


}

