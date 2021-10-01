

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



extension UIImage {
    func scaledDown(into size:CGSize, centered:Bool = false) -> UIImage {
        var (targetWidth, targetHeight) = (self.size.width, self.size.height)
        var (scaleW, scaleH) = (1 as CGFloat, 1 as CGFloat)
        if targetWidth > size.width {
            scaleW = size.width/targetWidth
        }
        if targetHeight > size.height {
            scaleH = size.height/targetHeight
        }
        let scale = min(scaleW,scaleH)
        targetWidth *= scale; targetHeight *= scale
        let sz = CGSize(targetWidth, targetHeight)
        if !centered {
            return UIGraphicsImageRenderer(size:sz).image { _ in
                self.draw(in:CGRect(origin:.zero, size:sz))
            }
        }
        
        let x = (size.width - targetWidth)/2
        let y = (size.height - targetHeight)/2
        let origin = CGPoint(x,y)
        return UIGraphicsImageRenderer(size:size).image { _ in
            self.draw(in:CGRect(origin:origin, size:sz))
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var iv1: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv4: UIImageView!
    @IBOutlet weak var iv5: UIImageView!
    @IBOutlet weak var iv6: UIImageView!
    @IBOutlet weak var iv7: UIImageView!
    @IBOutlet weak var iv8: UIImageView!
    @IBOutlet weak var iv9: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iv1.image = UIImage(named:"kittensBasket.png")!.scaledDown(into:iv1.bounds.size)
        iv2.image = UIImage(named:"smiley.png")!.scaledDown(into:iv2.bounds.size)
        iv3.image = UIImage(named:"lib.jpg")!.scaledDown(into:iv3.bounds.size)
        iv4.image = UIImage(named:"lib2.jpg")!.scaledDown(into:iv4.bounds.size)
        iv5.image = UIImage(named:"kittensBasketTiny.png")!.scaledDown(into:iv5.bounds.size)
        iv6.image = UIImage(named:"lib.jpg")!.scaledDown(into:iv6.bounds.size)
        iv7.image = UIImage(named:"kittensBasket.png")!.scaledDown(into:iv7.bounds.size)
        iv8.image = UIImage(named:"lib.jpg")!.scaledDown(into:iv8.bounds.size)
        iv9.image = UIImage(named:"kittensBasket.png")!.scaledDown(into:iv9.bounds.size)

    }


}

