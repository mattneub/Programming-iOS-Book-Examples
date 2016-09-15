import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController {
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        delay(1.0) {self.animate()}
    }
    
    let which = 1

    func animate () {
        
        switch which {
        case 1:
            let mars = UIImage(named: "Mars")!
            UIGraphicsBeginImageContextWithOptions(mars.size, false, 0)
            let empty = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let arr = [mars, empty, mars, empty, mars]
            let iv = UIImageView(image:empty)
            iv.frame.origin = CGPointMake(100,100)
            self.view.addSubview(iv)
            
            iv.animationImages = arr
            iv.animationDuration = 2
            iv.animationRepeatCount = 1
            delay(2) {
                iv.startAnimating()
            }

        case 2:
            
            var arr = [UIImage]()
            let w : CGFloat = 18
            for i in 0 ..< 6 {
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,w), false, 0)
                let con = UIGraphicsGetCurrentContext()!
                CGContextSetFillColorWithColor(con, UIColor.redColor().CGColor)
                let ii = CGFloat(i)
                CGContextAddEllipseInRect(con, CGRectMake(0+ii,0+ii,w-ii*2,w-ii*2))
                CGContextFillPath(con)
                let im = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                arr += [im]
            }
            let im = UIImage.animatedImageWithImages(arr, duration:0.5)
            let b = UIButton(type:.System)
            b.setTitle("Howdy", forState:.Normal)
            b.setImage(im, forState:.Normal)
            b.center = CGPointMake(100,200)
            b.sizeToFit()
            self.view.addSubview(b)

        case 3:
            let im = UIImage.animatedImageNamed("pac", duration:1)
            let b = UIButton(type:.System)
            b.setImage(im, forState:.Normal)
            b.center = CGPointMake(100,200)
            b.sizeToFit()
            self.view.addSubview(b)

        default: break
        }
        
    }
    
}
