
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, strong) AVPlayerLayer* playerlayer;
@property (nonatomic, strong) AVSynchronizedLayer* synchlayer;
@end

@implementation ViewController

// probably best to run on device

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"readyForDisplay"]) {
        AVPlayerLayer* lay = (AVPlayerLayer*) object;
        if (lay.readyForDisplay) {
            // now deprecated, and rightly so; turns out this was always wrong on my part
            // NSLog(@"on main thread? %i", dispatch_get_current_queue() == dispatch_get_main_queue());
            NSLog(@"on main thread? %i", [NSThread isMainThread]);
            NSLog(@"ready for display, adding synchronized layer");
            [lay removeObserver:self forKeyPath:@"readyForDisplay"];
            AVPlayerItem* item = self.player.currentItem;
            if (self.synchlayer)
                [self.synchlayer removeFromSuperlayer];
            AVSynchronizedLayer* syncLayer =
            [AVSynchronizedLayer synchronizedLayerWithPlayerItem:item];
            syncLayer.frame = CGRectMake(10,200,300,10);
            syncLayer.backgroundColor = [[UIColor whiteColor] CGColor];
            [self.view.layer addSublayer:syncLayer];
            self.synchlayer = syncLayer;
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
        }
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL* m = [[NSBundle mainBundle] URLForResource:@"ElMirage" withExtension:@"mp4"];
    
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:m options:nil];
    AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer* p = [AVPlayer playerWithPlayerItem:item];
    //    AVPlayer* p = [AVPlayer playerWithURL:m];
    
    self.player = p;
    AVPlayerLayer* lay = [AVPlayerLayer playerLayerWithPlayer:p];
    self.playerlayer = lay;
    NSLog(@"adding player layer to interface");
    lay.frame = CGRectMake(10,10,300,200);
    [self.view.layer addSublayer:lay];
    [lay addObserver:self forKeyPath:@"readyForDisplay" options:0 context:nil];
}

- (IBAction)doButton:(id)sender {
    CGFloat rate = self.player.rate;
    if (rate < 0.01)
        self.player.rate = 1;
    else
        self.player.rate = 0;
}

- (IBAction)doButton2:(id)sender {
    NSString* type = AVMediaTypeVideo;
    NSArray* arr = [self.player.currentItem.asset tracksWithMediaType:type];
    AVAssetTrack* track = [arr lastObject];
    
    AVMutableComposition* comp = [AVMutableComposition composition];
    AVMutableCompositionTrack* comptrack = [comp addMutableTrackWithMediaType:type preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [comptrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0,1), CMTimeMakeWithSeconds(5,1)) ofTrack:track atTime:CMTimeMakeWithSeconds(0,1) error:nil];
    [comptrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(30,1), CMTimeMakeWithSeconds(5,1)) ofTrack:track atTime:CMTimeMakeWithSeconds(5,1) error:nil];
    
    type = AVMediaTypeAudio;
    NSURL* s = [[NSBundle mainBundle] URLForResource:@"aboutTiagol" withExtension:@"m4a"];
    AVAsset* asset = [AVURLAsset URLAssetWithURL:s options:nil];
    arr = [asset tracksWithMediaType:type];
    track = [arr lastObject];
    
    comptrack = [comp addMutableTrackWithMediaType:type preferredTrackID:kCMPersistentTrackID_Invalid];
    [comptrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0,1), CMTimeMakeWithSeconds(10,1)) ofTrack:track atTime:CMTimeMakeWithSeconds(0,1) error:nil];
    
    AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:[comp copy]];
    
    
    AVMutableAudioMixInputParameters* params = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:comptrack];
    [params setVolume:1 atTime:CMTimeMakeWithSeconds(0,1)];
    [params setVolumeRampFromStartVolume:1 toEndVolume:0 timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(6,1), CMTimeMakeWithSeconds(2,1))];
    AVMutableAudioMix* mix = [AVMutableAudioMix audioMix];
    mix.inputParameters = [NSArray arrayWithObject: params];
    
    item.audioMix = mix;
    
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.playerlayer addObserver:self forKeyPath:@"readyForDisplay" options:0 context:nil];
}

@end
