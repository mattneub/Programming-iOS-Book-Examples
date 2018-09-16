

import UIKit
import AVKit
import AVFoundation

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
            self.addChildViewController(av)
            self.view.addSubview(av.view)
            av.didMove(toParentViewController: self)
        case 2:
            self.setUpChild()
        default: break
        }
    }
    
    func setUpChild() {
        let url = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(url:url)
        let track = #keyPath(AVURLAsset.tracks)
        asset.loadValuesAsynchronously(forKeys:[track]) {
            let status = asset.statusOfValue(forKey:track, error: nil)
            if status == .loaded {
                DispatchQueue.main.async {
                    self.getVideoTrack(asset)
                }
            }
        }
    }
    
    func getVideoTrack(_ asset:AVAsset) {
        // we have tracks or we wouldn't be here
        let visual = AVMediaCharacteristicVisual
        let vtrack = asset.tracks(withMediaCharacteristic: visual)[0]
        let size = #keyPath(AVAssetTrack.naturalSize)
        vtrack.loadValuesAsynchronously(forKeys: [size]) {
            let status = vtrack.statusOfValue(forKey: size, error: nil)
            if status == .loaded {
                DispatchQueue.main.async {
                    self.getNaturalSize(vtrack, asset)
                }
            }
        }
    }
    
    func getNaturalSize(_ vtrack:AVAssetTrack, _ asset:AVAsset) {
        // we have a natural size or we wouldn't be here
        let sz = vtrack.naturalSize
        let item = AVPlayerItem(asset:asset)
        let player = AVPlayer(playerItem:item)
        let av = AVPlayerViewController()
        av.view.frame = AVMakeRect(aspectRatio: sz, insideRect: CGRect(10,10,300,200))
        av.player = player
        self.addChildViewController(av)
        av.view.isHidden = true
        self.view.addSubview(av.view)
        av.didMove(toParentViewController: self)
        av.addObserver(
            self, forKeyPath: #keyPath(AVPlayerViewController.readyForDisplay), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            let ready = #keyPath(AVPlayerViewController.readyForDisplay)
            guard keyPath == ready else {return}
            guard let vc = object as? AVPlayerViewController else {return}
            guard let ok = change?[.newKey] as? Bool else {return}
            guard ok else {return}
            vc.removeObserver(self, forKeyPath:ready)
            DispatchQueue.main.async {
                vc.view.isHidden = false
            }
    }

    



}

