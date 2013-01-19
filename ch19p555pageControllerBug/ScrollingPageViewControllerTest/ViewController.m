

#import "ViewController.h"
#import "MyPage.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIPageViewController* pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self addChildViewController:pvc];
    [self.view addSubview:pvc.view];
    [pvc didMoveToParentViewController:self];
    pvc.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray* cons;
    cons =
    [NSLayoutConstraint
     constraintsWithVisualFormat:@"H:|[pvc]|"
     options:0
     metrics:nil
     views:@{@"pvc":pvc.view}];
    [self.view addConstraints:cons];
    cons =
    [NSLayoutConstraint
     constraintsWithVisualFormat:@"V:|[pvc]|"
     options:0
     metrics:nil
     views:@{@"pvc":pvc.view}];
    [self.view addConstraints:cons];

    pvc.dataSource = self;
    MyPage* page = [MyPage new];
    page.num = 1;
    [pvc setViewControllers:@[page] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    MyPage* page = (MyPage*)viewController;
    NSInteger num = page.num;
    if (num == 10) return nil;
    page = [MyPage new];
    page.num = num+1;
    return page;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    MyPage* page = (MyPage*)viewController;
    NSInteger num = page.num;
    if (num == 1) return nil;
    page = [MyPage new];
    page.num = num-1;
    return page;
}

// this is the key method

// start at page 1
// click the button to jump to page 8
// now swipe backwards to see the previous page
// it is page 1!
// that's the bug; the page view controller has not updated its internal state

-(void)jumpTo8:(id)sender {
    MyPage* page = [MyPage new];
    page.num = 8;
    UIPageViewController* pvc = self.childViewControllers[0];
    __weak UIPageViewController* pvcw = pvc;
    [pvc setViewControllers:@[page] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        // uncomment this completion handler to use the workaround!
        /*
        UIPageViewController* pvcs = pvcw;
        if (!pvcs) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            [pvcs setViewControllers:@[page] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
         */
        });
    }];
}

// workaround: use animated:NO instead of animated:YES
// this is not a very acceptable workaround visually,
// but at least it does cause the page view controller to update its internal state properly
// the above trick combines the two


@end
