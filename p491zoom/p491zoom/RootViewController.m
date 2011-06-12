

#import "RootViewController.h"

@implementation RootViewController

- (void)dealloc
{
    [super dealloc];
}

- (void) loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:
                        [[UIScreen mainScreen] applicationFrame]];
    self.view = sv;
    UIView* v = [[UIView alloc] init];
    CGFloat y = 10;
    for (int i=0; i<30; i++) {
        UILabel* lab = [[UILabel alloc] init];
        lab.text = [NSString stringWithFormat:@"This is label %i", i+1];
        [lab sizeToFit];
        CGRect f = lab.frame;
        f.origin = CGPointMake(10,y);
        lab.frame = f;
        [v addSubview:lab];
        y += lab.bounds.size.height + 10;
        [lab release];
    }
    CGSize sz = sv.bounds.size;
    sz.height = y;
    sv.contentSize = sz; 
    v.frame = CGRectMake(0,0,sz.width,sz.height);
    [sv addSubview:v];
    // so far so good; now we'll add zoomability
    v.tag = 999; 
    [v release]; 
    sv.minimumZoomScale = 1.0; 
    sv.maximumZoomScale = 2.0; 
    sv.delegate = self; 
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
