

import UIKit
import Photos
import GLKit
import OpenGLES
import MobileCoreServices
import AVFoundation
import MyVignetteFilter

protocol EditingViewControllerDelegate : class {
    func finishEditingWithVignette(vignette:Double)
}


class EditingViewController: UIViewController, GLKViewDelegate {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var glkview: GLKView!
    
    var context : CIContext!
    let displayImage : CIImage
    let vig = MyVignetteFilter()
    var initialVignette : Double = 0.85
    var canUndo = false
    weak var delegate : EditingViewControllerDelegate?
    
    init(displayImage:CIImage) {
        self.displayImage = displayImage
        super.init(nibName: "EditingViewController", bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slider.value = Float(self.initialVignette)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "doCancel:")
        self.navigationItem.leftBarButtonItem = cancel
        let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doDone:")
        self.navigationItem.rightBarButtonItem = done
        
        if self.canUndo {
            let undo = UIBarButtonItem(title: "Remove", style: .Plain, target: self, action: "doUndo:")
            self.navigationItem.rightBarButtonItems = [done, undo]
        }
        
        let eaglcontext = EAGLContext(API:.OpenGLES2)
        self.glkview.context = eaglcontext
        self.glkview.delegate = self
        
        self.context = CIContext(EAGLContext: self.glkview.context)
        
        self.glkview.display()
    }
    
    func glkView(view: GLKView, drawInRect rect: CGRect) {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        
        self.vig.setValue(self.displayImage, forKey: "inputImage")
        let val = Double(self.slider.value)
        self.vig.setValue(val, forKey:"inputPercentage")
        let output = self.vig.outputImage!
        
        var r = self.glkview.bounds
        r.size.width = CGFloat(self.glkview.drawableWidth)
        r.size.height = CGFloat(self.glkview.drawableHeight)

        r = AVMakeRectWithAspectRatioInsideRect(output.extent.size, r)
        
        self.context.drawImage(output, inRect: r, fromRect: output.extent)
    }

    
    func doCancel (sender:AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doDone (sender:AnyObject?) {
        self.dismissViewControllerAnimated(true) {
            _ in
            delay(0.1) {
                self.delegate?.finishEditingWithVignette(Double(self.slider.value))
            }
        }
    }
    
    func doUndo (sender:AnyObject?) {
        self.dismissViewControllerAnimated(true) {
            _ in
            delay(0.1) {
                self.delegate?.finishEditingWithVignette(-1) // signal for removal
            }
        }
    }

    @IBAction func doSlider(sender: AnyObject?) {
        self.glkview.display()
    }
    
    

}
