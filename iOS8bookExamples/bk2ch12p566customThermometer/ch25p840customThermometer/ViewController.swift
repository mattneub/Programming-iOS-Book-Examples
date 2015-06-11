
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var prog1 : UIProgressView!
    @IBOutlet var prog2 : UIProgressView!
    @IBOutlet var prog3 : MyProgressView!

    @IBAction func doButton (sender:AnyObject) {
        self.prog1.progress = 0
        self.prog2.progress = 0
        self.prog3.value = 0
        self.prog3.setNeedsDisplay()
        NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "inc:", userInfo: nil, repeats: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /*
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(9,9), NO, 0);
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(con, [UIColor blackColor].CGColor);
        CGContextMoveToPoint(con, 0, 4.5);
        CGContextAddLineToPoint(con, 4.5, 9);
        CGContextAddLineToPoint(con, 9, 4.5);
        CGContextAddLineToPoint(con, 4.5, 0);
        CGContextClosePath(con);
        CGPathRef p = CGContextCopyPath(con);
        CGContextFillPath(con);
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        CGContextSetFillColorWithColor(con, [UIColor whiteColor].CGColor);
        CGContextAddPath(con, p);
        CGContextFillPath(con);
        UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
        CGPathRelease(p);
        UIGraphicsEndImageContext();
        im = [im resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)
        resizingMode:UIImageResizingModeStretch];
        im2 = [im2 resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)
        resizingMode:UIImageResizingModeStretch];
        self.prog2.trackImage = im;
        self.prog2.progressImage = im2;
        */

        self.prog2.backgroundColor = UIColor.blackColor()
        self.prog2.trackTintColor = UIColor.blackColor()
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(10,10), true, 0)
        let con = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(con, UIColor.yellowColor().CGColor)
        CGContextFillRect(con, CGRectMake(0, 0, 10, 10))
        let r = CGRectInset(CGContextGetClipBoundingBox(con),1,1)
        CGContextSetLineWidth(con, 2)
        CGContextSetStrokeColorWithColor(con, UIColor.blackColor().CGColor)
        CGContextStrokeRect(con, r)
        CGContextStrokeEllipseInRect(con, r)
        let im =
            UIGraphicsGetImageFromCurrentImageContext().resizableImageWithCapInsets(UIEdgeInsetsMake(4, 4, 4, 4), resizingMode:.Stretch)
        UIGraphicsEndImageContext()
        // self.prog2.progressImage = im
        // hacky workaround
        let ims = self.prog2.subviews.filter {$0 is UIImageView} as! [UIImageView]
        ims[1].image = im
        
        // but this code, which worked fine for years including iOS 7.0, was broken by iOS 7.1
        // and remains broken in iOS 8

    }
    
    func inc(t:NSTimer) {
        var val = Float(self.prog3.value)
        val += 0.1
        self.prog1.setProgress(val, animated:true) // bug fixed in iOS 7.1
        self.prog2.setProgress(val, animated:true)
        self.prog3.value = CGFloat(val)
        self.prog3.setNeedsDisplay()
        if val >= 1.0 {
            t.invalidate()
        }

    }

}
