

#import "ViewController.h"
@import AVFoundation;


@interface ViewController()
@property (nonatomic, strong) AVCaptureSession* sess;
@property (nonatomic, strong) AVCaptureStillImageOutput* snapper;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic, strong) UIImageView* iv;
@end

@implementation ViewController

- (CGRect) previewRect {
    return CGRectMake(10,30,300,300);
}

- (IBAction)doStart:(id)sender {
    if (self.sess && self.sess.isRunning) {
        [self.sess stopRunning];
        [self.previewLayer removeFromSuperlayer];
        self.sess = nil;
        return;
    }
    
    self.sess = [AVCaptureSession new];
    
    self.sess.sessionPreset = AVCaptureSessionPreset640x480;
    self.snapper = [AVCaptureStillImageOutput new];
    // new iOS 6 feature: we can set the JPEG quality of the output
    self.snapper.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG, AVVideoQualityKey:@0.6};
    [self.sess addOutput:self.snapper];
    
    AVCaptureDevice* cam = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:cam error:nil];
    [self.sess addInput:input];
    
    // NB iPhone 4S and 5 and new iPads have video stabilization...
    // but *not* in the preview layer, since this causes weird real-time feedback
    AVCaptureVideoPreviewLayer* lay = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.sess];
    lay.frame = [self previewRect];
    [self.view.layer addSublayer:lay];
    // new addition: keep a ref
    self.previewLayer = lay;
    
    [self.sess startRunning];
}

- (IBAction)doSnap:(id)sender {
    if (!self.sess || !self.sess.isRunning)
        return;
    AVCaptureConnection *vc = [self.snapper connectionWithMediaType:AVMediaTypeVideo];
    [self.snapper captureStillImageAsynchronouslyFromConnection:vc
                                              completionHandler:
     ^(CMSampleBufferRef buf, NSError *err) {
         NSData* data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buf];
         UIImage* im = [UIImage imageWithData:data];
         // NSLog(@"%@", NSStringFromCGSize(im.size));
         dispatch_async(dispatch_get_main_queue(), ^{
             
             UIImageView* iv = [[UIImageView alloc] initWithFrame:self.previewLayer.frame];
             iv.contentMode = UIViewContentModeScaleAspectFit;
             iv.image = im;
             [self.view addSubview: iv];
             [self.iv removeFromSuperview];
             self.iv = iv;
             
             [self.previewLayer removeFromSuperlayer];
             self.previewLayer = nil;
             [self.sess stopRunning];
             
         });
     }];
}


@end
