

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *bar;
@property (weak, nonatomic) IBOutlet UIToolbar *bar2;

@end

@implementation ViewController

// no shadow for top toolbar on iPhone (really not supposed to use a toolbar this way, probably)
// bottom toolbar on iPhone does have shadow
// on iPad, both have shadow

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
    [self.bar setBackgroundImage:im forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    // note: on iPhone, there is no UIToolbarPositionTop! not supposed to use toolbar this way
    [self.bar2 setBackgroundImage:im forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1,3), NO, 0);
    // you want this to be small, tilable, and transparent
    [lin drawAtPoint:CGPointMake(-47,-47) blendMode:kCGBlendModeCopy alpha:0.4];
    UIImage* sh = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.bar setShadowImage:sh forToolbarPosition:UIToolbarPositionTop];
    [self.bar2 setShadowImage:sh forToolbarPosition:UIToolbarPositionBottom];
    
    // on iPhone, no shadow appears for top bar
    // makes sense since you're not supposed to have a top bar
    
}

@end
