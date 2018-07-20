

import UIKit
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView(frame: self.view.bounds)
        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(sv)
        sv.backgroundColor = .white
        var y : CGFloat = 10
        for i in 0 ..< 30 {
            let lab = UILabel()
            lab.text = "This is label \(i+1)"
            lab.sizeToFit()
            lab.frame.origin = CGPoint(10,y)
            sv.addSubview(lab)
            y += lab.bounds.size.height + 10
            
            // uncomment
//            lab.frame.size.width = self.view.bounds.width - 20
//            lab.backgroundColor = .red // make label bounds visible
//            lab.autoresizingMask = .flexibleWidth
            
        }
        var sz = sv.bounds.size
        sz.height = y
        // This is the crucial move
        // note that in iOS 11 we can do this by setting the layout guide size _directly_
        // this is one of the big advantages of the layout guide
        if #available(iOS 11.0, *) {
//            sv.contentLayoutGuide.widthAnchor.constraint(equalToConstant: sz.width).isActive = true
//            sv.contentLayoutGuide.heightAnchor.constraint(equalToConstant: sz.height).isActive = true
            sv.contentSize = sz
        } else {
            sv.contentSize = sz
        }

        
        if #available(iOS 11.0, *) {
            print(sv.contentInsetAdjustmentBehavior.rawValue) // .automatic
            // sv.contentInsetAdjustmentBehavior = .always
            // to show what _would_ have happened:
            // sv.contentInsetAdjustmentBehavior = .never
        } else {
            // this shows how we had to do this before iOS 11; we now get all this "for free"
            // note that initial contentOffset must be adjusted to compensate for contentInset
            sv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            sv.scrollIndicatorInsets = sv.contentInset
            // sv.contentOffset = CGPoint(x:0, y:-20)
            // but a better way is:
            sv.scrollRectToVisible(CGRect(0,0,1,1), animated: false)
            // that way we don't have to calculate the offset
        }

        
        print(sv.contentSize)
        
        delay(2) {
            print(sv.contentSize)
            // new in iOS 11, we also get automatic insetting
            // sv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            if #available(iOS 11.0, *) {
                print(sv.adjustedContentInset)
            } else {
                // Fallback on earlier versions
            } // inset 20 from the top
            // affects both content and scroll indicators!
            // the adjustedContentInset is _added_ to any content inset we explicitly provide
            // thus in most cases the best option is to do nothing!
            print(sv.contentInset) // zero
            print(sv.scrollIndicatorInsets) // zero
            print(sv.contentOffset) // 0, -20
        }
        
        

    }
    
}
