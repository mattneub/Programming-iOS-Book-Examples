

import UIKit
func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return result
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.yellow() // demonstrate translucency
        
        // new iOS 7 feature: replace the left-pointing chevron
        // very simple example

        self.navbar.backIndicatorImage =
            imageOfSize(CGSize(10,20)) {
                UIGraphicsGetCurrentContext()!.fill(CGRect(6,0,4,20))
        }
        self.navbar.backIndicatorTransitionMaskImage =
            imageOfSize(CGSize(10,20)) {}
        
        // shadow, as in previous example
        
        let sz = CGSize(20,20)
        
        self.navbar.setBackgroundImage(imageOfSize(sz) {
            UIColor(white:0.95, alpha:0.85).setFill()
            UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,20,20))
            }, for:.any, barMetrics: .default)
        
        do {
        
            let sz = CGSize(4,4)
            
            self.navbar.shadowImage = imageOfSize(sz) {
                UIColor.gray().withAlphaComponent(0.3).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,4,2))
                UIColor.gray().withAlphaComponent(0.15).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(0,2,4,2))
            }
            
        }
        
        self.navbar.isTranslucent = true

        
        // set up initial state of nav item

        let ni = UINavigationItem(title: "Tinker")
        let b = UIBarButtonItem(title: "Evers", style: .plain, target: self, action: #selector(pushNext))
        ni.rightBarButtonItem = b
        self.navbar.items = [ni]
    }
    
    func pushNext(_ sender:AnyObject) {
        let oldb = sender as! UIBarButtonItem
        let s = oldb.title! // *
        let ni = UINavigationItem(title:s)
        if s == "Evers" {
            let b = UIBarButtonItem(
                title:"Chance", style: .plain, target:self, action:#selector(pushNext))
            ni.rightBarButtonItem = b
        }
        self.navbar.push(ni, animated:true)
    }
}

extension ViewController : UIBarPositioningDelegate {
    func position(forBar bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
