
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

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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

class MySpyProgressView : UIProgressView {
    // spy on setProgress
    // proves that whatever a UIProgressView is doing,
    // it is _not_ using KVO on its Progress to set its `progress` explicitly
    override func setProgress(_ progress: Float, animated: Bool) {
        super.setProgress(progress, animated:animated)
        print(progress)
    }
    override var progress: Float {
        get {
            return super.progress
        }
        set {
            super.progress = newValue
            print(progress)
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var prog1 : UIProgressView!
    @IBOutlet var prog2 : UIProgressView!
    @IBOutlet var prog2b: UIProgressView!
    @IBOutlet var prog3 : MyProgressView!
    
    var op1 : ProgressingOperation?
    var op2 : ProgressingOperation?
    var op2b : ProgressingOperation?
    var op3 : ProgressingOperation?
    
    var ops = Set<NSKeyValueObservation>()
    
    @IBAction func doButton (_ sender: Any) {
        self.prog1.progress = 0
        self.prog2.progress = 0
        self.prog2b.progress = 0
        self.prog3.value = 0
        self.prog3.setNeedsDisplay()
        
        // architecture 1: progress view's observedProgress is a second pointer to a vended Progress
        
        self.op1 = ProgressingOperation(units:10)
        self.prog1.observedProgress = self.op1!.progress
        self.op1!.start()
        delay(2) {
            print(self.prog1.progress)
        }

        // architecture 2: progress view's observedProgress is implicit parent of distant Progress
        
        self.prog2.observedProgress = Progress.discreteProgress(totalUnitCount: 10)
        self.prog2.observedProgress?.becomeCurrent(withPendingUnitCount: 10)
        self.op2 = ProgressingOperation(units:10) // automatically becomes child!
        self.prog2.observedProgress?.resignCurrent()
        self.op2!.start()
        
        // architecture 2b: progress view's observed Progress is explicit parent of distant Progress
        
        self.prog2b.observedProgress = Progress.discreteProgress(totalUnitCount: 10)
        self.op2b = ProgressingOperation(units:10)
        self.prog2b.observedProgress?.addChild(self.op2b!.progress, withPendingUnitCount: 10)
        self.op2b!.start()

        // architecture 3: explicit KVO on a Progress, update progress view manually
        
        self.op3 = ProgressingOperation(units:10)
        let op = self.op3!.progress.observe(\.fractionCompleted, options: .new) { prog, ch in
            if let frac = ch.newValue {
                self.prog3.value = CGFloat(frac)
                self.prog3.setNeedsDisplay()
            }
        }
        self.ops.insert(op)
        self.op3!.start()

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
        }.resizableImage(withCapInsets:UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4), resizingMode:.stretch)
        
        self.prog2.progressImage = im
        
    }
    
}
