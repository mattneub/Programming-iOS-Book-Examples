

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface RootViewController : UIViewController <MPMediaPickerControllerDelegate> {
    
}
@property (nonatomic, retain) UIPopoverController* currentPop;

@end
