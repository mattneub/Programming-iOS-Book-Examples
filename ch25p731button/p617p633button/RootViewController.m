

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, weak) IBOutlet UIButton *button;
@end

@implementation RootViewController

-(void)viewDidLoad {
    UIImage* im = [UIImage imageNamed: @"coin2.png"];
    CGSize sz = [im size];
    UIImage* im2 = [im resizableImageWithCapInsets:UIEdgeInsetsMake(sz.height/2.0, sz.width/2.0, sz.height/2.0, sz.width/2.0) resizingMode:UIImageResizingModeStretch];
    [self.button setBackgroundImage: im2 forState: UIControlStateNormal];
    self.button.backgroundColor = [UIColor clearColor];
    
    
    NSMutableAttributedString* mas =
    [[NSMutableAttributedString alloc]
     initWithString:self.button.currentTitle attributes:
     @{
     NSFontAttributeName:self.button.titleLabel.font,
     NSForegroundColorAttributeName:self.button.titleLabel.textColor
     }
     ];
    [mas addAttributes:@{
NSStrokeColorAttributeName:[UIColor redColor],
NSStrokeWidthAttributeName:@(-2.0),
NSUnderlineStyleAttributeName:@1

     } range:NSMakeRange(4,mas.length-4)];
    
    [self.button setAttributedTitle:mas forState:UIControlStateNormal];
    
    mas = [mas mutableCopy];
    [mas setAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}
                 range:NSMakeRange(0,mas.length)];
     [self.button setAttributedTitle:mas forState:UIControlStateHighlighted];

}

@end
