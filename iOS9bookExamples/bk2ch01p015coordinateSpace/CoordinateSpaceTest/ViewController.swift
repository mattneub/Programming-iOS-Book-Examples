
import UIKit

extension UICoordinateSpace {
    static func convertRect(r:CGRect,
        fromCoordinateSpace s1:UICoordinateSpace,
        toCoordinateSpace s2:UICoordinateSpace) -> CGRect {
            return s1.convertRect(r, toCoordinateSpace:s2)
    }
}

class ViewController: UIViewController {

    @IBAction func doButton1(sender: UIButton) {
        let v = sender
        let r = v.superview!.convertRect(
            v.frame, toCoordinateSpace: UIScreen.mainScreen().fixedCoordinateSpace)
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convertRect(
                v.frame, toCoordinateSpace: UIScreen.mainScreen().coordinateSpace)
            print(r)
            print(v.frame)
        }
    }
    @IBAction func doButton2(sender: UIButton) {
        let v = sender
        let r = v.superview!.convertRect(
            v.frame, toCoordinateSpace: UIScreen.mainScreen().fixedCoordinateSpace)
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convertRect(
                v.frame, toCoordinateSpace: UIScreen.mainScreen().coordinateSpace)
            print(r)
            print(v.frame)
        }
    }


}

