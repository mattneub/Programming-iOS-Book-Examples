
import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v = UIView(frame:CGRect(x:100, y:100, width:50, height:50))
        // v.backgroundColor = UIColor(red: 0, green: 0.1, blue: 0.1, alpha: 1)
        // `init(dynamicProvider:)`
        v.backgroundColor = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.3, green: 0.4, blue: 0.4, alpha: 1)
            default:
                return UIColor(red: 0, green: 0.1, blue: 0.1, alpha: 1)
            }
        }
        v.backgroundColor = UIColor(named: "myDarkColor")
        // tried to do this by dragging but it generated two colors
        // and the compiler didn't like that
        self.view.addSubview(v)
    }


}

