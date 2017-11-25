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


class ViewController : UIViewController {
    
    let which = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lay1 = CALayer()
        lay1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1).cgColor
        lay1.frame = CGRect(113, 111, 132, 194)
        self.view.layer.addSublayer(lay1)
        let lay2 = CALayer()
        lay2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1).cgColor
        lay2.frame = CGRect(41, 56, 132, 194)
        lay1.addSublayer(lay2)
        
        switch which {
        case 1:
            // a view can be interspersed with sibling layers
            let iv = UIImageView(image:UIImage(named:"smiley"))
            self.view.addSubview(iv)
            // iv.layer.zPosition = 1
            iv.frame.origin = CGPoint(180,180)
        case 2:
            // a layer can have image content
            let lay4 = CALayer()
            let im = UIImage(named:"smiley")!
            lay4.frame = CGRect(origin:CGPoint(180,180), size:im.size)
            lay4.contents = im.cgImage // no need to remember to cast to id
            // but you do still need to remember to take the CGImage
            // a UIImage still gets no error but no image
            self.view.layer.addSublayer(lay4)

        default: break
        }

        let lay3 = CALayer()
        lay3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        lay3.frame = CGRect(43, 197, 160, 230)
        self.view.layer.addSublayer(lay3)
        
//        let iv = UIImageView(image:UIImage(named:"smiley"))
//        self.view.addSubview(iv)
//        iv.frame.origin = CGPoint(180,180)

        lay1.name = "manny"
        lay2.name = "moe"
        lay3.name = "jack"
        delay(2) {
            print(self.view.layer.sublayers?.map{$0.name} as Any)
        }
        
        lay1.setValue("manny", forKey: "pepboy")
        lay2.setValue("moe", forKey: "pepboy")
        lay3.setValue("jack", forKey: "pepboy")
        delay(2) {
            self.view.layer.sublayers?.forEach {
                print($0.value(forKey: "pepboy") as Any)
            }
        }


    }
    
}
