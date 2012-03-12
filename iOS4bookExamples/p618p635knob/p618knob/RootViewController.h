

#import <UIKit/UIKit.h>
@class MyKnob;
@interface RootViewController : UIViewController {
    
    MyKnob *knob;
}
@property (nonatomic, retain) IBOutlet MyKnob *knob;

@end
