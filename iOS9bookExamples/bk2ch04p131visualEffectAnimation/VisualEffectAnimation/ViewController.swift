

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v = UILabel(frame:CGRectMake(50,50,200,50))
        v.text = "Hello"
        self.view.addSubview(v)
        
        let e = UIVisualEffectView(effect: nil)
        e.frame = CGRectMake(50,50,200,50)
        self.view.addSubview(e)
        
        delay(4) {
            print("start")
            UIView.animateWithDuration(4, animations: {
                e.effect = UIBlurEffect(style:.Light)
            }, completion: {
                _ in
                UIView.animateWithDuration(4) {
                    e.frame = CGRectMake(50,50,0,0)
                }
            })
        }
        
    }



}

