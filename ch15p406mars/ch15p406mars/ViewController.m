

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIView* mainview = self.view;
    
    UIImageView* iv =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mars"]];
    [mainview addSubview: iv];
    iv.clipsToBounds = YES;
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // uncomment these lines to clarify the boundaries of the image view
    iv.layer.borderColor = [UIColor blackColor].CGColor;
    iv.layer.borderWidth = 2;

#define which 1
    
#if which==1

    // using autoresizing-type behavior
    iv.center = CGPointMake(CGRectGetMidX(iv.superview.bounds),
                            CGRectGetMidY(iv.superview.bounds));
    iv.frame = CGRectIntegral(iv.frame);
    
#elif which==2
    
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    [iv.superview addConstraint:
     [NSLayoutConstraint
      constraintWithItem:iv attribute:NSLayoutAttributeCenterX
      relatedBy:0
      toItem:iv.superview attribute:NSLayoutAttributeCenterX
      multiplier:1 constant:0]];
    [iv.superview addConstraint:
     [NSLayoutConstraint
      constraintWithItem:iv attribute:NSLayoutAttributeCenterY
      relatedBy:0
      toItem:iv.superview attribute:NSLayoutAttributeCenterY
      multiplier:1 constant:0]];
    iv.image = [UIImage imageNamed:@"Mars.png"]; // finds the image set in the asset catalog
    // (the file extension is stripped so that old code continues to work with asset catalogs)

#endif
    
    // showing what happens when a different image is assigned
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        iv.image = [UIImage imageNamed:@"smileyiPhone.png"];
    });
}



@end
