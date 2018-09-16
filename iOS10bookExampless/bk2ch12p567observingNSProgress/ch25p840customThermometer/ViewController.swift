
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



class ProgressingOperation {
    let progress : Progress
    init(units:Int) {
        self.progress = Progress(totalUnitCount: Int64(units))
    }
    func start() {
        Timer.scheduledTimer(timeInterval:0.4, target: self, selector: #selector(inc), userInfo: nil, repeats: true)
    }
    @objc func inc(_ t:Timer) {
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
    
    @IBAction func doButton (_ sender: Any) {
        self.prog1.progress = 0
        self.prog2.progress = 0
        self.prog3.value = 0
        self.prog3.setNeedsDisplay()
        
        // architecture 1: progress view's observedProgress is a second pointer to a vended NSProgress
        
        self.op1 = ProgressingOperation(units:10)
        self.prog1.observedProgress = self.op1!.progress
        self.op1!.start()

        // architecture 2: progress view's observedProgress is parent of distant NSProgress
        
        self.prog2.observedProgress = Progress.discreteProgress(totalUnitCount: 10)
        self.prog2.observedProgress?.becomeCurrent(withPendingUnitCount: 10)
        self.op2 = ProgressingOperation(units:10) // automatically becomes child!
        self.prog2.observedProgress?.resignCurrent()
        self.op2!.start()

        
        // architecture 3: explicit KVO on an NSProgress, update progress view manually
        
        self.op3 = ProgressingOperation(units:10)
        self.op3!.progress.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: [.new], context: nil)
        self.op3!.start()

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let _ = object as? Progress {
            if let frac = change?[.newKey] as? CGFloat {
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
        
        self.prog2.backgroundColor = .black
        self.prog2.trackTintColor = .black
        
        let r = UIGraphicsImageRenderer(size:CGSize(10,10))
        let im = r.image {
            ctx in let con = ctx.cgContext
            con.setFillColor(UIColor.yellow.cgColor)
            con.fill(CGRect(0, 0, 10, 10))
            let r = con.boundingBoxOfClipPath.insetBy(dx: 1,dy: 1)
            con.setLineWidth(2)
            con.setStrokeColor(UIColor.black.cgColor)
            con.stroke(r)
            con.strokeEllipse(in: r)
        }.resizableImage(withCapInsets:UIEdgeInsetsMake(4, 4, 4, 4), resizingMode:.stretch)

//        UIGraphicsBeginImageContextWithOptions(CGSize(10,10), true, 0)
//        let con = UIGraphicsGetCurrentContext()!
//        con.setFillColor(UIColor.yellow().cgColor)
//        con.fill(CGRect(0, 0, 10, 10))
//        let r = con.boundingBoxOfClipPath.insetBy(dx: 1,dy: 1)
//        con.setLineWidth(2)
//        con.setStrokeColor(UIColor.black().cgColor)
//        con.stroke(r)
//        con.strokeEllipse(in: r)
//        let im =
//            UIGraphicsGetImageFromCurrentImageContext()!.resizableImage(withCapInsets:UIEdgeInsetsMake(4, 4, 4, 4), resizingMode:.stretch)
//        UIGraphicsEndImageContext()
        
        self.prog2.progressImage = im
        
    }
    
}
