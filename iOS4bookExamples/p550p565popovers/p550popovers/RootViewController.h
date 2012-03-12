

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController 
<UIPopoverControllerDelegate, UINavigationControllerDelegate> 
{
    NSInteger oldChoice;
}
@property (nonatomic, retain) UIPopoverController* currentPop;

@end
