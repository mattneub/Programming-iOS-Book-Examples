

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;

@end

@implementation ViewController {
    CIFilter* _tran;
    CGRect _moiextent;
    double _frame;
    
    CFTimeInterval _timestamp;
    CIContext* _con;

}

- (IBAction)doButton:(id)sender {
    
    UIImage* moi = [UIImage imageNamed:@"moi"];
    CIImage* moi2 = [[CIImage alloc] initWithCGImage:moi.CGImage];
    self->_moiextent = moi2.extent;
    CIFilter* col = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor* cicol = [[CIColor alloc] initWithColor:[UIColor redColor]];
    [col setValue:cicol forKey:@"inputColor"];
    CIImage* colorimage = [col valueForKey: @"outputImage"];
    CIFilter* tran = [CIFilter filterWithName:@"CIFlashTransition"];
    [tran setValue:colorimage forKey:@"inputImage"];
    [tran setValue:moi2 forKey:@"inputTargetImage"];
    CIVector* center = [CIVector vectorWithX:self->_moiextent.size.width/2.0 Y:self->_moiextent.size.height/2.0];
    [tran setValue:center forKey:@"inputCenter"];
    
    self->_con = [CIContext contextWithOptions:nil];
    self->_tran = tran;
    self->_timestamp = 0.0; // signal that we are starting
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CADisplayLink* link = [CADisplayLink displayLinkWithTarget:self selector:@selector(nextFrame:)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

    });
    

    
}

#define SCALE 0.2 // try 0.2 for slow motion, looks better in simulator

- (void) nextFrame: (CADisplayLink*) sender {
    
    if (self->_timestamp < 0.01) { // pick up and store first timestamp
        self->_timestamp = sender.timestamp;
        self->_frame = 0.0;
    } else { // calculate frame
        self->_frame = (sender.timestamp - self->_timestamp) * SCALE;
    }
    sender.paused = YES; // defend against frame loss
    
    [_tran setValue:@(self->_frame) forKey:@"inputTime"];
    CGImageRef moi = [self->_con createCGImage:_tran.outputImage
                                       fromRect:_moiextent];
    [CATransaction setDisableActions:YES];
    self.v.layer.contents = (__bridge id)moi;
    CGImageRelease(moi);
    
    if (_frame > 1.0) {
        NSLog(@"%@", @"invalidate");
        [sender invalidate];
    }
    sender.paused = NO;
    
    NSLog(@"here %f", self->_frame); // useful for seeing dropped frame rate
    
    
}




@end
