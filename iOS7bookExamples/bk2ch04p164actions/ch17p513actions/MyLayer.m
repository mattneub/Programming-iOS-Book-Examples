

#import "MyLayer.h"


@implementation MyLayer

// layer whose response to contents setting is automatic push from left

+ (id < CAAction >)defaultActionForKey:(NSString *)aKey {
    if ([aKey isEqualToString:@"contents"]) {
        CATransition* tr = [CATransition animation];
        tr.type = kCATransitionPush;
        tr.subtype = kCATransitionFromLeft;
        return tr;
    }
    return [super defaultActionForKey: aKey];
}

// layer whose implicit position animation can be turned off

-(id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"position"] &&
        [self valueForKey:@"suppressPositionAnimation"])
        return nil;
    return [super actionForKey:event];
}

-(void)removeFromSuperlayer {
    NSLog(@"%@", @"I'm being removed from my superlayer");
    [super removeFromSuperlayer];
}


@end
