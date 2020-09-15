
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



class ViewController: UIViewController {
    @IBOutlet var navbar : UINavigationBar!
    @IBOutlet var toolbar : UIToolbar!
    
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)

        self.view.backgroundColor = .yellow
        
        do {
        
        let sz = CGSize(20,20)
        let r = UIGraphicsImageRenderer(size:sz)
        
        self.navbar.setBackgroundImage( r.image { ctx in
            UIColor(white:0.95, alpha:0.85).setFill()
            ctx.fill(CGRect(0,0,20,20))
            }, for:.any, barMetrics: .default)
        
        self.toolbar.setBackgroundImage( r.image { ctx in
            UIColor(white:0.95, alpha:0.85).setFill()
            ctx.fill(CGRect(0,0,20,20))
            }, forToolbarPosition:.any, barMetrics: .default)
            
        }
        
        do {
            let sz = CGSize(4,4)
            
            let r = UIGraphicsImageRenderer(size:sz)
            self.navbar.shadowImage = r.image { ctx in
                UIColor.gray.withAlphaComponent(0.3).setFill()
                ctx.fill(CGRect(0,0,4,2))
                UIColor.gray.withAlphaComponent(0.15).setFill()
                ctx.fill(CGRect(0,2,4,2))
            }
            self.toolbar.setShadowImage( r.image { ctx in
                UIColor.gray.withAlphaComponent(0.3).setFill()
                ctx.fill(CGRect(0,2,4,2))
                UIColor.gray.withAlphaComponent(0.15).setFill()
                ctx.fill(CGRect(0,0,4,2))
                }, forToolbarPosition:.any )
        }
        
        // try false - effective only here
        // hmm, unable to figure out what that was about
        return;
        self.navbar.isTranslucent = false
        self.toolbar.isTranslucent = false

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
