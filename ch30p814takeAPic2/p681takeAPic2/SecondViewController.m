

#import "SecondViewController.h"
#import "ViewController.h"

@implementation SecondViewController {
    UIImage* image;
    __weak IBOutlet UIImageView* iv;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage*)im
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Decide";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Use" style:UIBarButtonItemStyleBordered target:self action:@selector(doUse:)];
        self->image = im;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self->iv.image = image;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) doUse: (id) sender {
    ViewController* vc = (id)self.presentingViewController;
    [vc doUse: self->image];
}


@end
