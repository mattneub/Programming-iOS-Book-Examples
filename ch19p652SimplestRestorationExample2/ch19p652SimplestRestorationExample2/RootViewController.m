
#import "RootViewController.h"
#import "PresentedViewController.h"
#import "SecondViewController.h"

@interface RootViewController () <UIViewControllerRestoration>

@end

@implementation RootViewController

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    NSLog(@"%@ encode %@", self, coder);
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSLog(@"%@ decode %@", self, coder);
}

-(void)applicationFinishedRestoringState {
    NSLog(@"finished %@", self);
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load %@", self);
    self.view.backgroundColor = [UIColor greenColor];
    UIBarButtonItem* b =
    [[UIBarButtonItem alloc] initWithTitle:@"Push"
                                     style:UIBarButtonItemStylePlain
                                    target:self action:@selector(doPush:)];
    self.navigationItem.rightBarButtonItem = b;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Present" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(doPresent:)
     forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = self.view.center;
    [self.view addSubview:button];
}

+ (UIViewController*) makePresentedViewController {
    PresentedViewController* pvc = [PresentedViewController new];
    pvc.restorationIdentifier = @"presented";
    pvc.restorationClass = [self class];
    return pvc;
}

+ (UIViewController*) makeSecondViewController {
    SecondViewController* svc = [SecondViewController new];
    svc.restorationIdentifier = @"second";
    svc.restorationClass = [self class];
    return svc;
}

+ (UIViewController*) viewControllerWithRestorationIdentifierPath:(NSArray*)ip
                                                            coder:(NSCoder*)coder {
    NSLog(@"vcwithrip %@ %@ %@", self, ip, coder);
    UIViewController* vc = nil;
    if ([[ip lastObject] isEqualToString:@"presented"]) {
        vc = [self makePresentedViewController];
    }
    else if ([[ip lastObject] isEqualToString:@"second"]) {
        vc = [self makeSecondViewController];
    }
    return vc;
}

-(void)doPresent:(id)sender {
    UIViewController* pvc = [[self class] makePresentedViewController];
    [self presentViewController:pvc animated:YES completion:nil];
}

-(void)doPush:(id)sender {
    UIViewController* svc = [[self class] makeSecondViewController];
    [self.navigationController pushViewController:svc animated:YES];
}

@end
