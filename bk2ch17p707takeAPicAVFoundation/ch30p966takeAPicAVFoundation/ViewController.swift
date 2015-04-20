

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var sess : AVCaptureSession!
    var snapper : AVCaptureStillImageOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var iv : UIImageView!

    let previewRect = CGRectMake(10,30,300,300)
    
    @IBAction func doStart (sender:AnyObject!) {
        if self.sess != nil && self.sess.running {
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
        
        let cam = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input = AVCaptureDeviceInput(device:cam, error:nil)
        self.sess.addInput(input)
        
        let lay = AVCaptureVideoPreviewLayer(session:self.sess)
        lay.frame = self.previewRect
        self.view.layer.addSublayer(lay)
        self.previewLayer = lay // keep a ref
        
        self.sess.startRunning()
    }
    
    @IBAction func doSnap (sender:AnyObject!) {
        if self.sess == nil || !self.sess.running {
            return
        }
        let vc = self.snapper.connectionWithMediaType(AVMediaTypeVideo)
        self.snapper.captureStillImageAsynchronouslyFromConnection(vc) {
            (buf:CMSampleBuffer!, err:NSError!) in
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buf)
            let im = UIImage(data:data)
            dispatch_async(dispatch_get_main_queue()) {
                
                self.previewLayer.removeFromSuperlayer()
                self.sess.stopRunning()
                self.sess = nil

                let iv = UIImageView(frame:self.previewLayer.frame)
                iv.contentMode = .ScaleAspectFit
                iv.image = im
                self.view.addSubview(iv)
                self.iv?.removeFromSuperview()
                self.iv = iv
                
                
            }

        }

    }


}
