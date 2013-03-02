

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ExtraViewController.h"

@interface MasterViewController ()

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


-(void)doPresent:(id)sender {
    [self presentViewController:[ExtraViewController new] animated:YES completion:nil];
}

-(void)doDetail:(id)sender {
    [self.navigationController
     pushViewController:[DetailViewController new] animated:YES];
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
