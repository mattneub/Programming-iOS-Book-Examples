
import UIKit

extension CGAffineTransform : Printable {
    public var description : String {
    return NSStringFromCGAffineTransform(self)
    }
}
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController {
    @IBOutlet var lab: UILabel!
    @IBOutlet var v: UIView!
    
    var shouldRotate = false
    
    func adjustLabel() {
        self.lab.text = shouldRotate ? "On" : "Off"
    }
    
    override func viewDidLoad() {
        self.adjustLabel()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        // aha, this explains why we are called 10 times;
        // the first 9 times, the device doesn't have an orientation yet
        let orientation = UIDevice.currentDevice().orientation
        println("supported, device \(orientation.rawValue)")
        
        if orientation != .Unknown {
            println("self \(self.interfaceOrientation.rawValue)")
            // but the above is deprecated in iOS 8; ask about the status bar instead
            println("status bar \(UIApplication.sharedApplication().statusBarOrientation.rawValue)")
        }
        
        return Int(UIInterfaceOrientationMask.All.rawValue)
        // but not really, because the app is only portrait and the two landscapes
        // if we add upside-down, we crash when the app tries to rotate upside-down
    }
    
    override func shouldAutorotate() -> Bool {
        
        let orientation = UIDevice.currentDevice().orientation
        println("should, device \(orientation.rawValue)")
        
        if orientation != .Unknown {
            println("self \(self.interfaceOrientation.rawValue)")
            // but the above is deprecated in iOS 8; ask about the status bar instead
            println("status bar \(UIApplication.sharedApplication().statusBarOrientation.rawValue)")
        }
        // return true
        return self.shouldRotate
    }
    
    // rotate and tap the button to test attemptRotation and shouldAutorotate
    
    @IBAction func doButton(sender:AnyObject?) {
        self.shouldRotate = !self.shouldRotate
        self.adjustLabel()
        delay(0.1) {
            UIViewController.attemptRotationToDeviceOrientation()
        }
        // there's a bug here (at least I take it to be a bug) in iOS 8 only:
        // if you rotate the device and then tap the button,
        // we rotate but the app does not resize itself to fit the new orientation
        // if you run in iOS 7 it works fine
        // aaaah, looks like they fixed this bug in time
    }
    
    // rotation events (willAnimateRotation, willRotateTo, didRotateFrom) deprecated in iOS 8
    // instead, use this:
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // call super
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        println("will transition size change to \(size)")
        println("with target transform \(coordinator.targetTransform())") // *
        // apparently does not mean that anyone will actually have this transform ultimately
        // it's just a way of describing what the effective rotation is?
        println("screen bounds: \(UIScreen.mainScreen().bounds)")
        println("screen native bounds: \(UIScreen.mainScreen().nativeBounds)")
        println("screen coord space bounds: \(UIScreen.mainScreen().coordinateSpace.bounds)") // *
        println("screen fixed space bounds: \(UIScreen.mainScreen().fixedCoordinateSpace.bounds)") // *
        let r = self.view.convertRect(self.lab.frame, toCoordinateSpace: UIScreen.mainScreen().fixedCoordinateSpace)
        println("label's frame converted into fixed space: \(r)")
        println("window frame: \(self.view.window!.frame)")
        println("window bounds: \(self.view.window!.bounds)")
        println("window transform: \(self.view.window!.transform)")
        println("view transform: \(self.view.transform)")
        coordinator.animateAlongsideTransition({
            _ in
            println("transitioning size change to \(size)")
            // arrow keeps pointing to physical top of device
            self.v.transform = CGAffineTransformConcat(CGAffineTransformInvert(coordinator.targetTransform()), self.v.transform)
            }, completion: {
                _ in
                // showing that in iOS 8 the screen itself changes "size"
                println("did transition size change to \(size)")
                println("screen bounds: \(UIScreen.mainScreen().bounds)")
                println("screen native bounds: \(UIScreen.mainScreen().nativeBounds)")
                // screen native bounds do not change and are expressed in scale resolution
                println("screen coord space bounds: \(UIScreen.mainScreen().coordinateSpace.bounds)")
                println("screen fixed space bounds: \(UIScreen.mainScreen().fixedCoordinateSpace.bounds)")
                // concentrate on the green label and think about these numbers:
                // the fixed coordinate space's top left is glued to the top left of the physical device
                let r = self.view.convertRect(self.lab.frame, toCoordinateSpace: UIScreen.mainScreen().fixedCoordinateSpace)
                println("label's frame converted into fixed space: \(r)")
                println("window frame: \(self.view.window!.frame)")
                println("window bounds: \(self.view.window!.bounds)")
                // showing that in iOS 8 rotation no longer involves application of transform to view
                println("window transform: \(self.view.window!.transform)")
                println("view transform: \(self.view.transform)")
                println(CGAffineTransformIdentity)
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
