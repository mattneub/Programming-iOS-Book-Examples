

import UIKit
import AVKit
import AVFoundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController {
    
    var didInitialLayout = false
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }
    
    override func viewDidLayoutSubviews() {
        if !self.didInitialLayout {
            self.didInitialLayout = true
            self.setUpChild()
        }
    }
    
    func setUpChild() {
        let url = NSBundle.mainBundle().URLForResource("ElMirage", withExtension:"mp4")
        let asset = AVURLAsset(URL:url, options:nil)
        asset.loadValuesAsynchronouslyForKeys(["tracks"], completionHandler: {
            let status = asset.statusOfValueForKey("tracks", error: nil)
            if status == .Loaded {
                dispatch_async(dispatch_get_main_queue(), {
                    self.getVideoTrack(asset)
                })
            }
        })
    }
    
    func getVideoTrack(asset:AVAsset) {
        // we have tracks or we wouldn't be here
        let vtrack = asset.tracksWithMediaCharacteristic(AVMediaCharacteristicVisual)[0] as! AVAssetTrack
        vtrack.loadValuesAsynchronouslyForKeys(["naturalSize"], completionHandler: {
            let status = vtrack.statusOfValueForKey("naturalSize", error: nil)
            if status == .Loaded {
                dispatch_async(dispatch_get_main_queue(), {
                    self.getNaturalSize(vtrack, asset)
                })
            }
        })
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
            self, forKeyPath: "readyForDisplay", options: nil, context: nil)
    }
    
    override func observeValueForKeyPath(
        keyPath: String, ofObject object: AnyObject,
        change: [NSObject : AnyObject],
        context: UnsafeMutablePointer<()>) {
            if keyPath == "readyForDisplay" {
                dispatch_async(dispatch_get_main_queue(), {
                    self.finishConstructingInterface()
                })
            }
    }
    
    func finishConstructingInterface () {
        let vc = self.childViewControllers[0] as! AVPlayerViewController
        if !vc.readyForDisplay {
            return
        }
        vc.removeObserver(self, forKeyPath:"readyForDisplay")
        delay(0.3) { // avoid annoying "grow" animation! there ought to be a better way
            vc.view.hidden = false
        }
    }
    



}

