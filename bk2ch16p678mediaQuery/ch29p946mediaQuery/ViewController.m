

#import "ViewController.h"
@import MediaPlayer;

@interface ViewController ()
@property (nonatomic, strong) MPMediaItemCollection* q;
@property (nonatomic, weak) IBOutlet UILabel* label;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, weak) IBOutlet UIProgressView* prog;
@property (nonatomic, weak) IBOutlet MPVolumeView* vv;
@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    CGSize sz = CGSizeMake(20,20);
    UIGraphicsBeginImageContextWithOptions(
                                           CGSizeMake(sz.height,sz.height), NO, 0);
    [[UIColor blackColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:
      CGRectMake(0,0,sz.height,sz.height)] fill];
    UIImage* im1 = UIGraphicsGetImageFromCurrentImageContext();
    [[UIColor redColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:
      CGRectMake(0,0,sz.height,sz.height)] fill];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    [[UIColor orangeColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:
      CGRectMake(0,0,sz.height,sz.height)] fill];
    UIImage* im3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self.vv setMinimumVolumeSliderImage:
     [im1 resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,9,9)
                         resizingMode:UIImageResizingModeStretch]
                                forState:UIControlStateNormal];
    [self.vv setMaximumVolumeSliderImage:
     [im2 resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,9,9)
                         resizingMode:UIImageResizingModeStretch]
                                forState:UIControlStateNormal];
    [self.vv setVolumeWarningSliderImage:
     [im3 resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,9,9)
                         resizingMode:UIImageResizingModeStretch]];
    
    UIImage* thumb = [UIImage imageNamed:@"SmileyRound.png"];
    sz = CGSizeMake(40,40);
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [thumb drawInRect:CGRectMake(0,0,sz.width,sz.height)];
    thumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.vv setVolumeThumbImage:thumb forState:UIControlStateNormal];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wirelessChanged:) name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wirelessChanged2:) name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];

}

- (void) wirelessChanged: (NSNotification*) n {
    NSLog(@"wireless change %@", n.userInfo);
}

- (void) wirelessChanged2: (NSNotification*) n {
    NSLog(@"wireless active changed %@", n.userInfo);
}



- (IBAction)doAllAlbumTitles:(id)sender {
    MPMediaQuery* query = [MPMediaQuery albumsQuery];
    NSArray* result = [query collections];
    // prove we've performed the query, by logging the album titles
    for (MPMediaItemCollection* album in result)
        NSLog(@"%@", [album.representativeItem
                      valueForProperty:MPMediaItemPropertyAlbumTitle]);
    return; // testing
    for (MPMediaItemCollection* album in result)
        for (MPMediaItem* song in album.items) {
        
            NSLog(@"%@ %@ %@", [song
                             valueForProperty:MPMediaItemPropertyIsCloudItem], [song valueForProperty:MPMediaItemPropertyAssetURL], [song valueForProperty:MPMediaItemPropertyTitle]);
        }
    
}

- (IBAction)doBeethovenAlbumTitles:(id) sender {
    MPMediaQuery* query = [MPMediaQuery albumsQuery];
    MPMediaPropertyPredicate* hasBeethoven =
    [MPMediaPropertyPredicate predicateWithValue:@"Beethoven"
                                     forProperty:MPMediaItemPropertyAlbumTitle
                                  comparisonType:MPMediaPredicateComparisonContains];
    [query addFilterPredicate:hasBeethoven];
    NSArray* result = [query collections];
    for (MPMediaItemCollection* album in result)
        NSLog(@"%@", [album.representativeItem
                      valueForProperty:MPMediaItemPropertyAlbumTitle]);
}

- (IBAction) doSonataAlbumsOnDevice {
    MPMediaQuery* query = [MPMediaQuery albumsQuery];
    MPMediaPropertyPredicate* hasSonata =
    [MPMediaPropertyPredicate predicateWithValue:@"Sonata"
                                     forProperty:MPMediaItemPropertyTitle
                                  comparisonType:MPMediaPredicateComparisonContains];
    [query addFilterPredicate:hasSonata];
    
    MPMediaPropertyPredicate* isPresent =
    [MPMediaPropertyPredicate predicateWithValue:@NO
                                     forProperty:MPMediaItemPropertyIsCloudItem
                                  comparisonType:MPMediaPredicateComparisonEqualTo];
    [query addFilterPredicate:isPresent];
    
    NSArray* result = [query collections];
    for (MPMediaItemCollection* album in result)
        NSLog(@"%@", [album.representativeItem
                      valueForProperty:MPMediaItemPropertyAlbumTitle]);
    // and here are the songs in the first of those albums
    MPMediaItemCollection* album = result[0];
    for (MPMediaItem* song in album.items)
        NSLog(@"%@", [song valueForProperty:MPMediaItemPropertyTitle]);

}

- (IBAction) doPlayShortSongs: (id) sender {
    MPMediaQuery* query = [MPMediaQuery songsQuery];
    // always need to filter out songs that aren't present
    MPMediaPropertyPredicate* isPresent =
    [MPMediaPropertyPredicate predicateWithValue:@NO
                                     forProperty:MPMediaItemPropertyIsCloudItem
                                  comparisonType:MPMediaPredicateComparisonEqualTo];
    [query addFilterPredicate:isPresent];

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
        NSLog(@"got %lu short songs", (unsigned long)marr.count);
        MPMusicPlayerController* player =
        [MPMusicPlayerController applicationMusicPlayer];
        [player setQueueWithItemCollection:queue];
        player.shuffleMode = MPMusicShuffleModeSongs;
        
        [player beginGeneratingPlaybackNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changed:)
                                                     name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                   object:player];
        self.q = queue; // retain a pointer to the queue
        
        [player play];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        self.timer.tolerance = 0.1;
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
        NSUInteger ix = player.indexOfNowPlayingItem;
        if (NSNotFound == ix)
            self.label.text = @"";
        else
            self.label.text = [NSString stringWithFormat:@"%lu of %lu: %@",
                               (unsigned long)ix+1, (unsigned long)[self.q count], title];
    }
    
    // fire the timer now, looks better
    [self.timer fire];
}

- (void) timerFired: (id) dummy {
    MPMusicPlayerController* mp = [MPMusicPlayerController applicationMusicPlayer];
    MPMediaItem* item = mp.nowPlayingItem;
    if (!item || mp.playbackState == MPMusicPlaybackStateStopped) {
        self.prog.hidden = YES;
        return;
    }
    self.prog.hidden = NO;
    NSTimeInterval current = mp.currentPlaybackTime;
    NSTimeInterval total =
    [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    self.prog.progress = current / total;
}




@end
