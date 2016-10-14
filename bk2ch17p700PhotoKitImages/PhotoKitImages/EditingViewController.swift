

import UIKit
import Photos
import GLKit
import OpenGLES
import MobileCoreServices
import AVFoundation
import VignetteFilter

protocol EditingViewControllerDelegate : class {
    func finishEditing(vignette:Double)
}


class EditingViewController: UIViewController, GLKViewDelegate {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var glkview: GLKView!
    
    var context : CIContext!
    let displayImage : CIImage
    let vig = VignetteFilter()
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
        
        self.edgesForExtendedLayout = []
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doCancel))
        self.navigationItem.leftBarButtonItem = cancel
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doDone))
        self.navigationItem.rightBarButtonItem = done
        
        if self.canUndo {
            let undo = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(doUndo))
            self.navigationItem.rightBarButtonItems = [done, undo]
        }
        
        let eaglcontext = EAGLContext(api:.openGLES2)!
        self.glkview.context = eaglcontext
        self.glkview.delegate = self
        
        self.context = CIContext(eaglContext: self.glkview.context)
        
        self.glkview.display()
    }
    
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        
        self.vig.setValue(self.displayImage, forKey: "inputImage")
        let val = Double(self.slider.value)
        self.vig.setValue(val, forKey:"inputPercentage")
        let output = self.vig.outputImage!
        
        var r = self.glkview.bounds
        r.size.width = CGFloat(self.glkview.drawableWidth)
        r.size.height = CGFloat(self.glkview.drawableHeight)

        r = AVMakeRect(aspectRatio: output.extent.size, insideRect: r)
        
        self.context.draw(output, in: r, from: output.extent)
    }

    
    func doCancel (_ sender: Any?) {
        self.dismiss(animated:true)
    }
    
    func doDone (_ sender: Any?) {
        self.dismiss(animated:true) {
            delay(0.1) {
                self.delegate?.finishEditing(vignette:Double(self.slider.value))
            }
        }
    }
    
    func doUndo (_ sender: Any?) {
        self.dismiss(animated:true) {
            delay(0.1) {
                self.delegate?.finishEditing(vignette: -1) // signal for removal
            }
        }
    }

    @IBAction func doSlider(_ sender: Any?) {
        self.glkview.display()
    }
    
    

}
