

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController : UIViewController {
    
    // this is the way I prefer now, using anchor notation
    // notice that we use the new contentLayoutGuide to pin to
    // not required (the next example proves that) ...
    // ... but let's behave correctly
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        // we have to force content inset adjustment
        // otherwise, it isn't set up in time
        sv.contentInsetAdjustmentBehavior = .always
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
            // lab.backgroundColor = .red
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
        
        // last one, pin to bottom, this dictates content size height!
        svclg.bottomAnchor.constraint(
            equalTo: previousLab!.bottomAnchor, constant: 10).isActive = true
        
        // also need to disambiguate content size width; no scrolling, so anything will do
        // svclg.widthAnchor.constraint(equalToConstant:0).isActive = true
        // possibly better way to say this: make content width frame width!
        let svflg = sv.frameLayoutGuide
        svclg.widthAnchor.constraint(equalTo:svflg.widthAnchor).isActive = true
        
        delay(2) {
            print(sv.contentSize)
            print(sv.contentLayoutGuide)
            print(sv.contentOffset)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        delay(2) {
            if let sv = self.view.subviews[0] as? UIScrollView {
                print(sv.contentSize)
                print(sv.contentLayoutGuide)
                print(sv.contentOffset)
            }
        }
    }
    
}
