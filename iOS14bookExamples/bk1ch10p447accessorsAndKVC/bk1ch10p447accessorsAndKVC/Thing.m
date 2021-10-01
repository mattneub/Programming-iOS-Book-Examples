

#import "Thing.h"
#import "bk1ch10p447accessorsAndKVC-Swift.h"

@implementation Thing

- (void) test {
    ViewController* vc = [ViewController new];
    [vc setColor:[UIColor redColor]]; // "someone called the setter"
    UIColor* c __attribute__((unused)) = [vc color]; // "someone called the getter"
}

- (void) test2 {
    ViewController* vc = [ViewController new];
    [vc setHue:[UIColor redColor]]; // "someone called the setter"
    UIColor* c __attribute__((unused)) = [vc hue]; // "someone called the getter"
}

- (void) test3 {
    ViewController* vc = [ViewController new];
    [vc setCouleur:[UIColor redColor]];
    UIColor* c __attribute__((unused)) = [vc couleur];
}


@end
