

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>


@interface RootViewController : UIViewController <EKEventViewDelegate> {
    
}
@property (nonatomic, retain) UIPopoverController* currentPop;

@end
