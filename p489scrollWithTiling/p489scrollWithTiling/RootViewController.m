

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TiledView.h"


@implementation RootViewController

- (void)dealloc
{
    [super dealloc];
}

-(void)loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    self.view = sv;
    // in Apple's original picture there are a lot more tiles
    // but to save space I've included just 9, making a three-by-three image
    CGRect f = CGRectMake(0,0,3*TILESIZE,3*TILESIZE);
    TiledView* content = [[TiledView alloc] initWithFrame:f];
    float tsz = 256 * content.layer.contentsScale;
    [(CATiledLayer*)content.layer setTileSize: CGSizeMake(tsz, tsz)];
    [self.view addSubview:content];
    [content release];
    [sv setContentSize: f.size];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
