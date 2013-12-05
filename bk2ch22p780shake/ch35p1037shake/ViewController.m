

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// shake device (or simulator), watch console for response
// note that this does not disable Undo by shaking in text field

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ([self isFirstResponder])
        NSLog(@"hey, you shook me!");
    else
        [super motionEnded:motion withEvent:event];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self becomeFirstResponder];
}

@end
