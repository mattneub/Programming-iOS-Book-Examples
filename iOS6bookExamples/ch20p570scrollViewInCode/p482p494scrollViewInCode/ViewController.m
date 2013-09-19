

#import "ViewController.h"

@implementation ViewController

#define which 1 // try "2" and rotate the app


- (void) loadView {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:
                        [[UIScreen mainScreen] applicationFrame]];
    sv.backgroundColor = [UIColor whiteColor]; // default is black for new view
    self.view = sv;
    CGFloat y = 10;
    for (int i=0; i<30; i++) {
        UILabel* lab = [UILabel new];
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

-(NSUInteger)supportedInterfaceOrientations {
    NSUInteger result = UIInterfaceOrientationMaskPortrait;
    switch (which) {
        case 1:
            break;
        case 2:
            result = UIInterfaceOrientationMaskAll;
            break;
    }
    return result;
}


@end
