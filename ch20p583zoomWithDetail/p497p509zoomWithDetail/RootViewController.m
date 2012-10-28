

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TiledView.h"

@interface RootViewController () <UIScrollViewDelegate>
@end

@implementation RootViewController

// for best results, zoom with lines 14 and 15 showing, so you can see the tiling change

#define which 1 // try "2" to see how to get the same behavior on double-resolution screen

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
    
    switch (which) {
        case 1: break;
        case 2:
        {
            if ([[UIScreen mainScreen] scale] > 1.0) {
                NSLog(@"%@", NSStringFromCGRect(f));
                // these lines were always just wrong, it appears
                // perhaps this is because contentsscale now compensates for us
                // also I saw a weird behavior where drawRect picked a much smaller size
                //f.size.width *= 4.0;
                //f.size.height *= 4.0;
                //lay.tileSize = f.size;
                lay.levelsOfDetailBias = 3; // 2 wasn't enough to trigger retile on zoom
                NSLog(@"%@", NSStringFromCGRect(f));
            }
            break;
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:999];
}


@end
