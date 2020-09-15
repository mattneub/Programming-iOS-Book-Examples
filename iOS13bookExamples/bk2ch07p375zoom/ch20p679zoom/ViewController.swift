

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



class ViewController : UIViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sv)
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo:self.view.topAnchor),
            sv.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),
            sv.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),
            sv.trailingAnchor.constraint(equalTo:self.view.trailingAnchor),
            ])
        
        let v = UIView() // content view
        sv.addSubview(v)

        var y : CGFloat = 10
        var maxw : CGFloat = 0
        for i in 0 ..< 30 {
            let lab = UILabel()
            lab.text = "This is label \(i+1)"
            lab.sizeToFit()
            lab.frame.origin = CGPoint(10,y)
            v.addSubview(lab)
            y += lab.bounds.size.height + 10
            maxw = max(maxw, lab.frame.maxX + 10)
        }
        
        // set content view frame and content size explicitly
        v.frame = CGRect(0,0,maxw,y)
        sv.contentSize = v.frame.size

        
        v.tag = 999 // *
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 2.0
        sv.delegate = self
        
        sv.contentInsetAdjustmentBehavior = .always // work around launch offset bug

    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var which : Int {return 0} // 1 to add some interesting logging :)
        switch which {
        case 1:
            print(scrollView.bounds.size) // this is constant
            print(scrollView.contentSize) // this is changing
            let v = self.viewForZooming(in:scrollView)!
            print(v.bounds.size) // this is constant
            print(v.frame.size) // this is changing (and here it matches the content size)
            print()
        default : break
        }
    }

    
    
}
