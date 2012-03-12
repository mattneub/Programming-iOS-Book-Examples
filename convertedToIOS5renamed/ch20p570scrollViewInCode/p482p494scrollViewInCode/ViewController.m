

#import "ViewController.h"

@implementation ViewController

#define which 1 // try "2" and rotate the app


- (void) loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:
                        [[UIScreen mainScreen] applicationFrame]];
    sv.backgroundColor = [UIColor whiteColor]; // this line is new (default is now black for new view)
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
            case 1:
                break;
            case 2:
                lab.backgroundColor = [UIColor redColor]; // make label bounds visible
                lab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                break;
        }
    }
    CGSize sz = sv.bounds.size;
    sz.height = y;
    sv.contentSize = sz; // This is the crucial line
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (which) {
        case 1:
            break;
        case 2:
            return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// this really should have been in the book, but wasn't
// if we rotate a scroll view, its contentOffset remains constant
// so if we go from landscape to portrait, there can be white space at the bottom
// this prevents that

// whoa! in iOS 5 this appears to be fixed; this code is no longer necessary...
// and can be commented out (I've put in a return so that it is a no-op)

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)io 
                                         duration:(NSTimeInterval)duration {
    return;
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
