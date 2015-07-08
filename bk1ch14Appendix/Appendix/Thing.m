

#import "Thing.h"

void setState (enum state s) {
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

@end
