

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) MPMediaItemCollection* q;
@property (nonatomic, weak) IBOutlet UIProgressView *p;
@property (nonatomic, weak) IBOutlet UILabel *label;
@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMediaLibraryDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"library changed!");
    }];
    [[MPMediaLibrary defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
    NSLog(@"library last modified %@", [[MPMediaLibrary defaultMediaLibrary] lastModifiedDate]);
}

- (IBAction)doAllAlbumTitles:(id)sender {
    MPMediaQuery* query = [MPMediaQuery albumsQuery];
    NSArray* result = [query collections];
    // prove we've performed the query, by logging the album titles
    // unfortunately, on my machine, calling representativeItem causes nasty log messages
    // so I've switched to using the first song of the album as representative
    for (MPMediaItemCollection* album in result)
        NSLog(@"%@", [album.items[0]
                      valueForProperty:MPMediaItemPropertyAlbumTitle]);
//    for (MPMediaItemCollection* album in result)
//        for (MPMediaItem* song in album.items)
//            NSLog(@"%@ %@", [song
//                          valueForProperty:MPMediaItemPropertyIsCloudItem], [song valueForProperty:MPMediaItemPropertyTitle]);

}

- (IBAction)doAllSonataAlbumTitles:(id)sender {
    MPMediaQuery* query = [MPMediaQuery albumsQuery];
    MPMediaPropertyPredicate* hasSonata = 
    [MPMediaPropertyPredicate predicateWithValue:@"Sonata" 
                                     forProperty:MPMediaItemPropertyAlbumTitle 
                                  comparisonType:MPMediaPredicateComparisonContains];
    [query addFilterPredicate:hasSonata];
    NSArray* result = [query collections];
    for (MPMediaItemCollection* album in result) 
        NSLog(@"%@", [album.items[0]
                      valueForProperty:MPMediaItemPropertyAlbumTitle]);
    // titles of songs in first album
    result = [query collections];
    MPMediaItemCollection* album = result[0];
    for (MPMediaItem* song in album.items)
        NSLog(@"%@", [song valueForProperty:MPMediaItemPropertyTitle]);
    
}

- (IBAction)doPlayAllShortSongs:(id)sender {
    MPMediaQuery* query = [MPMediaQuery songsQuery];
    NSMutableArray* marr = [NSMutableArray array];
    MPMediaItemCollection* queue = nil;
    for (MPMediaItem* song in query.items) {
        NSNumber* dur =
        [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
        if ([dur floatValue] < 30)
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
        self.q = queue;
    }
}

- (void) changed: (NSNotification*) n {
    // NSLog(@"%@", @"changed");
    MPMusicPlayerController* player = 
    [MPMusicPlayerController applicationMusicPlayer];
    if ([n object] == player) { // just playing safe
        NSString* title = 
        [player.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        NSUInteger ix = player.indexOfNowPlayingItem; // new in iOS 5
        [self.label setText: [NSString stringWithFormat:@"%i of %i: %@",
                               ix+1, [self.q count], title]];
    }
    
    // since I've added the progress view, may as well fire the timer now, looks better
    [self.timer fire];
}

- (void) timerFired: (id) dummy {
    MPMusicPlayerController* mp = [MPMusicPlayerController applicationMusicPlayer];
    MPMediaItem* item = mp.nowPlayingItem;
    if (!item || mp.playbackState == MPMusicPlaybackStateStopped) {
        self.p.hidden = YES;
        return;
    }
    self.p.hidden = NO;
    NSTimeInterval current = mp.currentPlaybackTime;
    NSTimeInterval total =
    [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    self.p.progress = current / total;
}


@end
