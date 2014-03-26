
#import "ViewController.h"
#import "MyProgressView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *prog1;
@property (weak, nonatomic) IBOutlet UIProgressView *prog2;
@property (weak, nonatomic) IBOutlet MyProgressView *prog3;

@end

@implementation ViewController

- (IBAction) doButton: (id) sender {
    self.prog1.progress = 0;
    self.prog2.progress = 0;
    self.prog3.value = 0;
    [self.prog3 setNeedsDisplay];
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(inc:) userInfo:nil repeats:YES];
}

-(void)viewDidLayoutSubviews {
    
    /*
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
     */
    
    self.prog2.backgroundColor = [UIColor blackColor];
    self.prog2.trackTintColor = [UIColor blackColor];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10,10), YES, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(con, [UIColor yellowColor].CGColor);
    CGContextFillRect(con, CGRectMake(0, 0, 10, 10));
    CGRect r = CGRectInset(CGContextGetClipBoundingBox(con),1,1);
    CGContextSetLineWidth(con, 2);
    CGContextSetStrokeColorWithColor(con, [UIColor blackColor].CGColor);
    CGContextStrokeRect(con, r);
    CGContextStrokeEllipseInRect(con, r);
    self.prog2.progressImage =
    [UIGraphicsGetImageFromCurrentImageContext()
     resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)
     resizingMode:UIImageResizingModeStretch];
    UIGraphicsEndImageContext();
    
    // but this code, which worked fine for years including iOS 7.0, is broken by iOS 7.1

}

-(void)inc:(NSTimer*)t {
    CGFloat val = self.prog3.value;
    val += 0.1;
    [self.prog1 setProgress:val animated:YES]; // bug fixed in iOS 7.1
    [self.prog2 setProgress:val animated:YES];
    self.prog3.value = val;
    [self.prog3 setNeedsDisplay];
    if (val >= 1.0)
        [t invalidate];
}


@end
