

#import "DetailViewController.h"
#import "ExtraViewController.h"

@interface DetailViewController () <UIViewControllerRestoration>

@end

@implementation DetailViewController

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"dvc encode");
    [super encodeRestorableStateWithCoder:coder];

}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"dvc decode");
    [super decodeRestorableStateWithCoder:coder];

}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Detail";
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"dvc viewdidload");
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Extra" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doPresent:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = self.view.center;
    [self.view addSubview:button];
}

+(ExtraViewController*) newExtraViewController {
    ExtraViewController* evc = [ExtraViewController new];
    evc.restorationIdentifier = @"extra";
    evc.restorationClass = [self class];
    return evc;
}

-(void)doPresent:(id)sender {
    [self presentViewController:[[self class] newExtraViewController] animated:YES completion:nil];
}

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)ic
                                                             coder:(NSCoder *)coder {
    NSLog(@"%@", ic);
    if ([[ic lastObject] isEqualToString:@"extra"]) {
        return [self newExtraViewController];
    }
    return nil;
}



-(void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    NSLog(@"dvc view will appear");
}

-(void)viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    NSLog(@"dvc view did appear");
}

-(void)viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
    NSLog(@"dvc view will disappear");
}

-(void)viewDidDisappear:(BOOL) animated {
    [super viewDidDisappear:animated];
    NSLog(@"dvc view did disappear");
}

@end
