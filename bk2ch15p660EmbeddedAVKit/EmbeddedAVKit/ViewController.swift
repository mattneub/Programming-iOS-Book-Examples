

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
        let item = AVPlayerItem(asset:asset)
        let player = AVPlayer(playerItem:item)

        let av = AVPlayerViewController()
        av.player = player
        av.view.frame = CGRectMake(10,10,300,200)
        av.view.hidden = true // looks nicer if we don't show until ready
        self.addChildViewController(av)
        self.view.addSubview(av.view)
        av.didMoveToParentViewController(self)
        
        av.addObserver(self, forKeyPath: "readyForDisplay", options: nil, context: nil)
        
        return; // just proving you can swap out the player
        delay(3) {
            let url = NSBundle.mainBundle().URLForResource("wilhelm", withExtension:"aiff")
            let player = AVPlayer(URL:url)
            av.player = player
        }
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        if keyPath == "readyForDisplay" {
            dispatch_async(dispatch_get_main_queue(), {
                self.finishConstructingInterface()
            })
        }
    }

    func finishConstructingInterface () {
        let vc = self.childViewControllers[0] as AVPlayerViewController
        if !vc.readyForDisplay {
            return
        }
        println("finishing")
        vc.removeObserver(self, forKeyPath:"readyForDisplay")
        vc.view.hidden = false
    }



}

