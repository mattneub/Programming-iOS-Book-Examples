
#import "ViewController.h"
#import "Pep.h"

@implementation ViewController
@synthesize pvc = _pvc, pep = _pep;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pep = [NSArray arrayWithObjects: @"Manny", @"Moe", @"Jack", nil];
    
    // make a page view controller
    self.pvc = [[UIPageViewController alloc] 
                initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal 
                options:nil];
    
    // give it an initial page
    Pep* page = [[Pep alloc] initWithPepBoy:[self.pep objectAtIndex:0]];
    [self.pvc setViewControllers:[NSArray arrayWithObject:page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO completion:NULL];
    
    // give it a data source
    self.pvc.dataSource = self;

    // stick it in the hierarchy; notice that this move depends on custom container view controllers
    [self addChildViewController:self.pvc];
    [self.view addSubview:self.pvc.view];
    self.pvc.view.frame = self.view.bounds;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

// data source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSString* boy = [(Pep*)viewController boy];
    NSUInteger ix = [self.pep indexOfObject:boy];
    ix++;
    if (ix >= [self.pep count])
        return nil;
    return [[Pep alloc] initWithPepBoy:[self.pep objectAtIndex:ix]];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSString* boy = [(Pep*)viewController boy];
    NSUInteger ix = [self.pep indexOfObject:boy];
    if (ix == 0)
        return nil;
    return [[Pep alloc] initWithPepBoy:[self.pep objectAtIndex:--ix]];
}


@end
