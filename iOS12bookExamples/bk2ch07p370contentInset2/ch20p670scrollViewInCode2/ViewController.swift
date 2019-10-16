


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
        
        // work around initial content placement bug
        sv.alwaysBounceVertical = true
        
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo:self.view.topAnchor),
            sv.bottomAnchor.constraint(
                equalTo:self.view.safeAreaLayoutGuide.bottomAnchor),
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
        
        // experimenting
        // sv.contentInset = UIEdgeInsetsMake(30,0,0,0)
    }
    
    var didLayout = false
    
    override func viewDidLayoutSubviews() {
        if let sv = self.sv {
            print("did layout!")
//            let safe = self.view.safeAreaInsets
//            sv.contentInset = UIEdgeInsetsMake(safe.top, 0, safe.bottom, 0)
//            sv.scrollIndicatorInsets = self.sv.contentInset
            print("content inset", sv.contentInset)
            print("adjusted content inset", sv.adjustedContentInset)
            print("indicator insets", sv.scrollIndicatorInsets)
            print("content offset", sv.contentOffset)
            print("nav bar height", self.navigationController?.navigationBar.bounds.height as Any)
        }
    }
    
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ sv: UIScrollView) {
        print("did scroll, offset", sv.contentOffset)
    }
    func scrollViewDidChangeAdjustedContentInset(_ sv: UIScrollView) {
        print("did change inset!")
        print("content inset", sv.contentInset)
        print("adjusted content inset", sv.adjustedContentInset)
        print("indicator insets", sv.scrollIndicatorInsets)
        print("content offset", sv.contentOffset)
    }
}
