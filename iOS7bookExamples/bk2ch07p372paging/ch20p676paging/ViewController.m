

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGSize sz = self.sv.bounds.size;
    NSArray* colors = @[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]];
    for (int i = 0; i < 3; i++) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(sz.width*i,0,sz.width,sz.height)];
        v.backgroundColor = colors[i];
        [self.sv addSubview:v];
    }
    self.sv.contentSize = CGSizeMake(3*sz.width,sz.height);
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@", @"begin");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@", @"end");
    CGFloat x = self.sv.contentOffset.x;
    CGFloat w = self.sv.bounds.size.width;
    self.pager.currentPage = x/w;
}

- (IBAction)userDidPage:(id)sender {
    NSInteger p = self.pager.currentPage;
    CGFloat w = self.sv.bounds.size.width;
    [self.sv setContentOffset:CGPointMake(p*w,0) animated:YES];
}


@end
