
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



class PopoverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(320,300)
    }
    
    @IBAction func showOptions(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        func handler(_ act:UIAlertAction!) {
            print("User tapped \(act.title as Any)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handler))
        alert.addAction(UIAlertAction(title: "Hey", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Ho", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Hey Nonny No", style: .default, handler: handler))
        // .OverCurrentContext is the default, so no need to specify! just show it
        self.present(alert, animated: true)
        // tapping outside the sheet but inside the containing popover dismisses the sheet
        // tapping outside the containing popover dismisses the popover
        // to prevent that, you have to take charge of dismissal
        // No, the above is fixed in iOS 8.3
        // But then it got unfixed in iOS 9
    }

}
