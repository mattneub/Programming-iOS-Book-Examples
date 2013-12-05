

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString* f = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"txt"];
    NSError* err = nil;
    NSString* s = [NSString stringWithContentsOfFile:f
                                            encoding:NSUTF8StringEncoding
                                               error:&err];
    // error-checking omitted
    NSMutableDictionary* d = [NSMutableDictionary new];
    for (NSString* line in [s componentsSeparatedByString:@"\n"]) {
        NSArray* items = [line componentsSeparatedByString:@"\t"];
        NSInteger chnum = [items[0] integerValue];
        NSNumber* key = @(chnum);
        NSMutableArray* marr = d[key];
        if (!marr) { // no such key, create key–value pair
            marr = [NSMutableArray new];
            d[key] = marr;
        }
        // marr is now a mutable array, empty or otherwise
        NSString* picname = items[1];
        [marr addObject: picname];
    }
    NSLog(@"%@", d);
    
    return YES;
}


@end
