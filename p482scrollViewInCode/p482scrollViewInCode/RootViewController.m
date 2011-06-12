

#import "RootViewController.h"

@implementation RootViewController

#define which 1 // try "2" and rotate the app

- (void)dealloc
{
    [super dealloc];
}

- (void) loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:
                        [[UIScreen mainScreen] applicationFrame]];
    self.view = sv;
    CGFloat y = 10;
    for (int i=0; i<30; i++) {
        UILabel* lab = [[UILabel alloc] init];
        lab.text = [NSString stringWithFormat:@"This is label %i", i+1];
        [lab sizeToFit];
        CGRect f = lab.frame;
        f.origin = CGPointMake(10,y);
        lab.frame = f;
        [sv addSubview:lab];
        y += lab.bounds.size.height + 10;
        switch (which) {
            case 2:
                lab.backgroundColor = [UIColor redColor]; // make label bounds visible
                lab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                break;
        }
        [lab release];
    }
    CGSize sz = sv.bounds.size;
    sz.height = y;
    sv.contentSize = sz; // This is the crucial line
    [sv release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (which) {
        case 2:
            return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// this really should have been in the book, but wasn't
// if we rotate a scroll view, its contentOffset remains constant
// so if we go from landscape to portrait, there can be white space at the bottom
// this prevents that 
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)io 
                                         duration:(NSTimeInterval)duration {
    UIScrollView* sv = (UIScrollView*)self.view;
    CGSize csz = sv.contentSize;
    CGSize bsz = sv.bounds.size;
    if (sv.contentOffset.y + bsz.height > csz.height) {
        [sv setContentOffset:CGPointMake(sv.contentOffset.x, 
                                         csz.height - bsz.height) 
                    animated:YES];
    }
}

@end
