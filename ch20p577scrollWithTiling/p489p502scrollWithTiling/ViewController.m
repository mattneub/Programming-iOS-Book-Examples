

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TiledView.h"


@implementation ViewController


-(void)loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    sv.backgroundColor = [UIColor whiteColor];
    self.view = sv;
    // in Apple's original picture there are a lot more tiles
    // but to save space I've included just 9, making a three-by-three image
    CGRect f = CGRectMake(0,0,3*TILESIZE,3*TILESIZE);
    TiledView* content = [[TiledView alloc] initWithFrame:f];
    float tsz = TILESIZE * content.layer.contentsScale;
    [(CATiledLayer*)content.layer setTileSize: CGSizeMake(tsz, tsz)];
    [self.view addSubview:content];
    [sv setContentSize: f.size];
}




@end
