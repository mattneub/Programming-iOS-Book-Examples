

#import "MyTextField.h"
#import "TextFieldScrollingAppDelegate.h"

@implementation MyTextField
@synthesize nextField;

// p 575

- (BOOL) canPerformAction:(SEL)action withSender: (id) sender {
    if (action == @selector(expand:))
        return ([self.text length] == 2); // could be more intelligent here
    return NO;
}

- (void) expand: (id) sender {
    NSString* s = self.text;
    
    TextFieldScrollingAppDelegate* del = (TextFieldScrollingAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary* states = del.states;
    NSString* state = [states objectForKey:[s uppercaseString]];
    if (state)
        s = state;
    
    self.text = s;
}


@end
