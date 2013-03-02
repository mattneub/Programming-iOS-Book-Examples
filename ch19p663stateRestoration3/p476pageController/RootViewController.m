

#import "RootViewController.h"
#import "Pep.h"

@interface RootViewController () <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSArray* pep;
@end

@implementation RootViewController

/*
 We are not a built-in parent view controller type, so the runtime knows nothing about our children.
 It won't automatically follow the chain down to the self-restoring Pep object.
 So we have to tell it about the next object in the chain!
 We do this by encoding a reference to that object.
 */

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"rvc encode");
    UIPageViewController* pvc = self.childViewControllers[0];
    Pep* pep = pvc.viewControllers[0];
    [coder encodeObject:pep forKey:@"pep"];
    [super encodeRestorableStateWithCoder:coder];
}

/*
 In this case, however, we do not decode it. We *could*, but in fact we don't need it.
 The Pep object will restore its own state. We only encoded this reference in order to
 get the runtime to walk the chain down to the Pep instance and do save-and-restore on it.
 */
 

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"rvc decode");
    [super decodeRestorableStateWithCoder:coder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"rvc init");
        self.restorationIdentifier = @"root"; // provide an identifier
        // but no need for a restoration class
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"rvc viewdidload");
    
    self.pep = @[@"Manny", @"Moe", @"Jack"];
    
    // make a page view controller
    UIPageViewController* pvc = [[UIPageViewController alloc]
                                 initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                 options:nil];
    // pvc.restorationIdentifier = @"pvc"; // no need
    
    // give it an initial page
    Pep* page = [[Pep alloc] initWithPepBoy:(self.pep)[0] nib: nil bundle: nil];
    [pvc setViewControllers:@[page]
                  direction:UIPageViewControllerNavigationDirectionForward
                   animated:NO completion:nil];
    
    // give it a data source
    pvc.dataSource = self;
    
    // add it formally as a child and put its view in our view
    [self addChildViewController:pvc];
    [self.view addSubview:pvc.view];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|[pvc]|"
      options:0 metrics:nil views:@{@"pvc":pvc.view}]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[pvc]|"
      options:0 metrics:nil views:@{@"pvc":pvc.view}]];
    [pvc didMoveToParentViewController:self];
}

// data source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSString* boy = [(Pep*)viewController boy];
    NSUInteger ix = [self.pep indexOfObject:boy];
    ix++;
    if (ix >= [self.pep count])
        return nil;
    return [[Pep alloc] initWithPepBoy:(self.pep)[ix] nib: nil bundle: nil];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSString* boy = [(Pep*)viewController boy];
    NSUInteger ix = [self.pep indexOfObject:boy];
    if (ix == 0)
        return nil;
    return [[Pep alloc] initWithPepBoy:(self.pep)[--ix] nib: nil bundle: nil];
}

@end
