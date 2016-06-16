

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
    
    var didInitialLayout = false
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
//            return UIInterfaceOrientationMask.All
//        }
//        return UIInterfaceOrientationMask.Landscape
//    }
    
    override func viewDidLayoutSubviews() {
        if !self.didInitialLayout {
            self.didInitialLayout = true
            self.setUpChild()
        }
    }
    
    func setUpChild() {
        let url = Bundle.main().urlForResource("ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(url:url)
        asset.loadValuesAsynchronously(forKeys:["tracks"]) {
            let status = asset.statusOfValue(forKey:"tracks", error: nil)
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
        vtrack.loadValuesAsynchronously(forKeys: ["naturalSize"]) {
            let status = vtrack.statusOfValue(forKey: "naturalSize", error: nil)
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
            self, forKeyPath: "readyForDisplay", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
            guard keyPath == "readyForDisplay" else {return}
            guard let vc = object as? AVPlayerViewController else {return}
            guard let ok = change?[NSKeyValueChangeKey.newKey] as? Bool else {return}
            guard ok else {return}
            vc.removeObserver(self, forKeyPath:"readyForDisplay")
            DispatchQueue.main.async {
                self.finishConstructingInterface(vc)
            }
    }

    
    func finishConstructingInterface (_ vc:AVPlayerViewController) {
        vc.view.isHidden = false
    }
    



}

