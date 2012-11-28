

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *sw2;
@property (weak, nonatomic) IBOutlet UISwitch *sw;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // try *this* before iOS 6! people were doing a lot of nasty hacks...
    
    self.sw.tintColor = [UIColor redColor];
    self.sw.onTintColor = [UIColor blackColor];
    self.sw.thumbTintColor = [UIColor orangeColor];
    
    // well golllleeee! at *last* in iOS 6 we can draw the ON/OFF text ourselves!!
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(77,27), NO, 0);
    [[UIColor blackColor] setFill];
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,77,27)];
    [p fill];
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    NSAttributedString* att = [[NSAttributedString alloc] initWithString:@"YES" attributes:@{
                                                     NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:16],
                                          NSForegroundColorAttributeName:[UIColor whiteColor],
                                           NSParagraphStyleAttributeName:para
                               }];
    [att drawInRect:CGRectMake(0,5,77,22)];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.sw2.onImage = im;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(77,27), NO, 0);
    [[UIColor redColor] setFill];
    p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,77,27)];
    [p fill];
    para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    att = [[NSAttributedString alloc] initWithString:@"NO" attributes:@{
                                                     NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:16],
                                          NSForegroundColorAttributeName:[UIColor whiteColor],
                                           NSParagraphStyleAttributeName:para
                               }];
    [att drawInRect:CGRectMake(0,5,77,22)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.sw2.offImage = im;

    
}


@end
