
import UIKit

class ProgressingOperation {
    let progress : NSProgress
    init(units:Int) {
        self.progress = NSProgress(totalUnitCount: Int64(units))
    }
    func start() {
        NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "inc:", userInfo: nil, repeats: true)
    }
    @objc func inc(t:NSTimer) {
        self.progress.completedUnitCount += 1
        if self.progress.fractionCompleted >= 1.0 {
            t.invalidate()
            print("done")
        }
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet var prog1 : UIProgressView!
    @IBOutlet var prog2 : UIProgressView!
    @IBOutlet var prog3 : MyProgressView!
    
    var op1 : ProgressingOperation?
    var op2 : ProgressingOperation?
    var op3 : ProgressingOperation?
    
    @IBAction func doButton (sender:AnyObject) {
        self.prog1.progress = 0
        self.prog2.progress = 0
        self.prog3.value = 0
        self.prog3.setNeedsDisplay()
        
        // architecture 1: progress view's observedProgress is a second pointer to a vended NSProgress
        
        self.op1 = ProgressingOperation(units:10)
        self.prog1.observedProgress = self.op1!.progress
        self.op1!.start()

        // architecture 2: progress view's observedProgress is parent of distant NSProgress
        
        self.prog2.observedProgress = NSProgress.discreteProgressWithTotalUnitCount(10)
        self.prog2.observedProgress?.becomeCurrentWithPendingUnitCount(10)
        self.op2 = ProgressingOperation(units:10) // automatically becomes child!
        self.prog2.observedProgress?.resignCurrent()
        self.op2!.start()

        
        // architecture 3: explicit KVO on an NSProgress, update progress view manually
        
        self.op3 = ProgressingOperation(units:10)
        self.op3!.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.New], context: nil)
        self.op3!.start()

    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let _ = object as? NSProgress {
            if let frac = change?[NSKeyValueChangeNewKey] as? CGFloat {
                self.prog3.value = frac
                self.prog3.setNeedsDisplay()
            }
        }
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
        
    }
    
}
