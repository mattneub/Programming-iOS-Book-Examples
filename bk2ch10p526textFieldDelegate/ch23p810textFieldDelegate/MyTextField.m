

#import "MyTextField.h"

// ??? is this legal ???

/*

@interface UITextField (SelectionLikeTextView)
- (NSRange) selectedRange;
- (void) setSelectedRange: (NSRange) range;
@end

@implementation UITextField (SelectionLikeTextView)
- (NSRange) selectedRange {
    UITextRange* r = self.selectedTextRange;
    NSInteger loc = [self offsetFromPosition:self.beginningOfDocument
                                  toPosition:r.start];
    NSInteger len = [self offsetFromPosition:r.start
                                  toPosition:r.end];
    return NSMakeRange(loc,len);
}
- (void) setSelectedRange: (NSRange) r {
    UITextPosition* st = [self positionFromPosition:self.beginningOfDocument
                                             offset:r.location];
    UITextPosition* en = [self positionFromPosition:self.beginningOfDocument
                                             offset:r.location + r.length];
    [self setSelectedTextRange:[self textRangeFromPosition:st toPosition:en]];
}
@end
 
 */


@implementation MyTextField

+ (NSString*) stateForAbbrev: (NSString*) abbrev {
    static NSArray* list = nil;
    if (nil == list) {
        NSURL* path = [[NSBundle mainBundle] URLForResource:@"abbreviations" withExtension:@"txt"];
        NSString* s = [NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil];
        list = [s componentsSeparatedByString:@"\n"];
    }
    NSUInteger ix = [list indexOfObject:[abbrev uppercaseString]];
    if (NSNotFound == ix)
        return nil;
    return list[ix+1];
}

// hard to see why this would be strictly illegal

- (BOOL) canPerformAction:(SEL)action withSender: (id) sender {
    if (action == @selector(expand:)) {
        NSString* s = [self textInRange:self.selectedTextRange];
        return (s.length == 2 && [self.class stateForAbbrev: s]);
    }
    return [super canPerformAction:action withSender:sender];
}

- (void) expand: (id) sender {
    NSString* s = [self textInRange:self.selectedTextRange];
    s = [self.class stateForAbbrev:s];
    [self replaceRange:self.selectedTextRange withText:s];
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
