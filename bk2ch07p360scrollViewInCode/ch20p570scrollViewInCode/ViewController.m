

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame: self.view.bounds];
    sv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:sv];
    sv.backgroundColor = [UIColor whiteColor];
    CGFloat y = 10;
    for (int i=0; i<30; i++) {
        UILabel* lab = [UILabel new];
        lab.text = [NSString stringWithFormat:@"This is label %d", i+1];
        [lab sizeToFit];
        CGRect f = lab.frame;
        f.origin = CGPointMake(10,y);
        lab.frame = f;
        [sv addSubview:lab];
        y += lab.bounds.size.height + 10;
        
        // uncomment
//        f.size.width = self.view.bounds.size.width - 20;
//        lab.frame = f;
//        lab.backgroundColor = [UIColor redColor]; // make label bounds visible
//        lab.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    }
    CGSize sz = sv.bounds.size;
    sz.height = y;
    sv.contentSize = sz; // This is the crucial line
}

@end
