

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminateNotif:) name:UIApplicationWillTerminateNotification object:nil];
    return YES;
}

// someone claimed that we get the notification even if we don't get the event
// I see no evidence of this

- (void) terminateNotif: (id) notif {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSFileManager* fm = [NSFileManager new];
        NSError* err = nil;
        NSURL* docsurl =
        [fm URLForDirectory:NSDocumentDirectory
                   inDomain:NSUserDomainMask appropriateForURL:nil
                     create:YES error:&err];
        if (docsurl) {
            NSURL* url = [docsurl URLByAppendingPathComponent:@"resign.txt"];
            NSString* path = [url path];
            [@"resign" writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
        }
    });

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    __block UIBackgroundTaskIdentifier bti = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bti];
    }];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

        NSFileManager* fm = [NSFileManager new];
        NSError* err = nil;
        NSURL* docsurl =
        [fm URLForDirectory:NSDocumentDirectory
                   inDomain:NSUserDomainMask appropriateForURL:nil
                     create:YES error:&err];
        if (docsurl) {
            NSURL* url = [docsurl URLByAppendingPathComponent:@"background.txt"];
            NSString* path = [url path];
            [@"background" writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
        }
        
        [[UIApplication sharedApplication] endBackgroundTask:bti];
    });

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    __block UIBackgroundTaskIdentifier bti = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bti];
    }];
    
    // absolutely crucial _not_ to get on a background queue here
    // if you do, the code won't run; we'll die first
    //dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
    NSFileManager* fm = [NSFileManager new];
    NSError* err = nil;
    NSURL* docsurl =
    [fm URLForDirectory:NSDocumentDirectory
               inDomain:NSUserDomainMask appropriateForURL:nil
                 create:YES error:&err];
    if (docsurl) {
        NSURL* url = [docsurl URLByAppendingPathComponent:@"terminate.txt"];
        NSString* path = [url path];
        [@"background" writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    
    [[UIApplication sharedApplication] endBackgroundTask:bti];
    
    //});

}


@end
