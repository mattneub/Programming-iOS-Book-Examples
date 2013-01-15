

#import "ExtraViewController.h"

@interface ExtraViewController () <UIViewControllerRestoration>

@end

@implementation ExtraViewController

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"evc encode");
    [super encodeRestorableStateWithCoder:coder];

}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"evc decode");
    [super decodeRestorableStateWithCoder:coder];

}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Extra";
        self.restorationIdentifier = @"extra";
        self.restorationClass = [self class];
    }
    return self;
}

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)ic
                                                             coder:(NSCoder *)coder {
    NSLog(@"%@", ic);
    if ([[ic lastObject] isEqualToString:@"extra"]) {
        return [self new];
    }
    return nil;
}



-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"evc viewdidload");

    self.view.backgroundColor = [UIColor greenColor];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doDismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = self.view.center;
    [self.view addSubview:button];
}

-(void)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    NSLog(@"evc view will appear");
}

-(void)viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    NSLog(@"evc view did appear");
}

-(void)viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
    NSLog(@"evc view will disappear");
}

-(void)viewDidDisappear:(BOOL) animated {
    [super viewDidDisappear:animated];
    NSLog(@"evc view did disappear");
}

@end
