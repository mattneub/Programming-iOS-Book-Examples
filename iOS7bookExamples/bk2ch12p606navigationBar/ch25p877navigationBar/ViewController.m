

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;

@end

@implementation ViewController

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor yellowColor]; // demonstrate translucency
    
    
    // new iOS 7 feature: replace the left-pointing chevron
    // very simple example
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10,20), NO, 0);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(6,0,4,20));
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navbar.backIndicatorImage = im;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10,20), NO, 0);
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navbar.backIndicatorTransitionMaskImage = im2;
    
    // show how to get the shadow
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), NO, 0);
    [[UIColor colorWithWhite:0.95 alpha:0.85] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,20,20));
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navbar setBackgroundImage:im forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navbar.translucent = YES;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4,4), NO, 0);
    [[[UIColor grayColor] colorWithAlphaComponent:0.3] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,4,2));
    [[[UIColor grayColor] colorWithAlphaComponent:0.15] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,2,4,2));
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navbar.shadowImage = im;
    
    
    // set up initial state of nav item

    UINavigationItem* ni = [[UINavigationItem alloc] initWithTitle:@"Tinker"];
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Evers"
                                                          style:UIBarButtonItemStylePlain
                                                         target:self action:@selector(pushNext:)];
    ni.rightBarButtonItem = b;
    self.navbar.items = @[ni];

    
}


- (void) pushNext: (id) sender {
    UIBarButtonItem* oldb = sender;
    NSString* s = oldb.title;
    UINavigationItem* ni = [[UINavigationItem alloc] initWithTitle:s];
    if ([s isEqualToString: @"Evers"]) {
        UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Chance"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self action:@selector(pushNext:)];
        ni.rightBarButtonItem = b;
    }
    [self.navbar pushNavigationItem:ni animated:YES];
}



@end
