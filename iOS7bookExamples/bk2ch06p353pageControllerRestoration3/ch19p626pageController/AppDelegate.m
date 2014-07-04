

#import "AppDelegate.h"
#import "Pep.h"

@interface AppDelegate () <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSArray* pep;
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self setUpPageViewController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES; // *
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES; // *
}

- (void) setUpPageViewController {
    self.pep = @[@"Manny", @"Moe", @"Jack"];
    
    // make a page view controller
    UIPageViewController* pvc = [[UIPageViewController alloc]
                                 initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                 options:nil];
    pvc.restorationIdentifier = @"pvc";
    
    // give it an initial page
    Pep* page = [[Pep alloc] initWithPepBoy:self.pep[0] nib: nil bundle: nil];
    [pvc setViewControllers:@[page]
                  direction:UIPageViewControllerNavigationDirectionForward
                   animated:NO completion:nil];
    
    // give it a data source
    pvc.dataSource = self;
    
    // stick it in the window
    self.window.rootViewController = pvc;
    
    UIPageControl* proxy = [UIPageControl appearanceWhenContainedIn:[UIPageViewController class], nil];
    [proxy setPageIndicatorTintColor:[[UIColor redColor] colorWithAlphaComponent:0.6]];
    [proxy setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [proxy setBackgroundColor:[UIColor yellowColor]];
    
    // [self messWithGestureRecognizers:pvc]; // uncomment to try it

}

// all restorable view controllers already exist...
// ...so just point to them

-(UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)ip coder:(NSCoder *)coder {
    if ([ip.lastObject isEqualToString:@"pvc"])
        return self.window.rootViewController;
    if ([ip.lastObject isEqualToString:@"pep"])
        return [(UIPageViewController*)self.window.rootViewController viewControllers][0];
    return nil;
}

// encode current pep boy...
// ...not in order to retrieve it later, but in order to make "pvc/pep" a path

-(void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder {
    UIPageViewController* pvc = (UIPageViewController*)self.window.rootViewController;
    Pep* pep = (Pep*)pvc.viewControllers[0];
    [coder encodeObject:pep forKey:@"pep"];
}

// no decode!

// required data source methods

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSLog(@"after %@", viewController);
    NSString* boy = [(Pep*)viewController boy];
    NSUInteger ix = [self.pep indexOfObject:boy];
    ix++;
    if (ix >= [self.pep count])
        return nil;
    return [[Pep alloc] initWithPepBoy:(self.pep)[ix] nib: nil bundle: nil];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSLog(@"before %@", viewController);
    NSString* boy = [(Pep*)viewController boy];
    NSUInteger ix = [self.pep indexOfObject:boy];
    if (ix == 0)
        return nil;
    return [[Pep alloc] initWithPepBoy:(self.pep)[--ix] nib: nil bundle: nil];
}

#define WHICH 1
#if WHICH == 1

// optional, for use with a page indicator
// if implemented, the page indicator appears

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pvc {
    return [self.pep count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pvc {
    Pep* page = [pvc viewControllers][0];
    NSString* boy = page.boy;
    return [self.pep indexOfObject:boy];
}

#endif

- (void) messWithGestureRecognizers: (UIPageViewController*) pvc {
    for (UIGestureRecognizer* g in pvc.gestureRecognizers)
        if ([g isKindOfClass: [UITapGestureRecognizer class]])
            ((UITapGestureRecognizer*)g).numberOfTapsRequired = 2;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"tap"
                                                      object:nil queue:nil
                                                  usingBlock:^(NSNotification *n) {
        UIGestureRecognizer* g = n.object;
        NSInteger which = g.view.tag;
        UIViewController* vc =
        which == 0 ?
        [self pageViewController:pvc viewControllerBeforeViewController:pvc.viewControllers[0]] :
        [self pageViewController:pvc viewControllerAfterViewController:pvc.viewControllers[0]];
        if (!vc) return;
        UIPageViewControllerNavigationDirection dir =
        which == 0 ?
        UIPageViewControllerNavigationDirectionReverse :
        UIPageViewControllerNavigationDirectionForward;
        [pvc setViewControllers:@[vc] direction:dir animated:YES completion:nil];
    }];
}


@end
