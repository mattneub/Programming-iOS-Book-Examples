

#import "ExtraViewController.h"

@interface ExtraViewController () // <UIViewControllerRestoration>

@end

@implementation ExtraViewController

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
    NSLog(@"%@", @"evc encode");
    [super encodeRestorableStateWithCoder:coder];

}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"evc decode");
    [super decodeRestorableStateWithCoder:coder];

}

-(void) viewDidLoad {
    [super viewDidLoad];
    NSLog(@"evc view did load");
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
