
import UIKit

func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var tv : UITextView!
    var sv : UIScrollView! {
        return self.tv
    }
    var oldContentInset = UIEdgeInsets.zero
    var oldIndicatorInset = UIEdgeInsets.zero
    var oldOffset = CGPoint.zero
    var prevr = CGRect.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "brillig", ofType: "txt")!
        let s = try! String(contentsOfFile:path)
        let s2 = s.replacingOccurrences(of:"\n", with: "")
        let mas = NSMutableAttributedString(string:s2, attributes:[
            .font: UIFont(name:"GillSans", size:20)!
            ])
        
        mas.addAttribute(.paragraphStyle,
            value:lend() {
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


    

    @objc func doDone(_ sender: Any) {
        self.view.endEditing(false)
    }

}
