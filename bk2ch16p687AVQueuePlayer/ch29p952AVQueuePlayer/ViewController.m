//
//  ViewController.m
//  ch29p952AVQueuePlayer
//
//  Created by Matt Neuburg on 11/3/13.
//  Copyright (c) 2013 Matt Neuburg. All rights reserved.
//

#import "ViewController.h"
@import MediaPlayer;
@import AVFoundation;
#import "Player.h"

@interface ViewController ()
@property (nonatomic, strong) Player* player;
@property (nonatomic, strong) AVPlayer* avplayer;
@property (nonatomic, strong) MPMoviePlayerController* mpc;
@property (nonatomic, strong) AVQueuePlayer* qp;
@property (nonatomic, strong) NSMutableArray* assets;
@property (nonatomic, weak) IBOutlet UIProgressView *prog;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, strong) NSTimer* timer;


@end

@implementation ViewController {
    int _curnum;
    NSUInteger _total;

}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSURL*) oneSong {
    MPMediaQuery* query = [MPMediaQuery songsQuery];
    MPMediaPropertyPredicate* isPresent =
    [MPMediaPropertyPredicate predicateWithValue:@NO
                                     forProperty:MPMediaItemPropertyIsCloudItem
                                  comparisonType:MPMediaPredicateComparisonEqualTo];
    [query addFilterPredicate:isPresent];
    NSURL* url = [query.items[0] valueForProperty:MPMediaItemPropertyAssetURL];
    return url;
}

- (IBAction) doPlayOneSongAVAudioPlayer: (id) sender {
    NSURL* url = [self oneSong];
    self.player = [Player new];
    [self.player play:url];
}

- (IBAction) doPlayOneSongMPMoviePlayerController: (id) sender {
    NSURL* url = [self oneSong];
    MPMoviePlayerController* mpc = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.mpc = mpc;
    [mpc prepareToPlay];
    mpc.view.frame = CGRectMake(20,20,250,20);
    mpc.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mpc.view];
}

- (IBAction) doPlayOneSongAVPlayer: (id) sender {
    NSURL* url = [self oneSong];
    AVPlayer* avplayer = [[AVPlayer alloc] initWithURL:url];
    self.avplayer = avplayer;
    [avplayer play];
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
    for (MPMediaItem* song in query.items) {
        NSNumber* dur =
        [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
        if ([dur floatValue] < 30)
            [marr addObject: song];
    }
    NSLog(@"got %lu short songs", (unsigned long)marr.count);
    if (!marr.count)
        return;

    
    self.assets = [NSMutableArray array];
    for (MPMediaItem* item in marr) {
        AVPlayerItem* pi = [[AVPlayerItem alloc] initWithURL:
                            [item valueForProperty:MPMediaItemPropertyAssetURL]];
        [self.assets addObject:pi];
    }
    
    self->_curnum = 0;
    self->_total = [self.assets count];
    
    NSUInteger seed = MIN(3,self.assets.count);
    self.qp = [AVQueuePlayer queuePlayerWithItems:[self.assets objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,seed)]]];
    [self.assets removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,seed)]];
    
    [self.qp addObserver:self forKeyPath:@"currentItem" options:0 context:nil];
    [self.qp play];
    [self changed];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    // added a progress view as on p. 674
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    self.timer.tolerance = 0.1;
    [self.timer fire];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentItem"])
        [self changed];
}

- (void) changed {
    
    AVPlayerItem* item = self.qp.currentItem;
    NSArray* arr = item.asset.commonMetadata;
    arr = [AVMetadataItem metadataItemsFromArray:arr
                                         withKey:AVMetadataCommonKeyTitle
                                        keySpace:AVMetadataKeySpaceCommon];
    AVMetadataItem* met = arr[0];
    [met loadValuesAsynchronouslyForKeys:@[@"value"] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = [NSString stringWithFormat:@"%d of %lu: %@",
                               ++self->_curnum, (unsigned long)self->_total, met.value];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{MPMediaItemPropertyTitle: met.value}];
        });
    }];
    if (![self.assets count])
        return;
    AVPlayerItem* newItem = self.assets[0];
    [self.qp insertItem:newItem afterItem:[self.qp.items lastObject]];
    [self.assets removeObjectAtIndex:0];
    
    [self.timer fire];
}

- (void) timerFired: (id) dummy {
    //NSLog(@"%@", self.qp.currentItem);
    if (!self.qp.currentItem) {
        self.prog.hidden = YES;
        [self.timer invalidate];
    } else {
        AVPlayerItem* item = self.qp.currentItem;
        AVAsset* asset = item.asset;
        [asset loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                CMTime cur = self.qp.currentTime;
                CMTime dur = asset.duration;
                self.prog.progress = CMTimeGetSeconds(cur)/CMTimeGetSeconds(dur);
                self.prog.hidden = NO;
            });
        }];
    }
}


- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    UIEventSubtype rc = event.subtype;
    NSLog(@"hey, I got a remote event! %ld", (long)rc);
    if (rc == UIEventSubtypeRemoteControlPlay)
        [self.qp play];
    else if (rc == UIEventSubtypeRemoteControlStop)
        [self.qp pause];
    else if (rc == UIEventSubtypeRemoteControlPause)
        [self.qp pause];
    else if (rc == UIEventSubtypeRemoteControlTogglePlayPause) {
        if (self.qp.rate > 0.1)
            [self.qp pause];
        else
            [self.qp play];
    }
}


@end
