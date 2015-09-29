

import UIKit
import AVKit
import AVFoundation

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
        let url = NSBundle.mainBundle().URLForResource("ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(URL:url, options:nil)
        asset.loadValuesAsynchronouslyForKeys(["tracks"]) {
            let status = asset.statusOfValueForKey("tracks", error: nil)
            if status == .Loaded {
                dispatch_async(dispatch_get_main_queue(), {
                    self.getVideoTrack(asset)
                })
            }
        }
    }
    
    func getVideoTrack(asset:AVAsset) {
        // we have tracks or we wouldn't be here
        let visual = AVMediaCharacteristicVisual
        let vtrack = asset.tracksWithMediaCharacteristic(visual)[0]
        vtrack.loadValuesAsynchronouslyForKeys(["naturalSize"]) {
            let status = vtrack.statusOfValueForKey("naturalSize", error: nil)
            if status == .Loaded {
                dispatch_async(dispatch_get_main_queue(), {
                    self.getNaturalSize(vtrack, asset)
                })
            }
        }
    }
    
    func getNaturalSize(vtrack:AVAssetTrack, _ asset:AVAsset) {
        // we have a natural size or we wouldn't be here
        let sz = vtrack.naturalSize
        let item = AVPlayerItem(asset:asset)
        let player = AVPlayer(playerItem:item)
        let av = AVPlayerViewController()
        av.view.frame = AVMakeRectWithAspectRatioInsideRect(sz, CGRectMake(10,10,300,200))
        av.player = player
        self.addChildViewController(av)
        av.view.hidden = true
        self.view.addSubview(av.view)
        av.didMoveToParentViewController(self)
        av.addObserver(
            self, forKeyPath: "readyForDisplay", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?,
        context: UnsafeMutablePointer<()>) {
            guard keyPath == "readyForDisplay" else {return}
            guard let vc = object as? AVPlayerViewController else {return}
            guard let ok = change?[NSKeyValueChangeNewKey] as? Bool else {return}
            guard ok else {return}
            vc.removeObserver(self, forKeyPath:"readyForDisplay")
            dispatch_async(dispatch_get_main_queue(), {
                self.finishConstructingInterface(vc)
            })
    }

    
    func finishConstructingInterface (vc:AVPlayerViewController) {
        vc.view.hidden = false
    }
    



}

