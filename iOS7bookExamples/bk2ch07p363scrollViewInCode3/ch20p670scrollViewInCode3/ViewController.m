

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIScrollView* sv = [UIScrollView new];
    sv.backgroundColor = [UIColor whiteColor];
    sv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:sv];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sv]|"
                                             options:0 metrics:nil
                                               views:@{@"sv":sv}]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sv]|"
                                             options:0 metrics:nil
                                               views:@{@"sv":sv}]];
    
    UIView* v = [UIView new]; // content view
    [sv addSubview: v];
    
#define which 3
#if which == 1
    
    // content view doesn't use explicit constraints
    // subviews don't use explicit constraints either

    CGFloat y = 10;
    for (int i=0; i<30; i++) {
        UILabel* lab = [UILabel new];
        lab.text = [NSString stringWithFormat:@"This is label %d", i+1];
        [lab sizeToFit];
        CGRect f = lab.frame;
        f.origin = CGPointMake(10,y);
        lab.frame = f;
        [v addSubview:lab]; // *
        y += lab.bounds.size.height + 10;
    }
    
    // set content view frame and content size explicitly
    v.frame = CGRectMake(0,0,0,y);
    sv.contentSize = v.frame.size;
    
#elif which == 2
    
    // content view uses explicit constraints
    // subviews don't use explicit constraints
    
    CGFloat y = 10;
    for (int i=0; i<30; i++) {
        UILabel* lab = [UILabel new];
        lab.text = [NSString stringWithFormat:@"This is label %d", i+1];
        [lab sizeToFit];
        CGRect f = lab.frame;
        f.origin = CGPointMake(10,y);
        lab.frame = f;
        [v addSubview:lab]; // *
        y += lab.bounds.size.height + 10;
    }
    
    // set content view width, height, and frame-to-superview constraints
    // content size is calculated for us
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [sv addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v(y)]|"
                                             options:0 metrics:@{@"y":@(y)} views:@{@"v":v}]];
    [sv addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v(0)]|"
                                             options:0 metrics:nil views:@{@"v":v}]];
    
#elif which == 3
    
    // content view doesn't use explicit constraints
    // subviews do explicit constraints
    
    UILabel* previousLab = nil;
    for (int i=0; i<30; i++) {
        UILabel* lab = [UILabel new];
        // lab.backgroundColor = [UIColor redColor];
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        lab.text = [NSString stringWithFormat:@"This is label %d", i+1];
        [v addSubview:lab]; // *
        [v addConstraints: // *
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[lab]"
                                                 options:0 metrics:nil
                                                   views:@{@"lab":lab}]];
        if (!previousLab) { // first one, pin to top
            [v addConstraints: // *
             [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[lab]"
                                                     options:0 metrics:nil
                                                       views:@{@"lab":lab}]];
        } else { // all others, pin to previous
            [v addConstraints: // *
             [NSLayoutConstraint
              constraintsWithVisualFormat:@"V:[prev]-(10)-[lab]"
              options:0 metrics:nil
              views:@{@"lab":lab, @"prev":previousLab}]];
        }
        previousLab = lab;
    }
    
    // last one, pin to bottom, this dictates content size height
    [v addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lab]-(10)-|"
                                             options:0 metrics:nil
                                               views:@{@"lab":previousLab}]];

    // autolayout helps us learn the consequences of those constraints
    CGSize minsz = [v systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // set content view frame and content size explicitly
    v.frame = CGRectMake(0,0,0,minsz.height);
    sv.contentSize = v.frame.size;
    
#elif which == 4
    
    // content view uses explicit constraints
    // subviews use explicit constraints
    
    UILabel* previousLab = nil;
    for (int i=0; i<30; i++) {
        UILabel* lab = [UILabel new];
        // lab.backgroundColor = [UIColor redColor];
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        lab.text = [NSString stringWithFormat:@"This is label %d", i+1];
        [v addSubview:lab];
        [v addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[lab]"
                                                 options:0 metrics:nil
                                                   views:@{@"lab":lab}]];
        if (!previousLab) { // first one, pin to top
            [v addConstraints:
             [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[lab]"
                                                     options:0 metrics:nil
                                                       views:@{@"lab":lab}]];
        } else { // all others, pin to previous
            [v addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:@"V:[prev]-(10)-[lab]"
              options:0 metrics:nil
              views:@{@"lab":lab, @"prev":previousLab}]];
        }
        previousLab = lab;
    }
    
    // last one, pin to bottom, this dictates content size height
    [v addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lab]-(10)-|"
                                             options:0 metrics:nil
                                               views:@{@"lab":previousLab}]];
    
    // set content view width and frame-to-superview constraints
    // (height comes from subview constraints)
    // content size is calculated for us
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [sv addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|"
                                             options:0 metrics:nil views:@{@"v":v}]];
    [sv addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v(0)]|"
                                             options:0 metrics:nil views:@{@"v":v}]];

#endif

}


@end
