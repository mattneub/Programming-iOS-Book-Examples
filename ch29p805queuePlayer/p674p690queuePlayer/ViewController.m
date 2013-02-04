

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) MPMediaItemCollection* q;
@property (nonatomic, strong) AVQueuePlayer* qp;
@property (nonatomic, strong) NSMutableArray* assets;
@property (nonatomic, weak) IBOutlet UIProgressView *p;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet MPVolumeView *vv;

@end

@implementation ViewController {
    int _curnum;
    int _total;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // nice opportunity to add a volume view controller, MPVolumeView (added in nib)
    // in iOS 6 this has a customizable appearance
    // (alternatively, can show volume alert with MPVolumeSettingsAlertShow
    // but it isn't customizable)
    // larger, solid colored track parts; larger thumb based on original thumb
    // NB MPVolumeView works only on device!
    CGSize sz = CGSizeMake(20,20);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.height,sz.height), NO, 0);
    [[UIColor blackColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,sz.height,sz.height)] fill];
    UIImage* im1 = UIGraphicsGetImageFromCurrentImageContext();
    [[UIColor redColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,sz.height,sz.height)] fill];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.vv setMinimumVolumeSliderImage:[im1 resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,9,9) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.vv setMaximumVolumeSliderImage:[im2 resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,9,9) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.vv setMinimumVolumeSliderImage:[im2 resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,9,9) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
    [self.vv setMaximumVolumeSliderImage:[im1 resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,9,9) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
    
    UIImage* thumb = [self.vv volumeThumbImageForState:UIControlStateNormal];
    sz = thumb.size;
    sz.width +=10; sz.height += 10;
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [thumb drawInRect:CGRectMake(0,0,sz.width,sz.height)];
    UIImage* im3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.vv setVolumeThumbImage:im3 forState:UIControlStateNormal];

    sz.width +=10; sz.height += 10;
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [thumb drawInRect:CGRectMake(0,0,sz.width,sz.height)];
    UIImage* im4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.vv setVolumeThumbImage:im4 forState:UIControlStateHighlighted];

}

- (IBAction)doPlayAllShortSongs:(id)sender {
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
    self.assets = [NSMutableArray array];
    for (MPMediaItem* item in marr) {
        AVPlayerItem* pi = [[AVPlayerItem alloc] initWithURL:
                            [item valueForProperty:MPMediaItemPropertyAssetURL]];
        [self.assets addObject:pi];
    }
    
    self->_curnum = 0;
    self->_total = [self.assets count];
    
    self.qp = [AVQueuePlayer queuePlayerWithItems:[self.assets objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)]]];
    [self.assets removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)]];
               
                                                   
    [self.qp addObserver:self forKeyPath:@"currentItem" options:0 context:nil];
    [self.qp play];
    [self changed];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    

    // added a progress view as on p. 674 
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [self.timer fire];
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
            self.label.text = [NSString stringWithFormat:@"%i of %i: %@",
                                ++self->_curnum, self->_total, [met valueForKey:@"value"]];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{MPMediaItemPropertyTitle: [met valueForKey:@"value"]}];
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
    if (self.qp.rate < 0.01)
        self.p.hidden = YES;
    else {
        self.p.hidden = NO;
        AVPlayerItem* item = self.qp.currentItem;
        CMTime cur = self.qp.currentTime;
        CMTime dur = item.duration;
        self.p.progress = CMTimeGetSeconds(cur)/CMTimeGetSeconds(dur);
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentItem"])
        [self changed];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    UIEventSubtype rc = event.subtype;
    NSLog(@"hey, I got a remote event! %i", rc);
    if (rc == UIEventSubtypeRemoteControlPlay)
        [self.qp play];
    else if (rc == UIEventSubtypeRemoteControlStop)
        [self.qp pause];
    else if (rc == UIEventSubtypeRemoteControlTogglePlayPause) { // likeliest
        if (self.qp.rate > 0.1)
            [self.qp pause];
        else
            [self.qp play];
    }
}


@end
