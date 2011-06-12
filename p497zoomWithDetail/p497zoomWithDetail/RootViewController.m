

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TiledView.h"

@implementation RootViewController

#define which 1 // try "2" to see how to get the same behavior on double-resolution screen

- (void)loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = sv;
    
    CGRect f = CGRectMake(0,0,self.view.bounds.size.width,940);
    TiledView* content = [[TiledView alloc] initWithFrame:f];
    content.tag = 999;
    CATiledLayer* lay = (CATiledLayer*)content.layer;
    [lay setTileSize: f.size];
    lay.levelsOfDetail = 2;
    lay.levelsOfDetailBias = 1;
    [self.view addSubview:content];
    [content release];
    [sv setContentSize: f.size];
    sv.minimumZoomScale = 1.0;
    sv.maximumZoomScale = 2.0;
    sv.delegate = self;
    
    switch (which) {
        case 2:
        {
            if ([[UIScreen mainScreen] scale] > 1.0) {
                f.size.width *= 4;
                f.size.height *= 4;
                lay.tileSize = f.size;
                lay.levelsOfDetailBias = 2;
            }

            break;
        }
    }
    
    [sv release];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:999];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
