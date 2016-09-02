
import UIKit

func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var tv : UITextView!
    var keyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "brillig", ofType: "txt")!
        let s = try! String(contentsOfFile:path)
        let s2 = s.replacingOccurrences(of:"\n", with: "")
        let mas = NSMutableAttributedString(string:s2, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:20)!
            ])
        
        mas.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .left
                para.lineBreakMode = .byWordWrapping
            },
            range:NSMakeRange(0,1))
        
        self.tv.attributedText = mas

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
        
        self.tv.keyboardDismissMode = .interactive

    }
    
    override var shouldAutorotate : Bool {
        return !self.keyboardShowing
    }
    
    // as long as you play your part (adjust content offset),
    // iOS 8 will play its part (scroll cursor to visible)
    // and we don't have to animate
    
    func keyboardShow(_ n:Notification) {
        print("show")
        
        let d = n.userInfo!
        var r = (d[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        r = self.tv.convert(r, from:nil)
        self.tv.contentInset.bottom = r.size.height
        self.tv.scrollIndicatorInsets.bottom = r.size.height
        
        self.keyboardShowing = true
        

    }
    
    func keyboardHide(_ n:Notification) {
        print("hide")
        
        self.tv.contentInset = .zero
        self.tv.scrollIndicatorInsets = .zero
        
        self.keyboardShowing = false

    }

    func doDone(_ sender:AnyObject) {
        self.view.endEditing(false)
    }

}
