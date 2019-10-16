
import UIKit


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    var tran : CIFilter!
    var moiextent : CGRect!
    var frame : Double!
    
    var timestamp: CFTimeInterval!
    var context : CIContext!
    
    @IBAction func doButton (_ sender: Any) {
        let moi = CIImage(image:UIImage(named:"moi")!)!
        self.moiextent = moi.extent
        
        let col = CIFilter(name:"CIConstantColorGenerator")!
        let cicol = CIColor(color:.red)
        col.setValue(cicol, forKey:"inputColor")
        let colorimage = col.value(forKey:"outputImage") as! CIImage
        
        let tran = CIFilter(name:"CIFlashTransition")!
        tran.setValue(colorimage, forKey:"inputImage")
        tran.setValue(moi, forKey:"inputTargetImage")
        let center = CIVector(x:self.moiextent.width/2.0, y:self.moiextent.height/2.0)
        tran.setValue(center, forKey:"inputCenter")
        
        self.tran = tran
        self.timestamp = 0.0 // signal that we are starting
        self.context = CIContext()
        
        DispatchQueue.main.async {
        
            let link = CADisplayLink(target:self, selector:#selector(self.nextFrame))
            link.add(to:.main, forMode:.default)
        
        }
        
    }
    
    let SCALE = 1.0 // 0.2 for slow motion, looks a bit better in simulator
    // but really you need to test on device
    
    @objc func nextFrame(_ sender:CADisplayLink) {
        if self.timestamp < 0.01 { // pick up and store first timestamp
            self.timestamp = sender.timestamp
            self.frame = 0.0
        } else { // calculate frame
            self.frame = (sender.timestamp - self.timestamp) * SCALE
        }
        sender.isPaused = true // defend against frame loss
        
        self.tran.setValue(self.frame, forKey:"inputTime")
        let moi = self.context.createCGImage(tran.outputImage!, from:self.moiextent)
        CATransaction.setDisableActions(true)
        self.v.layer.contents = moi
        
        if self.frame > 1.0 {
            print("invalidate")
            sender.invalidate()
        }
        sender.isPaused = false
        
        print("here \(self.frame!)") // useful for seeing dropped frame rate
    }
    
}
