

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController 
<UIPopoverControllerDelegate, UINavigationControllerDelegate> 

@property (nonatomic, strong) UIPopoverController* currentPop;

@end
