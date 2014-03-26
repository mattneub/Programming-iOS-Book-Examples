

#import "ViewController.h"

@interface ViewController () <UIBarPositioningDelegate, UIToolbarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation ViewController

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    UIBarPosition result = UIBarPositionAny;
    if (bar == self.navbar)
        result = UIBarPositionTopAttached;
    if (bar == self.toolbar)
        result = UIBarPositionBottom;
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.toolbar.delegate = self;
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), NO, 0);
    [[UIColor colorWithWhite:0.95 alpha:0.85] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,20,20));
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navbar setBackgroundImage:im forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navbar.translucent = YES;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), NO, 0);
    [[UIColor colorWithWhite:0.95 alpha:0.85] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,20,20));
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.toolbar setBackgroundImage:im forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.toolbar.translucent = YES;

    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4,4), NO, 0);
    [[[UIColor grayColor] colorWithAlphaComponent:0.3] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,4,2));
    [[[UIColor grayColor] colorWithAlphaComponent:0.15] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,2,4,2));
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navbar.shadowImage = im;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4,4), NO, 0);
    [[[UIColor grayColor] colorWithAlphaComponent:0.3] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,2,4,2));
    [[[UIColor grayColor] colorWithAlphaComponent:0.15] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,4,2));
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.toolbar setShadowImage:im forToolbarPosition:UIBarPositionAny];
    
    return;
    // iOS 7.0 bug for which the following was a workaround is fixed in iOS 7.1
    for (UIView* v in self.toolbar.subviews) {
        if ([v isKindOfClass: [UIImageView class]] && v.bounds.size.height < 5) {
            v.backgroundColor = [UIColor clearColor];
            break;
        }
    }


}


@end
