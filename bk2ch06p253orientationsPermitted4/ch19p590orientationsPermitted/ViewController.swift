
import UIKit

class ViewController : UIViewController {
    
    var shouldRotate = false
    
    override func supportedInterfaceOrientations() -> Int {
        
        // aha, this explains why we are called 10 times;
        // the first 9 times, the device doesn't have an orientation yet
        let orientation = UIDevice.currentDevice().orientation
        println("supported, device \(orientation.toRaw())")
        
        if orientation != .Unknown {
            println("self \(self.interfaceOrientation.toRaw())")
            // but the above is deprecated in iOS 8; ask about the status bar instead
            println("status bar \(UIApplication.sharedApplication().statusBarOrientation.toRaw())")
        }
        
        return Int(UIInterfaceOrientationMask.All.toRaw())
        // but not really, because the app is only portrait and the two landscapes
        // if we add upside-down, we crash when the app tries to rotate upside-down
    }
    
    override func shouldAutorotate() -> Bool {
        
        let orientation = UIDevice.currentDevice().orientation
        println("should, device \(orientation.toRaw())")
        
        if orientation != .Unknown {
            println("self \(self.interfaceOrientation.toRaw())")
            // but the above is deprecated in iOS 8; ask about the status bar instead
            println("status bar \(UIApplication.sharedApplication().statusBarOrientation.toRaw())")
        }
        // return true
        return self.shouldRotate
    }
    
    // rotate and tap the button to test attemptRotation and shouldAutorotate
    
    @IBAction func doButton(sender:AnyObject?) {
        self.shouldRotate = !self.shouldRotate
        UIViewController.attemptRotationToDeviceOrientation()
        // there's a bug here (at least I take it to be a bug) in iOS 8 only:
        // we rotate but the app does not resize itself to fit the new orientation
        // if you run in iOS 7
    }
    
    // rotation events (willAnimateRotation, willRotateTo, didRotateFrom) deprecated in iOS 8
    // instead, use this:
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!) {
        println("will transition size change to \(size)")
        coordinator.animateAlongsideTransition({
            _ in
            println("transitioning size change to \(size)")
            }, completion: {
            _ in
            println("did transition size change to \(size)")
            })
    }
    
    // layout events check
    
    override func viewWillLayoutSubviews() {
        println(__FUNCTION__)
    }
    
    override func viewDidLayoutSubviews() {
        println(__FUNCTION__)
    }
    
    override func updateViewConstraints() {
        println(__FUNCTION__)
        super.updateViewConstraints()
    }
}
