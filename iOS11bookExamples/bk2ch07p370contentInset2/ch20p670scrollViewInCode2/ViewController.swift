


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

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController : UIViewController {
    var sv : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        self.sv = sv
        
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo:self.view.topAnchor),
            sv.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),
            sv.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),
            sv.trailingAnchor.constraint(equalTo:self.view.trailingAnchor),
        ])
        
        let svclg = sv.contentLayoutGuide
        var previousLab : UILabel? = nil
        for i in 0 ..< 30 {
            let lab = UILabel()
            lab.backgroundColor = .red
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.text = "This is label \(i+1)"
            sv.addSubview(lab)
            lab.leadingAnchor.constraint(
                equalTo: svclg.leadingAnchor,
                constant: 10).isActive = true
            lab.topAnchor.constraint(
                // first one, pin to top; all others, pin to previous
                equalTo: previousLab?.bottomAnchor ?? svclg.topAnchor,
                constant: 10).isActive = true
            previousLab = lab
        }
        
        svclg.bottomAnchor.constraint(
            equalTo: previousLab!.bottomAnchor, constant: 10).isActive = true
        let svflg = sv.frameLayoutGuide
        svclg.widthAnchor.constraint(equalTo:svflg.widthAnchor).isActive = true
        
        sv.delegate = self
        
        // without this or view controller "auto", we start off scrolled incorrectly
        sv.contentInsetAdjustmentBehavior = .always
        // this doesn't help
        // sv.scrollRectToVisible(CGRect(0,-100,1,1), animated: false)

        
        // experimenting
        // sv.contentInset = UIEdgeInsetsMake(30,0,0,0)
    }
    
    var didLayout = false
    
    override func viewDidLayoutSubviews() {
        if let sv = self.sv {

//            let safe = self.view.safeAreaInsets
//            sv.contentInset = UIEdgeInsetsMake(safe.top, 0, safe.bottom, 0)
//            sv.scrollIndicatorInsets = self.sv.contentInset
            print("content inset", sv.contentInset)
            print("adjusted content inset", sv.adjustedContentInset)
            print("indicator insets", sv.scrollIndicatorInsets)
            print("offset", sv.contentOffset)
            print("nav bar height", self.navigationController?.navigationBar.bounds.height as Any)
            // new in iOS 11: content inset is zero...
            // but we show properly anyway! scroll view obeys the safe area automatically
            // and the adjustedContentInset shows this
            // interestingly this works even though we didn't set the behavior to .always
            // is that because it works correctly for top bar but not for status bar alone?
        }
    }
    
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ sv: UIScrollView) {
        print("did scroll, offset", sv.contentOffset)
    }
    func scrollViewDidChangeAdjustedContentInset(_ sv: UIScrollView) {
        print("did change inset!", sv.adjustedContentInset)
    }
}
