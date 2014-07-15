
import UIKit

extension CGAffineTransform : Printable {
    var description : String {
    return NSStringFromCGAffineTransform(self)
    }
}

class ViewController : UIViewController {
    @IBOutlet var lab: UILabel
    
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
        self.adjustLabel()
        UIViewController.attemptRotationToDeviceOrientation()
        // there's a bug here (at least I take it to be a bug) in iOS 8 only:
        // we rotate but the app does not resize itself to fit the new orientation
        // if you run in iOS 7
    }
    
    // rotation events (willAnimateRotation, willRotateTo, didRotateFrom) deprecated in iOS 8
    // instead, use this:
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!) {
        println("will transition size change to \(size)")
        println("with target transform \(coordinator.targetTransform())") // *
        // apparently does not mean that anyone will actually have this transform ultimately
        // it's just a way of describing what the effective rotation is?
        println("screen bounds: \(UIScreen.mainScreen().bounds)")
        println("screen native bounds: \(UIScreen.mainScreen().nativeBounds)")
        println("screen coord space bounds: \(UIScreen.mainScreen().coordinateSpace.bounds)") // *
        println("screen fixed space bounds: \(UIScreen.mainScreen().fixedCoordinateSpace.bounds)") // *
        // haven't figure this out yet
        let sp = UIScreen.mainScreen().coordinateSpace
        let r = sp.convertRect(sp.bounds, toCoordinateSpace: UIScreen.mainScreen().fixedCoordinateSpace)
        println("coordinate space bounds converted into fixed space: \(r)")
        println("window frame: \(self.view.window.frame)")
        println("window bounds: \(self.view.window.bounds)")
        println("window transform: \(self.view.window.transform)")
        println("view transform: \(self.view.transform)")
        coordinator.animateAlongsideTransition({
            _ in
            println("transitioning size change to \(size)")
            }, completion: {
                _ in
                // showing that in iOS 8 the screen itself changes "size"
                println("did transition size change to \(size)")
                println("screen bounds: \(UIScreen.mainScreen().bounds)")
                println("screen native bounds: \(UIScreen.mainScreen().nativeBounds)")
                // screen native bounds do not change and are expressed in scale resolution
                println("screen coord space bounds: \(UIScreen.mainScreen().coordinateSpace.bounds)")
                println("screen fixed space bounds: \(UIScreen.mainScreen().fixedCoordinateSpace.bounds)")
                // haven't figure this out yet
                let sp = UIScreen.mainScreen().coordinateSpace
                let r = sp.convertRect(sp.bounds, toCoordinateSpace: UIScreen.mainScreen().fixedCoordinateSpace)
                println("coordinate space bounds converted into fixed space: \(r)")
                println("window frame: \(self.view.window.frame)")
                println("window bounds: \(self.view.window.bounds)")
                // showing that in iOS 8 rotation no longer involves application of transform to view
                println("window transform: \(self.view.window.transform)")
                println("view transform: \(self.view.transform)")
                
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
