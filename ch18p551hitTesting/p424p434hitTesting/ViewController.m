

#import "ViewController.h"

@implementation ViewController

/*
 Run on the iPhone 5 simulator and tap the button: this message never appears!
 But it does appear on iOS 6. This is new behavior.
 Here's how it works: a UIView now has a gestureRecognizerShouldBegin: method
 which is consulted by gesture recognizers belonging to superviews
 before they can begin to recognize.
 By default, a UIButton returns NO for a UITapGestureRecognizer.
 */

- (IBAction)doButton:(id)sender {
    NSLog(@"tapped the button");
}

@end
