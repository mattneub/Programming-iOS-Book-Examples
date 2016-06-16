
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
    
    @IBOutlet var prog1 : UIProgressView!
    @IBOutlet var prog2 : UIProgressView!
    @IBOutlet var prog3 : MyProgressView!
    @IBOutlet var prog4: MyCircularProgressButton!

    @IBAction func doButton (_ sender:AnyObject) {
        self.prog1.progress = 0
        self.prog2.progress = 0
        self.prog3.value = 0
        self.prog3.setNeedsDisplay()
        self.prog4.progress = 0
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(inc), userInfo: nil, repeats: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /*
        UIGraphicsBeginImageContextWithOptions(CGSize(9,9), NO, 0);
        CGContextRef con = UIGraphicsGetCurrentContext()!;
        CGContextSetFillColorWithColor(con, [UIColor blackColor].cgColor);
        CGContextMoveToPoint(con, 0, 4.5);
        CGContextAddLineToPoint(con, 4.5, 9);
        CGContextAddLineToPoint(con, 9, 4.5);
        CGContextAddLineToPoint(con, 4.5, 0);
        CGContextClosePath(con);
        CGPathRef p = CGContextCopyPath(con);
        CGContextFillPath(con);
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext()!;
        CGContextSetFillColorWithColor(con, [UIColor whiteColor].cgColor);
        CGContextAddPath(con, p);
        CGContextFillPath(con);
        UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext()!;
        CGPathRelease(p);
        UIGraphicsEndImageContext();
        im = [im resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)
        resizingMode:UIImageResizingModeStretch];
        im2 = [im2 resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)
        resizingMode:UIImageResizingModeStretch];
        self.prog2.trackImage = im;
        self.prog2.progressImage = im2;
        */

        self.prog2.backgroundColor = UIColor.black()
        self.prog2.trackTintColor = UIColor.black()
        UIGraphicsBeginImageContextWithOptions(CGSize(10,10), true, 0)
        let con = UIGraphicsGetCurrentContext()!
        con.setFillColor(UIColor.yellow().cgColor)
        con.fill(CGRect(0, 0, 10, 10))
        let r = con.boundingBoxOfClipPath.insetBy(dx: 1,dy: 1)
        con.setLineWidth(2)
        con.setStrokeColor(UIColor.black().cgColor)
        con.stroke(r)
        con.strokeEllipse(in: r)
        let im =
            UIGraphicsGetImageFromCurrentImageContext()!.resizableImage(withCapInsets:UIEdgeInsetsMake(4, 4, 4, 4), resizingMode:.stretch)
        UIGraphicsEndImageContext()
        self.prog2.progressImage = im
        
        // but this code, which worked fine for years including iOS 7.0, was broken by iOS 7.1
        // and remained broken in iOS 8
        // it is fixed at last once again in iOS 9!
        
        // hacky workaround, can't recommend really
        //        let ims = self.prog2.subviews.filter {$0 is UIImageView} as! [UIImageView]
        //        ims[1].image = im


    }
    
    func inc(_ t:Timer) {
        var val = Float(self.prog3.value)
        val += 0.1
        self.prog1.setProgress(val, animated:true) // bug fixed in iOS 7.1
        self.prog2.setProgress(val, animated:true)
        self.prog3.value = CGFloat(val)
        self.prog3.setNeedsDisplay()
        self.prog4.progress = val
        if val >= 1.0 {
            t.invalidate()
        }

    }

}
