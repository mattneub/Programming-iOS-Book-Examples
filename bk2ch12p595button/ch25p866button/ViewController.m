

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage* im = [UIImage imageNamed: @"coin2.png"];
    CGSize sz = [im size];
    UIImage* im2 = [im resizableImageWithCapInsets:UIEdgeInsetsMake(sz.height/2.0, sz.width/2.0, sz.height/2.0, sz.width/2.0) resizingMode:UIImageResizingModeStretch];
    [self.button setBackgroundImage: im2 forState: UIControlStateNormal];
    self.button.backgroundColor = [UIColor clearColor];
    [self.button setImage:im2 forState:UIControlStateNormal];
    
    NSMutableAttributedString* mas =
    [[NSMutableAttributedString alloc]
     initWithString:@"Pay Tribute" attributes:
     @{
       NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:16],
       NSForegroundColorAttributeName:[UIColor purpleColor]
       }
     ];
    [mas addAttributes:@{
                         NSStrokeColorAttributeName:[UIColor redColor],
                         NSStrokeWidthAttributeName:@(-2.0),
                         NSUnderlineStyleAttributeName:@1
                         } range:NSMakeRange(4,mas.length-4)];
    [self.button setAttributedTitle:mas forState:UIControlStateNormal];
    
    mas = [mas mutableCopy];
    [mas addAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}
                 range:NSMakeRange(0,mas.length)];
    [self.button setAttributedTitle:mas forState:UIControlStateHighlighted];
    
    self.button.adjustsImageWhenHighlighted = YES;
    
}



@end
