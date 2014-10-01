import UIKit


class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainview = self.view
        
        let lay1 = CALayer()
        lay1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1).CGColor
        lay1.frame = CGRectMake(113, 111, 132, 194)
        mainview.layer.addSublayer(lay1)
        let lay2 = CALayer()
        lay2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1).CGColor
        lay2.frame = CGRectMake(41, 56, 132, 194)
        lay1.addSublayer(lay2)
        
        let which = 1
        switch which {
        case 1:
            // a view can be interspersed with sibling layers
            let iv = UIImageView(image:UIImage(named:"smiley"))
            mainview.addSubview(iv)
            // iv.layer.zPosition = 1
            iv.frame.origin = CGPointMake(180,180)
        case 2:
            // a layer can have image content
            let lay4 = CALayer()
            let im = UIImage(named:"smiley")!
            lay4.frame = CGRect(origin:CGPointMake(180,180), size:im.size)
            lay4.contents = im.CGImage // no need to remember to cast to id
            // but you do still need to remember to take the CGImage
            // a UIImage still gets no error but no image
            mainview.layer.addSublayer(lay4)

        default: break
        }

        let lay3 = CALayer()
        lay3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).CGColor
        lay3.frame = CGRectMake(43, 197, 160, 230)
        mainview.layer.addSublayer(lay3)
        
//        let iv = UIImageView(image:UIImage(named:"smiley"))
//        mainview.addSubview(iv)
//        iv.frame.origin = CGPointMake(180,180)


    }
    
}
