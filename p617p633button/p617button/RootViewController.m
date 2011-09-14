

#import "RootViewController.h"

@implementation RootViewController
@synthesize button;

-(void)viewDidLoad {
    UIImage* im = [UIImage imageNamed: @"coin2.png"];
    CGSize sz = [im size];
    UIImage* im2 = [im stretchableImageWithLeftCapWidth:sz.width/2.0 
                                           topCapHeight:sz.height/2.0];
    [button setBackgroundImage: im2 forState: UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
}

- (void)dealloc {
    [button release];
    [super dealloc];
}

@end
