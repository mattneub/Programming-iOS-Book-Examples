
#import <UIKit/UIKit.h>
@class StyledText;
@interface RootViewController : UIViewController {
    
    StyledText *styler;
}
@property (nonatomic, retain) IBOutlet StyledText *styler;

@end
