
#import "MyView.h"

@interface MyView ()
@property (nonatomic, strong) NSUndoManager *undoer;
@end

@implementation MyView

- (NSUndoManager*) undoManager {
    return self.undoer;
}

// draggable square; a drag can be undone by shaking the device or by press-and-hold on the square

- (void)awakeFromNib {
    [super awakeFromNib];
    NSUndoManager* u = [NSUndoManager new];
    self.undoer = u; // retain policy
    UIPanGestureRecognizer* p = [[UIPanGestureRecognizer alloc] 
                                 initWithTarget:self 
                                 action:@selector(dragging:)];
    [self addGestureRecognizer:p];
    UILongPressGestureRecognizer* l = [[UILongPressGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(longPress:)];
    [self addGestureRecognizer:l];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

#define which 1 // 2 is the "invocation" way

#if (which == 1)

- (void) setCenterUndoably: (NSValue*) newCenter {
    [self.undoer registerUndoWithTarget:self 
                               selector:@selector(setCenterUndoably:) 
                                 object:[NSValue valueWithCGPoint:self.center]];
    [self.undoer setActionName: @"Move"];
    if (self.undoer.isUndoing || self.undoer.isRedoing) { // animate
        NSLog(@"here");
        UIViewAnimationOptions opt = UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:0.4 delay:0.1 options:opt animations:^{
            self.center = [newCenter CGPointValue];
        } completion:nil];
    } else { // just do it
        self.center = [newCenter CGPointValue];
    }
}

- (void) dragging: (UIPanGestureRecognizer*) p {
    if (p.state == UIGestureRecognizerStateBegan)
        [self.undoer beginUndoGrouping];
    if (p.state == UIGestureRecognizerStateBegan ||
        p.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [p translationInView: self.superview];
        CGPoint c = self.center;
        c.x += delta.x; c.y += delta.y;
        [self setCenterUndoably: [NSValue valueWithCGPoint:c]];
        [p setTranslation: CGPointZero inView: self.superview];
    }
    if (p.state == UIGestureRecognizerStateEnded || 
        p.state == UIGestureRecognizerStateCancelled) {
        [self.undoer endUndoGrouping];
        [self becomeFirstResponder];
    }
}

#elif (which == 2)

- (void) setCenterUndoably: (CGPoint) newCenter {
    [[self.undoer prepareWithInvocationTarget:self]
     setCenterUndoably: self.center];
    [self.undoer setActionName: @"Move"];
    if (self.undoer.isUndoing || self.undoer.isRedoing) { // animate
        NSLog(@"here");
        UIViewAnimationOptions opt = UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:0.4 delay:0.1 options:opt animations:^{
            self.center = newCenter;
        } completion:nil];
    } else { // just do it
        self.center = newCenter;
    }
}


- (void) dragging: (UIPanGestureRecognizer*) p {
    if (p.state == UIGestureRecognizerStateBegan)
        [self.undoer beginUndoGrouping];
    if (p.state == UIGestureRecognizerStateBegan ||
        p.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [p translationInView: self.superview];
        CGPoint c = self.center;
        c.x += delta.x; c.y += delta.y;
        [self setCenterUndoably: c];
        [p setTranslation: CGPointZero inView: self.superview];
    }
    if (p.state == UIGestureRecognizerStateEnded ||
        p.state == UIGestureRecognizerStateCancelled) {
        [self.undoer endUndoGrouping];
        [self becomeFirstResponder];
    }
}


#endif

// ===== press-and-hold, menu

- (void) longPress: (UIGestureRecognizer*) g {
    if (g.state == UIGestureRecognizerStateBegan) {
        UIMenuController *m = [UIMenuController sharedMenuController];
        [m setTargetRect:self.bounds inView:self];
        UIMenuItem *mi1 = 
        [[UIMenuItem alloc] initWithTitle:[self.undoer undoMenuItemTitle] 
                                   action:@selector(undo:)];
        UIMenuItem *mi2 = 
        [[UIMenuItem alloc] initWithTitle:[self.undoer redoMenuItemTitle] 
                                   action:@selector(redo:)];
        [m setMenuItems:@[mi1, mi2]];
        [m setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(undo:))
        return [self.undoer canUndo];
    if (action == @selector(redo:))
        return [self.undoer canRedo];
    return [super canPerformAction:action withSender:sender];
}

- (void) undo: (id) dummy {
    [self.undoer undo];
}

- (void) redo: (id) dummy {
    [self.undoer redo];
}



@end
