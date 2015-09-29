

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
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return .All
        }
        return .Landscape
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
        _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: [])
    }
    
    let which = 2
    
    override func viewDidLayoutSubviews() {
        if !self.didInitialLayout {
            self.didInitialLayout = true
            switch which {
            case 1:
                self.setUpChildSimple()
            case 2:
                self.setUpChild()
            default:break
            }
        }
    }
    
    func setUpChildSimple() {
        let url = NSBundle.mainBundle().URLForResource(
            "ElMirage", withExtension:"mp4")!
        let player = AVPlayer(URL:url)
        let av = AVPlayerViewController()
        av.player = player
        av.view.frame = CGRectMake(10,10,300,200)
        self.addChildViewController(av)
        self.view.addSubview(av.view)
        av.didMoveToParentViewController(self)
    }
    
    func setUpChild() {
        let url = NSBundle.mainBundle().URLForResource("ElMirage", withExtension:"mp4")!
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
            let url = NSBundle.mainBundle().URLForResource("wilhelm", withExtension:"aiff")!
            let player = AVPlayer(URL:url)
            av.player = player
        }
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
        print("finishing")
        vc.view.hidden = false // hmm, maybe I should be animating the alpha instead
    }
}

extension ViewController : UIVideoEditorControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    @IBAction func doEditorButton (sender:AnyObject!) {
        let path = NSBundle.mainBundle().pathForResource("ElMirage", ofType: "mp4")!
        let can = UIVideoEditorController.canEditVideoAtPath(path)
        if !can {
            print("can't edit this video")
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
        print(vc.modalPresentationStyle.rawValue)
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
        print("saved to \(editedVideoPath)")
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(editedVideoPath) {
            print("saving to photos album")
            UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath, self, "video:savedWithError:ci:", nil)
        } else {
            print("can't save to photos album, need to think of something else")
        }
    }
    
    func video(video:NSString!, savedWithError error:NSError!, ci:UnsafeMutablePointer<()>) {
        print("error:\(error)")
        /*
        Important to check for error, because user can deny access
        to Photos library
        If that's the case, we will get error like this:
        Error Domain=ALAssetsLibraryErrorDomain Code=-3310 "Data unavailable" UserInfo=0x1d8355d0 {NSLocalizedRecoverySuggestion=Launch the Photos application, NSUnderlyingError=0x1d83d470 "Data unavailable", NSLocalizedDescription=Data unavailable}
        */
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func videoEditorControllerDidCancel(editor: UIVideoEditorController) {
        print("editor cancelled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func videoEditorController(editor: UIVideoEditorController, didFailWithError error: NSError) {
        print("error: \(error.localizedDescription)")
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
        print("editor popover dismissed")
    }
    
}

