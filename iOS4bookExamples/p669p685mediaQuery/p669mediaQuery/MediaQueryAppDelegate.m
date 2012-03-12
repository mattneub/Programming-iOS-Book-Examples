

#import "MediaQueryAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation MediaQueryAppDelegate


@synthesize window=_window;
@synthesize timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [label release];
    [p release];
    [timer invalidate];
    [timer release];
    [super dealloc];
}

// must be run on device
// alter the examples as necessary so that you get some results

// note that iOS 4.3 introduced a bug where the console will burp when you do a media query
// CPSqliteStatementPerform: attempt to write a readonly database
// just have to ignore it

- (IBAction)doAllAlbumTitles:(id)sender {
    MPMediaQuery* query = [MPMediaQuery albumsQuery];
    NSArray* result = [query collections];
    // prove we've performed the query, by logging the album titles
    for (MPMediaItemCollection* album in result)
        NSLog(@"%@", [[album representativeItem] 
                      valueForProperty:MPMediaItemPropertyAlbumTitle]);
}

- (IBAction)doAllBachAlbumTitles:(id)sender {
    MPMediaQuery* query = [MPMediaQuery albumsQuery];
    MPMediaPropertyPredicate* hasBach = 
    [MPMediaPropertyPredicate predicateWithValue:@"Bach" 
                                     forProperty:MPMediaItemPropertyAlbumTitle 
                                  comparisonType:MPMediaPredicateComparisonContains];
    [query addFilterPredicate:hasBach];
    NSArray* result = [query collections];
    for (MPMediaItemCollection* album in result) 
        NSLog(@"%@", [[album representativeItem] 
                      valueForProperty:MPMediaItemPropertyAlbumTitle]);
    // titles of songs in first album
    result = [query collections];
    MPMediaItemCollection* album = [result objectAtIndex: 0];
    for (MPMediaItem* song in album.items)
        NSLog(@"%@", [song valueForProperty:MPMediaItemPropertyTitle]);

}

- (IBAction)doPlayAllShortSongs:(id)sender {
    MPMediaQuery* query = [MPMediaQuery songsQuery];
    NSMutableArray* marr = [NSMutableArray array];
    MPMediaItemCollection* queue = nil;
    for (MPMediaItem* song in query.items) {
        CGFloat dur = 
        [[song valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
        if (dur < 30)
            [marr addObject: song];
    }
    if ([marr count] == 0)
        NSLog(@"No songs that short!");
    else
        queue = [MPMediaItemCollection collectionWithItems:marr];
    if (queue) {
        MPMusicPlayerController* player = 
        [MPMusicPlayerController applicationMusicPlayer];
        [player setQueueWithItemCollection:queue];
        player.shuffleMode = MPMusicShuffleModeSongs;
        
        [player beginGeneratingPlaybackNotifications];
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(changed:) 
         name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
         object:player];
        
        [player play];
        
        // added a progress view as on p. 674 
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
}

- (void) changed: (NSNotification*) n {
    MPMusicPlayerController* player = 
    [MPMusicPlayerController applicationMusicPlayer];
    if ([n object] == player) { // just playing safe
        NSString* title = 
        [player.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        [self->label setText: title];
    }
    
    // since I've added the progress view, may as well fire the timer now, looks better
    [self.timer fire];
}

- (void) timerFired: (id) dummy {
    MPMusicPlayerController* mp = [MPMusicPlayerController applicationMusicPlayer];
    if ([mp playbackState] == MPMusicPlaybackStatePlaying || 
        [mp playbackState] == MPMusicPlaybackStatePaused) {
        p.hidden = NO;
        MPMediaItem* item = mp.nowPlayingItem;
        NSTimeInterval current = mp.currentPlaybackTime;
        NSTimeInterval total = 
        [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
        p.progress = current / total;
    } else {
        p.hidden = YES;
    }
}


@end
