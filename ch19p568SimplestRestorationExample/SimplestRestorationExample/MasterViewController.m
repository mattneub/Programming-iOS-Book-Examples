

#import "MasterViewController.h"

@interface MasterViewController () //  <UIViewControllerRestoration>

@end

@implementation MasterViewController


- (IBAction) unwind: (UIStoryboardSegue*) seg {
    
}

/*
 
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)ic
                                                            coder:(NSCoder *)coder {
    NSLog(@"%@ %@", self, ic);
    UIStoryboard* sb = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    return [sb instantiateViewControllerWithIdentifier:[ic lastObject]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.restorationClass = [self class];
    return self;
}
 
 */

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"mvc encode");
    [super encodeRestorableStateWithCoder:coder];
}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"mvc decode");
    [super decodeRestorableStateWithCoder:coder];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    NSLog(@"mvc view did load");
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
