
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView* v;
@property (nonatomic, strong) UILongPressGestureRecognizer* longPresser;

@end
