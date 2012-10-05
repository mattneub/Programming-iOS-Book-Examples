
#import "MyView2.h"

@implementation MyView2

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    int ct = [[touches anyObject] tapCount];
    if (ct == 2) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(singleTap)
                                                   object:nil];
    }    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    int ct = [[touches anyObject] tapCount];
    if (ct == 1)
        [self performSelector:@selector(singleTap) withObject:nil afterDelay:0.3];
    if (ct == 2)
        NSLog(@"double tap");
}

- (void) singleTap {
    NSLog(@"single tap");
}


@end
