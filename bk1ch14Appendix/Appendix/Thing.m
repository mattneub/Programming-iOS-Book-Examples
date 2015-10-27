

#import "Thing.h"
#import "Appendix-Swift.h"

void setState (State s) {
    NSLog(@"%d",s);
}


@implementation Thing

- (NSString*) badMethod: (NSString*) s {
    return @"howdy";
}

- (nullable NSString*) goodMethod: (NSString*) s {
    return @"howdy";
}

- (NSArray<NSString*>*) pepBoys {
    return @[@"Mannie", @"Moe", @"Jack"];
}

- (void) justTesting {
    Womble* womble = [[Womble alloc] init];
}

@end
