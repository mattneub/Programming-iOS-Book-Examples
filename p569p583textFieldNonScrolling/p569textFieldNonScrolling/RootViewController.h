
#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController {
    CGPoint oldOffset;
    UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) UIView* fr;

@end
