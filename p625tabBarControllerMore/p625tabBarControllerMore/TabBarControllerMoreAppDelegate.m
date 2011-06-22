

#import "TabBarControllerMoreAppDelegate.h"
#import "MyDataSource.h"

@implementation TabBarControllerMoreAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

@synthesize myDataSource;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    
    
    // comment out what follows to see what difference this customization makes
    UINavigationController* more = self.tabBarController.moreNavigationController;
    UIViewController* list = [more.viewControllers objectAtIndex:0];
    list.title = @"";
    UIBarButtonItem* b = [[UIBarButtonItem alloc] init];
    b.title = @"Back";
    list.navigationItem.backBarButtonItem = b; // so user can navigate back
    [b release];
    more.navigationBar.barStyle = UIBarStyleBlack;
    UITableView* tv = (UITableView*)list.view;
    MyDataSource* mds = [[MyDataSource alloc] init];
    self.myDataSource = mds; // retain policy
    [mds release];
    self.myDataSource.originalDataSource = tv.dataSource;
    tv.dataSource = self.myDataSource;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [myDataSource release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
