

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
}

@end
