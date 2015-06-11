

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let motman = CMMotionManager()
    var timer : NSTimer!
    @IBOutlet var label : UILabel!
    var oldX = 0.0
    var oldY = 0.0
    var oldZ = 0.0
    var state = 0
    
    func stopAccelerometer () {
        self.timer?.invalidate()
        self.timer = nil
        self.motman.stopAccelerometerUpdates()
        self.label.text = ""
        (oldX, oldY, oldZ, state) = (0,0,0,0)
    }
    
    @IBAction func doButton (sender:AnyObject!) {
        if self.motman.accelerometerActive {
            self.stopAccelerometer()
            return
        }
        if !self.motman.accelerometerAvailable {
            println("Oh, well")
            return
        }
        self.motman.accelerometerUpdateInterval = 1.0 / 30.0
        
        let which = 1
        switch which {
        case 1:
            self.motman.startAccelerometerUpdates()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(self.motman.accelerometerUpdateInterval, target: self, selector: "pollAccel:", userInfo: nil, repeats: true)
        case 2:
            self.motman.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
                (accelerometerData:CMAccelerometerData!, error:NSError!) in
                if error != nil {
                    println(error)
                    self.stopAccelerometer()
                    return
                }
                self.receiveAccel(accelerometerData)
            })
        default:break
        }
    }
    
    func pollAccel (_:AnyObject!) {
        let dat = self.motman.accelerometerData
        if dat == nil { return }
        self.receiveAccel(dat)
    }
    
    func addAcceleration(accel:CMAcceleration) {
        let alpha = 0.1
        self.oldX = accel.x * alpha + self.oldX * (1.0 - alpha)
        self.oldY = accel.y * alpha + self.oldY * (1.0 - alpha)
        self.oldZ = accel.z * alpha + self.oldZ * (1.0 - alpha)
    }

    func receiveAccel (dat:CMAccelerometerData) {
        self.addAcceleration(dat.acceleration)
        let x = self.oldX
        let y = self.oldY
        let z = self.oldZ
        let accu = 0.08
        if abs(x) < accu && abs(y) < accu && z < -0.5 {
            if self.state == -1 || self.state == 1 {
                self.state = 0
                self.label.text = "I'm lying on my back... ahhh..."
            }
        } else {
            if self.state == -1 || self.state == 0 {
                self.state = 1
                self.label.text = "Hey, put me back down on the table!"
            }
        }
    }

}
