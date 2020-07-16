
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



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this one doesn't work; must come from asset catalog
        let im1 = UIImage(named:"cool.svg")
        if im1 == nil {
            print("nope")
        }
        
        // this one is perfect only if you checked Preserve Vector Data
        let im2 = UIImage(named:"coolness")
        let iv = UIImageView(image:im2)
        iv.frame = CGRect(30,30,300,300)
        self.view.addSubview(iv)
        
        // this one is perfect regardless
        let r = UIGraphicsImageRenderer(size: CGSize(300,300))
        let im3 = r.image { _ in
            im2?.draw(in: CGRect(0,0,300,300))
        }
        let iv2 = UIImageView(image:im3)
        iv2.frame = CGRect(30,350,300,300)
        self.view.addSubview(iv2)
    }


}

