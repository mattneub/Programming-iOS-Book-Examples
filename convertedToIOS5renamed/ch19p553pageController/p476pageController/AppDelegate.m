

#import "AppDelegate.h"
#import "Pep.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize pep = _pep;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.pep = [NSArray arrayWithObjects: @"Manny", @"Moe", @"Jack", nil];
    
    // make a page view controller
    UIPageViewController* pvc = [[UIPageViewController alloc] 
                                 initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal 
                                 options:nil];
    
    // give it an initial page
    Pep* page = [[Pep alloc] initWithPepBoy:[self.pep objectAtIndex:0] nib: nil bundle: nil];
    [pvc setViewControllers:[NSArray arrayWithObject:page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO completion:NULL];
    
    // give it a data source
    pvc.dataSource = self;
    
    // stick it in the window
    self.window.rootViewController = pvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

// data source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSString* boy = [(Pep*)viewController boy];
    NSUInteger ix = [self.pep indexOfObject:boy];
    ix++;
    if (ix >= [self.pep count])
        return nil;
    return [[Pep alloc] initWithPepBoy:[self.pep objectAtIndex:ix] nib: nil bundle: nil];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSString* boy = [(Pep*)viewController boy];
    NSUInteger ix = [self.pep indexOfObject:boy];
    if (ix == 0)
        return nil;
    return [[Pep alloc] initWithPepBoy:[self.pep objectAtIndex:--ix] nib: nil bundle: nil];
}



@end
