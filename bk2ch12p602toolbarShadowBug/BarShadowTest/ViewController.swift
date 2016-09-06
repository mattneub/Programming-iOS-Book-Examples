
import UIKit

//func imageOfSize(_ size:CGSize, _ opaque:Bool = false, _ closure:() -> ()) -> UIImage {
//    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
//    closure()
//    let result = UIGraphicsGetImageFromCurrentImageContext()!
//    UIGraphicsEndImageContext()
//    return result
//}

func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    let r = UIGraphicsImageRenderer(size:size)
    return r.image {
        _ in closure()
    }
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



class ViewController: UIViewController {
    @IBOutlet var navbar : UINavigationBar!
    @IBOutlet var toolbar : UIToolbar!
    
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)

        self.view.backgroundColor = .yellow
        
        let sz = CGSize(20,20)
        
        self.navbar.setBackgroundImage(imageOfSize(sz) {
            UIColor(white:0.95, alpha:0.85).setFill()
            //UIColor(red: 1, green: 0, blue: 0, alpha: 1).setFill()
            UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,20,20))
            }, for:.any, barMetrics: .default)
        
        self.toolbar.setBackgroundImage(imageOfSize(sz) {
            UIColor(white:0.95, alpha:0.85).setFill()
            UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,20,20))
            }, forToolbarPosition:.any, barMetrics: .default)
        
        do {
            let sz = CGSize(4,4)
            
            self.navbar.shadowImage = imageOfSize(sz) {
                UIColor.gray.withAlphaComponent(0.3).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,4,2))
                UIColor.gray.withAlphaComponent(0.15).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(0,2,4,2))
            }
            self.toolbar.setShadowImage( imageOfSize(sz) {
                UIColor.gray.withAlphaComponent(0.3).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(0,2,4,2))
                UIColor.gray.withAlphaComponent(0.15).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,4,2))
                }, forToolbarPosition:.any )
        }
        
        // try false - effective only here
        self.navbar.isTranslucent = true
        self.toolbar.isTranslucent = true

    }
}

extension ViewController : UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        switch true { // another (old) trick for special switch situations
        case bar === self.navbar: return .topAttached
        case bar === self.toolbar: return .bottom
        default: return .any
        }
    }
}
