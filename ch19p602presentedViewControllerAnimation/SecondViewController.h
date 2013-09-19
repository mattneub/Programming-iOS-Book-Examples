
#import <UIKit/UIKit.h>

@protocol SecondViewControllerDelegate
- (void) acceptData: (id) data;
@end

@interface SecondViewController : UIViewController
@property (nonatomic, weak) id <SecondViewControllerDelegate> delegate;
@property (nonatomic, strong) id data;
@end
