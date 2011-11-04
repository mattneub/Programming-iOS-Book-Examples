

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController* pvc;
@property (nonatomic, strong) NSArray* pep;
@end
