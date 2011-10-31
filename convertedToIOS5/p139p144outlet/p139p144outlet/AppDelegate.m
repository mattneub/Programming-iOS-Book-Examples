

#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // Override point for customization after application launch.
    
    // MyClass exists solely as an owner so we can load the nib (MyNib.xib)
    // using an outlet, we grab the label instantiated by the nib as it loads...
    // ...and stuff it into the visible interface
    MyClass* mc = [[MyClass alloc] init]; 
    [[NSBundle mainBundle] loadNibNamed:@"MyNib" owner:mc options:nil]; 
    UILabel* lab = [mc valueForKey: @"theLabel"]; 
    [self.window addSubview: lab]; 
    lab.center = CGPointMake(100,100);
    lab.frame = CGRectIntegral(lab.frame); // added to prevent fuzzies
    
    // Now, you could argue that MyClass isn't really needed:
    // we could just as well have used AppDelegate itself (self) as MyNib's owner
    // That's perfectly true, and in rewriting the book discussion I might change this...
    // ...but I also might keep it this way, because it illustrates the truly general case:
    // Any instance can act as a file's owner, and it's perfectly reasonable...
    // ...to devise a class specifically as a source of such instances

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
