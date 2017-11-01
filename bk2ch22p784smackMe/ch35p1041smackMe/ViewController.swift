
import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    enum Slap {
        case unknown
        case left
        case right
    }

    let motman = CMMotionManager()
    var polltimer : Timer!
    var canceltimer : Timer!
    
    var oldX = 0.0
    var oldY = 0.0
    var oldZ = 0.0
    var oldTime : TimeInterval = 0
    var lastSlap = Slap.unknown
    
    @IBAction func doButton (_ sender: Any!) {
        if !self.motman.isAccelerometerAvailable {
            print("Oh, well")
            return
        }
        print("starting")
        self.motman.accelerometerUpdateInterval = 1.0 / 30.0
        self.motman.startAccelerometerUpdates()
        self.polltimer = Timer.scheduledTimer(timeInterval:self.motman.accelerometerUpdateInterval, target: self, selector: #selector(pollAccel), userInfo: nil, repeats: true)
    }
    
    func add(acceleration accel:CMAcceleration) {
        let alpha = 0.1
        self.oldX = accel.x - ((accel.x * alpha) + (self.oldX * (1.0 - alpha)))
        self.oldY = accel.y - ((accel.y * alpha) + (self.oldY * (1.0 - alpha)))
        self.oldZ = accel.z - ((accel.z * alpha) + (self.oldZ * (1.0 - alpha)))
    }
    
    @objc func pollAccel(_: Any!) {
        guard let data = self.motman.accelerometerData else {return}
        self.add(acceleration: data.acceleration)
        let x = self.oldX
        let thresh = 1.0
        if x < -thresh || x > thresh {
            // print(x)
        }
        if x < -thresh {
            if data.timestamp - self.oldTime > 0.5 || self.lastSlap == .right {
                self.oldTime = data.timestamp
                self.lastSlap = .left
                //print("invalidating")
                self.canceltimer?.invalidate()
                self.canceltimer = .scheduledTimer(withTimeInterval:0.5, repeats: false) {
                    _ in print("left")
                }
            }
        } else if x > thresh {
            if data.timestamp - self.oldTime > 0.5 || self.lastSlap == .left {
                self.oldTime = data.timestamp
                self.lastSlap = .right
                //print("invalidating")
                self.canceltimer?.invalidate()
                self.canceltimer = .scheduledTimer(withTimeInterval:0.5, repeats: false) {
                    _ in print("right")
                }
            }
        }
    }


    
}
