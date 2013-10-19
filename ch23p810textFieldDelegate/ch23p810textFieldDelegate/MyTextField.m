

#import "MyTextField.h"

@implementation MyTextField

- (BOOL) canPerformAction:(SEL)action withSender: (id) sender {
    if (action == @selector(expand:))
        return ([self.text length] == 2); // could be more intelligent here
    return [super canPerformAction:action withSender:sender];
}

- (void) expand: (id) sender {
    NSString* s = self.text;
    // ... alter s here ...
    s = [s stringByAppendingString:@" "]; // dummy action, prevent circularity
    self.text = s;
}

- (void) copy: (id) sender {
    [super copy: sender];
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    NSString* s = pb.string;
    // ... alter s here ....
    s = [s stringByAppendingString:@"suprise!"];
    pb.string = s;
}


@end
