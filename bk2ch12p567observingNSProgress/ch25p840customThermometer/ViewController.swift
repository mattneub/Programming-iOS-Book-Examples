
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var prog1 : UIProgressView!
    @IBOutlet var prog2 : UIProgressView!
    @IBOutlet var prog3 : MyProgressView!
    
    var progress : NSProgress?
    var progress2 : NSProgress?

    @IBAction func doButton (sender:AnyObject) {
        self.prog1.progress = 0
        self.prog2.progress = 0
        self.prog3.value = 0
        self.prog3.setNeedsDisplay()
        NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "inc:", userInfo: nil, repeats: true)
    }
    
    var didSetUp = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.didSetUp { return }
        self.didSetUp = true
        
        self.prog2.backgroundColor = UIColor.blackColor()
        self.prog2.trackTintColor = UIColor.blackColor()
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(10,10), true, 0)
        let con = UIGraphicsGetCurrentContext()!
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
        self.prog2.progressImage = im
        
        // demonstrate NSProgress
        
        self.progress = NSProgress.discreteProgressWithTotalUnitCount(10)
        self.prog1.observedProgress = self.progress
        
        // but how likely is it that we would want two pointers to the same NSProgress object?
        // perhaps a more realistic scenario: set it and forget it
        // the progress view's progress is a parent; meanwhile, the progressing operation updates a child
        
        self.prog2.observedProgress = NSProgress.discreteProgressWithTotalUnitCount(10)
        self.progress2 = NSProgress(totalUnitCount: 10, parent: self.prog2.observedProgress!, pendingUnitCount: 10)
        
        // and of course that architecture is even more convincing if the child NSProgress lives at a distance
        // from the progress view, and if there are multiple children

    }
    
    func inc(t:NSTimer) {
        var val = Float(self.prog3.value)
        val += 0.1
        
        // direct updating: prog1's progress is our progress
        self.progress!.completedUnitCount = Int64(val * 10)
        
        // indirect updating: prog2's progress is our progress's parent
        self.progress2!.completedUnitCount = Int64(val * 10)
        
        self.prog3.value = CGFloat(val)
        self.prog3.setNeedsDisplay()
        if val >= 1.0 {
            t.invalidate()
        }

    }

}
