

#import "AppDelegate.h"

#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize states;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // p 575
    UIMenuItem *mi = [[UIMenuItem alloc] initWithTitle:@"Expand" 
                                                action:@selector(expand:)];
    UIMenuController *mc = [UIMenuController sharedMenuController];
    mc.menuItems = [NSArray arrayWithObject:mi];
    
    NSString* s = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray* arr = [s componentsSeparatedByString:@"\n"];
    NSMutableDictionary* md = [NSMutableDictionary dictionary];
    for (NSString* line in arr) {
        NSArray* both = [line componentsSeparatedByString:@"\t"];
        [md setObject:[both objectAtIndex:0] forKey:[both objectAtIndex:1]];
    }
    self.states = [md copy];
    NSLog(@"%@", self.states);

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[RootViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
