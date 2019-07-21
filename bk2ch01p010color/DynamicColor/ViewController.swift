
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

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    
    var v : UIView!

    @IBOutlet weak var otherView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yellow = UIColor.systemYellow
        let light = UITraitCollection(userInterfaceStyle: .light)
        let dark = UITraitCollection(userInterfaceStyle: .dark)

        let yellowLight = yellow.resolvedColor(with: light)
        let yellowDark = yellow.resolvedColor(with: dark)
        print(yellowLight)
        print(yellowDark)
        
        self.otherView.layer.borderWidth = 4
        self.otherView.layer.borderColor = UIColor(named: "myDarkColor")?.cgColor
        
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
        
        self.v = v
        
        delay(2) {
            print(self.view.traitCollection)
            print(v.traitCollection)
            
            let alert = UIAlertController(title: "Howdy", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            
                delay(1) {
                print(self.view.traitCollection)
                print(v.traitCollection)
                print(alert.traitCollection)
            }
            
        }
    }

    override func traitCollectionDidChange(_ prevtc: UITraitCollection?) {
        super.traitCollectionDidChange(prevtc)
        if prevtc?.hasDifferentColorAppearance(comparedTo: self.traitCollection) ?? false {
            var red : CGFloat = 0
            UIColor(named: "myDarkColor")?.getRed(&red, green: nil, blue: nil, alpha: nil)
            print(red)
            self.otherView.layer.borderColor = UIColor(named: "myDarkColor")?.cgColor
        }
    }


}

