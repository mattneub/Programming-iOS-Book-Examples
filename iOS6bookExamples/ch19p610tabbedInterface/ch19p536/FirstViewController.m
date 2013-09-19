

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", @"view 1 did load");
}

-(NSUInteger)supportedInterfaceOrientations {
    NSLog(@"supported1");
    return UIInterfaceOrientationMaskLandscape; // irrelevant! called but not obeyed in any way
}



@end
