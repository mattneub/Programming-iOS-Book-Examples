

#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation RootViewController
@synthesize player;

- (void)dealloc {
    [player release];
    [super dealloc];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL* m = [[NSBundle mainBundle] URLForResource:@"movie2" withExtension:@"m4v"];
    AVPlayer* p = [AVPlayer playerWithURL:m];
    self.player = p; // might need a reference later
    AVPlayerLayer* lay = [AVPlayerLayer playerLayerWithPlayer:p];
    lay.frame = CGRectMake(10,10,300,200);
    [self.view.layer addSublayer:lay];
    
    AVPlayerItem* item = p.currentItem;
    AVAsset* asset = [item asset];
    // use of blocks here not in book example (because threading is treated later)
    // but launch looks better this way
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] 
     completionHandler:^(void) {
         dispatch_async(dispatch_get_main_queue(), ^{
             AVSynchronizedLayer* syncLayer = 
             [AVSynchronizedLayer synchronizedLayerWithPlayerItem:item];
             syncLayer.frame = CGRectMake(10,200,300,10);
             syncLayer.backgroundColor = [[UIColor whiteColor] CGColor];
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
         });
     }];
}

- (IBAction)doButton:(id)sender {
    CGFloat rate = self.player.rate;
    if (rate < 0.01)
        self.player.rate = 1;
    else
        self.player.rate = 0;
}

@end
