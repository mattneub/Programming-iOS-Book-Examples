

#import "ViewController.h"
#import "MyPage.h"

@interface ViewController () <UIPageViewControllerDataSource>

@end

@implementation ViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIPageViewController* pvc = (UIPageViewController*)segue.destinationViewController;
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
         });
         */
    }];
}


@end
