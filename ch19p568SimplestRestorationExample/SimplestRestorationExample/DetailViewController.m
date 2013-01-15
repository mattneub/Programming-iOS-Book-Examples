

#import "DetailViewController.h"

@interface DetailViewController () // <UIViewControllerRestoration>

@end

@implementation DetailViewController


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
    NSLog(@"%@", @"dvc encode");
    [super encodeRestorableStateWithCoder:coder];
}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"dvc decode");
    [super decodeRestorableStateWithCoder:coder];

}

-(void) viewDidLoad {
    [super viewDidLoad];
    NSLog(@"dvc view did load");
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
