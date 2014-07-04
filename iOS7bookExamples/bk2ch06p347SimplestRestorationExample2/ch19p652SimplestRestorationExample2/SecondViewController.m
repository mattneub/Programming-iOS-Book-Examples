

#import "SecondViewController.h"
#import "PresentedViewController.h"

@interface SecondViewController () <UIViewControllerRestoration>

@end

@implementation SecondViewController

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
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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

+ (UIViewController*) viewControllerWithRestorationIdentifierPath:(NSArray*)ip
                                                            coder:(NSCoder*)coder {
    NSLog(@"vcwithrip %@ %@ %@", self, ip, coder);
    UIViewController* vc = nil;
    if ([[ip lastObject] isEqualToString:@"presented"]) {
        vc = [self makePresentedViewController];
    }
    return vc;
}

-(void)doPresent:(id)sender {
    UIViewController* pvc = [[self class] makePresentedViewController];
    [self presentViewController:pvc animated:YES completion:nil];
}



@end
