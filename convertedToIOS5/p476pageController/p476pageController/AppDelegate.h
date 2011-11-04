

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIPageViewController* pvc;
@property (nonatomic, strong) NSArray* pep;

@end
