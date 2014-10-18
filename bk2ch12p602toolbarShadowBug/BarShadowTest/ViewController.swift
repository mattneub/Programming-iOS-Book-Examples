
import UIKit
func imageOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

class ViewController: UIViewController {
    @IBOutlet var navbar : UINavigationBar!
    @IBOutlet var toolbar : UIToolbar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.yellowColor()
        
        let sz = CGSizeMake(20,20)
        
        self.navbar.setBackgroundImage(imageOfSize(sz) {
            UIColor(white:0.95, alpha:0.85).setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,20,20))
            }, forBarPosition:.Any, barMetrics: .Default)
        self.navbar.translucent = true
        
        self.toolbar.setBackgroundImage(imageOfSize(sz) {
            UIColor(white:0.95, alpha:0.85).setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,20,20))
            }, forToolbarPosition:.Any, barMetrics: .Default)
        self.navbar.translucent = true

        let sz2 = CGSizeMake(4,4)
        
        self.navbar.shadowImage = imageOfSize(sz2) {
            UIColor.grayColor().colorWithAlphaComponent(0.3).setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,4,2))
            UIColor.grayColor().colorWithAlphaComponent(0.15).setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,2,4,2))
        }
        self.toolbar.setShadowImage( imageOfSize(sz2) {
            UIColor.grayColor().colorWithAlphaComponent(0.3).setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,2,4,2))
            UIColor.grayColor().colorWithAlphaComponent(0.15).setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,4,2))
            }, forToolbarPosition:.Any )
    }
}

extension ViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        switch true { // another (old) trick for special switch situations
        case bar === self.navbar: return .TopAttached
        case bar === self.toolbar: return .Bottom
        default: return .Any
        }
    }
}
