

#import "AppDelegate.h"
@import MediaPlayer;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMediaLibraryDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"library changed!");
        NSLog(@"library last modified %@", [[MPMediaLibrary defaultMediaLibrary] lastModifiedDate]);
    }];
    [[MPMediaLibrary defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
    NSLog(@"library last modified %@", [[MPMediaLibrary defaultMediaLibrary] lastModifiedDate]);

    
    return YES;
}



@end
