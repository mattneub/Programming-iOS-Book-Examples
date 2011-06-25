

#import <UIKit/UIKit.h>
@class MPMoviePlayerController;

@interface RootViewController : UIViewController <UINavigationControllerDelegate, UIVideoEditorControllerDelegate> {
    
}
@property (nonatomic, retain) MPMoviePlayerController* mpc;

@end
