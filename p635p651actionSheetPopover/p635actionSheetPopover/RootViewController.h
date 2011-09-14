

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIActionSheetDelegate> {
    
    UIToolbar *toolbar;
}
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@end
