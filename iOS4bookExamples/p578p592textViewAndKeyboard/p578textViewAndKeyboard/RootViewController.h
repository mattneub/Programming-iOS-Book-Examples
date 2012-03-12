
#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController {
    CGRect oldFrame;
    UITextView *tv;
}
@property (nonatomic, retain) IBOutlet UITextView *tv;

@end
