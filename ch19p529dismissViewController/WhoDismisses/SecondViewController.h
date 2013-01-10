

#import <UIKit/UIKit.h>

@protocol SVCDelegate
- (void) dismissMe;
@end

@interface SecondViewController : UIViewController
@property (weak, nonatomic) id <SVCDelegate> delegate;
@end
