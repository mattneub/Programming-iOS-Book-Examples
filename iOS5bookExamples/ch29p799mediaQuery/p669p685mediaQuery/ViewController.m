

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic, retain) MPMediaItemCollection* q;
@end

@implementation ViewController {
    IBOutlet __weak UIProgressView *p;
    IBOutlet __weak UILabel *label;
}

@synthesize timer, q;


- (IBAction)doAllAlbumTitles:(id)sender {
    MPMediaQuery* query = [MPMediaQuery albumsQuery];
    NSArray* result = [query collections];
    // prove we've performed the query, by logging the album titles
    for (MPMediaItemCollection* album in result)
        NSLog(@"%@", [[album representativeItem] 
                      valueForProperty:MPMediaItemPropertyAlbumTitle]);
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
        self.q = queue;
    }
}

- (void) changed: (NSNotification*) n {
    MPMusicPlayerController* player = 
    [MPMusicPlayerController applicationMusicPlayer];
    if ([n object] == player) { // just playing safe
        NSString* title = 
        [player.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        NSUInteger ix = player.indexOfNowPlayingItem; // new in iOS 5
        [self->label setText: [NSString stringWithFormat:@"%i of %i: %@",
                               ix+1, [self.q count], title]];
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
