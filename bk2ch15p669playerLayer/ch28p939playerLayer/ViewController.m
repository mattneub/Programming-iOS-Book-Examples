

#import "ViewController.h"
@import AVFoundation;

@interface ViewController ()
@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, strong) AVPlayerLayer* playerLayer;
@property (nonatomic, strong) AVSynchronizedLayer* synchLayer;
@end

@implementation ViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    
    NSURL* m = [[NSBundle mainBundle] URLForResource:@"ElMirage"
                                       withExtension:@"mp4"];
    // AVPlayer* p = [AVPlayer playerWithURL:m];
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:m options:nil];
    AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer* p = [AVPlayer playerWithPlayerItem:item];
    self.player = p; // might need a reference later
    AVPlayerLayer* lay = [AVPlayerLayer playerLayerWithPlayer:p];
    lay.frame = CGRectMake(10,10,300,200);
    self.playerLayer = lay;
    
    [lay addObserver:self forKeyPath:@"readyForDisplay" options:0 context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString: @"readyForDisplay"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishConstructingInterface];
        });
    }
}

-(void) finishConstructingInterface {
    if (!self.playerLayer.readyForDisplay)
        return;
    
    [self.playerLayer removeObserver:self forKeyPath:@"readyForDisplay"];
    
    if (!self.playerLayer.superlayer)
        [self.view.layer addSublayer:self.playerLayer];
    
    if (!self.synchLayer.superlayer)
        [self.synchLayer removeFromSuperlayer];
    
    // create synch layer, put it in the interface
    AVPlayerItem* item = self.player.currentItem;
    AVSynchronizedLayer* syncLayer =
    [AVSynchronizedLayer synchronizedLayerWithPlayerItem:item];
    syncLayer.frame = CGRectMake(10,220,300,10);
    syncLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    [self.view.layer addSublayer:syncLayer];
    // give synch layer a sublayer
    CALayer* subLayer = [CALayer layer];
    subLayer.backgroundColor = [[UIColor blackColor] CGColor];
    subLayer.frame = CGRectMake(0,0,10,10);
    [syncLayer addSublayer:subLayer];
    // animate the sublayer
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.fromValue = [NSValue valueWithCGPoint: subLayer.position];
    anim.toValue = [NSValue valueWithCGPoint: CGPointMake(295,5)];
    anim.removedOnCompletion = NO;
    anim.beginTime = AVCoreAnimationBeginTimeAtZero; // important trick
    anim.duration = CMTimeGetSeconds(item.asset.duration);
    [subLayer addAnimation:anim forKey:nil];

    self.synchLayer = syncLayer;
}

- (IBAction)doButton:(id)sender {
    
    CGFloat rate = self.player.rate;
    if (rate < 0.01)
        self.player.rate = 1;
    else
        self.player.rate = 0;
}

- (IBAction)doButton2:(id)sender {
    AVAsset* oldAsset = self.player.currentItem.asset;
    
    NSString* type = AVMediaTypeVideo;
    NSArray* arr = [oldAsset tracksWithMediaType:type];
    AVAssetTrack* track = [arr lastObject];
    
    CMTime duration = track.timeRange.duration;
    
    AVMutableComposition* comp = [AVMutableComposition composition];
    AVMutableCompositionTrack* comptrack = [comp addMutableTrackWithMediaType:type preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [comptrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(5,600)) ofTrack:track atTime:CMTimeMakeWithSeconds(0,600) error:nil];
    [comptrack insertTimeRange:CMTimeRangeMake(CMTimeSubtract(duration, CMTimeMakeWithSeconds(5,600)), CMTimeMakeWithSeconds(5,600)) ofTrack:track atTime:CMTimeMakeWithSeconds(5,600) error:nil];
    
    type = AVMediaTypeAudio;
    arr = [oldAsset tracksWithMediaType:type];
    track = [arr lastObject];
    comptrack = [comp addMutableTrackWithMediaType:type preferredTrackID:kCMPersistentTrackID_Invalid];

    [comptrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(5,600)) ofTrack:track atTime:CMTimeMakeWithSeconds(0,600) error:nil];
    [comptrack insertTimeRange:CMTimeRangeMake(CMTimeSubtract(duration, CMTimeMakeWithSeconds(5,600)), CMTimeMakeWithSeconds(5,600)) ofTrack:track atTime:CMTimeMakeWithSeconds(5,600) error:nil];

    
    type = AVMediaTypeAudio;
    NSURL* s = [[NSBundle mainBundle] URLForResource:@"aboutTiagol" withExtension:@"m4a"];
    AVAsset* asset = [AVURLAsset URLAssetWithURL:s options:nil];
    arr = [asset tracksWithMediaType:type];
    track = [arr lastObject];
    
    comptrack = [comp addMutableTrackWithMediaType:type preferredTrackID:kCMPersistentTrackID_Invalid];
    [comptrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0,600), CMTimeMakeWithSeconds(10,600)) ofTrack:track atTime:CMTimeMakeWithSeconds(0,600) error:nil];
    
    
    
    AVMutableAudioMixInputParameters* params = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:comptrack];
    [params setVolume:1 atTime:CMTimeMakeWithSeconds(0,600)];
    [params setVolumeRampFromStartVolume:1 toEndVolume:0 timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(6,600), CMTimeMakeWithSeconds(2,600))];
    AVMutableAudioMix* mix = [AVMutableAudioMix new];
    mix.inputParameters = @[params];
    
    AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:comp];
    item.audioMix = mix;
    
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:0 context:nil];
    [sender setEnabled:NO];
}

- (IBAction) restart: (id) sender {
    AVPlayerItem* item = [self.player currentItem];
    // if (CMTIME_COMPARE_INLINE(item.currentTime, ==, item.duration))
    [item seekToTime:CMTimeMake(0, 1)];
}



@end
