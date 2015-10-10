
import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    enum Slap {
        case Unknown
        case Left
        case Right
    }

    let motman = CMMotionManager()
    var polltimer : NSTimer!
    var canceltimer : CancelableTimer!
    
    var oldX = 0.0
    var oldY = 0.0
    var oldZ = 0.0
    var oldTime : NSTimeInterval = 0
    var lastSlap = Slap.Unknown
    
    @IBAction func doButton (sender:AnyObject!) {
        if !self.motman.accelerometerAvailable {
            print("Oh, well")
            return
        }
        print("starting")
        self.motman.accelerometerUpdateInterval = 1.0 / 30.0
        self.motman.startAccelerometerUpdates()
        self.polltimer = NSTimer.scheduledTimerWithTimeInterval(self.motman.accelerometerUpdateInterval, target: self, selector: "pollAccel:", userInfo: nil, repeats: true)
    }
    
    func addAcceleration(accel:CMAcceleration) {
        let alpha = 0.1
        self.oldX = accel.x - ((accel.x * alpha) + (self.oldX * (1.0 - alpha)))
        self.oldY = accel.y - ((accel.y * alpha) + (self.oldY * (1.0 - alpha)))
        self.oldZ = accel.z - ((accel.z * alpha) + (self.oldZ * (1.0 - alpha)))
    }
    
    func pollAccel(_:AnyObject!) {
        guard let dat = self.motman.accelerometerData else {return}
        self.addAcceleration(dat.acceleration)
        let x = self.oldX
        let thresh = 1.0
        if x < -thresh || x > thresh {
            // print(x)
        }
        if x < -thresh {
            if dat.timestamp - self.oldTime > 0.5 || self.lastSlap == .Right {
                self.oldTime = dat.timestamp
                self.lastSlap = .Left
                self.canceltimer?.cancel()
                self.canceltimer = CancelableTimer(once: true) {
                    print("left")
                }
                self.canceltimer.startWithInterval(0.5)
            }
        } else if x > thresh {
            if dat.timestamp - self.oldTime > 0.5 || self.lastSlap == .Left {
                self.oldTime = dat.timestamp
                self.lastSlap = .Right
                self.canceltimer?.cancel()
                self.canceltimer = CancelableTimer(once: true) {
                    print("right")
                }
                self.canceltimer.startWithInterval(0.5)
            }
        }
    }


    
}
