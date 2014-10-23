

import UIKit
import MediaPlayer
import AVFoundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController, UINavigationControllerDelegate, UIVideoEditorControllerDelegate, UIPopoverPresentationControllerDelegate {

    var didInitialLayout = false
    var mpc : MPMoviePlayerController?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func willFullscreen(n:NSNotification) {
        println("will fullscreen")
        // I don't see how to prevent it
    }
    
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
            self.setUpMPC()
        }
    }
    
    func setUpMPC() {
        let m = NSBundle.mainBundle().URLForResource("ElMirage", withExtension: "mp4")
        // let m = NSBundle.mainBundle().URLForResource("wilhelm", withExtension: "aiff")
        let mp = MPMoviePlayerController(contentURL: m)
        self.mpc = mp
        self.mpc!.shouldAutoplay = false
        self.mpc!.view.frame = CGRectMake(10, 10, 300, 250)
        self.mpc!.backgroundView.backgroundColor = UIColor.redColor()
        self.mpc!.prepareToPlay()
        //self.mpc!.controlStyle = .Fullscreen
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateChanged:", name: MPMoviePlayerPlaybackStateDidChangeNotification, object: self.mpc)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willFullscreen:", name: MPMoviePlayerWillEnterFullscreenNotification, object: self.mpc)
        
        let which = 1
        switch which {
        case 1:
            var observer : NSObjectProtocol! = nil
            observer = NSNotificationCenter.defaultCenter().addObserverForName(MPMoviePlayerReadyForDisplayDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                (n:NSNotification!) -> () in
                NSNotificationCenter.defaultCenter().removeObserver(observer)
                self.view.addSubview(self.mpc!.view)
            })
        case 2:
            var observer : NSObjectProtocol! = nil
            observer = NSNotificationCenter.defaultCenter().addObserverForName(MPMovieNaturalSizeAvailableNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                (n:NSNotification!) -> () in
                NSNotificationCenter.defaultCenter().removeObserver(observer)
                self.finishSetup()
            })
        default:break
        }
    }
    
    func finishSetup() {
        println("finishing setup")
        var f = self.mpc!.view.bounds
        f.size = self.mpc!.naturalSize
        // make width 300, keep ratio
        let ratio = 300.0/f.size.width
        f.size.width *= ratio
        f.size.height *= ratio
        self.mpc!.view.bounds = f
        self.view.addSubview(self.mpc!.view)
    }
    
    // just testing, pay no attention
    func stateChanged(n:NSNotification) {
        println("state changed: \((n.object as MPMoviePlayerController).playbackState.rawValue)")
        return;
        println(AVAudioSession.sharedInstance().category)
        if self.mpc!.playbackState == .Playing {
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        } else {
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient, withOptions: nil, error: nil)
        }
    }
    
    // =========================
    
    @IBAction func doButton (sender:AnyObject!) {
        let m = NSBundle.mainBundle().URLForResource("ElMirage", withExtension: "mp4")
        let mpvc = MyMoviePlayerViewController(contentURL: m)
        // mpvc.moviePlayer.shouldAutoplay = false
        self.presentMoviePlayerViewControllerAnimated(mpvc)
        // mpvc.moviePlayer.initialPlaybackTime = 0
        // mpvc.moviePlayer.endPlaybackTime = 60 + 57
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "vcFinished:", name: MPMoviePlayerPlaybackDidFinishNotification, object: mpvc.moviePlayer)
    }

    func vcFinished(n:NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        println("did finish \(n)")
        // try commenting this out and you'll see what the problem is:
        // There Can Be Only One
        // so after our MPMoviePlayerViewController, our MPMoviePlayerController's view is busted
        // to prevent that, we call prepareToPlay
        self.mpc!.prepareToPlay()
    }
    
    // ===============
    
    // note: must run on device; no video editing in simulator
    
    @IBAction func doEditorButton (sender:AnyObject!) {
        let path = NSBundle.mainBundle().pathForResource("ElMirage", ofType: "mp4")!
        let can = UIVideoEditorController.canEditVideoAtPath(path)
        if !can {
            println("can't edit this video")
            return
        }
        let vc = MyVideoEditorController()
        vc.delegate = self
        vc.videoPath = path
        // must set to popover _manually_ on iPad! exception on presentation if you don't
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            vc.modalPresentationStyle = .Popover
        }
        self.presentViewController(vc, animated: true, completion: nil)
        if let pop = vc.popoverPresentationController {
            let v = sender as UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
            pop.delegate = self
        }
        // both Cancel and Save on phone (Cancel and Use on pad) dismiss the v.c.
        // but without delegate methods, you don't know what happened or where the edited movie is
        // with delegate methods, on the other hand, dismissing is up to you
    }

    func videoEditorController(editor: UIVideoEditorController!, didSaveEditedVideoToPath editedVideoPath: String!) {
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
    
    func videoEditorControllerDidCancel(editor: UIVideoEditorController!) {
        println("editor cancelled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func videoEditorController(editor: UIVideoEditorController!, didFailWithError error: NSError!) {
        println("error: \(error.localizedDescription)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController!, willShowViewController viewController: UIViewController!, animated: Bool) {
        let vc = viewController as UIViewController
        vc.title = ""
        vc.navigationItem.title = ""
        // I can suppress the title but I haven't found a way to fix the right bar button
        // (so that it says Save instead of Use)
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController!) {
        println("editor popover dismissed")
    }
}
