

#import "MyLayer.h"


@implementation MyLayer

+ (id < CAAction >)defaultActionForKey:(NSString *)aKey {
    if ([aKey isEqualToString:@"contents"]) {
        CATransition* tr = [CATransition animation];
        tr.type = kCATransitionPush;
        tr.subtype = kCATransitionFromLeft;
        return tr;
    }
    return [super defaultActionForKey: aKey];
}

-(id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"position"] &&
        [self valueForKey:@"suppressPositionAnimation"])
        return nil;
    return [super actionForKey:event];
}


@end
