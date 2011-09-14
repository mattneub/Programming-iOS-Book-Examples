

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController {
    
    UITabBar *tb;
}
@property (nonatomic, retain) IBOutlet UITabBar *tb;
@property (nonatomic, copy) NSArray* items;
@end
