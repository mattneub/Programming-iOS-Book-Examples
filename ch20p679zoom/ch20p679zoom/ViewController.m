

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@end

@implementation ViewController


-(void)viewDidLoad {
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
    
    CGFloat y = 10;
    CGFloat w = 0;
    for (int i=0; i<30; i++) {
        UILabel* lab = [UILabel new];
        lab.text = [NSString stringWithFormat:@"This is label %d", i+1];
        [lab sizeToFit];
        CGRect f = lab.frame;
        f.origin = CGPointMake(10,y);
        lab.frame = f;
        [v addSubview:lab]; // *
        y += lab.bounds.size.height + 10;
        
        if (lab.bounds.size.width > w)
            w = lab.bounds.size.width;
    }
    
    // set content view frame and content size explicitly
    v.frame = CGRectMake(0,0,w+20,y);
    sv.contentSize = v.frame.size;
    
    
    v.tag = 999;
    sv.minimumZoomScale = 1.0;
    sv.maximumZoomScale = 2.0;
    sv.delegate = self;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:999];
}


@end
