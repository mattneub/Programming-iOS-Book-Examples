

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ExtraViewController.h"

@interface MasterViewController () <UIViewControllerRestoration>

@end

@implementation MasterViewController

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"mvc encode");
    [super encodeRestorableStateWithCoder:coder];

}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"mvc decode");
    [super decodeRestorableStateWithCoder:coder];

}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Master";
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"mvc viewdidload");

    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Detail" style:UIBarButtonItemStylePlain target:self action:@selector(doDetail:)];
    self.navigationItem.rightBarButtonItem = b;
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

+(DetailViewController*) newDetailViewController {
    DetailViewController* dvc = [DetailViewController new];
    dvc.restorationIdentifier = @"detail";
    dvc.restorationClass = [self class];
    return dvc;
}

-(void)doDetail:(id)sender {
    [self.navigationController
     pushViewController:[[self class] newDetailViewController] animated:YES];
}

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)ic
                                                             coder:(NSCoder *)coder {
    NSLog(@"%@", ic);
    if ([[ic lastObject] isEqualToString:@"detail"]) {
        return [self newDetailViewController];
    }
    if ([[ic lastObject] isEqualToString:@"extra"]) {
        return [self newExtraViewController];
    }
    return nil;
}



-(void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    NSLog(@"mvc view will appear");
}

-(void)viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    NSLog(@"mvc view did appear");
}

-(void)viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
    NSLog(@"mvc view will disappear");
}

-(void)viewDidDisappear:(BOOL) animated {
    [super viewDidDisappear:animated];
    NSLog(@"mvc view did disappear");
}

@end
