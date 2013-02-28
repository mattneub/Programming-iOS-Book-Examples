

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
 shouldAutorotateToInterfaceOrientation: is completely ignored!
 Instead, we start by treating the application's declaration in the plist
 as ruling not merely launch preference but rotation generally.
 Thus, because I happened to turn on landscape for the application,
 this interface now autorotates, even though the UIViewController is generic.
 
 To put it another way, previously I was using a generic UIViewController to help
 guarantee that we would be portrait-only, but that no longer works.
 
 (2)
 
 So now we face the problem of how the interface will compose itself when we autorotate.
 In iOS 6, a nib uses autolayout in a new project by default.
 So if the reader creates this project from scratch, autolayout is in force.
 It's quite tricky to specify consistent layout for our two views;
 in the end I specified both centered, one above the other.
 
 */


@end
