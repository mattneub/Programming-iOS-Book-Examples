

import UIKit

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


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
    
    @IBOutlet var seg : UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.seg.layer.speed = 0.2
        delay(1) {
            UIView.animate(withDuration:0.4) {
                self.seg.selectedSegmentIndex = 1
            }
        }

//        self.seg.tintColor = UIColor.red()
//        return
        
        // background, set desired height but make width resizable
        // sufficient to set for Normal only
        
        let sz = CGSize(100,60)
        let im = imageOfSize(sz) {
            UIImage(named:"linen.png")!.draw(in:CGRect(origin: CGPoint(), size: sz))
            }.resizableImage(withCapInsets:
                UIEdgeInsetsMake(0,10,0,10), resizingMode: .stretch)
        self.seg.setBackgroundImage(im, for: [], barMetrics: .default)
        
        // segment images, redraw at final size
        let pep = ["manny", "moe", "jack"].map {$0 + ".jpg"}
        for (i, boy) in pep.enumerated() {
            let sz = CGSize(30,30)
            let im = imageOfSize(sz) {
                UIImage(named:boy)!.draw(in:CGRect(origin: CGPoint(), size: sz))
                }.withRenderingMode(.alwaysOriginal)
            self.seg.setImage(im, forSegmentAt: i)
            self.seg.setWidth(80, forSegmentAt: i)
        }
        
        // divider, set at desired width, sufficient to set for Normal only
        let sz2 = CGSize(2,10)
        let div = imageOfSize(sz2) {
            UIColor.white().set()
            UIGraphicsGetCurrentContext()!.fill(CGRect(origin: CGPoint(), size: sz2))
        }
        self.seg.setDividerImage(div, forLeftSegmentState: [], rightSegmentState: [], barMetrics: .default)
        
        let seg = UISegmentedControl(
            items: [
                UIImage(named:"smiley")!.withRenderingMode(.alwaysOriginal),
                "Two"
            ])
        seg.frame.origin = CGPoint(40,100)
        seg.frame.size.width = 200
        self.view.addSubview(seg)

    }
}
