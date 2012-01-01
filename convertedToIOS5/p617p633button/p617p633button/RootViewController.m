

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, retain) IBOutlet UIButton *button;
@end

@implementation RootViewController
@synthesize button;

-(void)viewDidLoad {
    UIImage* im = [UIImage imageNamed: @"coin2.png"];
    CGSize sz = [im size];
    UIImage* im2 = [im resizableImageWithCapInsets:UIEdgeInsetsMake(sz.height/2.0, sz.width/2.0, sz.height/2.0, sz.width/2.0)];
    [button setBackgroundImage: im2 forState: UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
}

@end
