

#import "MyBoundedLabel.h"


@implementation MyBoundedLabel

- (void)drawTextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextStrokeRect(context, CGRectInset(self.bounds, 1.0, 1.0));
    [super drawTextInRect:CGRectInset(rect, 5.0, 5.0)];
}

/*
 By chance, this project raises issues I don't want to get to yet in the book.
 
 (1)
 
 In iOS 6, the rules for autorotation have completely changed.
 shouldAutorotateToInterfaceOrientation: is deprecated, and is consulted only if implemented.
 In a generic UIViewController it is not implemented...
 and so the default (portrait only) is not applied.
 Instead, we start by treating the application's declaration in the plist
 as ruling not merely launch preference but rotation generally.
 Thus, because I happened to turn on landscape for the application,
 this interface now autorotates, even though the UIViewController is generic.
 
 (2)
 
 So now we face the problem of how the interface will compose itself when we autorotate.
 In iOS 6, a nib uses autolayout in a new project by default.
 So if the reader creates this project from scratch, autolayout is in force.
 It's quite tricky to specify consistent layout for our two views;
 in the end I specified both centered, one above the other.
 
 */


@end
