
#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController {
    CGPoint oldOffset;
    UIEdgeInsets oldContentInset;
    UIEdgeInsets oldIndicatorInset;
    UIScrollView *scrollView;
    UIView *buttonView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) UIView* fr;
@property (nonatomic, retain) IBOutlet UIView *buttonView;

@end
