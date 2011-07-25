
#import "MyView.h"

@interface MyView ()
@property (nonatomic, retain) NSUndoManager *undoManager;
@end

@implementation MyView
@synthesize undoManager;

- (void)dealloc {
    [undoManager release];
    [super dealloc];
}

// draggable square; a drag can be undone by shaking the device or by press-and-hold on the square

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSUndoManager* u = [[NSUndoManager alloc] init];
    self.undoManager = u; // retain policy
    [u release];
    UIPanGestureRecognizer* p = [[UIPanGestureRecognizer alloc] 
                                 initWithTarget:self 
                                 action:@selector(dragging:)];
    [self addGestureRecognizer:p];
    [p release];
    UILongPressGestureRecognizer* l = [[UILongPressGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(longPress:)];
    [self addGestureRecognizer:l];
    [l release];
    return self;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) setCenterUndoably: (NSValue*) newCenter {
    [self.undoManager registerUndoWithTarget:self 
                               selector:@selector(setCenterUndoably:) 
                                 object:[NSValue valueWithCGPoint:self.center]];
    [self.undoManager setActionName: @"Move"];
    self.center = [newCenter CGPointValue];
}


- (void) dragging: (UIPanGestureRecognizer*) p {
    [self becomeFirstResponder];
    if (p.state == UIGestureRecognizerStateBegan)
        [self.undoManager beginUndoGrouping];
    if (p.state == UIGestureRecognizerStateBegan ||
        p.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [p translationInView: self.superview];
        CGPoint c = self.center;
        c.x += delta.x; c.y += delta.y;
        [self setCenterUndoably: [NSValue valueWithCGPoint:c]];
        [p setTranslation: CGPointZero inView: self.superview];
    }
    if (p.state == UIGestureRecognizerStateEnded || 
        p.state == UIGestureRecognizerStateCancelled)
        [self.undoManager endUndoGrouping];
}

// ===== press-and-hold, menu

- (void) longPress: (id) g {
    UIMenuController *m = [UIMenuController sharedMenuController];
    [m setTargetRect:self.bounds inView:self];
    UIMenuItem *mi1 = 
    [[UIMenuItem alloc] initWithTitle:[self.undoManager undoMenuItemTitle] 
                               action:@selector(undo:)];
    UIMenuItem *mi2 = 
    [[UIMenuItem alloc] initWithTitle:[self.undoManager redoMenuItemTitle] 
                               action:@selector(redo:)];
    [m setMenuItems:[NSArray arrayWithObjects: mi1, mi2, nil]];
    [mi1 release]; [mi2 release];
    [m setMenuVisible:YES animated:YES];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(undo:))
        return [self.undoManager canUndo];
    if (action == @selector(redo:))
        return [self.undoManager canRedo];
    return [super canPerformAction:action withSender:sender];
}

- (void) undo: (id) dummy {
    [self.undoManager undo];
}

- (void) redo: (id) dummy {
    [self.undoManager redo];
}



@end
