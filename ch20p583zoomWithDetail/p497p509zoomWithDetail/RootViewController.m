

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TiledView.h"

@interface RootViewController () <UIScrollViewDelegate>
@end

@implementation RootViewController

// for best results, zoom with lines 14 and 15 showing, so you can see the tiling change


- (void)loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = sv;
    
    CGRect f = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height * 2);
    TiledView* content = [[TiledView alloc] initWithFrame:f];
    content.tag = 999;
    CATiledLayer* lay = (CATiledLayer*)content.layer;
    lay.tileSize = f.size;
    lay.levelsOfDetail = 2;
    lay.levelsOfDetailBias = 1;
    [self.view addSubview:content];
    [sv setContentSize: f.size];
    sv.minimumZoomScale = 1.0;
    sv.maximumZoomScale = 2.0;
    sv.delegate = self;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:999];
}


@end
