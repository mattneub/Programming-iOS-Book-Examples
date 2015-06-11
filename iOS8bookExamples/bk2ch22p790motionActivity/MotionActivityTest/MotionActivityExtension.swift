
import UIKit
import CoreMotion

extension CMMotionActivity {
    private func tf(b:Bool) -> String {
        return b ? "t" : "f"
    }
    func overallAct() -> String {
        let s = tf(self.stationary)
        let w = tf(self.walking)
        let r = tf(self.running)
        let a = tf(self.automotive)
        let u = tf(self.unknown)
        return "\(s) \(w) \(r) \(a) \(u)"
    }

}
