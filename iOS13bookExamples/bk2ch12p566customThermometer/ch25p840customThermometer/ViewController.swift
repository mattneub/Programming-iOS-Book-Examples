
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

    @IBAction func doButton (_ sender: Any) {
        self.prog1.progress = 0
        self.prog2.progress = 0
        self.prog3.value = 0
        self.prog3.setNeedsDisplay()
        self.prog4.progress = 0
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(inc), userInfo: nil, repeats: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let r = UIGraphicsImageRenderer(size:CGSize(10,10))
        var trackim : UIImage?
        let im = r.image { ctx in
            let con = ctx.cgContext
            // track
            con.setFillColor(UIColor.black.cgColor)
            con.fill(CGRect(0,0,10,10))
            trackim = ctx.currentImage
            // progress
            con.setFillColor(UIColor.yellow.cgColor)
            con.fillEllipse(in: CGRect(2,2,6,6))
        }
        self.prog2.trackImage = trackim?.resizableImage(
            withCapInsets:UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
            resizingMode:.stretch)
        self.prog2.progressImage = im.resizableImage(
            withCapInsets:UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
            resizingMode:.stretch)
        
        // but this code, which worked fine for years including iOS 7.0, was broken by iOS 7.1
        // and remained broken in iOS 8
        // it is fixed at last once again in iOS 9!
        
        // hacky workaround, can't recommend really
        //        let ims = self.prog2.subviews.filter {$0 is UIImageView} as! [UIImageView]
        //        ims[1].image = im


    }
    
    @objc func inc(_ t:Timer) {
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
