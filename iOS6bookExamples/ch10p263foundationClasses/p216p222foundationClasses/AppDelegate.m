

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    NSString* f = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"txt"];
    NSError* err = nil;
    NSString* s = [NSString stringWithContentsOfFile:f 
                                            encoding:NSUTF8StringEncoding 
                                               error:&err];
    // error-checking omitted
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    for (NSString* line in [s componentsSeparatedByString:@"\n"]) {
        NSArray* items = [line componentsSeparatedByString:@"\t"];
        // ooh ooh ooh this is my chance to use the snazzy new notation
        NSInteger chnum = [items[0] integerValue]; //
        NSNumber* key = @(chnum); //
        NSMutableArray* marr = d[key]; //
        if (!marr) { // no such key, create key–value pair
            marr = [NSMutableArray array];
            d[key] = marr; //
        }
        // marr is now a mutable array, empty or otherwise
        NSString* picname = items[1]; //
        [marr addObject: picname];
    }
    NSLog(@"%@", d); // look at the log to see how we've parsed the text file into a dictionary

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
