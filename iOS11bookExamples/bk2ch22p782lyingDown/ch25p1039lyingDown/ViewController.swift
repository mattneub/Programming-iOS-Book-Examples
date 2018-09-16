

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    enum State {
        case unknown
        case lyingDown
        case notLyingDown
    }

    let motman = CMMotionManager()
    var timer : Timer!
    @IBOutlet var label : UILabel!
    var oldX = 0.0
    var oldY = 0.0
    var oldZ = 0.0
    var state = State.unknown
    
    func stopAccelerometer () {
        self.timer?.invalidate()
        self.timer = nil
        self.motman.stopAccelerometerUpdates()
        self.label.text = ""
        (oldX, oldY, oldZ, state) = (0,0,0,.unknown)
    }
    
    @IBAction func doButton (_ sender: Any!) {
        if self.motman.isAccelerometerActive {
            self.stopAccelerometer()
            return
        }
        guard self.motman.isAccelerometerAvailable else {
            print("Oh, well")
            return
        }
        self.motman.accelerometerUpdateInterval = 1.0 / 30.0
        
        var which : Int { return 1 }
        switch which {
        case 1:
            self.motman.startAccelerometerUpdates()
            self.timer = Timer.scheduledTimer(timeInterval:self.motman.accelerometerUpdateInterval, target: self, selector: #selector(pollAccel), userInfo: nil, repeats: true)
        case 2:
            self.motman.startAccelerometerUpdates(to: .main) { data, err in
                guard let data = data else {
                    print(err as Any)
                    self.stopAccelerometer()
                    return
                }
                self.receive(acceleration:data)
            }
        default:break
        }
    }
    
    @objc func pollAccel (_: Any!) {
        guard let data = self.motman.accelerometerData else {return}
        self.receive(acceleration:data)
    }
    
    func add(acceleration accel:CMAcceleration) {
        let alpha = 0.1
        self.oldX = accel.x * alpha + self.oldX * (1.0 - alpha)
        self.oldY = accel.y * alpha + self.oldY * (1.0 - alpha)
        self.oldZ = accel.z * alpha + self.oldZ * (1.0 - alpha)
    }

    func receive(acceleration data:CMAccelerometerData) {
        self.add(acceleration: data.acceleration)
        let x = self.oldX
        let y = self.oldY
        let z = self.oldZ
        let accu = 0.08
        if abs(x) < accu && abs(y) < accu && z < -0.5 {
            if self.state == .unknown || self.state == .notLyingDown {
                self.state = .lyingDown
                self.label.text = "I'm lying on my back... ahhh..."
            }
        } else {
            if self.state == .unknown || self.state == .lyingDown {
                self.state = .notLyingDown
                self.label.text = "Hey, put me back down on the table!"
            }
        }
    }

}
