

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

// run on iPad, or iPhone 6/7 plus

class ViewController: UIViewController {

    lazy var greenView : UIView = {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }()
    var firstTime = true
    var nextTraitCollection = UITraitCollection()
    // iPhone 6/7 plus is the oddball here
    func greenViewShouldAppear(size sz: CGSize) -> Bool {
        let tc = self.nextTraitCollection
        if tc.horizontalSizeClass == .regular {
            if sz.width > sz.height {
                return true
            }
        }
        return false
    }
    // we _know_ we will get this at launch with our view ready to go
    override func viewWillLayoutSubviews() {
        if self.firstTime {
            self.firstTime = false
            self.nextTraitCollection = self.traitCollection
            let sz = self.view.bounds.size
            if self.greenViewShouldAppear(size:sz) {
                let v = self.greenView
                v.frame = CGRect(0,0,sz.width/3, sz.height)
                self.view.addSubview(v)
            }
        }
    }
    // if tc is going to change,
    // we _know_ we will hear about it before we hear about size change
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to:newCollection, with:coordinator)
        self.nextTraitCollection = newCollection
    }
    // we _know_ we will get this on rotation and splitscreen changes even on iPad
    override func viewWillTransition(to sz: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:sz, with:coordinator)
//        print (self.nextTraitCollection)
//        print (self.traitCollection)
        if sz != self.view.bounds.size {
            // there are three theoretical possibilities:
            // view is present and needs to disappear
            // view is absent and needs to appear
            // view is present and needs to be resized
            // but the third possibility never actually happens
            if self.greenView.window != nil {
                if !self.greenViewShouldAppear(size:sz) {
                    coordinator.animate(alongsideTransition: { _ in
                        let f = self.greenView.frame
                        self.greenView.frame = CGRect(-f.width,0,f.width,f.height)
                    }) { _ in
                        self.greenView.removeFromSuperview()
                    }
                } else {
                    coordinator.animate(alongsideTransition: { _ in
                        fatalError("I'm betting this can never happen")
                        self.greenView.frame = CGRect(-sz.width/3,0,sz.width/3,sz.height)
                    })
                }
            } else {
                if self.greenViewShouldAppear(size:sz) {
                    self.greenView.frame = CGRect(-sz.width/3,0,sz.width/3,sz.height)
                    self.view.addSubview(self.greenView)
                    coordinator.animate(alongsideTransition: { _ in
                        self.greenView.frame.origin = CGPoint.zero
                    })
                }
            }
        }
    }

}

