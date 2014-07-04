

#import "ViewController.h"

@interface ViewController () <UIToolbarDelegate>
@property (nonatomic, weak) IBOutlet UIToolbar* toolbar;
@property (nonatomic, strong) UIPopoverController* currentPop;
@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.toolbar.delegate = self;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
        UIPopoverController* pop = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.currentPop = pop;
//        [CATransaction setCompletionBlock:^{
//            pop.passthroughViews = nil;
//        }];
    }
}

-(IBAction)unwind:(UIStoryboardSegue*)sender {
    
}




@end
