
#import "HorizPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@implementation HorizPanGestureRecognizer {
    CGPoint _origLoc;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self->_origLoc = [(UITouch*)touches.anyObject locationInView:self.view.superview];
    [super touchesBegan: touches withEvent: event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStatePossible) {
        CGPoint loc = [(UITouch*)touches.anyObject locationInView:self.view.superview];
        CGFloat deltaX = fabs(loc.x - self->_origLoc.x);
        CGFloat deltaY = fabs(loc.y - self->_origLoc.y);
        if (deltaY >= deltaX)
            self.state = UIGestureRecognizerStateFailed;
    }
    [super touchesMoved: touches withEvent:event];
}

- (CGPoint)translationInView:(UIView *)v {
    CGPoint proposedTranslation = [super translationInView:v];
    proposedTranslation.y = 0;
    return proposedTranslation;
}

@end
