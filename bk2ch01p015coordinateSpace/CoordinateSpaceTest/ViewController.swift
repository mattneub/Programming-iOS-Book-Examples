
import UIKit

// interesting only when rotated to landscape

class ViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }

    fileprivate func report(_ v: UIButton) {
        let screen = UIScreen.main.fixedCoordinateSpace
        let r = v.superview!.convert(v.frame, to: screen)
        print("my frame in fixed coordinate space:", r)
        // print("my frame:", v.frame)
        do {
            let r = v.superview!.convert(v.frame, to: UIScreen.main.coordinateSpace)
            print("my frame in screen coordinate space:", r)
            print("my frame:", v.frame)
        }
    }

    @IBAction func doButton1(_ sender: UIButton) {
        let v = sender
        report(v)
    }
    @IBAction func doButton2(_ sender: UIButton) {
        let v = sender
        report(v)
    }


}

