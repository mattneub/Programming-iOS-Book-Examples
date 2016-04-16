
import UIKit

// interesting only when rotated to landscape

class ViewController: UIViewController {

    @IBAction func doButton1(_ sender: UIButton) {
        let v = sender
        let r = v.superview!.convert(v.frame, to: UIScreen.main().fixedCoordinateSpace)
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convert(v.frame, to: UIScreen.main().coordinateSpace)
            print(r)
            print(v.frame)
        }
    }
    @IBAction func doButton2(_ sender: UIButton) {
        let v = sender
        let r = v.superview!.convert(v.frame, to: UIScreen.main().fixedCoordinateSpace)
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convert(v.frame, to: UIScreen.main().coordinateSpace)
            print(r)
            print(v.frame)
        }
    }


}

