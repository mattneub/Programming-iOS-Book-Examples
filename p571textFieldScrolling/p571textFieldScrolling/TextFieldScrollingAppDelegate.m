

#import "TextFieldScrollingAppDelegate.h"

#import "RootViewController.h"

@implementation TextFieldScrollingAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

@synthesize states;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // p 575
    UIMenuItem *mi = [[UIMenuItem alloc] initWithTitle:@"Expand" 
                                                action:@selector(expand:)];
    UIMenuController *mc = [UIMenuController sharedMenuController];
    mc.menuItems = [NSArray arrayWithObject:mi];
    [mi release];
    
    NSString* s = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray* arr = [s componentsSeparatedByString:@"\n"];
    NSMutableDictionary* md = [NSMutableDictionary dictionary];
    for (NSString* line in arr) {
        NSArray* both = [line componentsSeparatedByString:@"\t"];
        [md setObject:[both objectAtIndex:0] forKey:[both objectAtIndex:1]];
    }
    self.states = [[md copy] autorelease];
    NSLog(@"%@", self.states);
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [states release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
