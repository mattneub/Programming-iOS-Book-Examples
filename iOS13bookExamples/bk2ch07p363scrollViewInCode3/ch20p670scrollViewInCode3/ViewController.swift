

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
        
        var which : Int { return 4 }
        switch which {
        case 1:
            
            // content view doesn't use explicit constraints
            // subviews don't use explicit constraints either
            
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
            
        case 2:
            
            // content view uses explicit constraints
            // subviews don't use explicit constraints
            
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
            
            // set content view width, height, and edge constraints
            // content size is calculated for us
            v.translatesAutoresizingMaskIntoConstraints = false
            let svclg = sv.contentLayoutGuide
            NSLayoutConstraint.activate([
                v.widthAnchor.constraint(equalToConstant:maxw),
                v.heightAnchor.constraint(equalToConstant:y),
                svclg.topAnchor.constraint(equalTo:v.topAnchor),
                svclg.bottomAnchor.constraint(equalTo:v.bottomAnchor),
                svclg.leadingAnchor.constraint(equalTo:v.leadingAnchor),
                svclg.trailingAnchor.constraint(equalTo:v.trailingAnchor),
            ])
            
            sv.contentInsetAdjustmentBehavior = .always // work around launch offset bug
            
        case 3:
            // content view uses explicit constraints
            // subviews use explicit constraints

            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                // lab.backgroundColor = .red
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.text = "This is label \(i+1)"
                v.addSubview(lab)
                lab.leadingAnchor.constraint(
                    equalTo: v.leadingAnchor,
                    constant: 10).isActive = true
                lab.topAnchor.constraint(
                    // first one, pin to top; all others, pin to previous
                    equalTo: previousLab?.bottomAnchor ?? v.topAnchor,
                    constant: 10).isActive = true
                previousLab = lab
            }

            // last one, pin to bottom, this dictates content size height!
            v.bottomAnchor.constraint(
                equalTo: previousLab!.bottomAnchor, constant: 10).isActive = true
            // need to do something about width
            v.trailingAnchor.constraint(
                equalTo: previousLab!.trailingAnchor, constant: 10).isActive = true
            
            // pin content view to scroll view, sized by its subview constraints
            // content size is calculated for us
            v.translatesAutoresizingMaskIntoConstraints = false
            let svclg = sv.contentLayoutGuide
            NSLayoutConstraint.activate([
                svclg.topAnchor.constraint(equalTo:v.topAnchor),
                svclg.bottomAnchor.constraint(equalTo:v.bottomAnchor),
                svclg.leadingAnchor.constraint(equalTo:v.leadingAnchor),
                svclg.trailingAnchor.constraint(equalTo:v.trailingAnchor),
            ])
            
            sv.contentInsetAdjustmentBehavior = .always // work around launch offset bug

        case 4:
            // content view doesn't use explicit constraints
            // subviews do explicit constraints
            
            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                // lab.backgroundColor = .red
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.text = "This is label \(i+1)"
                v.addSubview(lab)
                lab.leadingAnchor.constraint(
                    equalTo: v.leadingAnchor,
                    constant: 10).isActive = true
                lab.topAnchor.constraint(
                    // first one, pin to top; all others, pin to previous
                    equalTo: previousLab?.bottomAnchor ?? v.topAnchor,
                    constant: 10).isActive = true
                previousLab = lab
            }
            
            // last one, pin to bottom, this dictates content size height!
            v.bottomAnchor.constraint(
                equalTo: previousLab!.bottomAnchor, constant: 10).isActive = true
            // need to do something about width
            v.trailingAnchor.constraint(
                equalTo: previousLab!.trailingAnchor, constant: 10).isActive = true


            // autolayout helps us learn the consequences of those constraints
            let minsz = v.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            // set content view frame and content size explicitly
            v.frame = CGRect(origin:.zero, size:minsz)
            sv.contentSize = minsz
            

        default: break
        }
        
        delay(2) {
            print(sv.contentSize)
        }

    }
    
    
}
