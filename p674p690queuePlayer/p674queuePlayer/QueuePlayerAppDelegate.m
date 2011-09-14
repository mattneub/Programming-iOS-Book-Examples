

#import "QueuePlayerAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation QueuePlayerAppDelegate
@synthesize qp;

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [qp release];
    [_window release];
    [super dealloc];
}

// run on device
// like previous example but using an AVQueuePlayer
// ignore false warning in console on 4.3

- (IBAction)doPlay:(id)sender {
    MPMediaQuery* query = [MPMediaQuery songsQuery];
    NSMutableArray* marr = [NSMutableArray array];
    for (MPMediaItem* song in query.items) {
        CGFloat dur = 
        [[song valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
        if (dur < 30)
            [marr addObject: song];
    }
    if ([marr count] == 0) {
        NSLog(@"No songs that short!");
        return;
    }
    NSMutableArray* assets = [NSMutableArray array];
    for (MPMediaItem* item in marr) {
        AVPlayerItem* pi = [[AVPlayerItem alloc] initWithURL:
                            [item valueForProperty:MPMediaItemPropertyAssetURL]];
        [assets addObject:pi];
        [pi release];
    }
    self.qp = [AVQueuePlayer queuePlayerWithItems:assets];
    [self.qp play];
}

@end
