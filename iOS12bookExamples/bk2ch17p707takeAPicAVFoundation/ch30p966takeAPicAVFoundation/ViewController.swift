

import UIKit
import AVFoundation
import Photos

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



func checkForPhotoLibraryAccess(andThen f:(()->())? = nil) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization() { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        break
    }
}

func checkForMicrophoneCaptureAccess(andThen f:(()->())? = nil) {
    let status = AVCaptureDevice.authorizationStatus(for:.audio)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        AVCaptureDevice.requestAccess(for:.audio) { granted in
            if granted {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        let alert = UIAlertController(
            title: "Need Authorization",
            message: "Wouldn't you like to authorize this app " +
            "to use the microphone?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "No", style: .cancel))
        alert.addAction(UIAlertAction(
        title: "OK", style: .default) {
            _ in
            let url = URL(string:UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        UIApplication.shared.delegate!.window!!.rootViewController!.present(alert, animated:true)
    }
}



func checkForMovieCaptureAccess(andThen f:(()->())? = nil) {
    let status = AVCaptureDevice.authorizationStatus(for:.video)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        AVCaptureDevice.requestAccess(for:.video) { granted in
            if granted {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        let alert = UIAlertController(
            title: "Need Authorization",
            message: "Wouldn't you like to authorize this app " +
            "to use the camera?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "No", style: .cancel))
        alert.addAction(UIAlertAction(
        title: "OK", style: .default) {
            _ in
            let url = URL(string:UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        UIApplication.shared.delegate!.window!!.rootViewController!.present(alert, animated:true)
    }
}

extension UIDeviceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return nil
        }
    }
}


class ViewController: UIViewController {
    
    var sess : AVCaptureSession!
    var snapper : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var iv : UIImageView!
    var previewImage : UIImage!

    let previewRect = CGRect(10,30,300,300)
        
    @IBAction func doStart (_ sender: Any!) {
        checkForMovieCaptureAccess(andThen:self.micCheck)
    }
    
    func micCheck() {
        checkForMicrophoneCaptureAccess(andThen:self.reallyStart)
    }
        
    func reallyStart() {
        if self.sess != nil && self.sess.isRunning {
            self.sess.stopRunning()
            self.previewLayer.removeFromSuperlayer()
            self.sess = nil
            return
        }
        self.iv?.removeFromSuperview()
        
        self.sess = AVCaptureSession()
        
        do {
            self.sess.beginConfiguration()
            
            guard self.sess.canSetSessionPreset(self.sess.sessionPreset) else {return}
            self.sess.sessionPreset = .photo
            
            let output = AVCapturePhotoOutput()
            guard self.sess.canAddOutput(output) else {return}
            self.sess.addOutput(output)
            
            self.sess.commitConfiguration()
        }
        
        guard let cam = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device:cam)
            else {return}
        self.sess.addInput(input)
        
        let lay = AVCaptureVideoPreviewLayer(session:self.sess)
        lay.frame = self.previewRect
        self.view.layer.addSublayer(lay)
        self.previewLayer = lay // keep a ref so we can remove it later
        
        self.sess.startRunning()
    }
    
    @IBAction func doSnap (_ sender: Any!) {
        guard self.sess != nil && self.sess.isRunning else {
            return
        }
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.isAutoStillImageStabilizationEnabled = true
        // let's also ask for a preview image
        let pbpf = settings.availablePreviewPhotoPixelFormatTypes[0]
        let len = max(self.previewLayer.bounds.width, self.previewLayer.bounds.height)
        settings.previewPhotoFormat = [
            kCVPixelBufferPixelFormatTypeKey as String : pbpf,
            kCVPixelBufferWidthKey as String : len,
            kCVPixelBufferHeightKey as String : len
        ]
        // let's also ask for a thumnail image
        settings.embeddedThumbnailPhotoFormat = [
            AVVideoCodecKey : AVVideoCodecType.jpeg
        ]

        guard let output = self.sess.outputs[0] as? AVCapturePhotoOutput else {return}
        // how to deal with orientation; stolen from Apple's AVCam example!
        if let conn = output.connection(with: .video) {
            let orientation = UIDevice.current.orientation.videoOrientation!
            conn.videoOrientation = orientation
        }
        output.capturePhoto(with: settings, delegate: self)
    }

}

extension ViewController : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("photo size", photo.resolvedSettings.photoDimensions)
        print("preview size", photo.resolvedSettings.previewDimensions)
        print("thumbnail format", photo.embeddedThumbnailPhotoFormat as Any)
        print("flash usage", photo.resolvedSettings.isFlashEnabled)
        
        if let cgim = photo.previewCGImageRepresentation()?.takeUnretainedValue() {
            // grapple with orientation issue relative to preview
            var orient : UIImage.Orientation {
                switch UIDevice.current.orientation {
                case .portrait: return .right
                case .portraitUpsideDown: return .left
                case .landscapeLeft: return .up
                case .landscapeRight: return .down
                default: return .right
                }
            }
            self.previewImage = UIImage(cgImage: cgim, scale: 1, orientation: orient)
        }
        
        if let data = photo.fileDataRepresentation() {
            checkForPhotoLibraryAccess {
                print("saving to library")
                let lib = PHPhotoLibrary.shared()
                lib.performChanges({
                    let req = PHAssetCreationRequest.forAsset()
                    req.addResource(with: .photo, data: data, options: nil)
                })
            }

        }

    }
    
    /*
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto sampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
            print("photo", resolvedSettings.photoDimensions)
            print("preview", resolvedSettings.previewDimensions)
            print("flash", resolvedSettings.isFlashEnabled)
//            let width = resolvedSettings.photoDimensions.width
//            let height = resolvedSettings.photoDimensions.height
//            let landscape = width > height
            if let prev = previewPhotoSampleBuffer {
                print("got preview image")
                if let buff = CMSampleBufferGetImageBuffer(prev) {
                    print("got image buffer")
                    let cim = CIImage(cvPixelBuffer: buff)
                    self.previewImage = UIImage(ciImage: cim)
                }
            }
            if let buff = sampleBuffer {
                if let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buff, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
                    
                        checkForPhotoLibraryAccess {
                            print("saving to library")
                            let lib = PHPhotoLibrary.shared()
                            lib.performChanges({
                                let req = PHAssetCreationRequest.forAsset()
                                req.addResource(with: .photo, data: data, options: nil)
                            })
                        }
                    
                }
                
                
            }
    }
 
 */
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
        DispatchQueue.main.async {
            
            self.previewLayer.removeFromSuperlayer()
            self.sess.stopRunning()
            self.sess = nil
            
            if let im = self.previewImage {
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
