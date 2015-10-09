

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var motman = CMMotionManager()
    var timer : NSTimer!
    @IBOutlet var v : MyView!
    var ref : CMAttitude!
    
    @IBAction func doButton (sender:AnyObject!) {
        self.ref = nil // start over if user presses button again
        guard self.motman.deviceMotionAvailable else {
            print("oh well")
            return
        }
        let ref = CMAttitudeReferenceFrame.XArbitraryCorrectedZVertical
        let avail = CMMotionManager.availableAttitudeReferenceFrames()
        guard avail.contains(ref) else {
            print("darn")
            return
        }
        self.motman.deviceMotionUpdateInterval = 1.0 / 20.0
        self.motman.startDeviceMotionUpdatesUsingReferenceFrame(ref)
        let t = 1.0 / 10.0
        self.timer = NSTimer.scheduledTimerWithTimeInterval(t, target:self, selector:"pollAttitude:",userInfo:nil, repeats:true)
    }
    
    func pollAttitude(_:AnyObject!) {
        guard let mot = self.motman.deviceMotion else {return}
        let att = mot.attitude
        if self.ref == nil {
            self.ref = att
            print("got ref \(att.pitch), \(att.roll), \(att.yaw)")
            return
        }
        att.multiplyByInverseOfAttitude(self.ref)
        let r = att.rotationMatrix
        
        var t = CATransform3DIdentity
        // even more Swift numeric barf
        t.m11 = CGFloat(r.m11)
        t.m12 = CGFloat(r.m12)
        t.m13 = CGFloat(r.m13)
        t.m21 = CGFloat(r.m21)
        t.m22 = CGFloat(r.m22)
        t.m23 = CGFloat(r.m23)
        t.m31 = CGFloat(r.m31)
        t.m32 = CGFloat(r.m32)
        t.m33 = CGFloat(r.m33)

        let lay = self.v.layer.sublayers![0]
        CATransaction.setAnimationDuration(1.0/10.0)
        lay.transform = t
    }

}
