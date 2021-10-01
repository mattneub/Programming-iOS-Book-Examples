

import UIKit

// warning, test on device! on simulator, can do some fake autoscrolling that's wrong

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var sv : UIScrollView!
    var oldContentInset = UIEdgeInsets.zero
    var oldIndicatorInset = UIEdgeInsets.zero
    var oldOffset = CGPoint.zero
    var prevr = CGRect.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // content view's width and height constraints in storyboard are placeholders
        let contentView = self.sv.subviews[0]
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo:self.sv.widthAnchor),
            contentView.heightAnchor.constraint(equalTo:self.sv.heightAnchor),
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)

        
        self.sv.keyboardDismissMode = .interactive
        
        // just testing: what if the scroll view doesn't occupy the whole main view?
        // self.bottomConstraint.constant = 30
        
    }
    
    func textFieldShouldReturn(_ tf: UITextField) -> Bool {
        print("return")
        tf.resignFirstResponder()
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(textField.selectedTextRange as Any)
    }
    
    enum KeyboardState {
        case unknown
        case entering
        case exiting
    }

    func keyboardState(for d:[AnyHashable:Any], in v:UIView?) -> (KeyboardState, CGRect?) {
        var rold = d[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        var rnew = d[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        var ks : KeyboardState = .unknown
        var newRect : CGRect? = nil
        if let v = v {
            let co = UIScreen.main.coordinateSpace
            rold = co.convert(rold, to:v)
            rnew = co.convert(rnew, to:v)
            newRect = rnew
            if !rold.intersects(v.bounds) && rnew.intersects(v.bounds) {
                ks = .entering
            }
            if rold.intersects(v.bounds) && !rnew.intersects(v.bounds) {
                ks = .exiting
            }
        }
        print(ks == .entering ? "entering" : ks == .exiting ? "exiting" : "unknown")
        return (ks, newRect)
    }

    @objc func keyboardShow(_ n:Notification) {
        print("show")
        guard self.traitCollection.userInterfaceIdiom == .phone else {return}
        let d = n.userInfo!
        let (state, rnew) = keyboardState(for:d, in:self.sv)
        if state == .entering {
            print("really showing")
            self.oldContentInset = self.sv.contentInset
            self.oldIndicatorInset = self.sv.verticalScrollIndicatorInsets
            self.oldOffset = self.sv.contentOffset
        }
        // no need to scroll, as the scroll view will do it for us
        // so all we have to do is adjust the inset
        if let rnew = rnew, rnew != self.prevr {
            print("adjusting")
            self.prevr = rnew
            let h = rnew.intersection(self.sv.bounds).height + 6 // ?
            self.sv.contentInset.bottom = h
            self.sv.verticalScrollIndicatorInsets.bottom = h
        }
    }
    
    @objc func keyboardHide(_ n:Notification) {
        print("hide")
        guard self.traitCollection.userInterfaceIdiom == .phone else {return}
        let d = n.userInfo!
        let (state, _) = keyboardState(for:d, in:self.sv)
        if state == .exiting {
            print("really hiding")
            // restore original setup
            self.sv.contentOffset = self.oldOffset
            self.sv.verticalScrollIndicatorInsets = self.oldIndicatorInset
            self.sv.contentInset = self.oldContentInset
            self.prevr = .zero
        }
    }

    @objc func keyboardChange(_ n:Notification) {
        print("keyboard change")
    }

    
}
