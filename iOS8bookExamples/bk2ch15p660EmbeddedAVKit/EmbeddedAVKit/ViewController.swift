

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
        
        /*
        // just experimenting
        let grs = (av.view.subviews[0] as UIView).gestureRecognizers as [UIGestureRecognizer]
        for gr in grs {
        if gr is UIPinchGestureRecognizer {
        gr.enabled = false
        }
        }
        */
        
        av.addObserver(self, forKeyPath: "readyForDisplay", options: .New, context: nil)
        
        return; // just proving you can swap out the player
        delay(3) {
            let url = NSBundle.mainBundle().URLForResource("wilhelm", withExtension:"aiff")
            let player = AVPlayer(URL:url)
            av.player = player
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        if keyPath == "readyForDisplay",
            let obj = object as? AVPlayerViewController,
            ok = change[NSKeyValueChangeNewKey] as? Bool where ok {
                dispatch_async(dispatch_get_main_queue(), {
                    self.finishConstructingInterface(obj)
                })
        }
    }
    
    func finishConstructingInterface (vc:AVPlayerViewController) {
        println("finishing")
        vc.removeObserver(self, forKeyPath:"readyForDisplay")
        vc.view.hidden = false // hmm, maybe I should be animating the alpha instead
    }
}

extension ViewController : UIVideoEditorControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    @IBAction func doEditorButton (sender:AnyObject!) {
        let path = NSBundle.mainBundle().pathForResource("ElMirage", ofType: "mp4")!
        let can = UIVideoEditorController.canEditVideoAtPath(path)
        if !can {
            println("can't edit this video")
            return
        }
        let vc = UIVideoEditorController()
        vc.delegate = self
        vc.videoPath = path
        // must set to popover _manually_ on iPad! exception on presentation if you don't
        // could just set it; works fine as adaptive on iPhone
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            vc.modalPresentationStyle = .Popover
        }
        self.presentViewController(vc, animated: true, completion: nil)
        println(vc.modalPresentationStyle.rawValue)
        if let pop = vc.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
            pop.delegate = self
        }
        // both Cancel and Save on phone (Cancel and Use on pad) dismiss the v.c.
        // but without delegate methods, you don't know what happened or where the edited movie is
        // with delegate methods, on the other hand, dismissing is up to you
    }
    
    func videoEditorController(editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        println("saved to \(editedVideoPath)")
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(editedVideoPath) {
            println("saving to photos album")
            UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath, self, "video:savedWithError:ci:", nil)
        } else {
            println("can't save to photos album, need to think of something else")
        }
    }
    
    func video(video:NSString!, savedWithError error:NSError!, ci:UnsafeMutablePointer<()>) {
        println("did save, error:\(error)")
        /*
        Important to check for error, because user can deny access
        to Photos library
        If that's the case, we will get error like this:
        Error Domain=ALAssetsLibraryErrorDomain Code=-3310 "Data unavailable" UserInfo=0x1d8355d0 {NSLocalizedRecoverySuggestion=Launch the Photos application, NSUnderlyingError=0x1d83d470 "Data unavailable", NSLocalizedDescription=Data unavailable}
        */
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func videoEditorControllerDidCancel(editor: UIVideoEditorController) {
        println("editor cancelled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func videoEditorController(editor: UIVideoEditorController, didFailWithError error: NSError) {
        println("error: \(error.localizedDescription)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        let vc = viewController as UIViewController
        vc.title = ""
        vc.navigationItem.title = ""
        // I can suppress the title but I haven't found a way to fix the right bar button
        // (so that it says Save instead of Use)
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        println("editor popover dismissed")
    }
    
}

