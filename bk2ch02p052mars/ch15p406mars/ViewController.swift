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



extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}



class ViewController : UIViewController {
    
    let which = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let iv = UIImageView(image:UIImage(named:"Mars")!)
        self.view.addSubview(iv)
        
        iv.clipsToBounds = true // default is false...
        // though this won't matter unless you also play with the content mode
        iv.contentMode = .scaleAspectFit // default is .ScaleToFill...
        // ... which fits but doesn't preserve aspect
        
//        print(iv.clipsToBounds)
//        print(iv.contentMode.rawValue)
        
        // just to clarify boundaries of image view
        iv.layer.borderColor = UIColor.black.cgColor
        iv.layer.borderWidth = 2
        
        switch which {
        case 1:
            // position using autoresizing-type behavior
            iv.center = iv.superview!.bounds.center // see above
            iv.frame = iv.frame.integral
        case 2:
            // position using constraints
            iv.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iv.centerXAnchor.constraint(equalTo:iv.superview!.centerXAnchor),
                iv.centerYAnchor.constraint(equalTo:iv.superview!.centerYAnchor)
                ])
        default: break
        }
        
        // showing what happens when a different image is assigned
        delay (2) {
            iv.image = UIImage(named:"bottle5.png")
            // if we're using constraints...
            // the image view is resized, because setting the image changes the intrinsic content size
        }
        
    }
    
    
    
}
