

#import "RootViewController.h"
#import "Pep.h"
#import "MyPageViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray* pep;
@end

@implementation RootViewController

/*
 We are not a built-in parent view controller type, so the runtime knows nothing about our children.
 So we have to tell it! We do this by encoding a reference to the child view controller.
 */

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"rvc encode");
    [coder encodeObject:self.childViewControllers[0] forKey:@"pvc"];
    [super encodeRestorableStateWithCoder:coder];
}

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"rvc viewdidload");
    
    self.pep = @[@"Manny", @"Moe", @"Jack"];
    
    // make a page view controller
    MyPageViewController* pvc = [[MyPageViewController alloc]
                                 initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                 options:nil];
    
    // give it an initial page
    Pep* page = [[Pep alloc] initWithPepBoy:(self.pep)[0] nib: nil bundle: nil];
    [pvc setViewControllers:@[page]
                  direction:UIPageViewControllerNavigationDirectionForward
                   animated:NO completion:NULL];
    
    // give it a data source
    pvc.dataSource = self;
    
    // add it formally as a child and put its view in our view
    [self addChildViewController:pvc];
    [self.view addSubview:pvc.view];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-0-[pvc]-0-|"
      options:0 metrics:nil views:@{@"pvc":pvc.view}]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-0-[pvc]-0-|"
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
