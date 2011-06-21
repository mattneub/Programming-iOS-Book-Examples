

#import <UIKit/UIKit.h>
@class MyProgressView;
@interface RootViewController : UIViewController {
    
    MyProgressView *prog;
}
@property (nonatomic, retain) IBOutlet MyProgressView *prog;

@end
