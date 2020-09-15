
import UIKit

// showing the extremely strange behavior of a view pinned to its superview's safe area
// (when that superview is not the main view and might move)

class SafeAreaReportingView : UIView {
    override func safeAreaInsetsDidChange() {
        // I was hoping this would be reported throughout the animation
        // but it isn't, so pointless
        // print("safe area of", self.backgroundColor!, self.safeAreaInsets.top)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBAction func doButton(_ sender: Any) {
        print("green view is pinned to yellow view's safe area top")
        print("main view safe area top:", self.view.safeAreaInsets.top)
        print("green view top:", self.greenView.frame.origin.y)
        let howFar : CGFloat = 300
        topConstraint.constant -= howFar
        UIView.animate(withDuration: 6, animations: ({
            self.view.layoutIfNeeded()
        })) { _ in
            print("green view top:", self.greenView.frame.origin.y)
            self.topConstraint.constant += howFar
            UIView.animate(withDuration:6, animations: ({
                self.view.layoutIfNeeded()
            })) { _ in
                print("green view top:", self.greenView.frame.origin.y)
            }
        }
    }
    var firstTime = true
    override func viewDidLayoutSubviews() {
        if firstTime {
            firstTime = false
//            print(self.yellowView.frame.origin.y)
            self.additionalSafeAreaInsets = UIEdgeInsets(
                top: self.yellowView.frame.origin.y,
                left: 0, bottom: 0, right: 0)
        }
//        print("did layout")
//        print(self.additionalSafeAreaInsets)
//        print(self.view.safeAreaInsets)
    }
    


}

