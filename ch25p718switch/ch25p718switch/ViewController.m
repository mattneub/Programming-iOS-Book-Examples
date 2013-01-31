

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIPageControl *pc;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UISwitch *sw2;
@property (weak, nonatomic) IBOutlet UISwitch *sw;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.pc.pageIndicatorTintColor = [UIColor blueColor];
    self.pc.currentPageIndicatorTintColor = [UIColor yellowColor];
    
    // try *this* before iOS 6! people were doing a lot of nasty hacks...
    
    self.sw.tintColor = [UIColor redColor];
    self.sw.onTintColor = [UIColor blackColor];
    self.sw.thumbTintColor = [UIColor orangeColor];
    
    // well golllleeee! at *last* in iOS 6 we can draw the ON/OFF text ourselves!!
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(79,27), NO, 0);
    [[UIColor blackColor] setFill];
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,79,27)];
    [p fill];
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    NSAttributedString* att = [[NSAttributedString alloc] initWithString:@"YES" attributes:@{
                                                     NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:16],
                                          NSForegroundColorAttributeName:[UIColor whiteColor],
                                           NSParagraphStyleAttributeName:para
                               }];
    [att drawInRect:CGRectMake(0,5,79,22)];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.sw2.onImage = im;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(79,27), NO, 0);
    [[UIColor redColor] setFill];
    p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,79,27)];
    [p fill];
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"NO" attributes:@{
                                                     NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:16],
                                          NSForegroundColorAttributeName:[UIColor whiteColor],
                                           NSParagraphStyleAttributeName:para
                               }];
    [att drawInRect:CGRectMake(0,5,79,22)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.sw2.offImage = im;
    
    // can also heavily customize a stepper

    self.stepper.tintColor = [UIColor yellowColor];
    UIImage* image = [UIImage imageNamed: @"pic2.png"];
    UIImage* image2 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    [self.stepper setBackgroundImage:image2 forState:UIControlStateNormal];
    image = [UIImage imageNamed: @"pic1.png"];
    image2 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    [self.stepper setBackgroundImage:image2 forState:UIControlStateDisabled];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3,3), YES, 0);
    [image2 drawAtPoint:CGPointMake(0,0)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image2 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    [self.stepper setDividerImage:image2 forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];
    [self.stepper setDividerImage:image2 forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateHighlighted];
    [self.stepper setDividerImage:image2 forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateNormal];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,27), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DA" attributes:@{
                                 NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                      NSForegroundColorAttributeName:[UIColor whiteColor],
                       NSParagraphStyleAttributeName:para
           }];
    [att drawInRect:CGRectMake(0,-5,45,27)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.stepper setDecrementImage:im forState:UIControlStateNormal];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,27), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DA" attributes:@{
                                 NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                      NSForegroundColorAttributeName:[UIColor blackColor],
                       NSParagraphStyleAttributeName:para
           }];
    [att drawInRect:CGRectMake(0,-5,45,27)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.stepper setDecrementImage:im forState:UIControlStateDisabled];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,27), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DA" attributes:@{
                                 NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                      NSForegroundColorAttributeName:[UIColor blueColor],
                       NSParagraphStyleAttributeName:para
           }];
    [att drawInRect:CGRectMake(0,-5,45,27)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.stepper setDecrementImage:im forState:UIControlStateHighlighted];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,27), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DB" attributes:@{
                                 NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                      NSForegroundColorAttributeName:[UIColor whiteColor],
                       NSParagraphStyleAttributeName:para
           }];
    [att drawInRect:CGRectMake(0,-5,45,27)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.stepper setIncrementImage:im forState:UIControlStateNormal];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,27), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DB" attributes:@{
                                 NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                      NSForegroundColorAttributeName:[UIColor blackColor],
                       NSParagraphStyleAttributeName:para
           }];
    [att drawInRect:CGRectMake(0,-5,45,27)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.stepper setIncrementImage:im forState:UIControlStateDisabled];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,27), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DB" attributes:@{
                                 NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                      NSForegroundColorAttributeName:[UIColor blueColor],
                       NSParagraphStyleAttributeName:para
           }];
    [att drawInRect:CGRectMake(0,-5,45,27)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.stepper setIncrementImage:im forState:UIControlStateHighlighted];
    
    
    return; // interesting effect: remove overlay entirely if disabled
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,27), NO, 0);
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.stepper setDecrementImage:im forState:UIControlStateDisabled];
    [self.stepper setIncrementImage:im forState:UIControlStateDisabled];
    
}


@end
