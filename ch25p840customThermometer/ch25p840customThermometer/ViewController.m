
#import "ViewController.h"
#import "MyProgressView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *prog1;
@property (weak, nonatomic) IBOutlet UIProgressView *prog2;
@property (weak, nonatomic) IBOutlet MyProgressView *prog3;

@end

@implementation ViewController


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
    self.prog2.trackImage = im;
    self.prog2.progressImage = im2;
}

-(void)inc:(NSTimer*)t {
    CGFloat val = self.prog3.value;
    val += 0.1;
    [self.prog1 setProgress:val animated:NO]; // can't prevent it!
    [self.prog2 setProgress:val animated:YES];
    self.prog3.value = val;
    [self.prog3 setNeedsDisplay];
    if (val >= 1.0)
        [t invalidate];
}


@end
