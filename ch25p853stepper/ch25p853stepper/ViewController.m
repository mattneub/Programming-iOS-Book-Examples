

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIProgressView *prog;

@end

@implementation ViewController

- (IBAction)doStep:(id)sender {
    UIStepper* step = sender;
    self.prog.progress = step.value / (step.maximumValue - step.minimumValue);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.stepper.tintColor = [UIColor yellowColor];
    
    UIImage* image = [UIImage imageNamed: @"pic2.png"];
    UIImage* image2 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    [self.stepper setBackgroundImage:image2 forState:UIControlStateNormal];
    
    image = [UIImage imageNamed: @"pic1.png"];
    image2 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    [self.stepper setBackgroundImage:image2 forState:UIControlStateDisabled];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3,3), YES, 0);
    [self.stepper.tintColor setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,3,3));
    // [image2 drawAtPoint:CGPointMake(0,0)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image2 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    [self.stepper setDividerImage:image2 forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];
    [self.stepper setDividerImage:image2 forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateHighlighted];
    [self.stepper setDividerImage:image2 forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateNormal];
    
    
    // in iOS 7, the image is treated as a template if you don't prevent it (forgot about that)
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,29), NO, 0);
    [[UIColor whiteColor] setStroke];
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    NSAttributedString* att = [[NSAttributedString alloc] initWithString:@"\u21DA" attributes:@{
                                                                                                NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                                                                                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                NSParagraphStyleAttributeName:para
                                                                                                }];
    [att drawInRect:CGRectMake(0,-5,45,29)];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    im = [im imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.stepper setDecrementImage:im forState:UIControlStateNormal];
    
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,29), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DA" attributes:@{
                                                                            NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                                                                            NSForegroundColorAttributeName:[UIColor blackColor],
                                                                            NSParagraphStyleAttributeName:para
                                                                            }];
    [att drawInRect:CGRectMake(0,-5,45,29)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    im = [im imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.stepper setDecrementImage:im forState:UIControlStateDisabled];
    
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,29), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DA" attributes:@{
                                                                            NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                                                                            NSForegroundColorAttributeName:self.stepper.tintColor,
                                                                            NSParagraphStyleAttributeName:para
                                                                            }];
    [att drawInRect:CGRectMake(0,-5,45,29)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    im = [im imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.stepper setDecrementImage:im forState:UIControlStateHighlighted];
    
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,29), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DB" attributes:@{
                                                                            NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                                                                            NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                            NSParagraphStyleAttributeName:para
                                                                            }];
    [att drawInRect:CGRectMake(0,-5,45,29)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    im = [im imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.stepper setIncrementImage:im forState:UIControlStateNormal];
    
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,29), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DB" attributes:@{
                                                                            NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                                                                            NSForegroundColorAttributeName:[UIColor blackColor],
                                                                            NSParagraphStyleAttributeName:para
                                                                            }];
    [att drawInRect:CGRectMake(0,-5,45,29)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    im = [im imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.stepper setIncrementImage:im forState:UIControlStateDisabled];
    
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,29), NO, 0);
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"\u21DB" attributes:@{
                                                                            NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:30],
                                                                            NSForegroundColorAttributeName:self.stepper.tintColor,
                                                                            NSParagraphStyleAttributeName:para
                                                                            }];
    [att drawInRect:CGRectMake(0,-5,45,29)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    im = [im imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.stepper setIncrementImage:im forState:UIControlStateHighlighted];
    
    
    return; // interesting effect: remove overlay entirely if disabled
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45,29), NO, 0);
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.stepper setDecrementImage:im forState:UIControlStateDisabled];
    [self.stepper setIncrementImage:im forState:UIControlStateDisabled];

}


@end
