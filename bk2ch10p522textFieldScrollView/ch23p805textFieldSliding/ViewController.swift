

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView : UIScrollView!
    var oldContentInset = UIEdgeInsets.zero
    var oldIndicatorInset = UIEdgeInsets.zero
    var oldOffset = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // content view's width and height constraints in storyboard are placeholders
        let contentView = self.scrollView.subviews[0]
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo:self.scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo:self.scrollView.heightAnchor),
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)

        
        self.scrollView.keyboardDismissMode = .interactive
        
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
        let (state, rnew) = keyboardState(for:d, in:self.scrollView)
        if state == .entering {
            print("really showing")
            self.oldContentInset = self.scrollView.contentInset
            self.oldIndicatorInset = self.scrollView.scrollIndicatorInsets
            self.oldOffset = self.scrollView.contentOffset
        }
        print("show")
        // no need to scroll, as the scroll view will do it for us
        // so all we have to do is adjust the inset
        if let rnew = rnew {
            let h = rnew.intersection(self.scrollView.bounds).height + 6 // ?
            self.scrollView.contentInset.bottom = h
            self.scrollView.scrollIndicatorInsets.bottom = h
        }
    }
    
    @objc func keyboardHide(_ n:Notification) {
        print("hide")
        guard self.traitCollection.userInterfaceIdiom == .phone else {return}
        let d = n.userInfo!
        let (state, _) = keyboardState(for:d, in:self.scrollView)
        if state == .exiting {
            print("really hiding")
            // restore original setup
            self.scrollView.contentOffset = self.oldOffset
            self.scrollView.scrollIndicatorInsets = self.oldIndicatorInset
            self.scrollView.contentInset = self.oldContentInset
        }
    }

    @objc func keyboardChange(_ n:Notification) {
        print("keyboard change")
    }

    
}
