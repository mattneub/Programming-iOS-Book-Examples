
import UIKit

func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var tv : UITextView!
    var scrollView : UIScrollView! {
        return self.tv
    }
    var oldContentInset = UIEdgeInsets.zero
    var oldIndicatorInset = UIEdgeInsets.zero
    var oldOffset = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "brillig", ofType: "txt")!
        let s = try! String(contentsOfFile:path)
        let s2 = s.replacingOccurrences(of:"\n", with: "")
        let mas = NSMutableAttributedString(string:s2, attributes:[
            .font: UIFont(name:"GillSans", size:20)!
            ])
        
        mas.addAttribute(.paragraphStyle,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .left
                para.lineBreakMode = .byWordWrapping
            },
            range:NSMakeRange(0,1))
        
        self.tv.attributedText = mas

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.tv.keyboardDismissMode = .interactive

    }
    
    // as long as you play your part (adjust content offset),
    // iOS will play its part (scroll cursor to visible)
    // and we don't have to animate
    
    // code identical to scroll view example, because a text view _is_ a scroll view
    
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
        return (ks, newRect)
    }
    
    @objc func keyboardShow(_ n:Notification) {
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
            let h = rnew.intersection(self.scrollView.bounds).height
            self.scrollView.contentInset.bottom = h
            self.scrollView.scrollIndicatorInsets.bottom = h
        }
    }
    
    @objc func keyboardHide(_ n:Notification) {
        let d = n.userInfo!
        let (state, _) = keyboardState(for:d, in:self.scrollView)
        if state == .exiting {
            print("really hiding")
            // restore original setup
            // we _don't_ do this; let the text view position itself
            // self.scrollView.contentOffset = self.oldOffset
            self.scrollView.scrollIndicatorInsets = self.oldIndicatorInset
            self.scrollView.contentInset = self.oldContentInset
        }
    }

    

    @objc func doDone(_ sender: Any) {
        self.view.endEditing(false)
    }

}
