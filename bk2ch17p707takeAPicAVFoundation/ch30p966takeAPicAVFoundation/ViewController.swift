

import UIKit
import AVFoundation

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
    
    var sess : AVCaptureSession!
    var snapper : AVCaptureStillImageOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var iv : UIImageView!

    let previewRect = CGRect(10,30,300,300)
    
    @IBAction func doStart (_ sender: Any!) {
        if self.sess != nil && self.sess.isRunning {
            self.sess.stopRunning()
            self.previewLayer.removeFromSuperlayer()
            self.sess = nil
            return
        }
        
        self.sess = AVCaptureSession()
        
        self.sess.sessionPreset = AVCaptureSessionPreset640x480
        self.snapper = AVCaptureStillImageOutput()
        self.snapper.outputSettings = [
            AVVideoCodecKey: AVVideoCodecJPEG,
            AVVideoQualityKey: 0.6
            ]
        self.sess.addOutput(self.snapper)
        
        let cam = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        guard let input = try? AVCaptureDeviceInput(device:cam) else {return}
        self.sess.addInput(input)
        
        let lay = AVCaptureVideoPreviewLayer(session:self.sess)!
        lay.frame = self.previewRect
        self.view.layer.addSublayer(lay)
        self.previewLayer = lay // keep a ref
        
        self.sess.startRunning()
    }
    
    @IBAction func doSnap (_ sender: Any!) {
        if self.sess == nil || !self.sess.isRunning {
            return
        }
        let vc = self.snapper.connection(withMediaType: AVMediaTypeVideo)
        self.snapper.captureStillImageAsynchronously(from:vc) {
            (buf:CMSampleBuffer?, err:NSError?) in
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buf)
            let im = UIImage(data:data!)
            DispatchQueue.main.async {
                
                self.previewLayer.removeFromSuperlayer()
                self.sess.stopRunning()
                self.sess = nil

                let iv = UIImageView(frame:self.previewLayer.frame)
                iv.contentMode = .scaleAspectFit
                iv.image = im
                self.view.addSubview(iv)
                self.iv?.removeFromSuperview()
                self.iv = iv
                
                
            }

        }

    }


}
