

#import "DetailViewController.h"
#import "MasterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MySplitViewController.h"

@interface DetailViewController () <UISplitViewControllerDelegate>
@property (nonatomic, strong) UIBarButtonItem* btn;
@property (nonatomic, strong) UIViewController* nav;
@end

@implementation DetailViewController 

#pragma mark - Managing the detail item

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Detail";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Master" style:UIBarButtonItemStyleBordered target:self action:@selector(doMasterButton:)];
    self.btn = b;
    [self.navigationItem setLeftBarButtonItem:self.btn animated:NO];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)io 
                                         duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsPortrait(io))
        [self.navigationItem setLeftBarButtonItem:self.btn animated:NO];
    else
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
}
							
- (void) doMasterButton: (id) sender {
    UIViewController* vc = self.parentViewController;
    while (![vc isKindOfClass: [MySplitViewController class]])
        vc = vc.parentViewController;
    [(MySplitViewController*)vc showView1];
}

@end
