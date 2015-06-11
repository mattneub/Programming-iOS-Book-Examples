

#import "Thing.h"
#import "bk1ch10p447accessorsAndKVC-Swift.h"

@implementation Thing

- (void) test {
    ViewController* vc = [ViewController new];
    [vc setColor:[UIColor redColor]]; // "someone called the setter"
    UIColor* c __attribute__((unused)) = [vc color]; // "someone called the getter"
}

@end
