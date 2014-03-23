
#import "MyView2.h"

@implementation MyView2 {
    NSTimeInterval _time;
}

#define which 1
#if which == 1

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger ct = [(UITouch*)touches.anyObject tapCount];
    if (ct == 2) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(singleTap)
                                                   object:nil];
    }    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger ct = [(UITouch*)touches.anyObject tapCount];
    if (ct == 1)
        [self performSelector:@selector(singleTap) withObject:nil afterDelay:0.3];
    if (ct == 2)
        NSLog(@"double tap");
}

- (void) singleTap {
    NSLog(@"single tap");
}

#elif which == 2

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self->_time = [(UITouch*)touches.anyObject timestamp];
    [self performSelector:@selector(touchWasLong)
               withObject:nil afterDelay:0.4];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSTimeInterval diff = event.timestamp - self->_time;
    if (diff < 0.4) {
        NSLog(@"short");
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(touchWasLong)
                                                   object:nil];
    }
}

- (void) touchWasLong {
    NSLog(@"long");
}


#endif



@end
