
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController()
@property (nonatomic, strong) AVCaptureSession* sess;
@property (nonatomic, strong) AVCaptureStillImageOutput* snapper;
@end

@implementation ViewController
@synthesize sess=_sess, snapper=_snapper;

- (IBAction)doStart:(id)sender {
    if (self.sess && self.sess.isRunning) {
        [self.sess stopRunning];
        [[self.view.layer.sublayers lastObject] removeFromSuperlayer];
        return;
    }
    
    self.sess = [AVCaptureSession new];
    
    self.sess.sessionPreset = AVCaptureSessionPreset640x480;
    self.snapper = [AVCaptureStillImageOutput new];
    self.snapper.outputSettings = [NSDictionary dictionaryWithObject:AVVideoCodecJPEG 
                                                              forKey:AVVideoCodecKey];
    [self.sess addOutput:self.snapper];

    AVCaptureDevice* cam = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:cam error:nil];
    [self.sess addInput:input];
    
    AVCaptureVideoPreviewLayer* lay = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.sess];
    lay.frame = CGRectMake(10,30,300,300);
    [self.view.layer addSublayer:lay];
    
    [self.sess startRunning];
}

- (IBAction)doSnap:(id)sender {
    // find AVCaptureConnection
    AVCaptureConnection *vc = [self.snapper connectionWithMediaType:AVMediaTypeVideo];
    // deal with image when it arrives
    typedef void(^MyBufBlock)(CMSampleBufferRef, NSError*);
    MyBufBlock h = ^(CMSampleBufferRef buf, NSError *err) {
        NSData* data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buf];
        UIImage* im = [UIImage imageWithData:data];
        NSLog(@"%@", NSStringFromCGSize(im.size));
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10,30,300,300)];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            iv.image = im;
            [self.sess stopRunning];
            [[self.view.layer.sublayers lastObject] removeFromSuperlayer];
            [self.view addSubview: iv];
        });
    };
    [self.snapper captureStillImageAsynchronouslyFromConnection:vc 
                                              completionHandler:h];
}

@end
