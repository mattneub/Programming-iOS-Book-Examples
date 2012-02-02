
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController()
@property (nonatomic, strong) AVCaptureSession* sess;
@end

@implementation ViewController
@synthesize sess=_sess;

- (IBAction)doStart:(id)sender {
    if (self.sess && self.sess.isRunning) {
        [self.sess stopRunning];
        [[self.view.layer.sublayers lastObject] removeFromSuperlayer];
        return;
    }
    
    self.sess = [AVCaptureSession new];
    AVCaptureDevice* cam = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:cam error:nil];
    [self.sess addInput:input];
    
    AVCaptureVideoPreviewLayer* lay = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.sess];
    lay.videoGravity = AVLayerVideoGravityResizeAspect;
    lay.masksToBounds = YES;
    lay.frame = CGRectMake(0,0,300,300);
    lay.backgroundColor = [UIColor blackColor].CGColor;
    lay.position = CGPointMake(self.view.bounds.size.width/2.0, 160);
    [self.view.layer addSublayer:lay];
    
    [self.sess startRunning];
}

@end
