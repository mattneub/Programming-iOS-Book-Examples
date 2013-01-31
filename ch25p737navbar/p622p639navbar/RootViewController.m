
#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, weak) IBOutlet UINavigationBar *nav;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem* ni = [[UINavigationItem alloc] initWithTitle:@"Tinker"];
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Evers"
                                                          style:UIBarButtonItemStyleBordered 
                                                         target:self action:@selector(pushNext:)];
    ni.rightBarButtonItem = b;
    self.nav.items = @[ni]; // self.nav is the UINavigationBar
}

- (void) pushNext: (id) sender {
    UIBarButtonItem* oldb = sender;
    NSString* s = oldb.title;
    UINavigationItem* ni = [[UINavigationItem alloc] initWithTitle:s];
    if ([s isEqualToString: @"Evers"]) {
        UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Chance"
                                                              style:UIBarButtonItemStyleBordered 
                                                             target:self action:@selector(pushNext:)];
        ni.rightBarButtonItem = b;
    }
    [self.nav pushNavigationItem:ni animated:YES];
}

/*
 Also, in the running app, notice the subtle shadow at the bottom in iOS 6
 This is present provided we do not clip to bounds
 You can provide your own shadowImage if you are customizing the background image
 */

- (IBAction)doButton:(id)sender {
    
    // let's test the shadow image
    // we need a custom background image
    UIImage* lin = [UIImage imageNamed:@"lin.png"];
    // you can't just show any old image, because the *whole* image will appear...
    // unless you clip to bounds - but if you clip to bounds you get no shadow!
    // so you must size the image first
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30,44), NO, 0);
    // height can be 44 or less; width can be anything; runtime will tile for us
    [lin drawAtPoint:CGPointMake(-50,-50)];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.nav setBackgroundImage:im forBarMetrics:UIBarMetricsDefault];
    // we get default shadow automatically
    
    // notice that on iOS 6 we automatically get color change of the status bar on iPhone only
    
    return; // comment out this line to get custom shadow
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1,3), NO, 0);
    // you want this to be small, tilable, and transparent
    [lin drawAtPoint:CGPointMake(-47,-47) blendMode:kCGBlendModeCopy alpha:0.4];
    UIImage* sh = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.nav setShadowImage:sh];
    
    return; // comment out this line to play with custom status bar color
    
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
//    return;
    
    UINavigationBar* nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,1)];
    nav.tintColor = [UIColor redColor];
    nav.alpha = 0;
    [self.nav.superview addSubview:nav];


}



@end
