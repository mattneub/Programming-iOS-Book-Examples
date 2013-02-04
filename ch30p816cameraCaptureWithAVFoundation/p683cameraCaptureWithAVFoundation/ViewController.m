
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController()
@property (nonatomic, strong) AVCaptureSession* sess;
@property (nonatomic, strong) AVCaptureStillImageOutput* snapper;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
@end

@implementation ViewController

- (IBAction)doStart:(id)sender {
    if (self.sess && self.sess.isRunning) {
        [self.sess stopRunning];
        [[self.view.layer.sublayers lastObject] removeFromSuperlayer];
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
    lay.frame = CGRectMake(10,30,300,300);
    [self.view.layer addSublayer:lay];
    // new addition: keep a ref
    self.previewLayer = lay;
    
    [self.sess startRunning];
}

- (IBAction)doSnap:(id)sender {
    // find AVCaptureConnection
    AVCaptureConnection *vc = [self.snapper connectionWithMediaType:AVMediaTypeVideo];
    // deal with image when it arrives
    typedef void(^MyBufBlock)(CMSampleBufferRef, NSError*);
    MyBufBlock h = ^(CMSampleBufferRef buf, NSError *err) {
        // new iOS 6 feature: we can stop the flow of real-time video right now
        // vc.enabled = NO;

        NSData* data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buf];
        UIImage* im = [UIImage imageWithData:data];
        // NSLog(@"%@", NSStringFromCGSize(im.size));
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10,30,300,300)];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            iv.image = im;
            [self.view addSubview: iv];
            
            [self.previewLayer removeFromSuperlayer];
            self.previewLayer = nil;
            [self.sess stopRunning];

        });
    };
    [self.snapper captureStillImageAsynchronouslyFromConnection:vc 
                                              completionHandler:h];

}

@end
