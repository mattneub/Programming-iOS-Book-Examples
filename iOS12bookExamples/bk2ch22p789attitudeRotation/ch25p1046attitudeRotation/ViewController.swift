

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var motman = CMMotionManager()
    var timer : Timer!
    @IBOutlet var v : MyView!
    var ref : CMAttitude!
    
    @IBAction func doButton (_ sender: Any!) {
        self.ref = nil // start over if user presses button again
        guard self.motman.isDeviceMotionAvailable else {
            print("oh well")
            return
        }
        let ref = CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical
        let avail = CMMotionManager.availableAttitudeReferenceFrames()
        guard avail.contains(ref) else {
            print("darn")
            return
        }
        self.motman.deviceMotionUpdateInterval = 1.0 / 20.0
        self.motman.startDeviceMotionUpdates(using: ref)
        let t = 1.0 / 10.0
        self.timer = Timer.scheduledTimer(timeInterval:t, target:self, selector:#selector(pollAttitude),userInfo:nil, repeats:true)
    }
    
    @objc func pollAttitude(_: Any!) {
        guard let mot = self.motman.deviceMotion else {return}
        let att = mot.attitude
        if self.ref == nil {
            self.ref = att
            print("got ref \(att.pitch), \(att.roll), \(att.yaw)")
            return
        }
        att.multiply(byInverseOf: self.ref)
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
