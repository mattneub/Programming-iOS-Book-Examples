
import UIKit


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    var tran : CIFilter!
    var moiextent : CGRect!
    var frame : Double!
    
    var timestamp: CFTimeInterval!
    var con: CIContext!
    
    @IBAction func doButton (sender:AnyObject) {
        let moi = CIImage(image:UIImage(named:"moi"))
        self.moiextent = moi.extent()
        
        let col = CIFilter(name:"CIConstantColorGenerator")
        let cicol = CIColor(color:UIColor.redColor())
        col.setValue(cicol, forKey:"inputColor")
        let colorimage = col.valueForKey("outputImage") as! CIImage
        
        let tran = CIFilter(name:"CIFlashTransition")
        tran.setValue(colorimage, forKey:"inputImage")
        tran.setValue(moi, forKey:"inputTargetImage")
        let center = CIVector(x:self.moiextent.width/2.0, y:self.moiextent.height/2.0)
        tran.setValue(center, forKey:"inputCenter")
        
        self.con = CIContext(options:nil)
        self.tran = tran
        self.timestamp = 0.0 // signal that we are starting
        
        dispatch_async(dispatch_get_main_queue()) {
        
            let link = CADisplayLink(target:self, selector:"nextFrame:")
            link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode:NSDefaultRunLoopMode)
        
        }
        
    }
    
    let SCALE = 0.2 // 0.2 for slow motion, looks a bit better in simulator
    // but really you need to test on device
    
    func nextFrame(sender:CADisplayLink) {
        if self.timestamp < 0.01 { // pick up and store first timestamp
            self.timestamp = sender.timestamp
            self.frame = 0.0
        } else { // calculate frame
            self.frame = (sender.timestamp - self.timestamp) * SCALE
        }
        sender.paused = true // defend against frame loss
        
        self.tran.setValue(self.frame, forKey:"inputTime")
        let moi = self.con.createCGImage(tran.outputImage, fromRect:self.moiextent)
        CATransaction.setDisableActions(true)
        self.v.layer.contents = moi
        
        if self.frame > 1.0 {
            println("invalidate")
            sender.invalidate()
        }
        sender.paused = false
        
        println("here \(self.frame)") // useful for seeing dropped frame rate
    }
    
}
