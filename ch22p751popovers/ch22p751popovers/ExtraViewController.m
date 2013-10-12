

#import "ExtraViewController.h"

@interface ExtraViewController ()

@end

@implementation ExtraViewController
- (IBAction)doButton:(id)sender {
    NSLog(@"extra view controller view frame: %@", NSStringFromCGRect(self.view.frame));
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", @"dismissed");
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.preferredContentSize = CGSizeMake(320,220);
        // self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0,0,320,220);
}


-(void)dealloc {
    NSLog(@"%@", @"dealloc extra view controller");
}

@end
