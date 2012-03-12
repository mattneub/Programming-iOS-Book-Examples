
#import "p046nilTestingAppDelegate.h"

@implementation NilTestingAppDelegate

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    /* Showing the dance you do with nil-testing in an error situation */
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"textfile" ofType:@"txt"];
    NSStringEncoding enc = NSUTF8StringEncoding; // this is a lie, so an error will result later 
    NSError* err = nil; 
    // attempt to load a text file while specifying the wrong encoding
    NSString* s = [NSString stringWithContentsOfFile:path encoding:enc error:&err];
    // at this point, s is nil as a signal that things went wrong, and err is a meaningful NSError
    if (nil == s) // could also say if (!s)
    {
        NSLog(@"We got an error, as expected; it says:\n\"%@\"", [err localizedDescription]);
    }
    else
    {
        NSLog(@"everything went just fine; the text file says:\n%@", s); 
        // change NSUTF8StringEncoding to NSUTF16StringEncoding to get this message!
    }
    
    
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
