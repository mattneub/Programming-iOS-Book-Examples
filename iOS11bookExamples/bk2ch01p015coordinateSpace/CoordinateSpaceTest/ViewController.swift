
import UIKit

// interesting only when rotated to landscape

class ViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }

    @IBAction func doButton1(_ sender: UIButton) {
        let v = sender
        let screen = UIScreen.main.fixedCoordinateSpace
        let r = v.superview!.convert(v.frame, to: screen)
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convert(v.frame, to: UIScreen.main.coordinateSpace)
            print(r)
            print(v.frame)
        }
    }
    @IBAction func doButton2(_ sender: UIButton) {
        let v = sender
        let screen = UIScreen.main.fixedCoordinateSpace
        let r = v.superview!.convert(v.frame, to: screen)
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convert(v.frame, to: UIScreen.main.coordinateSpace)
            print(r)
            print(v.frame)
        }
    }


}

