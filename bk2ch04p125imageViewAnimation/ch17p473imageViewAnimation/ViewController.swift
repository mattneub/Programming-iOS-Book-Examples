import UIKit

func delay(_ delay:Double, closure:()->()) {
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


class ViewController : UIViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(1.0) {self.animate()}
    }
    
    let which = 3

    func animate () {
        
        switch which {
        case 1:
            let mars = UIImage(named: "Mars")!
            let r = UIGraphicsImageRenderer(size:mars.size)
            let empty = r.image {_ in}
            
//            UIGraphicsBeginImageContextWithOptions(mars.size, false, 0)
//            let empty = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
            
            let arr = [mars, empty, mars, empty, mars]
            let iv = UIImageView(image:empty)
            iv.frame.origin = CGPoint(100,100)
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
                let r = UIGraphicsImageRenderer(size:CGSize(w,w))
                arr += [r.image {
                    ctx in
                    let con = ctx.cgContext
                    con.setFillColor(UIColor.red.cgColor)
                    let ii = CGFloat(i)
                    con.addEllipse(inRect:CGRect(0+ii,0+ii,w-ii*2,w-ii*2))
                    con.fillPath()
                }]

//                UIGraphicsBeginImageContextWithOptions(CGSize(w,w), false, 0)
//                let con = UIGraphicsGetCurrentContext()!
//                con.setFillColor(UIColor.red().cgColor)
//                let ii = CGFloat(i)
//                con.addEllipse(inRect:CGRect(0+ii,0+ii,w-ii*2,w-ii*2))
//                con.fillPath()
//                let im = UIGraphicsGetImageFromCurrentImageContext()!
//                UIGraphicsEndImageContext()
//                arr += [im]
            }
            let im = UIImage.animatedImage(with:arr, duration:0.5)
            let b = UIButton(type:.system)
            b.setTitle("Howdy", for:.normal)
            b.setImage(im, for:.normal)
            b.center = CGPoint(100,200)
            b.sizeToFit()
            self.view.addSubview(b)

        case 3:
            let im = UIImage.animatedImageNamed("pac", duration:1)
            let b = UIButton(type:.system)
            b.setImage(im, for:.normal)
            b.center = CGPoint(100,200)
            b.sizeToFit()
            self.view.addSubview(b)

        default: break
        }
        
    }
    
}
