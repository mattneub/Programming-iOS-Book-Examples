

#import "AppDelegate.h"
#import "Pep.h"

@interface AppDelegate () <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSArray* pep;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.pep = @[@"Manny", @"Moe", @"Jack"];
    
    // make a page view controller
    UIPageViewController* pvc = [[UIPageViewController alloc] 
                                 initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal 
                                 options:nil];
    
    // give it an initial page
    Pep* page = [[Pep alloc] initWithPepBoy:self.pep[0] nib: nil bundle: nil];
    [pvc setViewControllers:@[page]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO completion:nil];
    
    // give it a data source
    pvc.dataSource = self;
    
    // stick it in the window
    self.window.rootViewController = pvc;
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    for (UIGestureRecognizer* g in pvc.gestureRecognizers)
        if ([g isKindOfClass: [UITapGestureRecognizer class]])
            ((UITapGestureRecognizer*)g).numberOfTapsRequired = 2;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"tap" object:nil queue:nil usingBlock:^(NSNotification *note) {
        UIGestureRecognizer* g = note.object;
        int which = g.view.tag;
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
    
    return YES;
}

// data source

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

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pvc {
    return [self.pep count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pvc {
    Pep* page = [pvc viewControllers][0];
    NSString* boy = page.boy;
    return [self.pep indexOfObject:boy];
}

@end
