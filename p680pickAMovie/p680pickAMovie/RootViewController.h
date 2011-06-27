

#import <UIKit/UIKit.h>
@class MPMoviePlayerController;

@interface RootViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIView *redView;
}
@property (nonatomic, retain) IBOutlet UIView *redView;
@property (nonatomic, retain) MPMoviePlayerController* mpc;
@property (nonatomic, retain) UIPopoverController* currentPop;
@end
