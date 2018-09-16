

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController : UIViewController {
    
    // same as previous, but we pin to sv itself instead of content layout guide
    // this is not "correct" behavior but I'm just showing that it still works
    
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
        
        var previousLab : UILabel? = nil
        for i in 0 ..< 30 {
            let lab = UILabel()
            // lab.backgroundColor = .red
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.text = "This is label \(i+1)"
            sv.addSubview(lab)
            lab.leadingAnchor.constraint(
                equalTo: sv.leadingAnchor, constant: 10).isActive = true
            lab.topAnchor.constraint(
                // first one, pin to top; all others, pin to previous
                equalTo: previousLab?.bottomAnchor ?? sv.topAnchor,
                constant: 10).isActive = true
            previousLab = lab
        }
        
        // last one, pin to bottom, this dictates content size height!
        sv.bottomAnchor.constraint(
            equalTo: previousLab!.bottomAnchor, constant: 10).isActive = true
        
        // still have to do something about content width
        // cannot set the width of the scroll view!
        // new in iOS 11, can use the layout guide instead
        // sv.contentLayoutGuide.widthAnchor.constraint(equalToConstant:1).isActive = true
        previousLab!.trailingAnchor.constraint(equalTo:sv.trailingAnchor).isActive = true

        
        // sv.contentOffset = CGPoint(x:0,y:-20) // doesn't help
        
        delay(2) {
            print(sv.contentSize)
            print(sv.contentLayoutGuide)
            print(sv.adjustedContentInset)
            print(sv.contentOffset)
            print(sv.contentInsetAdjustmentBehavior.rawValue)
        }
        
    }
    
}
