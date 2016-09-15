

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


func imageOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

class ViewController: UIViewController {
    
    @IBOutlet var seg : UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.seg.layer.speed = 0.2
        delay(1) {
            UIView.animateWithDuration(0.4, animations: {
                self.seg.selectedSegmentIndex = 1
            })
        }

//        self.seg.tintColor = UIColor.redColor()
//        return
        
        // background, set desired height but make width resizable
        // sufficient to set for Normal only
        
        let sz = CGSizeMake(100,60)
        let im = imageOfSize(sz) {
            UIImage(named:"linen.png")!.drawInRect(CGRect(origin: CGPoint(), size: sz))
            }.resizableImageWithCapInsets(
                UIEdgeInsetsMake(0,10,0,10), resizingMode: .Stretch)
        self.seg.setBackgroundImage(im, forState: .Normal, barMetrics: .Default)
        
        // segment images, redraw at final size
        let pep = ["manny", "moe", "jack"].map {$0 + ".jpg"}
        for (i, boy) in pep.enumerate() {
            let sz = CGSizeMake(30,30)
            let im = imageOfSize(sz) {
                UIImage(named:boy)!.drawInRect(CGRect(origin: CGPoint(), size: sz))
                }.imageWithRenderingMode(.AlwaysOriginal)
            self.seg.setImage(im, forSegmentAtIndex: i)
            self.seg.setWidth(80, forSegmentAtIndex: i)
        }
        
        // divider, set at desired width, sufficient to set for Normal only
        let sz2 = CGSizeMake(2,10)
        let div = imageOfSize(sz2) {
            UIColor.whiteColor().set()
            CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRect(origin: CGPoint(), size: sz2))
        }
        self.seg.setDividerImage(div, forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
        
        let seg = UISegmentedControl(
            items: [
                UIImage(named:"smiley")!.imageWithRenderingMode(.AlwaysOriginal),
                "Two"
            ])
        seg.frame.origin = CGPointMake(40,100)
        seg.frame.size.width = 200
        self.view.addSubview(seg)

    }
}
