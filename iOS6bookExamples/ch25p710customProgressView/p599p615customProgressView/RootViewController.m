
#import "RootViewController.h"
#import "MyProgressView.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progDef;
@property (weak, nonatomic) IBOutlet UIProgressView *prog3;
@property (weak, nonatomic) IBOutlet UIProgressView *prog2;
@property (nonatomic, strong) IBOutlet MyProgressView *prog;
@end

@implementation RootViewController 


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(inc:) userInfo:nil repeats:YES];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(9,9), NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(con, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(con, 0, 4.5);
    CGContextAddLineToPoint(con, 4.5, 9);
    CGContextAddLineToPoint(con, 9, 4.5);
    CGContextAddLineToPoint(con, 4.5, 0);
    CGContextClosePath(con);
    CGPathRef p = CGContextCopyPath(con);
    CGContextFillPath(con);
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    CGContextSetFillColorWithColor(con, [UIColor whiteColor].CGColor);
    CGContextAddPath(con, p);
    CGContextFillPath(con);
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    CGPathRelease(p);
    UIGraphicsEndImageContext();
    im = [im resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)
                            resizingMode:UIImageResizingModeStretch];
    im2 = [im2 resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)
                              resizingMode:UIImageResizingModeStretch];
    self.prog3.trackImage = im;
    self.prog3.progressImage = im2;
}

-(void)inc:(NSTimer*)t {
    CGFloat val = self.prog.value;
    val += 0.1;
    self.prog.value = val;
    self.prog2.progress = val;
    self.prog3.progress = val;
    self.progDef.progress = val;
    [self.prog setNeedsDisplay];
    if (val >= 1.0)
        [t invalidate];
}



@end
