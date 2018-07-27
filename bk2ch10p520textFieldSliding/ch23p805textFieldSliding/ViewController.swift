
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var topConstraint : NSLayoutConstraint!
    @IBOutlet var bottomConstraint : NSLayoutConstraint!
    @IBOutlet var slidingView : UIView!
    var fr : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(_ tf: UITextField) {
        print("did begin!")
        self.fr = tf // keep track of first responder
    }
    
    func textFieldShouldReturn(_ tf: UITextField) -> Bool {
        self.fr = nil // * let's reverse these
        tf.resignFirstResponder()
        return false
    }
    
    override var shouldAutorotate : Bool {
        return self.fr == nil
    }
    
    @objc func keyboardShow(_ n:Notification) {
        print("show!")
        let d = n.userInfo!
        if let local = d[UIResponder.keyboardIsLocalUserInfoKey] {
            print(local)
        }
        var r = d[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        r = self.slidingView.convert(r, from:nil)
        let h = self.slidingView.bounds.intersection(r).height
        if let f = self.fr?.frame {
            if r.origin.y < f.maxY {
                self.topConstraint.constant = -h
                self.bottomConstraint.constant = h
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardHide(_ n:Notification) {
        print("hide!")
        let d = n.userInfo!
        if let local = d[UIResponder.keyboardIsLocalUserInfoKey] {
            print(local)
        }
        do { // work around bug, may be fixed by now
            let beginning = d[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
            let ending = d[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            if beginning == ending {print("bail!"); return}
        }
        self.topConstraint.constant = 0
        self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
        self.fr?.resignFirstResponder()
        self.fr = nil
    }
    
    @objc func keyboardChange(_ n: Notification) {
        print("change!")
        let d = n.userInfo!
        if let local = d[UIResponder.keyboardIsLocalUserInfoKey] {
            print(local)
        }
        do { // just in case
            let beginning = d[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
            let ending = d[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            if beginning == ending {print("bail!"); return}
        }
        // interesting only if top of frame is more than zero in both cases
        let rold = d[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let rnew = d[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        guard rold.minY > 0 && rnew.minY > 0 else { print("boring"); return }
        let r = self.slidingView.convert(rnew, from:nil)
        let h = self.slidingView.bounds.intersection(r).height
        print(h)
    }

}
