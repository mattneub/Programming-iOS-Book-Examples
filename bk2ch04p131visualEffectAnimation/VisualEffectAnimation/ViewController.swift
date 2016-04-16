

import UIKit

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

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



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v = UILabel(frame:CGRect(50,50,200,50))
        v.text = "Hello"
        self.view.addSubview(v)
        
        let e = UIVisualEffectView(effect: nil)
        e.frame = CGRect(50,50,200,50)
        self.view.addSubview(e)
        
        delay(4) {
            print("start")
            UIView.animate(withDuration:4, animations: {
                e.effect = UIBlurEffect(style:.light)
            }, completion: {
                _ in
                UIView.animate(withDuration:4) {
                    e.frame = CGRect(50,50,0,0)
                }
            })
        }
        
    }



}

